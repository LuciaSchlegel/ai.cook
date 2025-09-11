import 'package:flutter/material.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/utils/responsive_utils.dart';
import 'package:ai_cook_project/widgets/responsive/responsive_builder.dart';
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

    // Responsive card width based on device type
    final double cardWidth =
        ResponsiveUtils.getDeviceType(context) == DeviceType.iPhone
            ? 280.0
            : ResponsiveUtils.getDeviceType(context) == DeviceType.iPadMini
            ? 320.0
            : 360.0;

    return OverlayEntry(
      builder:
          (context) => Stack(
            children: [
              // Backdrop with blur effect
              Positioned.fill(
                child: GestureDetector(
                  onTap: _closeMenu,
                  child: Container(
                    color: Colors.black.withOpacity(0.2),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                      child: Container(color: Colors.transparent),
                    ),
                  ),
                ),
              ),
              // Menu content
              Positioned(
                top:
                    offset.dy +
                    size.height +
                    ResponsiveUtils.spacing(context, ResponsiveSpacing.md),
                left: offset.dx - (cardWidth - size.width) / 2,
                child: CompositedTransformFollower(
                  link: _layerLink,
                  showWhenUnlinked: false,
                  offset: Offset(
                    0,
                    size.height +
                        ResponsiveUtils.spacing(context, ResponsiveSpacing.md),
                  ),
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
                              borderRadius: BorderRadius.circular(
                                ResponsiveUtils.borderRadius(
                                  context,
                                  ResponsiveBorderRadius.xl,
                                ),
                              ),
                              border: Border.all(
                                color: AppColors.orange.withOpacity(0.08),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: ResponsiveUtils.spacing(
                                    context,
                                    ResponsiveSpacing.xl,
                                  ),
                                  offset: Offset(
                                    0,
                                    ResponsiveUtils.spacing(
                                      context,
                                      ResponsiveSpacing.md,
                                    ),
                                  ),
                                  spreadRadius: 0,
                                ),
                                BoxShadow(
                                  color: AppColors.orange.withOpacity(0.06),
                                  blurRadius: ResponsiveUtils.spacing(
                                    context,
                                    ResponsiveSpacing.xxl,
                                  ),
                                  offset: Offset(
                                    0,
                                    ResponsiveUtils.spacing(
                                      context,
                                      ResponsiveSpacing.lg,
                                    ),
                                  ),
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Elegant header
                                Container(
                                  padding: ResponsiveUtils.padding(
                                    context,
                                    ResponsiveSpacing.lg,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        AppColors.orange.withOpacity(0.03),
                                        AppColors.lightYellow.withOpacity(0.06),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(
                                        ResponsiveUtils.borderRadius(
                                          context,
                                          ResponsiveBorderRadius.xl,
                                        ),
                                      ),
                                      topRight: Radius.circular(
                                        ResponsiveUtils.borderRadius(
                                          context,
                                          ResponsiveBorderRadius.xl,
                                        ),
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      // Sophisticated avatar
                                      Container(
                                        width:
                                            ResponsiveUtils.iconSize(
                                              context,
                                              ResponsiveIconSize.xxl,
                                            ) +
                                            4,
                                        height:
                                            ResponsiveUtils.iconSize(
                                              context,
                                              ResponsiveIconSize.xxl,
                                            ) +
                                            4,
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
                                              color: AppColors.orange
                                                  .withOpacity(0.25),
                                              blurRadius:
                                                  ResponsiveUtils.spacing(
                                                    context,
                                                    ResponsiveSpacing.sm,
                                                  ),
                                              offset: Offset(
                                                0,
                                                ResponsiveUtils.spacing(
                                                  context,
                                                  ResponsiveSpacing.xxs,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        child: ResponsiveIcon(
                                          Icons.person_rounded,
                                          null,
                                          size: ResponsiveIconSize.lg,
                                          color: AppColors.white,
                                        ),
                                      ),
                                      ResponsiveSpacingWidget.horizontal(
                                        ResponsiveSpacing.md,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ResponsiveText(
                                              'Lucia Schlegel',
                                              fontSize: ResponsiveFontSize.lg,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.black,
                                              letterSpacing: -0.3,
                                            ),
                                            ResponsiveSpacingWidget.vertical(
                                              ResponsiveSpacing.xxs,
                                            ),
                                            ResponsiveText(
                                              'Culinary enthusiast',
                                              fontSize: ResponsiveFontSize.sm,
                                              color: AppColors.mutedGreen,
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: -0.2,
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Elegant close button
                                      GestureDetector(
                                        onTap: _closeMenu,
                                        child: Container(
                                          width: ResponsiveUtils.iconSize(
                                            context,
                                            ResponsiveIconSize.xl,
                                          ),
                                          height: ResponsiveUtils.iconSize(
                                            context,
                                            ResponsiveIconSize.xl,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade50,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Colors.grey.shade200,
                                              width: 1,
                                            ),
                                          ),
                                          child: ResponsiveIcon(
                                            Icons.close_rounded,
                                            null,
                                            size: ResponsiveIconSize.sm,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Refined menu items
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: ResponsiveUtils.spacing(
                                      context,
                                      ResponsiveSpacing.sm,
                                    ),
                                  ),
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
    return ResponsiveBuilder(
      builder: (context, deviceType) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            onTap();
            _closeMenu();
            widget.onMenuStateChanged(false);
          },
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(
              horizontal: ResponsiveUtils.spacing(
                context,
                ResponsiveSpacing.md,
              ),
              vertical: ResponsiveUtils.spacing(context, ResponsiveSpacing.xxs),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveUtils.spacing(
                context,
                ResponsiveSpacing.md,
              ),
              vertical: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                ResponsiveUtils.borderRadius(
                  context,
                  ResponsiveBorderRadius.md,
                ),
              ),
              color: Colors.transparent,
            ),
            child: Row(
              children: [
                // Refined icon container
                Container(
                  width: ResponsiveUtils.iconSize(
                    context,
                    ResponsiveIconSize.xxl,
                  ),
                  height: ResponsiveUtils.iconSize(
                    context,
                    ResponsiveIconSize.xxl,
                  ),
                  decoration: BoxDecoration(
                    color:
                        isDestructive
                            ? Colors.red.shade50
                            : AppColors.orange.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(
                      ResponsiveUtils.borderRadius(
                        context,
                        ResponsiveBorderRadius.sm,
                      ),
                    ),
                    border: Border.all(
                      color:
                          isDestructive
                              ? Colors.red.shade100
                              : AppColors.orange.withOpacity(0.15),
                      width: 1,
                    ),
                  ),
                  child: ResponsiveIcon(
                    icon,
                    null,
                    size: ResponsiveIconSize.md,
                    color:
                        isDestructive ? Colors.red.shade600 : AppColors.orange,
                  ),
                ),
                ResponsiveSpacingWidget.horizontal(ResponsiveSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ResponsiveText(
                        label,
                        fontSize: ResponsiveFontSize.md,
                        fontWeight: FontWeight.w600,
                        color:
                            isDestructive
                                ? Colors.red.shade600
                                : AppColors.black,
                        letterSpacing: -0.2,
                      ),
                      ResponsiveSpacingWidget.vertical(ResponsiveSpacing.xxs),
                      ResponsiveText(
                        subtitle,
                        fontSize: ResponsiveFontSize.sm,
                        color: AppColors.mutedGreen,
                        fontWeight: FontWeight.w500,
                        letterSpacing: -0.1,
                      ),
                    ],
                  ),
                ),
                // Elegant arrow
                Container(
                  width: ResponsiveUtils.iconSize(
                    context,
                    ResponsiveIconSize.lg,
                  ),
                  height: ResponsiveUtils.iconSize(
                    context,
                    ResponsiveIconSize.lg,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade200, width: 1),
                  ),
                  child: ResponsiveIcon(
                    Icons.arrow_forward_ios_rounded,
                    null,
                    size: ResponsiveIconSize.xs,
                    color: AppColors.mutedGreen,
                  ),
                ),
              ],
            ),
          ),
        );
      },
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
    return ResponsiveBuilder(
      builder: (context, deviceType) {
        final buttonSize =
            ResponsiveUtils.iconSize(context, ResponsiveIconSize.xxl) + 8;

        return CompositedTransformTarget(
          link: _layerLink,
          child: SizedBox(
            width: buttonSize,
            height: buttonSize,
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [AppColors.orange, AppColors.lightYellow],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.orange.withOpacity(0.2),
                    blurRadius: ResponsiveUtils.spacing(
                      context,
                      ResponsiveSpacing.md,
                    ),
                    offset: Offset(
                      0,
                      ResponsiveUtils.spacing(context, ResponsiveSpacing.xs),
                    ),
                    spreadRadius: 0,
                  ),
                  BoxShadow(
                    color: AppColors.orange.withOpacity(0.08),
                    blurRadius: ResponsiveUtils.spacing(
                      context,
                      ResponsiveSpacing.xl,
                    ),
                    offset: Offset(
                      0,
                      ResponsiveUtils.spacing(context, ResponsiveSpacing.md),
                    ),
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
                    child: ResponsiveIcon(
                      Icons.menu_rounded,
                      null,
                      size: ResponsiveIconSize.lg,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
