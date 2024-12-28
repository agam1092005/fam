import 'package:flutter/material.dart';

Widget buildDynamicContainer(Map<String, dynamic> json) {
  switch (json['design_type']) {
    case 'HC1':
      return Container(
        height: double.parse(json['height'].toString()),
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: (json['cards'][0].containsKey("bg_color"))
              ? Color(
                  int.parse(
                    "0xFF${json['cards'][0]['bg_color'].toString().substring(1)}",
                  ),
                )
              : Colors.transparent,
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
        ),
        child: Align(
          alignment: Alignment.center,
          child: ListTile(
            leading: (json['cards'][0].containsKey("icon"))
                ? Image(
                    image: NetworkImage(
                      json['cards'][0]['icon']['image_url'],
                    ),
                    width: (json['cards'][0].containsKey("icon_size"))
                        ? double.parse(json['cards'][0]['icon_size'].toString())
                        : 35,
                  )
                : null,
            title: Text(json['cards'][0]['title']),
          ),
        ),
      );
    case 'HC3':
      return Container(
        height: double.parse(json['height'].toString()),
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: (json['cards'][0].containsKey("bg_color"))
              ? Color(
                  int.parse(
                    "0xFF${json['cards'][0]['bg_color'].toString().substring(1)}",
                  ),
                )
              : Colors.transparent,
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
        ),
        child: Stack(
          alignment: Alignment.topLeft,
          children: [
            (json['cards'][0].containsKey('bg_image'))
                ? Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      child: Image.network(
                        json['cards'][0]['bg_image']['image_url'],
                        fit: BoxFit.cover,
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
                    json['cards'][0]['title'],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  (json['cards'][0].containsKey('cta'))
                      ? TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            backgroundColor: Color(int.parse(
                                "0xFF${json['cards'][0]['cta'][0]['bg_color'].toString().substring(1)}")),
                          ),
                          child: Text(json['cards'][0]['cta'][0]['text']),
                        )
                      : SizedBox(
                          height: 0,
                        ),
                ],
              ),
            ),
          ],
        ),
      );
    case 'HC5':
      return Container(
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: (json['cards'][0].containsKey("bg_color"))
              ? Color(
                  int.parse(
                    "0xFF${json['cards'][0]['bg_color'].toString().substring(1)}",
                  ),
                )
              : Colors.transparent,
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
        ),
        child: Stack(
          alignment: Alignment.topLeft,
          children: [
            (json['cards'][0].containsKey('bg_image'))
                ? Image(
                    image: NetworkImage(
                      json['cards'][0]['bg_image']['image_url'],
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
                    json['cards'][0]['title'],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  (json['cards'][0].containsKey('cta'))
                      ? TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            backgroundColor: Color(
                              int.parse(
                                "0xFF${json['cards'][0]['cta'][0]['bg_color'].toString().substring(1)}",
                              ),
                            ),
                          ),
                          child: Text(json['cards'][0]['cta'][0]['text']),
                        )
                      : SizedBox(
                          height: 0,
                        ),
                ],
              ),
            ),
          ],
        ),
      );
    case 'HC6':
      return Container(
        height: double.parse(json['height'].toString()),
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: (json['cards'][0].containsKey("bg_color"))
              ? Color(
                  int.parse(
                    "0xFF${json['cards'][0]['bg_color'].toString().substring(1)}",
                  ),
                )
              : Colors.transparent,
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
        ),
        child: Align(
          alignment: Alignment.center,
          child: ListTile(
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: (json['cards'][0].containsKey("icon_size"))
                  ? double.parse(json['cards'][0]['icon_size'].toString())
                  : 35,
            ),
            leading: (json['cards'][0].containsKey("icon"))
                ? Image(
                    image: NetworkImage(
                      json['cards'][0]['icon']['image_url'],
                    ),
                    width: (json['cards'][0].containsKey("icon_size"))
                        ? double.parse(json['cards'][0]['icon_size'].toString())
                        : 35,
                  )
                : null,
            title: Text(json['cards'][0]['title']),
          ),
        ),
      );
    case 'HC9':
      return Container(
        height: double.parse(json['height'].toString()),
        decoration: BoxDecoration(
          color: (json['cards'][0].containsKey("bg_color"))
              ? Color(
                  int.parse(
                    "0xFF${json['cards'][0]['bg_color'].toString().substring(1)}",
                  ),
                )
              : Colors.transparent,
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
        ),
        child: Stack(
          alignment: Alignment.topLeft,
          children: [
            (json['cards'][0].containsKey('bg_image'))
                ? Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors:
                            (json['cards'][0]['bg_gradient']['colors'] as List)
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
                            json['cards'][0]['bg_gradient']['angle'].toString(),
                          ),
                        ),
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(12),
                      ),
                    ),
                    child: Image(
                      image: NetworkImage(
                        json['cards'][0]['bg_image']['image_url'],
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
                  (json['cards'][0].containsKey('cta'))
                      ? TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            backgroundColor: Color(
                              int.parse(
                                "0xFF${json['cards'][0]['cta'][0]['bg_color'].toString().substring(1)}",
                              ),
                            ),
                          ),
                          child: Text(json['cards'][0]['cta'][0]['text']),
                        )
                      : SizedBox(
                          height: 0,
                        ),
                ],
              ),
            ),
          ],
        ),
      );
    default:
      return Container();
  }
}
