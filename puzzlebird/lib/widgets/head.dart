// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers

import "package:flutter/material.dart";
import 'package:puzzlebird/widgets/shuffleButton.dart';

class Head extends StatefulWidget {
  final void Function()? shuffleTap;
  final GlobalKey? key2;
  final int? mouvement;
  const Head({Key? key, this.shuffleTap, this.mouvement, this.key2})
      : super(key: key);

  @override
  _HeadState createState() => _HeadState();
}

class _HeadState extends State<Head> with TickerProviderStateMixin {
  AnimationController? animationController;
  Tween<Offset>? pos;

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
    pos = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero);
    super.initState();
  }

  @override
  void dispose() {
    animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SlideTransition(
                position: pos!.animate(animationController!),
                child: Image.asset(
                  "asset/bird1x.png",
                  width: 40,
                  height: 40,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                "Puzzle Bird",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          ShuffleBtn(ontap: widget.shuffleTap),
          const SizedBox(height: 10),
          Text(
            "Move : ${widget.mouvement}",
            key: widget.key2,
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
          )
        ],
      ),
    );
  }
}
