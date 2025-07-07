import 'package:flutter/material.dart';
import 'package:ai_cook_project/theme.dart';
import 'dart:ui';

class MainFloatingButton extends StatefulWidget {
  final VoidCallback onProfileTap;
  final VoidCallback onFeedTap;
  final VoidCallback onLogoutTap;
  final int currentIndex;
  final Function(bool) onMenuStateChanged;

  const MainFloatingButton({
    super.key,
    required this.onProfileTap,
    required this.onFeedTap,
    required this.onLogoutTap,
    required this.currentIndex,
    required this.onMenuStateChanged,
  });

  @override
  State<MainFloatingButton> createState() => _MainFloatingButtonState();
}

class _MainFloatingButtonState extends State<MainFloatingButton>
    with SingleTickerProviderStateMixin {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.7,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
  }

  void _toggleMenu() {
    if (_isOpen) {
      _closeMenu();
    } else {
      _openMenu();
    }
    widget.onMenuStateChanged(!_isOpen);
  }

  void _openMenu() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final overlay = Overlay.of(context);
      _overlayEntry = _buildOverlayEntry();
      overlay.insert(_overlayEntry!);
      _controller.forward();
      setState(() => _isOpen = true);
    });
  }

  void _closeMenu() {
    if (!_isOpen) return;
    if (mounted) {
      _controller.reverse().then((_) {
        _overlayEntry?.remove();
        _overlayEntry = null;
        if (mounted) {
          setState(() => _isOpen = false);
        }
      });
    }
  }

  OverlayEntry _buildOverlayEntry() {
    final renderObject = context.findRenderObject();
    if (renderObject == null || renderObject is! RenderBox) {
      return OverlayEntry(builder: (_) => const SizedBox.shrink());
    }
    final RenderBox renderBox = renderObject;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;
    final double cardWidth = 280;

    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Backdrop with blur effect
          Positioned.fill(
            child: GestureDetector(
              onTap: _closeMenu,
              child: Container(
                color: Colors.black.withOpacity(0.2),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                  child: Container(
                    color: Colors.transparent,
                  ),
                ),
              ),
            ),
          ),
          // Menu content
          Positioned(
            top: offset.dy + size.height + 16,
            left: offset.dx - (cardWidth - size.width) / 2,
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: Offset(0, size.height + 16),
              child: Material(
                elevation: 0,
                color: Colors.transparent,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Container(
                        width: cardWidth,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: AppColors.orange.withOpacity(0.08),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 32,
                              offset: const Offset(0, 16),
                              spreadRadius: 0,
                            ),
                            BoxShadow(
                              color: AppColors.orange.withOpacity(0.06),
                              blurRadius: 48,
                              offset: const Offset(0, 24),
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Elegant header
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.orange.withOpacity(0.03),
                                    AppColors.lightYellow.withOpacity(0.06),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(24),
                                  topRight: Radius.circular(24),
                                ),
                              ),
                              child: Row(
                                children: [
                                  // Sophisticated avatar
                                  Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        colors: [
                                          AppColors.orange,
                                          AppColors.lightYellow,
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.orange.withOpacity(0.25),
                                          blurRadius: 12,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.person_rounded,
                                      color: AppColors.white,
                                      size: 22,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  const Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Lucia Schlegel',
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.black,
                                            letterSpacing: -0.3,
                                          ),
                                        ),
                                        SizedBox(height: 3),
                                        Text(
                                          'Culinary enthusiast',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: AppColors.mutedGreen,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: -0.2,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Elegant close button
                                  GestureDetector(
                                    onTap: _closeMenu,
                                    child: Container(
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade50,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.grey.shade200,
                                          width: 1,
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.close_rounded,
                                        size: 18,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Refined menu items
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Column(
                                children: [
                                  if (widget.currentIndex != -1)
                                    _buildMenuItem(
                                      Icons.home_rounded,
                                      'Feed',
                                      'Discover new recipes',
                                      widget.onFeedTap,
                                    ),
                                  _buildMenuItem(
                                    Icons.person_rounded,
                                    'Profile',
                                    'Manage your account',
                                    widget.onProfileTap,
                                  ),
                                  _buildMenuItem(
                                    Icons.logout_rounded,
                                    'Logout',
                                    'Sign out of your account',
                                    widget.onLogoutTap,
                                    isDestructive: true,
                                  ),
                                ],
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
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    IconData icon,
    String label,
    String subtitle,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        onTap();
        _closeMenu();
        widget.onMenuStateChanged(false);
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.transparent,
        ),
        child: Row(
          children: [
            // Refined icon container
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isDestructive
                    ? Colors.red.shade50
                    : AppColors.orange.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDestructive
                      ? Colors.red.shade100
                      : AppColors.orange.withOpacity(0.15),
                  width: 1,
                ),
              ),
              child: Icon(
                icon,
                size: 20,
                color: isDestructive ? Colors.red.shade600 : AppColors.orange,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isDestructive ? Colors.red.shade600 : AppColors.black,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.mutedGreen,
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.1,
                    ),
                  ),
                ],
              ),
            ),
            // Elegant arrow
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.grey.shade200,
                  width: 1,
                ),
              ),
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: AppColors.mutedGreen,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: SizedBox(
        width: 48,
        height: 48,
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                AppColors.orange,
                AppColors.lightYellow,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.orange.withOpacity(0.2),
                blurRadius: 16,
                offset: const Offset(0, 8),
                spreadRadius: 0,
              ),
              BoxShadow(
                color: AppColors.orange.withOpacity(0.08),
                blurRadius: 32,
                offset: const Offset(0, 16),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: _toggleMenu,
              child: AnimatedRotation(
                turns: _isOpen ? 0.125 : 0,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
                child: const Icon(
                  Icons.menu_rounded,
                  color: AppColors.white,
                  size: 24,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
