// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, file_names

import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:lottie/lottie.dart';
import 'package:puzzlebird/ViewAccordingScreen.dart';
import 'package:puzzlebird/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WinPage extends StatefulWidget {
  final int? score;
  const WinPage({Key? key, this.score}) : super(key: key);

  @override
  _WinPageState createState() => _WinPageState();
}

class _WinPageState extends State<WinPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1434A4).withOpacity(0.9),
      body: ViewAccordingScreen(
        large: LargeScreenWin(
          score: widget.score,
        ),
        medium: MediumScreenWin(
          score: widget.score,
        ),
        normal: NormalScreenWin(
          score: widget.score,
        ),
      ),
    );
  }
}

class WinHead extends StatefulWidget {
  final int? score;
  const WinHead({Key? key, required this.score}) : super(key: key);

  @override
  _WinHeadState createState() => _WinHeadState();
}

class _WinHeadState extends State<WinHead> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "You have Win !",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            child: ElevatedButton.icon(
              style: ButtonStyle(
                padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 16,
                  ),
                ),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  CupertinoPageRoute(
                    builder: (context) {
                      return Home();
                    },
                  ),
                );
              },
              icon: const Icon(Icons.replay),
              label: const Text("Replay"),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Your move : ${widget.score}",
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          )
        ],
      ),
    );
  }
}

class FooterWin extends StatefulWidget {
  final int score;
  const FooterWin({Key? key, required this.score}) : super(key: key);

  @override
  _FooterWinState createState() => _FooterWinState();
}

class _FooterWinState extends State<FooterWin> {
  var bestMove = 0;
  SharedPreferences? pref;

  getBestMove() async {
    pref = await SharedPreferences.getInstance();
    int best = pref!.getInt("bestMove") ?? 2000;

    if (widget.score < best) {
      pref!.setInt("bestMove", widget.score);
    }
    bestMove = pref!.getInt("bestMove")!;
    setState(() {});
  }

  @override
  void initState() {
    getBestMove();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Best move : ",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "$bestMove",
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class LargeScreenWin extends StatefulWidget {
  final int? score;
  const LargeScreenWin({Key? key, required this.score}) : super(key: key);

  @override
  _LargeScreenWinState createState() => _LargeScreenWinState();
}

class _LargeScreenWinState extends State<LargeScreenWin> {
  @override
  Widget build(BuildContext context) {
    var taille = MediaQuery.of(context).size.height / 2.8;
    return Stack(
      children: [
        Container(
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: WinHead(
                    score: widget.score,
                  ),
                ),
                Stack(
                  children: [
                    SizedBox(
                      child: Image.asset(
                        "asset/bird.png",
                        width: 400,
                        height: 400,
                      ),
                    ),
                    Container(
                      child: Lottie.asset(
                        'asset/lottie/win1.json',
                        width: 395,
                        height: 395,
                      ),
                    ),
                  ],
                ),
                Flexible(
                  child: FooterWin(
                    score: widget.score!,
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          left: 20,
          bottom: 10,
          child: Container(
            child: Lottie.asset(
              'asset/lottie/stars.json',
              width: taille,
              height: taille,
            ),
          ),
        ),
        Positioned(
          right: 20,
          bottom: 0,
          child: Container(
            child: Lottie.asset(
              'asset/lottie/stars.json',
              width: taille,
              height: taille,
            ),
          ),
        ),
      ],
    );
  }
}

class MediumScreenWin extends StatefulWidget {
  final int? score;
  const MediumScreenWin({Key? key, this.score}) : super(key: key);

  @override
  _MediumScreenWinState createState() => _MediumScreenWinState();
}

class _MediumScreenWinState extends State<MediumScreenWin> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  child: Image.asset(
                    "asset/bird.png",
                    width: 395,
                    height: 395,
                  ),
                ),
                Container(
                  child: Lottie.asset(
                    'asset/lottie/win1.json',
                    width: 385,
                    height: 385,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                WinHead(score: widget.score),
                SizedBox(width: 20),
                FooterWin(score: widget.score!),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class NormalScreenWin extends StatefulWidget {
  final int? score;
  const NormalScreenWin({Key? key, this.score}) : super(key: key);

  @override
  _NormalScreenWinState createState() => _NormalScreenWinState();
}

class _NormalScreenWinState extends State<NormalScreenWin> {
  @override
  Widget build(BuildContext context) {
    var taille = MediaQuery.of(context).size.height / 4;
    return Stack(
      children: [
        Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: WinHead(
                  score: widget.score,
                ),
              ),
              Flexible(
                child: Stack(
                  children: [
                    SizedBox(
                      child: Image.asset(
                        "asset/bird.png",
                        width: 400,
                        height: 400,
                      ),
                    ),
                    Container(
                      child: Lottie.asset(
                        'asset/lottie/win1.json',
                        width: 310,
                        height: 310,
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: FooterWin(
                  score: widget.score!,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: -20,
          top: 10,
          child: Container(
            child: Lottie.asset(
              'asset/lottie/stars.json',
              width: taille,
              height: taille,
            ),
          ),
        ),
        Positioned(
          right: -20,
          bottom: 0,
          child: Container(
            child: Lottie.asset(
              'asset/lottie/stars.json',
              width: taille,
              height: taille,
            ),
          ),
        ),
      ],
    );
  }
}
