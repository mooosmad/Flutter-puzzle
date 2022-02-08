// ignore_for_file: avoid_unnecessary_containers, avoid_print, prefer_const_constructors

import 'package:lottie/lottie.dart';
import "package:window_manager/window_manager.dart";
import 'dart:io';
import 'dart:ui';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import "package:flutter/material.dart";
import 'package:puzzlebird/ViewAccordingScreen.dart';
import 'package:puzzlebird/screens/largeScreen.dart';
import 'package:puzzlebird/screens/mediumScreen.dart';
import 'package:puzzlebird/screens/normalScreen.dart';
import 'package:puzzlebird/model/CaseImage.dart';
import 'package:puzzlebird/screens/winPage.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import "package:shared_preferences/shared_preferences.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb && Platform.isWindows) {
    await windowManager.ensureInitialized();
    windowManager.waitUntilReadyToShow().then((_) async {
      await windowManager.setMinimumSize(Size(253, 424));
    });
  } // if is windows and not web set minimumSize

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Puzzle Bird",
      home: Home(),
      theme: ThemeData(
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: Colors.white.withOpacity(0.4),
        ),
      ),
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
  int bestMove = 0;
  SharedPreferences? pref;
  initShared() async {
    pref = await SharedPreferences.getInstance();
    isFirst = pref!.getBool("isFirst") ?? true;
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
    try {
      if (kIsWeb) {
        print("WEB");
      } else {
        print("NO WEB");
        if (Platform.isAndroid || Platform.isIOS) {
          WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
            await initShared();
            if (isFirst!) showTutorial(context);
          });
        }
      }
    } catch (e) {
      print(e.toString());
    }

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
              medium: MediumScreen(
                images: images,
                clickGrid: clickGrid,
                mouvement: mouvement,
                shuffleTap: reset,
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
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    pin = !pin;
                                  });
                                },
                                child: SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: Image.asset(
                                    pin ? "asset/unpin.png" : "asset/pin.png",
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.blue.withOpacity(0.5),
                                  image: const DecorationImage(
                                    image: AssetImage(
                                      "asset/resultatFinal.png",
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                height: 250,
                                width: 250,
                              ),
                            ),
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
                controller: (animation) {},
                child: GestureDetector(
                  onTap: () async {
                    showModalBottomSheet(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      context: context,
                      builder: (context) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Wrap(
                              alignment: WrapAlignment.center,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "Expected result",
                                      style: TextStyle(
                                        color: Color(0xff1434A4),
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "take a deep breath",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "You can succeed!",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    Lottie.asset(
                                      "asset/lottie/stars.json",
                                      width: 50,
                                      height: 50,
                                    ),
                                  ],
                                ),
                                Container(
                                  width: 200,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                  ),
                                  child: Image.asset(
                                    "asset/resultatFinal.png",
                                    // fit: BoxFit.cover,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
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
    if (isWin()) {
      Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) {
        return WinPage(
          score: mouvement,
        );
      }));
    }
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
