import 'package:ai_cook_project/screens/calendar/calendar_screen.dart';
import 'package:ai_cook_project/screens/recipes/recipes_screen.dart';
import 'package:ai_cook_project/screens/settings/settings_screen.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:flutter/material.dart';

class IconProperties {
  final IconData? icon;
  final String? svgAsset;
  final double size;
  final double? activeSize;
  final Color? activeColor;
  final Color? inactiveColor;
  final double? activeShadowRadius;
  final Color? activeShadowColor;

  const IconProperties({
    this.icon,
    this.svgAsset,
    this.size = 24,
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

final List<_PageData> pages = [
  _PageData(
    title: 'Cupboard',
    icon: IconProperties(
      svgAsset: 'assets/icons/fridge.svg',
      size: 26,
      activeSize: 28,
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
      size: 26,
      activeSize: 28,
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
      size: 26,
      activeSize: 28,
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
      size: 26,
      activeSize: 28,
      activeColor: AppColors.orange,
      inactiveColor: const Color.fromARGB(255, 123, 123, 123),
      activeShadowRadius: 8,
      activeShadowColor: AppColors.orange.withOpacity(0.1),
    ),
    widget: const SettingsScreen(),
  ),
];
