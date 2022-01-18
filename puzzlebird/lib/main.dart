// ignore_for_file: avoid_unnecessary_containers, avoid_print

import 'dart:async';
import 'dart:io';

import 'package:animate_do/animate_do.dart';
import "package:flutter/material.dart";
import 'package:puzzlebird/ViewAccordingScreen.dart';
import 'package:puzzlebird/screens/largeScreen.dart';
import 'package:puzzlebird/screens/normalScreen.dart';
import 'package:puzzlebird/model/CaseImage.dart';
import 'package:puzzlebird/widgets/grid.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import "package:shared_preferences/shared_preferences.dart";

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
  bool? isFirst;
  SharedPreferences? pref;
  initShared() async {
    pref = await SharedPreferences.getInstance();
    isFirst = pref!.getBool("isFirst") ?? true;
    print("RECUPERATION : $isFirst");
  }

  List<CaseImage> images = List.generate(
    16,
    (index) => CaseImage(
      imagePath: index == 15 ? "" : "asset/imagesBird/${index + 1}x.jpg",
      value: index == 15 ? 0 : index + 1,
    ),
  );
  bool inZone = false;
  bool pin = false;

  List<TargetFocus> target = [];
  GlobalKey mykey = GlobalKey();
  GlobalKey key2 = GlobalKey();

  showTutorial(BuildContext context) {
    target.addAll([
      TargetFocus(
        identify: "one",
        keyTarget: key2,
        shape: ShapeLightFocus.RRect,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: Column(
              children: [
                const SizedBox(height: 10),
                Text(
                  "Snumber of movements performed".toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "be sure to do as little as possible for a better score",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 21,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: "two",
        keyTarget: mykey,
        shape: ShapeLightFocus.Circle,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "SEE FINAL RESULT",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Once in the game, press the bird to see the expected result",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 21,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ]);
    TutorialCoachMark(
      context,
      targets: target,
      alignSkip: Alignment.bottomLeft,
      onSkip: () {
        pref!.setBool("isFirst", false);
      },
      onClickTarget: (focus) {
        if (focus.keyTarget == mykey) {
          pref!.setBool("isFirst", false);
        }
      },
    ).show();
  }

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      await initShared();
      if (isFirst!) showTutorial(context);
    });

    images.shuffle();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xff1434A4).withOpacity(0.9),
      body: Stack(
        children: [
          Center(
            child: ViewAccordingScreen(
              large: LargeScreen(
                mouvement: mouvement,
                shuffleTap: reset,
                images: images,
                clickGrid: clickGrid,
              ),
              medium: Container(
                child: Grid(
                  images: images,
                  clickGrid: clickGrid,
                ),
              ),
              normal: NormalScreen(
                key2: key2,
                shuffleTap: reset,
                mouvement: mouvement,
                images: images,
                clickGrid: clickGrid,
              ),
            ),
          ),
          width > 700
              ? AnimatedPositioned(
                  duration: const Duration(milliseconds: 800),
                  top: 20,
                  left: inZone ? 0 : -255,
                  child: MouseRegion(
                    onEnter: (p) {
                      setState(() {
                        inZone = true;
                      });
                    },
                    onExit: (p) {
                      if (!pin) {
                        setState(() {
                          inZone = false;
                        });
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: IconButton(
                                splashRadius: 20,
                                onPressed: () {
                                  setState(() {
                                    pin = !pin;
                                  });
                                },
                                icon: Icon(
                                  pin
                                      ? Icons.do_not_step_outlined
                                      : Icons.push_pin_rounded,
                                  size: 15,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.blue.withOpacity(0.5),
                            ),
                            height: 250,
                            width: 250,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : Container(),
          if (width < 400)
            Positioned(
              right: 10,
              bottom: 10,
              child: Spin(
                controller: (animation) {
                  Timer.periodic(const Duration(seconds: 5), (timer) {
                    if (animation.isCompleted) {
                      animation.reset();
                      animation.forward();
                    }
                  });
                },
                child: GestureDetector(
                  onTap: () async {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            child: Hero(
                              tag: "tag1",
                              child: Container(
                                width: 200,
                                height: 260,
                                child: Image.asset(
                                  "asset/bird.png",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );
                        });
                  },
                  child: Container(
                    key: mykey,
                    width: 43,
                    height: 43,
                    decoration: const BoxDecoration(
                      color: Colors.white24,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Hero(
                        tag: "tag1",
                        child: Image.asset(
                          "asset/bird.png",
                          width: 40,
                          height: 40,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void reset() {
    setState(() {
      images.shuffle();
      mouvement = 0;
    });
  }

  void clickGrid(int index) {
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
