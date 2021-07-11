import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerContainer extends StatelessWidget {
  const ShimmerContainer({required this.child, Key? key}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!.withOpacity(.1),
      period: Duration(milliseconds: 1500),
      child: child,
    );
  }
}

class ShimmerItem extends StatelessWidget {
  ShimmerItem({
    required this.width,
    required this.height,
    this.radius = 8.0,
  });

  final double? width, height, radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius!),
        color: Colors.grey,
      ),
    );
  }
}
