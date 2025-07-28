import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class AiRecipesDialog extends StatefulWidget {
  final VoidCallback onToggle;
  final bool isOpen;

  const AiRecipesDialog({
    super.key,
    required this.onToggle,
    required this.isOpen,
  });

  @override
  State<AiRecipesDialog> createState() => _AiRecipesDialogState();
}

class _AiRecipesDialogState extends State<AiRecipesDialog>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _apertureAnimation;
  late Animation<double> _contentOpacityAnimation;
  late Animation<double> _contentScaleAnimation;

  @override
  void initState() {
    super.initState();

    // Single controller for all animations
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    // Aperture animation (0.0 to 0.5)
    _apertureAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutCubic),
      ),
    );

    // Content opacity (delayed, 0.3 to 1.0)
    _contentOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 1.0, curve: Curves.easeInOut),
      ),
    );

    // Content scale (delayed, 0.3 to 1.0)
    _contentScaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOutBack),
      ),
    );

    // Start animation if dialog should be open
    if (widget.isOpen) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(AiRecipesDialog oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isOpen != oldWidget.isOpen) {
      if (widget.isOpen) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  void _handleClose() {
    widget.onToggle();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Only build when open or animating
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // Don't render if completely closed
        if (!widget.isOpen && _controller.value == 0.0) {
          return const SizedBox.shrink();
        }

        final size = MediaQuery.of(context).size;
        final maxRadius = math.sqrt(
          size.width * size.width + size.height * size.height,
        );

        return Material(
          type: MaterialType.transparency,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black54.withOpacity(_controller.value * 0.5),
            child: Stack(
              children: [
                // Background overlay
                GestureDetector(
                  onTap: _handleClose,
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.transparent,
                  ),
                ),

                // Main dialog with aperture animation
                ClipPath(
                  clipper: OptimizedApertureClipper(
                    progress: _apertureAnimation.value,
                    maxRadius: maxRadius,
                  ),
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: DraggableScrollableSheet(
                      initialChildSize: 0.9,
                      minChildSize: 0.5,
                      maxChildSize: 0.95,
                      builder: (context, scrollController) {
                        return Transform.scale(
                          scale: _contentScaleAnimation.value,
                          child: Opacity(
                            opacity: _contentOpacityAnimation.value,
                            child: Container(
                              decoration: BoxDecoration(
                                color: CupertinoColors.white,
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(30),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 20,
                                    offset: const Offset(0, -5),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  // Handle bar
                                  Container(
                                    margin: const EdgeInsets.only(top: 12),
                                    width: 40,
                                    height: 4,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),

                                  // Close button
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: IconButton(
                                      onPressed: _handleClose,
                                      icon: const Icon(
                                        CupertinoIcons.xmark,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),

                                  // Content area
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: SingleChildScrollView(
                                        controller: scrollController,
                                        child: _buildDialogContent(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDialogContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'AI Recipe Recommendations',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 20),

        // Placeholder content - replace with your actual AI recipes content
        Container(
          height: 200,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(CupertinoIcons.sparkles, size: 48, color: Colors.blue),
                SizedBox(height: 16),
                Text(
                  'AI Recipe Content Goes Here',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Add more content as needed
        for (int i = 0; i < 5; i++)
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Text(
              'Recipe suggestion ${i + 1} - This is where your AI-generated recipe recommendations would appear.',
              style: const TextStyle(fontSize: 14),
            ),
          ),
      ],
    );
  }
}

// Optimized clipper that caches expensive calculations
class OptimizedApertureClipper extends CustomClipper<Path> {
  final double progress;
  final double maxRadius;

  // Cache for expensive calculations
  static final Map<String, Path> _pathCache = {};

  OptimizedApertureClipper({required this.progress, required this.maxRadius});

  @override
  Path getClip(Size size) {
    // Create cache key
    final key = '${size.width}-${size.height}-${progress.toStringAsFixed(3)}';

    // Return cached path if available
    if (_pathCache.containsKey(key)) {
      return _pathCache[key]!;
    }

    // Calculate and cache new path
    final center = Offset(size.width / 2, size.height / 2);
    final radius = maxRadius * progress;

    final path = Path();
    path.addOval(Rect.fromCircle(center: center, radius: radius));

    // Cache the path (limit cache size)
    if (_pathCache.length > 50) {
      _pathCache.clear();
    }
    _pathCache[key] = path;

    return path;
  }

  @override
  bool shouldReclip(OptimizedApertureClipper oldClipper) {
    return oldClipper.progress != progress;
  }
}
