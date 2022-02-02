// ignore_for_file: unnecessary_import, prefer_const_constructors

import 'package:flutter/foundation.dart';
import "package:flutter/material.dart";
import 'package:puzzlebird/model/CaseImage.dart';

class Grid extends StatelessWidget {
  final List<CaseImage>? images;
  final Function? clickGrid;
  const Grid({Key? key, this.images, this.clickGrid}) : super(key: key);
  double getWidth(widthScreen) {
    if (widthScreen >= 400 && widthScreen <= 700) {
      return 300.0;
    } else if (widthScreen > 700) {
      return 400.0;
    }
    return double.infinity;
  }

  double getHeigth(widthScreen, context) {
    if (widthScreen >= 400 && widthScreen <= 700) {
      return 300.0;
    } else if (widthScreen > 700) {
      return 400.0;
    }
    return MediaQuery.of(context).size.height * 0.65;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.all(5),
      width: getWidth(width),
      height: getHeigth(width, context),
      child: GridView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: images!.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 2,
          crossAxisSpacing: 2,
        ),
        itemBuilder: (context, index) {
          return images![index].value != 0
              ? Stack(
                  children: [
                    InkWell(
                      onTap: () {
                        clickGrid!(index);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white,
                          image: DecorationImage(
                            image: AssetImage(images![index].imagePath!),
                          ),
                        ),
                      ),
                    ), // enlever elastic animation
                    Positioned(
                      top: 5,
                      right: 5,
                      child: Text(
                        "${images![index].value}",
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
              : const SizedBox.shrink();
        },
      ),
    );
  }
}
