// ignore_for_file: avoid_unnecessary_containers, file_names, prefer_const_constructors

import "package:flutter/material.dart";
import 'package:puzzlebird/model/CaseImage.dart';
import 'package:puzzlebird/widgets/grid.dart';
import 'package:puzzlebird/widgets/head.dart';

class MediumScreen extends StatefulWidget {
  final List<CaseImage>? images;
  final Function? clickGrid;
  final void Function()? shuffleTap;
  final int? mouvement;
  const MediumScreen(
      {Key? key, this.clickGrid, this.images, this.mouvement, this.shuffleTap})
      : super(key: key);

  @override
  _MediumScreenState createState() => _MediumScreenState();
}

class _MediumScreenState extends State<MediumScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            Head(
              mouvement: widget.mouvement,
              shuffleTap: widget.shuffleTap,
            ),
            SizedBox(height: 10),
            Grid(
              clickGrid: widget.clickGrid,
              images: widget.images,
            ),
          ],
        ),
      ),
    );
  }
}
