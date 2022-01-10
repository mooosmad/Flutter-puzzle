// ignore_for_file: avoid_unnecessary_containers, file_names

import "package:flutter/material.dart";
import 'package:puzzlebird/model/CaseImage.dart';
import 'package:puzzlebird/widgets/grid.dart';
import 'package:puzzlebird/widgets/head.dart';

class LargeScreen extends StatefulWidget {
  final List<CaseImage>? images;
  final Function? clickGrid;
  final void Function()? shuffleTap;
  final int? mouvement;
  final int? seconds;
  const LargeScreen(
      {Key? key,
      required this.clickGrid,
      required this.images,
      this.mouvement,
      this.seconds,
      this.shuffleTap})
      : super(key: key);

  @override
  _LargeScreenState createState() => _LargeScreenState();
}

class _LargeScreenState extends State<LargeScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Head(
              mouvement: widget.mouvement,
              shuffleTap: widget.shuffleTap,
            ),
            const SizedBox(
              width: 50,
            ),
            Grid(
              images: widget.images,
              clickGrid: widget.clickGrid,
            ),
          ],
        ),
      ),
    );
  }
}
