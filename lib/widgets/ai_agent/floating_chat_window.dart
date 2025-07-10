import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ai_cook_project/widgets/ai_agent/chat_widget.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

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

  // Track keyboard state
  double _keyboardHeight = 0;
  bool _keyboardVisible = false;

  // Responsive size constants
  static const double _minWindowWidth = 320.0;
  static const double _maxWindowWidth = 500.0;
  static const double _minWindowHeight = 400.0;
  static const double _maxWindowHeight = 700.0;
  static const double _aspectRatio = 0.75; // height = width * 1.33

  final GlobalKey<ChatWidgetState> _chatWidgetKey =
      GlobalKey<ChatWidgetState>();

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

  void _handleSendMessage(String message) async {
    try {
      final response = await http
          .post(
            Uri.parse('http://172.20.10.14:3000/llm/talk'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'prompt': message}),
          )
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw TimeoutException('Request timed out after 10 seconds');
            },
          );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final aiResponse = responseData['response'] as String;
        if (_chatWidgetKey.currentState != null) {
          _chatWidgetKey.currentState!.receiveMessage(aiResponse);
        }
      } else {
        if (_chatWidgetKey.currentState != null) {
          _chatWidgetKey.currentState!.receiveMessage(
            'Sorry, I encountered an error while processing your message. Please try again.',
          );
        }
      }
    } catch (error) {
      if (_chatWidgetKey.currentState != null) {
        _chatWidgetKey.currentState!.receiveMessage(
          'Sorry, I encountered an error while processing your message. Please try again.',
        );
      }
    }
  }

  Size _calculateWindowSize(BoxConstraints constraints, double keyboardHeight) {
    final screenWidth = constraints.maxWidth;
    final screenHeight = constraints.maxHeight;
    final availableHeight = screenHeight - keyboardHeight;
    final isLandscape = screenWidth > screenHeight;

    // Calculate width
    double width;
    if (isLandscape) {
      width = screenWidth * 0.4;
    } else {
      width = screenWidth * 0.85;
    }
    width = width.clamp(_minWindowWidth, _maxWindowWidth);

    // Calculate height with keyboard consideration
    double height;
    if (keyboardHeight > 0) {
      // When keyboard is visible, use more of available height
      height = availableHeight * 0.8;
      // Ensure minimum height even with keyboard
      height = height.clamp(_minWindowHeight, _maxWindowHeight);
    } else {
      // Normal height calculation
      height = width / _aspectRatio;
      height = height.clamp(_minWindowHeight, _maxWindowHeight);
    }

    // Final adjustment to ensure window fits on screen
    if (height > availableHeight * 0.95) {
      height = availableHeight * 0.95;
      width = height * _aspectRatio;
      width = width.clamp(_minWindowWidth, screenWidth * 0.95);
    }

    return Size(width, height);
  }

  Offset _calculatePosition(
    BoxConstraints constraints,
    Size windowSize,
    double keyboardHeight,
  ) {
    final screenWidth = constraints.maxWidth;
    final screenHeight = constraints.maxHeight;
    final availableHeight = screenHeight - keyboardHeight;

    // If no position is set, center it
    if (_position == null) {
      return Offset(
        (screenWidth - windowSize.width) / 2,
        (availableHeight - windowSize.height) / 2,
      );
    }

    // Adjust existing position for keyboard
    double newX = _position!.dx;
    double newY = _position!.dy;

    // Ensure window stays within bounds
    newX = newX.clamp(0, screenWidth - windowSize.width);
    newY = newY.clamp(0, availableHeight - windowSize.height);

    // If keyboard is visible and window would be hidden, move it up
    if (keyboardHeight > 0 && (newY + windowSize.height) > availableHeight) {
      newY = availableHeight - windowSize.height;
    }

    return Offset(newX, newY);
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isOpen) {
      return const SizedBox.shrink();
    }

    return Material(
      type: MaterialType.transparency,
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Get keyboard height
          final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
          final isKeyboardVisible = keyboardHeight > 0;

          // Update keyboard state
          if (_keyboardVisible != isKeyboardVisible) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                setState(() {
                  _keyboardVisible = isKeyboardVisible;
                  _keyboardHeight = keyboardHeight;
                });
              }
            });
          }

          final windowSize = _calculateWindowSize(constraints, keyboardHeight);
          final position = _calculatePosition(
            constraints,
            windowSize,
            keyboardHeight,
          );

          // Update position if it changed due to keyboard
          if (_position != position && !_isDragging) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                setState(() {
                  _position = position;
                });
              }
            });
          }

          return Stack(
            children: [
              // Background overlay
              Positioned.fill(
                child: GestureDetector(
                  onTap: widget.onClose,
                  behavior: HitTestBehavior.opaque,
                  child: Container(color: Colors.black.withOpacity(0.3)),
                ),
              ),
              // Chat window
              AnimatedPositioned(
                duration:
                    _isDragging
                        ? Duration.zero
                        : const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                left: (_position ?? position).dx,
                top: (_position ?? position).dy,
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
                          final newPosition = Offset(
                            (_position!.dx + details.delta.dx).clamp(
                              0,
                              constraints.maxWidth - windowSize.width,
                            ),
                            (_position!.dy + details.delta.dy).clamp(
                              0,
                              (constraints.maxHeight - keyboardHeight) -
                                  windowSize.height,
                            ),
                          );
                          _position = newPosition;
                        });
                      },
                      onPanEnd: (details) {
                        setState(() => _isDragging = false);
                      },
                      child: Container(
                        width: windowSize.width,
                        height: windowSize.height,
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
                                  key: _chatWidgetKey,
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
                  'powered by Apple Intelligence®',
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
