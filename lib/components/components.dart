import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/constants.dart';
import '../utils/formatter.dart';

// Converts hex code to color, otherwise returns transparent.
Color getBackgroundColor(Map<String, dynamic> card) {
  return card.containsKey("bg_color")
      ? Color(int.parse("0xFF${card['bg_color'].toString().substring(1)}"))
      : Colors.transparent;
}

// Returns a leading icon from a network image, with optional size.
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

// Returns a trailing arrow icon, with customizable size.
getTrailingArrow(Map<String, dynamic> card) {
  return Icon(
    Icons.arrow_forward_ios,
    size: (card.containsKey("icon_size"))
        ? double.parse(card['icon_size'].toString())
        : 35,
  );
}

// Displays external background image if defined.
getBgImage(Map<String, dynamic> card) {
  return (card.containsKey('bg_image') &&
          card['bg_image']['image_type'] == "ext")
      ? Positioned.fill(
          child: ClipRRect(
            borderRadius: Constants.defaultBorderRadius,
            child: Image.network(
              card['bg_image']['image_url'],
              fit: BoxFit.cover,
              alignment: Alignment.topLeft,
            ),
          ),
        )
      : SizedBox(
          height: 0,
        );
}

// Applies horizontal margin if more than one card exists.
EdgeInsets? getMargin(Map<String, dynamic> card, bool isHC3, bool isOpen) {
  if (card.length > 1) {
    if (isHC3 && isOpen) {
      return EdgeInsets.only(
        left: 8,
        right: 158,
      );
    } else {
      return EdgeInsets.symmetric(horizontal: 8);
    }
  }
  return null;
}

// Determines scroll physics based on scrollable setting.
ScrollPhysics getScrollable(Map<String, dynamic> json) {
  return (json['is_scrollable'])
      ? ClampingScrollPhysics()
      : NeverScrollableScrollPhysics();
}

// Calculates width of small cards based on screen size and scrollable state.
double? getSmallCardWidth(Map<String, dynamic> json, Size size) {
  return (json['is_scrollable'])
      ? (size.width / 2)
      : ((size.width - 64) / json['cards'].length);
}

// Creates a linear gradient with color hex codes and angle.
Gradient getCardGradient(Map<String, dynamic> card) {
  return LinearGradient(
    colors: (card['bg_gradient']['colors'] as List).map((hex) {
      if (hex is String) {
        final colorValue = int.parse(hex.substring(1), radix: 16);
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
        card['bg_gradient']['angle'].toString(),
      ),
    ),
  );
}

// Generates CTA buttons with text, URL, and styling.
getCta(Map<String, dynamic> card) {
  return (card.containsKey('cta'))
      ? Wrap(
          spacing: 8,
          children: [
            for (var cta in card['cta'])
              TextButton(
                onPressed: () async {
                  (cta.containsKey('url'))
                      ? await launchUrl(
                          Uri.parse(
                            cta['url'],
                          ),
                        )
                      : null;
                },
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        Constants.radius), // Adjust the radius as needed
                  ),
                  backgroundColor: (cta.containsKey("bg_color"))
                      ? Color(int.parse(
                          "0xFF${cta['bg_color'].toString().substring(1)}"))
                      : null,
                ),
                child: Text(
                  cta['text'],
                  style: TextStyle(
                    color: (cta.containsKey("text_color"))
                        ? Color(int.parse(
                            "0xFF${cta['text_color'].toString().substring(1)}"))
                        : null,
                  ),
                ),
              )
          ],
        )
      : SizedBox(
          height: 0,
        );
}

// Returns formatted title or plain text if no format exists.
getTitle(Map<String, dynamic> card) {
  return (card.containsKey("formatted_title"))
      ? RichText(
          text: Formatter.formatText(
            card['formatted_title']['text'],
            card['formatted_title']['entities'],
          ),
          textAlign: getTextAlign(card['formatted_title']['align']),
        )
      : Text(card['title'] ?? '');
}

// Returns formatted description or plain text if no format exists.
getDesc(Map<String, dynamic> card) {
  return (card.containsKey("formatted_description"))
      ? RichText(
          text: Formatter.formatText(
            card['formatted_description']['text'],
            card['formatted_description']['entities'],
          ),
          textAlign: getTextAlign(card['formatted_description']['align']),
        )
      : Text(card['description'] ?? '');
}

// for Text alignment
TextAlign getTextAlign(String align) {
  switch (align) {
    case 'left':
      return TextAlign.left;
    case 'center':
      return TextAlign.center;
    case 'right':
      return TextAlign.right;
    case 'justify':
      return TextAlign.justify;
    default:
      return TextAlign.start;
  }
}

// Opens the card’s URL if it exists.
launchCardUrl(Map<String, dynamic> card) async {
  return (card.containsKey("url"))
      ? await launchUrl(
          Uri.parse(
            card['url'],
          ),
        )
      : null;
}
