import 'package:ai_cook_project/screens/calendar/calendar_screen.dart';
import 'package:ai_cook_project/screens/recipes/recipes_screen.dart';
import 'package:ai_cook_project/screens/settings/settings_screen.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/utils/responsive_utils.dart';
import 'package:flutter/material.dart';

class IconProperties {
  final IconData? icon;
  final String? svgAsset;
  final double? size;
  final double? activeSize;
  final Color? activeColor;
  final Color? inactiveColor;
  final double? activeShadowRadius;
  final Color? activeShadowColor;

  const IconProperties({
    this.icon,
    this.svgAsset,
    this.size,
    this.activeSize,
    this.activeColor,
    this.inactiveColor,
    this.activeShadowRadius,
    this.activeShadowColor,
  }) : assert(
         icon != null || svgAsset != null,
         'Either icon or svgAsset must be provided',
       );
}

class _PageData {
  final String title;
  final IconProperties icon;
  final Widget? widget;

  const _PageData({required this.title, required this.icon, this.widget});
}

List<_PageData> getPages(BuildContext context) {
  return [
    _PageData(
      title: 'Cupboard',
      icon: IconProperties(
        svgAsset: 'assets/icons/fridge.svg',
        size: ResponsiveUtils.iconSize(context, ResponsiveIconSize.lg),
        activeSize: ResponsiveUtils.iconSize(context, ResponsiveIconSize.lg),
        activeColor: AppColors.orange,
        inactiveColor: const Color.fromARGB(255, 123, 123, 123),
        activeShadowRadius: 8,
        activeShadowColor: AppColors.orange.withOpacity(0.1),
      ),
    ),
    _PageData(
      title: 'Recipes',
      icon: IconProperties(
        svgAsset: 'assets/icons/recipes.svg',
        size: ResponsiveUtils.iconSize(context, ResponsiveIconSize.lg),
        activeSize: ResponsiveUtils.iconSize(context, ResponsiveIconSize.lg),
        activeColor: AppColors.orange,
        inactiveColor: const Color.fromARGB(255, 123, 123, 123),
        activeShadowRadius: 8,
        activeShadowColor: AppColors.orange.withOpacity(0.1),
      ),
      widget: const RecipesScreen(),
    ),
    _PageData(
      title: 'Calendar',
      icon: IconProperties(
        svgAsset: 'assets/icons/calendar.svg',
        size: ResponsiveUtils.iconSize(context, ResponsiveIconSize.lg),
        activeSize: ResponsiveUtils.iconSize(context, ResponsiveIconSize.lg),
        activeColor: AppColors.orange,
        inactiveColor: const Color.fromARGB(255, 123, 123, 123),
        activeShadowRadius: 8,
        activeShadowColor: AppColors.orange.withOpacity(0.1),
      ),
      widget: const CalendarScreen(),
    ),
    _PageData(
      title: 'Settings',
      icon: IconProperties(
        svgAsset: 'assets/icons/settings.svg',
        size: ResponsiveUtils.iconSize(context, ResponsiveIconSize.lg),
        activeSize: ResponsiveUtils.iconSize(context, ResponsiveIconSize.lg),
        activeColor: AppColors.orange,
        inactiveColor: const Color.fromARGB(255, 123, 123, 123),
        activeShadowRadius: 8,
        activeShadowColor: AppColors.orange.withOpacity(0.1),
      ),
      widget: const SettingsScreen(),
    ),
  ];
}
