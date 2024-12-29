// ignore_for_file: use_build_context_synchronously

import 'package:fam/components/card_components.dart';
import 'package:fam/providers/card_provider.dart';
import 'package:fam/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
              return GestureDetector(
                onTap: () async {
                  await launchCardUrl(widget.json['cards'][index]);
                },
                child: Container(
                  width: getSmallCardWidth(
                      widget.json, MediaQuery.of(context).size),
                  margin: getMargin(widget.json['cards'][index]),
                  decoration: BoxDecoration(
                    color: getBackgroundColor(widget.json['cards'][index]),
                    borderRadius: Constants.defaultBorderRadius,
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: ListTile(
                      leading: getLeadingIcon(widget.json['cards'][index]),
                      title: getTitle(widget.json['cards'][index]),
                      subtitle: getDesc(widget.json['cards'][index]),
                    ),
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
                    _isSlidingMap[index] = !_isSlidingMap[index]!;
                  });
                  HapticFeedback.heavyImpact();
                },
                onTap: () async {
                  await launchCardUrl(widget.json['cards'][index]);
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
                                Provider.of<CardProvider>(context,
                                        listen: false)
                                    .removeItem(
                                        "${widget.json['id']}-${widget.json['cards'][index]['id']}");
                                setState(() {
                                  _isSlidingMap[index] = false;
                                });
                                HapticFeedback.selectionClick();
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
                              onTap: () async {
                                final SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                List<String> items =
                                    prefs.getStringList('items') ?? [];
                                items.add(
                                    "${widget.json['id']}-${widget.json['cards'][index]['id']}");
                                await prefs.setStringList('items', items);
                                Provider.of<CardProvider>(context,
                                        listen: false)
                                    .removeItem(
                                        "${widget.json['id']}-${widget.json['cards'][index]['id']}");
                                setState(() {
                                  _isSlidingMap[index] = false;
                                });
                                HapticFeedback.selectionClick();
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
                            padding: EdgeInsets.symmetric(horizontal: 48),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.1,
                                  ),
                                ),
                                getTitle(widget.json['cards'][index]),
                                getDesc(widget.json['cards'][index]),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.05,
                                ),
                                getCta(widget.json['cards'][index]),
                                SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.025,
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

            double h = snapshot.data ?? 200;
            return SizedBox(
              height: h,
              width: double.maxFinite,
              child: ListView.builder(
                itemCount: widget.json['cards'].length,
                scrollDirection: Axis.horizontal,
                physics: getScrollable(widget.json),
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () async {
                      await launchCardUrl(widget.json['cards'][index]);
                    },
                    child: Container(
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
                          getTitle(widget.json['cards'][index]),
                          getDesc(widget.json['cards'][index]),
                          getCta(widget.json['cards'][index]),
                        ],
                      ),
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
              return GestureDetector(
                onTap: () async {
                  await launchCardUrl(widget.json['cards'][index]);
                },
                child: Container(
                  width: getSmallCardWidth(
                      widget.json, MediaQuery.of(context).size),
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
                      title: getTitle(widget.json['cards'][index]),
                      subtitle: getDesc(widget.json['cards'][index]),
                    ),
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
              return GestureDetector(
                onTap: () async {
                  await launchCardUrl(widget.json['cards'][index]);
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    gradient: getCardGradient(widget.json['cards'][index]),
                    borderRadius: Constants.defaultBorderRadius,
                  ),
                  child: (widget.json['cards'][index].containsKey('bg_image') &&
                          widget.json['cards'][index]['bg_image']
                                  ['image_type'] ==
                              "ext")
                      ? Image(
                          image: NetworkImage(
                            widget.json['cards'][index]['bg_image']
                                ['image_url'],
                          ),
                        )
                      : null,
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
