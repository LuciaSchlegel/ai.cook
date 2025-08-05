// optimized_aperture_clipper.dart
import 'package:flutter/material.dart';

class OptimizedApertureClipper extends CustomClipper<Path> {
  final double progress;
  final double maxRadius;

  static final Map<String, Path> _pathCache = {};

  OptimizedApertureClipper({required this.progress, required this.maxRadius});

  @override
  Path getClip(Size size) {
    final key = '${size.width}-${size.height}-${progress.toStringAsFixed(3)}';

    if (_pathCache.containsKey(key)) return _pathCache[key]!;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = maxRadius * progress;

    final path =
        Path()..addOval(Rect.fromCircle(center: center, radius: radius));

    if (_pathCache.length > 50) _pathCache.clear();
    _pathCache[key] = path;

    return path;
  }

  @override
  bool shouldReclip(covariant OptimizedApertureClipper oldClipper) =>
      oldClipper.progress != progress;
}
