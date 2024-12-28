import 'package:flutter/material.dart';

Color getBackgroundColor(Map<String, dynamic> card) {
  return card.containsKey("bg_color")
      ? Color(int.parse("0xFF${card['bg_color'].toString().substring(1)}"))
      : Colors.transparent;
}

EdgeInsets? getMargin(Map<String, dynamic> card) {
  return (card.length > 1)
      ? EdgeInsets.symmetric(horizontal: 8)
      : null;
}