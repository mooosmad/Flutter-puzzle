// ignore_for_file: file_names, avoid_unnecessary_containers

import "package:flutter/material.dart";
import 'package:puzzlebird/model/CaseImage.dart';
import 'package:puzzlebird/widgets/grid.dart';
import 'package:puzzlebird/widgets/head.dart';

class NormalScreen extends StatefulWidget {
  final List<CaseImage>? images;
  final void Function()? shuffleTap;
  final Function? clickGrid;
  final int? mouvement;
  final int? seconds;
  final GlobalKey? key2;
  const NormalScreen(
      {Key? key,
      this.clickGrid,
      this.images,
      this.mouvement,
      this.seconds,
      this.shuffleTap,
      required this.key2})
      : super(key: key);

  @override
  _NormalScreenState createState() => _NormalScreenState();
}

class _NormalScreenState extends State<NormalScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            Head(
              key2: widget.key2,
              shuffleTap: widget.shuffleTap,
              mouvement: widget.mouvement,
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              child: Grid(
                images: widget.images,
                clickGrid: widget.clickGrid,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
