import 'package:flutter/material.dart';

import 'package:minimalisticpush/styles/styles.dart';

class IconDescriptionList extends StatelessWidget {
  final List<ListElement> elements;

  const IconDescriptionList({this.elements});

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [];

    for (ListElement e in this.elements) {
      if (e.iconData == null && e.number == null) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Expanded(
              child: Text(
                e.description,
                softWrap: true,
                style: TextStyles.body,
              ),
            ),
          ),
        );
      } else if (e.iconData == null) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    height: 36.0,
                    width: 36.0,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Text(e.number.toString(),
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 22.0,
                        )),
                  ),
                ),
                Flexible(
                  child: Text(
                    e.description,
                    softWrap: true,
                    style: TextStyles.body,
                  ),
                ),
              ],
            ),
          ),
        );
      } else if (e.number == null) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Icon(
                    e.iconData,
                    color: Colors.white,
                    size: 36.0,
                  ),
                ),
                Flexible(
                  child: Text(
                    e.description,
                    softWrap: true,
                    style: TextStyles.body,
                  ),
                ),
              ],
            ),
          ),
        );
      }
    }

    return Column(children: widgets);
  }
}

class ListElement {
  final IconData iconData;
  final int number;
  final String description;

  ListElement({this.iconData, this.number, @required this.description}) {
    assert((this.iconData == null && this.number != null) ||
        (this.iconData != null && this.number == null));
    assert(this.description != null && this.description.trim().length != 0);
  }
}
