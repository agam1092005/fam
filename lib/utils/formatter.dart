import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Formatter {
  static TextSpan formatText(String template, List<dynamic> entities) {
    List<TextSpan> spans = [];
    int lastIndex = 0;

    // Mapping of font_family to font_weight
    final Map<String, FontWeight> fontWeights = {
      'met_regular': FontWeight.w400,
      'met_semi_bold': FontWeight.w600,
      'met_bold': FontWeight.w700,
    };

    for (var entity in entities) {
      final Map<String, dynamic> entityMap = entity as Map<String, dynamic>;

      int placeholderIndex = template.indexOf('{}', lastIndex);
      if (placeholderIndex == -1) break;

      // Add plain text before the placeholder
      if (placeholderIndex > lastIndex) {
        spans.add(TextSpan(
          text: template.substring(lastIndex, placeholderIndex),
        ));
      }

      // Retrieve fontWeight from font_family
      FontWeight? fontWeight = fontWeights[entityMap['font_family']];

      // Add the rich text for the entity
      spans.add(
        TextSpan(
          text: entityMap['text'],
          style: TextStyle(
            color: entityMap['color'] != null
                ? Color(int.parse('0xFF${entityMap['color'].substring(1)}'))
                : null,
            fontSize: entityMap['font_size']?.toDouble(),
            fontWeight: fontWeight,
            fontStyle:
                entityMap['font_style'] == 'italic' ? FontStyle.italic : null,
            decoration: entityMap['font_style'] == 'underline'
                ? TextDecoration.underline
                : null,
          ),
          recognizer: entityMap['url'] != null
              ? (TapGestureRecognizer()
                ..onTap = () async {
                  await launchUrl(
                    Uri.parse(
                      entityMap['url'],
                    ),
                  );
                })
              : null,
        ),
      );

      lastIndex = placeholderIndex + 2; // Move past the placeholder
    }

    // Add remaining plain text
    if (lastIndex < template.length) {
      spans.add(TextSpan(
        text: template.substring(lastIndex),
      ));
    }

    return TextSpan(children: spans);
  }
}
