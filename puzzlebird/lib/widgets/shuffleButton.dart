// ignore_for_file: avoid_unnecessary_containers, file_names

import "package:flutter/material.dart";

class ShuffleBtn extends StatelessWidget {
  final void Function()? ontap;
  const ShuffleBtn({Key? key, this.ontap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
        onPressed: ontap,
        icon: const Icon(Icons.replay),
        label: const Text("Shuffle"),
      ),
    );
  }
}
