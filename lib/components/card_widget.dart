import 'dart:math';
import 'package:fam/components/card_components.dart';
import 'package:fam/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/helper.dart';

class DynamicContainer extends StatefulWidget {
  final Map<String, dynamic> json;
  const DynamicContainer({super.key, required this.json});

  @override
  State<DynamicContainer> createState() => _DynamicContainerState();
}

class _DynamicContainerState extends State<DynamicContainer> {
  final Map<int, bool> _isSlidingMap = {};
  @override
  Widget build(BuildContext context) {
    switch (widget.json['design_type']) {
      case 'HC1':
        return SizedBox(
          height: double.parse(widget.json['height'].toString()),
          width: double.maxFinite,
          child: ListView.builder(
            itemCount: widget.json['cards'].length,
            scrollDirection: Axis.horizontal,
            physics: (widget.json['is_scrollable'])
                ? ClampingScrollPhysics()
                : NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return Container(
                width: (widget.json['is_scrollable'])
                    ? (MediaQuery.of(context).size.width / 2)
                    : ((MediaQuery.of(context).size.width - 64) /
                        widget.json['cards'].length),
                margin: getMargin(widget.json['cards'][index]),
                decoration: BoxDecoration(
                  color: getBackgroundColor(widget.json['cards'][index]),
                  borderRadius: BorderRadius.all(
                    Radius.circular(12),
                  ),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: ListTile(
                    leading: (widget.json['cards'][index].containsKey("icon"))
                        ? Image(
                            image: NetworkImage(
                              widget.json['cards'][index]['icon']['image_url'],
                            ),
                            width: (widget.json['cards'][index]
                                    .containsKey("icon_size"))
                                ? double.parse(widget.json['cards'][index]
                                        ['icon_size']
                                    .toString())
                                : 35,
                          )
                        : null,
                    title: Text(widget.json['cards'][index]['title'] ?? ''),
                    subtitle:
                        Text(widget.json['cards'][index]['description'] ?? ''),
                  ),
                ),
              );
            },
          ),
        );
      case 'HC3':
        return SizedBox(
          height: double.parse(widget.json['height'].toString()),
          width: double.maxFinite,
          child: ListView.builder(
            itemCount: widget.json['cards'].length,
            scrollDirection: Axis.horizontal,
            physics: (widget.json['is_scrollable'])
                ? ClampingScrollPhysics()
                : NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              _isSlidingMap.putIfAbsent(index, () => false);
              return GestureDetector(
                onLongPress: () {
                  setState(() {
                    _isSlidingMap[index] = true;
                  });
                },
                onTap: () {
                  setState(() {
                    _isSlidingMap[index] = false;
                  });
                },
                child: Stack(
                  children: [
                    if (_isSlidingMap[index]!)
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            bottomLeft: Radius.circular(12),
                          ),
                          color: Colors.white,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                // Handle "Remind Later" action
                                print('Remind Later Pressed');
                                setState(() {
                                  _isSlidingMap[index] = false;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
                                  color: Constants.bgColor,
                                ),
                                child: Column(
                                  children: [
                                    Icon(Icons.notifications,
                                        color: Colors.orange),
                                    Text('Remind Later'),
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                // Handle "Dismiss Now" action
                                print('Dismiss Now Pressed');
                                setState(() {
                                  _isSlidingMap[index] = false;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
                                  color: Constants.bgColor,
                                ),
                                child: Column(
                                  children: [
                                    Icon(Icons.cancel, color: Colors.red),
                                    Text('Dismiss Now'),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      transform: _isSlidingMap[index]!
                          ? Matrix4.translationValues(
                              150, 0, 0) // Slide to the left
                          : Matrix4.translationValues(
                              0, 0, 0), // Original position
                      margin: getMargin(widget.json['cards'][index]),
                      width: MediaQuery.of(context).size.width - 48,
                      decoration: BoxDecoration(
                        color: getBackgroundColor(widget.json['cards'][index]),
                        borderRadius: BorderRadius.all(
                          Radius.circular(12),
                        ),
                      ),
                      child: Stack(
                        alignment: Alignment.topLeft,
                        children: [
                          (widget.json['cards'][index].containsKey('bg_image'))
                              ? Positioned.fill(
                                  child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12)),
                                    child: Image.network(
                                      widget.json['cards'][index]['bg_image']
                                          ['image_url'],
                                      fit: BoxFit.cover,
                                      alignment: Alignment.topLeft,
                                    ),
                                  ),
                                )
                              : SizedBox(
                                  height: 0,
                                ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 40),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                    widget.json['cards'][index]['title'] ?? ''),
                                SizedBox(
                                  height: 20,
                                ),
                                (widget.json['cards'][index].containsKey('cta'))
                                    ? TextButton(
                                        onPressed: () async {
                                          await launchUrl(
                                            Uri.parse(
                                              widget.json['cards'][index]
                                                  ['url'],
                                            ),
                                          );
                                        },
                                        style: TextButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                8), // Adjust the radius as needed
                                          ),
                                          backgroundColor: Color(int.parse(
                                              "0xFF${widget.json['cards'][index]['cta'][0]['bg_color'].toString().substring(1)}")),
                                        ),
                                        child: Text(widget.json['cards'][index]
                                            ['cta'][0]['text']),
                                      )
                                    : SizedBox(
                                        height: 0,
                                      ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      case 'HC5':
        return FutureBuilder<double>(
          future: getImageHeight(
              widget.json['cards'][0]['bg_image']['image_url'],
              MediaQuery.of(context).size.width - 48),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            double h = snapshot.data ?? 100;
            return SizedBox(
              height: h,
              width: double.maxFinite,
              child: ListView.builder(
                itemCount: widget.json['cards'].length,
                scrollDirection: Axis.horizontal,
                physics: (widget.json['is_scrollable'])
                    ? ClampingScrollPhysics()
                    : NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: getMargin(widget.json['cards'][index]),
                    width: MediaQuery.of(context).size.width - 48,
                    decoration: BoxDecoration(
                      color: getBackgroundColor(widget.json['cards'][index]),
                      borderRadius: BorderRadius.all(
                        Radius.circular(12),
                      ),
                    ),
                    child: Stack(
                      alignment: Alignment.topLeft,
                      children: [
                        (widget.json['cards'][index].containsKey('bg_image'))
                            ? AspectRatio(
                                aspectRatio: widget.json['cards'][index]
                                    ['bg_image']['aspect_ratio'],
                                child: Image.network(
                                  widget.json['cards'][index]['bg_image']
                                      ['image_url'],
                                ),
                              )
                            : SizedBox(
                                height: 0,
                              ),
                        Text(widget.json['cards'][index]['title'] ?? ''),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        );
      case 'HC6':
        return SizedBox(
          height: double.parse(widget.json['height'].toString()),
          width: double.maxFinite,
          child: ListView.builder(
            itemCount: widget.json['cards'].length,
            scrollDirection: Axis.horizontal,
            physics: (widget.json['is_scrollable'])
                ? ClampingScrollPhysics()
                : NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return Container(
                width: (widget.json['is_scrollable'])
                    ? (MediaQuery.of(context).size.width / 2)
                    : ((MediaQuery.of(context).size.width - 64) /
                        widget.json['cards'].length),
                margin: getMargin(widget.json['cards'][index]),
                decoration: BoxDecoration(
                  color: getBackgroundColor(widget.json['cards'][index]),
                  borderRadius: BorderRadius.all(
                    Radius.circular(12),
                  ),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: ListTile(
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size:
                          (widget.json['cards'][index].containsKey("icon_size"))
                              ? double.parse(widget.json['cards'][index]
                                      ['icon_size']
                                  .toString())
                              : 35,
                    ),
                    leading: (widget.json['cards'][index].containsKey("icon"))
                        ? Image(
                            image: NetworkImage(
                              widget.json['cards'][index]['icon']['image_url'],
                            ),
                            width: (widget.json['cards'][index]
                                    .containsKey("icon_size"))
                                ? double.parse(widget.json['cards'][index]
                                        ['icon_size']
                                    .toString())
                                : 35,
                          )
                        : null,
                    title: Text(widget.json['cards'][index]['title'] ?? ''),
                    subtitle:
                        Text(widget.json['cards'][index]['description'] ?? ''),
                  ),
                ),
              );
            },
          ),
        );
      case 'HC9':
        return SizedBox(
          height: double.parse(widget.json['height'].toString()),
          child: ListView.builder(
            itemCount: widget.json['cards'].length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: (widget.json['cards'][index]['bg_gradient']
                            ['colors'] as List)
                        .map((hex) {
                      if (hex is String) {
                        final colorValue =
                            int.parse(hex.substring(1), radix: 16);
                        return Color(0xFF000000 | colorValue);
                      } else {
                        throw FormatException(
                            'Expected hex string, but got ${hex.runtimeType}');
                      }
                    }).toList(),
                    begin: Alignment(-1.0, 0.0),
                    end: Alignment(1.0, 0.0),
                    transform: GradientRotation(
                      double.parse(
                        widget.json['cards'][index]['bg_gradient']['angle']
                            .toString(),
                      ),
                    ),
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(12),
                  ),
                ),
                child: Image(
                  image: NetworkImage(
                    widget.json['cards'][index]['bg_image']['image_url'],
                  ),
                ),
              );
            },
          ),
        );
      default:
        return Container();
    }
  }
}
