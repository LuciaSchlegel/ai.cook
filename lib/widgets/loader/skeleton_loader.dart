import 'package:ai_cook_project/widgets/loader/skeleton_card.dart';
import 'package:ai_cook_project/widgets/loader/skeleton_element.dart';
import 'package:flutter/material.dart';

class SkeletonLoader extends StatefulWidget {
  const SkeletonLoader({super.key});

  @override
  State<SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<SkeletonLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _animation = Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _skeleton(double height, double width, {BorderRadius? radius}) {
    return SkeletonElement(
      height: height,
      width: width,
      borderRadius: radius ?? BorderRadius.circular(4),
      animation: _animation,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        return Column(
          children: [
            SkeletonCard(
              child: Row(
                children: [
                  _skeleton(24, 24, radius: BorderRadius.circular(12)),
                  const SizedBox(width: 12),
                  Expanded(child: _skeleton(16, double.infinity)),
                ],
              ),
            ),
            SkeletonCard(
              child: Column(
                children: [
                  Row(
                    children: [
                      _skeleton(32, 32, radius: BorderRadius.circular(8)),
                      const SizedBox(width: 12),
                      _skeleton(20, 200),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(5, (i) {
                      final width =
                          i % 2 == 0
                              ? double.infinity
                              : MediaQuery.of(context).size.width * 0.6;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _skeleton(14, width),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
