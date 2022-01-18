// ignore_for_file: file_names

import "package:flutter/material.dart";

class ViewAccordingScreen extends StatefulWidget {
  final Widget? large;
  final Widget? medium;
  final Widget? normal;
  const ViewAccordingScreen({Key? key, this.large, this.medium, this.normal})
      : super(key: key);

  @override
  _ViewAccordingScreenState createState() => _ViewAccordingScreenState();
}

class _ViewAccordingScreenState extends State<ViewAccordingScreen> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    print(width);
    if (width >= 400 && width <= 700) {
      //medium
      return widget.medium!;
    } else if (width > 700) {
      //large
      return widget.large!;
    }
    // normal
    return widget.normal!;
  }
}
