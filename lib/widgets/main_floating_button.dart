//main_floating_button.dart
import 'package:flutter/material.dart';
import 'package:ai_cook_project/theme.dart';

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
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  void _toggleMenu() {
    setState(() {
      _isOpen = !_isOpen;
      widget.onMenuStateChanged(_isOpen);
      if (_isOpen) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double cardWidth = screenWidth < 350 ? 190 : 230;

    return Material(
      color: Colors.transparent,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          if (!_isOpen)
            SizedBox(
              width: 48,
              height: 48,
              child: FloatingActionButton(
                heroTag: 'main_fab',
                onPressed: _toggleMenu,
                backgroundColor: AppColors.orange,
                elevation: 4,
                shape: const CircleBorder(),
                mini: true,
                child: const Icon(Icons.menu_rounded, color: Colors.white),
              ),
            ),
          if (_isOpen)
            TapRegion(
              onTapOutside: (event) {
                setState(() {
                  _isOpen = false;
                  _animationController.reverse();
                  widget.onMenuStateChanged(false);
                });
              },
              child: Positioned(
                top: 0,
                right: 0,
                child: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(16),
                  clipBehavior: Clip.antiAlias,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Container(
                        width: cardWidth,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  const CircleAvatar(
                                    radius: 16,
                                    backgroundImage: AssetImage(
                                      'assets/images/default_avatar.png',
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      'Lucia Schlegel',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.black,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () {
                                      _toggleMenu();
                                      widget.onMenuStateChanged(false);
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.all(4),
                                      child: Icon(
                                        Icons.close_rounded,
                                        size: 16,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(height: 1),
                            if (widget.currentIndex != -1)
                              GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  widget.onFeedTap();
                                  setState(() {
                                    _isOpen = false;
                                    _animationController.reverse();
                                    widget.onMenuStateChanged(false);
                                  });
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.home_rounded,
                                        size: 20,
                                        color: AppColors.orange,
                                      ),
                                      const SizedBox(width: 12),
                                      const Text(
                                        'Feed',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                widget.onProfileTap();
                                setState(() {
                                  _isOpen = false;
                                  _animationController.reverse();
                                  widget.onMenuStateChanged(false);
                                });
                              },
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.person_rounded,
                                      size: 20,
                                      color: AppColors.orange,
                                    ),
                                    const SizedBox(width: 12),
                                    const Text(
                                      'Profile',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                widget.onLogoutTap();
                                setState(() {
                                  _isOpen = false;
                                  _animationController.reverse();
                                  widget.onMenuStateChanged(false);
                                });
                              },
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.logout_rounded,
                                      size: 20,
                                      color: AppColors.orange,
                                    ),
                                    const SizedBox(width: 12),
                                    const Text(
                                      'Logout',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.black,
                                      ),
                                    ),
                                  ],
                                ),
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
      ),
    );
  }
}
