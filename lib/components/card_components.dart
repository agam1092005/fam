import 'package:flutter/material.dart';

import '../utils/constants.dart';

Color getBackgroundColor(Map<String, dynamic> card) {
  return card.containsKey("bg_color")
      ? Color(int.parse("0xFF${card['bg_color'].toString().substring(1)}"))
      : Colors.transparent;
}

getLeadingIcon(Map<String, dynamic> card) {
  return (card.containsKey("icon"))
      ? Image(
          image: NetworkImage(
            card['icon']['image_url'],
          ),
          width: (card.containsKey("icon_size"))
              ? double.parse(card['icon_size'].toString())
              : 35,
        )
      : null;
}

getTrailingArrow(Map<String, dynamic> card) {
  return Icon(
    Icons.arrow_forward_ios,
    size:
    (card.containsKey("icon_size"))
        ? double.parse(card['icon_size'].toString())
        : 35,
  );
}

getBgImage(Map<String, dynamic> card) {
  return (card.containsKey('bg_image'))
      ? Positioned.fill(
    child: ClipRRect(
      borderRadius: Constants.defaultBorderRadius,
      child: Image.network(
        card['bg_image']
        ['image_url'],
        fit: BoxFit.cover,
        alignment: Alignment.topLeft,
      ),
    ),
  )
      : SizedBox(
    height: 0,
  );
}

EdgeInsets? getMargin(Map<String, dynamic> card) {
  return (card.length > 1) ? EdgeInsets.symmetric(horizontal: 8) : null;
}

ScrollPhysics getScrollable(Map<String, dynamic> json) {
  return (json['is_scrollable'])
      ? ClampingScrollPhysics()
      : NeverScrollableScrollPhysics();
}

double? getSmallCardWidth(Map<String, dynamic> json, Size size) {
  return (json['is_scrollable'])
      ? (size.width / 2)
      : ((size.width - 64) / json['cards'].length);
}


Gradient getCardGradient(Map<String, dynamic> card) {
  return LinearGradient(
    colors: (card['bg_gradient']
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
        card['bg_gradient']['angle']
            .toString(),
      ),
    ),
  );
}