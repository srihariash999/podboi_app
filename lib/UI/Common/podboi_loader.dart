import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:podboi/Constants/constants.dart';

class PodboiLoader extends StatelessWidget {
  const PodboiLoader({
    super.key,
    this.size = 128.0,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: Lottie.asset(
        K.animationAssets.loading,
        fit: BoxFit.cover,
        frameRate: FrameRate(120),
      ),
    );
  }
}
