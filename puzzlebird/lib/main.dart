// ignore_for_file: avoid_unnecessary_containers, avoid_print

import "package:flutter/material.dart";
import 'package:puzzlebird/ViewAccordingScreen.dart';
import 'package:puzzlebird/screens/largeScreen.dart';
import 'package:puzzlebird/screens/normalScreen.dart';
import 'package:puzzlebird/model/CaseImage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Puzzle Bird",
      home: Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  int mouvement = 0;

  List<CaseImage> images = List.generate(
    16,
    (index) => CaseImage(
      imagePath: index == 15 ? "" : "asset/imagesBird/${index + 1}x.jpg",
      value: index == 15 ? 0 : index + 1,
    ),
  );
  // List images = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15];
  @override
  void initState() {
    images.shuffle();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).size.width);
    return Scaffold(
      backgroundColor: const Color(0xff1434A4).withOpacity(0.9),
      body: Center(
        child: ViewAccordingScreen(
          large: LargeScreen(
            mouvement: mouvement,
            shuffleTap: reset,
            images: images,
            clickGrid: clickGrid,
          ),
          medium: Container(),
          normal: NormalScreen(
            shuffleTap: reset,
            mouvement: mouvement,
            images: images,
            clickGrid: clickGrid,
          ),
        ),
      ),
      // body: SingleChildScrollView(
      //   child: Center(
      //     child: Container(
      //       child: Column(
      //         mainAxisAlignment: MainAxisAlignment.center,
      //         children: [
      //           const Head(),
      //           Grid(
      //             images: images,
      //             clickGrid: clickGrid,
      //           ),
      //           ShuffleBtn(
      //             ontap: reset,
      //           ),
      //         ],
      //       ),
      //     ),
      //   ),
      // ),
    );
  }

  void reset() {
    setState(() {
      images.shuffle();
      mouvement = 0;
    });
  }

  void clickGrid(int index) {
    print("index tapped $index");
    print(
        "case vide actuellement : ${images.indexOf(const CaseImage(imagePath: "", value: 0))}");

    if (index - 1 >= 0 &&
            images[index - 1] == const CaseImage(imagePath: "", value: 0) &&
            index % 4 != 0 ||
        index + 1 < 16 &&
            images[index + 1] == const CaseImage(imagePath: "", value: 0) &&
            (index + 1) % 4 != 0 ||
        (index - 4 >= 0 &&
            images[index - 4] == const CaseImage(imagePath: "", value: 0)) ||
        (index + 4 < 16 &&
            images[index + 4] == const CaseImage(imagePath: "", value: 0))) {
      setState(() {
        mouvement++;
        images[images.indexOf(const CaseImage(imagePath: "", value: 0))] =
            images[index];
        images[index] = const CaseImage(imagePath: "", value: 0);
      });
    }
    print(isWin());
  }

  isWin() {
    var deb = images.first.value!;
    for (var i = 1; i < images.length - 1; i++) {
      if (deb > images[i].value!) {
        return false;
      }
      deb = images[i].value!;
    }
    return true;
  }
}
