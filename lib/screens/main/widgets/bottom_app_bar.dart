import 'package:ai_cook_project/screens/main/helpers/tabs.dart';
import 'package:ai_cook_project/screens/main/widgets/build_tab.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/widgets/buttons/ai_button.dart';
import 'package:ai_cook_project/utils/responsive_utils.dart';
import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabTapped;

  const CustomBottomNavBar({
    required this.currentIndex,
    required this.onTabTapped,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final deviceType = ResponsiveUtils.getDeviceType(context);

    // Consistent height calculation using responsive spacing system
    final height = switch (deviceType) {
      DeviceType.iPhone =>
        ResponsiveUtils.spacing(context, ResponsiveSpacing.xxl) +
            ResponsiveUtils.spacing(context, ResponsiveSpacing.lg),
      DeviceType.iPadMini =>
        ResponsiveUtils.spacing(context, ResponsiveSpacing.xxl) +
            ResponsiveUtils.spacing(context, ResponsiveSpacing.xl),
      DeviceType.iPadPro =>
        ResponsiveUtils.spacing(context, ResponsiveSpacing.xxl) +
            ResponsiveUtils.spacing(context, ResponsiveSpacing.xxl) * 0.5,
    };

    // Consistent notch margin using responsive spacing
    final notchMargin = ResponsiveUtils.spacing(context, ResponsiveSpacing.xs);

    return BottomAppBar(
      color: AppColors.white,
      elevation: 8,
      notchMargin: notchMargin,
      shape: const CircularNotchedRectangle(),
      // Consistent horizontal padding using responsive system
      padding: ResponsiveUtils.horizontalPadding(context, ResponsiveSpacing.sm),
      child: SizedBox(
        height: height,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment:
              CrossAxisAlignment.center, // Centrar verticalmente
          children: [
            // Primera mitad de tabs (índices 0 y 1)
            // First half of tabs (indices 0 and 1)
            ...List.generate(
              2,
              (index) => Expanded(
                child: SizedBox(
                  height: height,
                  child: Center(
                    child: TabItem(
                      icon: getPages(context)[index].icon,
                      label: getPages(context)[index].title,
                      isActive: currentIndex == index,
                      onTap: () => onTabTapped(index),
                    ),
                  ),
                ),
              ),
            ),
            // Space for AI floating button - consistent across devices
            Expanded(flex: 1, child: const SizedBox()),
            // Second half of tabs (indices 2 and 3)
            ...List.generate(
              2,
              (index) => Expanded(
                child: SizedBox(
                  height: height,
                  child: Center(
                    child: TabItem(
                      icon: getPages(context)[index + 2].icon,
                      label: getPages(context)[index + 2].title,
                      isActive: currentIndex == index + 2,
                      onTap: () => onTabTapped(index + 2),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NavBarBuilder extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabTapped;
  final VoidCallback toggleAiWindow;
  final bool isAiWindowOpen;

  const NavBarBuilder({
    super.key,
    required this.currentIndex,
    required this.onTabTapped,
    required this.toggleAiWindow,
    required this.isAiWindowOpen,
  });

  @override
  Widget build(BuildContext context) {
    final deviceType = ResponsiveUtils.getDeviceType(context);
    final mediaQuery = MediaQuery.of(context);
    final bottomSafeArea = mediaQuery.padding.bottom;

    // Base AI button size using consistent responsive scaling
    final baseButtonSize = ResponsiveUtils.iconSize(
      context,
      ResponsiveIconSize.xxl,
    );

    // Consistent button sizing with proportional scaling
    final normalSize = switch (deviceType) {
      DeviceType.iPhone => baseButtonSize * 1.8,
      DeviceType.iPadMini => baseButtonSize * 1.9,
      DeviceType.iPadPro => baseButtonSize * 2.0,
    };

    final activeSize = switch (deviceType) {
      DeviceType.iPhone => baseButtonSize * 2.4,
      DeviceType.iPadMini => baseButtonSize * 2.6,
      DeviceType.iPadPro => baseButtonSize * 2.8,
    };

    // Improved positioning that accounts for safe area and device type
    final normalTop = switch (deviceType) {
      DeviceType.iPhone =>
        ResponsiveUtils.spacing(context, ResponsiveSpacing.xs) * 0.5,
      DeviceType.iPadMini =>
        bottomSafeArea > 0
            ? ResponsiveUtils.spacing(context, ResponsiveSpacing.sm)
            : ResponsiveUtils.spacing(context, ResponsiveSpacing.xs),
      DeviceType.iPadPro =>
        bottomSafeArea > 0
            ? ResponsiveUtils.spacing(context, ResponsiveSpacing.sm)
            : ResponsiveUtils.spacing(context, ResponsiveSpacing.xs),
    };

    final activeTop = switch (deviceType) {
      DeviceType.iPhone =>
        -ResponsiveUtils.spacing(context, ResponsiveSpacing.xl),
      DeviceType.iPadMini =>
        bottomSafeArea > 0
            ? -ResponsiveUtils.spacing(context, ResponsiveSpacing.lg)
            : -ResponsiveUtils.spacing(context, ResponsiveSpacing.xl),
      DeviceType.iPadPro =>
        bottomSafeArea > 0
            ? -ResponsiveUtils.spacing(context, ResponsiveSpacing.xl)
            : -ResponsiveUtils.spacing(context, ResponsiveSpacing.xl) * 1.2,
    };

    // Consistent animation duration
    const animDuration = Duration(milliseconds: 300);

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        SafeArea(
          bottom: false,
          child: CustomBottomNavBar(
            currentIndex: currentIndex,
            onTabTapped: onTabTapped,
          ),
        ),
        Positioned(
          bottom: bottomSafeArea,
          left: 0,
          right: 0,
          child: AnimatedContainer(
            duration: animDuration,
            curve: Curves.easeInOutCubic,
            transform: Matrix4.translationValues(
              0,
              isAiWindowOpen ? activeTop : normalTop,
              0,
            ),
            child: Center(
              child: AnimatedContainer(
                duration: animDuration,
                curve: Curves.easeInOutCubic,
                width: isAiWindowOpen ? activeSize : normalSize,
                height: isAiWindowOpen ? activeSize : normalSize,
                child: AiButton(
                  onPressed: toggleAiWindow,
                  isActive: isAiWindowOpen,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
