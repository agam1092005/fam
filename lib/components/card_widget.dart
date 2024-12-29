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
            physics: getScrollable(widget.json),
            itemBuilder: (BuildContext context, int index) {
              return Container(
                width:
                    getSmallCardWidth(widget.json, MediaQuery.of(context).size),
                margin: getMargin(widget.json['cards'][index]),
                decoration: BoxDecoration(
                  color: getBackgroundColor(widget.json['cards'][index]),
                  borderRadius: Constants.defaultBorderRadius,
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: ListTile(
                    leading: getLeadingIcon(widget.json['cards'][index]),
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
            physics: getScrollable(widget.json),
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
                                padding: Constants.defaultPadding,
                                decoration: BoxDecoration(
                                  borderRadius: Constants.defaultBorderRadius,
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
                                padding: Constants.defaultPadding,
                                decoration: BoxDecoration(
                                  borderRadius: Constants.defaultBorderRadius,
                                  color: Constants.bgColor,
                                ),
                                child: Column(
                                  children: [
                                    Icon(Icons.cancel, color: Colors.orange),
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
                        borderRadius: Constants.defaultBorderRadius,
                      ),
                      child: Stack(
                        alignment: Alignment.topLeft,
                        children: [
                          getBgImage(widget.json['cards'][index]),
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
                                getCta(widget.json['cards'][index]),
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
                physics: getScrollable(widget.json),
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: getMargin(widget.json['cards'][index]),
                    width: MediaQuery.of(context).size.width - 48,
                    decoration: BoxDecoration(
                      color: getBackgroundColor(widget.json['cards'][index]),
                      borderRadius: Constants.defaultBorderRadius,
                    ),
                    child: Stack(
                      alignment: Alignment.topLeft,
                      children: [
                        getBgImage(widget.json['cards'][index]),
                        Text(widget.json['cards'][index]['title'] ?? ''),
                        getCta(widget.json['cards'][index]),
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
            physics: getScrollable(widget.json),
            itemBuilder: (BuildContext context, int index) {
              return Container(
                width:
                    getSmallCardWidth(widget.json, MediaQuery.of(context).size),
                margin: getMargin(widget.json['cards'][index]),
                decoration: BoxDecoration(
                  color: getBackgroundColor(widget.json['cards'][index]),
                  borderRadius: Constants.defaultBorderRadius,
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: ListTile(
                    trailing: getTrailingArrow(widget.json['cards'][index]),
                    leading: getLeadingIcon(widget.json['cards'][index]),
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
                  gradient: getCardGradient(widget.json['cards'][index]),
                  borderRadius: Constants.defaultBorderRadius,
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
