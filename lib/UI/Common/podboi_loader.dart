import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class PodboiLoader extends StatelessWidget {
  const PodboiLoader({
    super.key,
    this.size = 128.0,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      child: Lottie.asset('assets/loaders/loader_2.json',
          fit: BoxFit.cover, frameRate: FrameRate(120)),
    );
  }
}
