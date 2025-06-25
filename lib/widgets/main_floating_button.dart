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
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
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
    final double cardWidth = size.width < 200 ? 190 : 230;

    return OverlayEntry(
      builder:
          (context) => Positioned(
            top: offset.dy + size.height + 8,
            left: offset.dx,
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: Offset(0, size.height + 8),
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
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 16,
                                  backgroundColor: Colors.grey.shade200,
                                  child: const Icon(
                                    Icons.person,
                                    color: AppColors.orange,
                                    size: 18,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Expanded(
                                  child: Text(
                                    'Lucia Schlegel',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.black,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: _closeMenu,
                                  child: const Icon(
                                    Icons.close,
                                    size: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(height: 1),
                          if (widget.currentIndex != -1)
                            _buildMenuItem(
                              Icons.home_rounded,
                              'Feed',
                              widget.onFeedTap,
                            ),
                          _buildMenuItem(
                            Icons.person_rounded,
                            'Profile',
                            widget.onProfileTap,
                          ),
                          _buildMenuItem(
                            Icons.logout_rounded,
                            'Logout',
                            widget.onLogoutTap,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
    );
  }

  Widget _buildMenuItem(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        onTap();
        _closeMenu();
        widget.onMenuStateChanged(false);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.orange),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.black,
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
    );
  }
}
