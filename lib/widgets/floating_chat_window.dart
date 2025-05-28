import 'package:flutter/material.dart';
import 'package:ai_cook_project/widgets/chat_widget.dart';
import 'package:ai_cook_project/theme.dart';

class FloatingChatWindow extends StatefulWidget {
  final VoidCallback onClose;
  final bool isOpen;

  const FloatingChatWindow({
    super.key,
    required this.onClose,
    required this.isOpen,
  });

  @override
  State<FloatingChatWindow> createState() => _FloatingChatWindowState();
}

class _FloatingChatWindowState extends State<FloatingChatWindow>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  Offset? _position;
  bool _isDragging = false;

  // Responsive size constants
  static const double _minWindowWidth = 320.0;
  static const double _maxWindowWidth = 500.0;
  static const double _minWindowHeight = 450.0;
  static const double _maxWindowHeight = 700.0;
  static const double _aspectRatio = 0.75; // height = width * 1.5

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutExpo));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    if (widget.isOpen) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(FloatingChatWindow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isOpen != oldWidget.isOpen) {
      if (widget.isOpen) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSendMessage(String message) {
    // TODO: Implement AI service integration
    print('Message sent: $message');
  }

  Size _calculateWindowSize(BoxConstraints constraints) {
    // Calculate base width as percentage of screen width
    final screenWidth = constraints.maxWidth;
    final screenHeight = constraints.maxHeight;
    final isLandscape = screenWidth > screenHeight;

    // Base calculations
    double width;
    if (isLandscape) {
      // In landscape, use smaller percentage of screen width
      width = screenWidth * 0.4;
    } else {
      // In portrait, use larger percentage of screen width
      width = screenWidth * 0.85;
    }

    // Clamp width between min and max
    width = width.clamp(_minWindowWidth, _maxWindowWidth);

    // Calculate height based on aspect ratio, but respect min/max
    double height = width / _aspectRatio;
    height = height.clamp(_minWindowHeight, _maxWindowHeight);

    // Final adjustment to ensure window fits on screen
    if (height > screenHeight * 0.9) {
      height = screenHeight * 0.9;
      width = height * _aspectRatio;
      width = width.clamp(_minWindowWidth, screenWidth * 0.95);
    }

    return Size(width, height);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = _calculateWindowSize(constraints);
          final width = size.width;
          final height = size.height;

          // Calculate initial centered position if not set
          _position ??= Offset(
            (constraints.maxWidth - width) / 2,
            (constraints.maxHeight - height) / 2,
          );

          return Stack(
            children: [
              // Optional semi-transparent background overlay
              Positioned.fill(
                child: GestureDetector(
                  onTap: widget.onClose,
                  child: Container(color: Colors.black.withOpacity(0.3)),
                ),
              ),
              // Chat window
              Positioned(
                left: _position!.dx,
                top: _position!.dy,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: GestureDetector(
                      onPanStart: (details) {
                        setState(() => _isDragging = true);
                      },
                      onPanUpdate: (details) {
                        setState(() {
                          _position = Offset(
                            (_position!.dx + details.delta.dx).clamp(
                              0,
                              constraints.maxWidth - width,
                            ),
                            (_position!.dy + details.delta.dy).clamp(
                              0,
                              constraints.maxHeight - height,
                            ),
                          );
                        });
                      },
                      onPanEnd: (details) {
                        setState(() => _isDragging = false);
                      },
                      child: Container(
                        width: width,
                        height: height,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 30,
                              spreadRadius: -5,
                              offset: const Offset(0, 10),
                            ),
                            BoxShadow(
                              color: AppColors.white.withOpacity(0.1),
                              blurRadius: 40,
                              spreadRadius: 0,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: Column(
                            children: [
                              _buildHeader(),
                              Expanded(
                                child: ChatWidget(
                                  onSendMessage: _handleSendMessage,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.white.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'my Kitchen Assistant',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'Casta',
                    letterSpacing: 0.3,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'powered by DeepSeek®',
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.5),
                    fontSize: 10,
                    fontFamily: 'Arial',
                    letterSpacing: 0.5,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: widget.onClose,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: const Icon(
                    Icons.close_rounded,
                    color: Colors.black,
                    size: 22,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
