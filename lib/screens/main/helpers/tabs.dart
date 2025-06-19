import 'package:ai_cook_project/screens/calendar/calendar_screen.dart';
import 'package:ai_cook_project/screens/cupboard/cupboard_screen.dart';
import 'package:ai_cook_project/screens/recipes/recipes_screen.dart';
import 'package:ai_cook_project/screens/settings/settings_screen.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:flutter/material.dart';

class IconProperties {
  final IconData icon;
  final double size;
  final double? activeSize;
  final Color? activeColor;
  final Color? inactiveColor;
  final double? activeShadowRadius;
  final Color? activeShadowColor;

  const IconProperties({
    required this.icon,
    this.size = 24,
    this.activeSize,
    this.activeColor,
    this.inactiveColor,
    this.activeShadowRadius,
    this.activeShadowColor,
  });
}

class _PageData {
  final String title;
  final IconProperties icon;
  final Widget widget;

  const _PageData({
    required this.title,
    required this.icon,
    required this.widget,
  });
}

final List<_PageData> pages = [
  _PageData(
    title: 'Cupboard',
    icon: IconProperties(
      icon: Icons.kitchen_rounded,
      size: 24,
      activeSize: 28,
      activeColor: AppColors.orange,
      inactiveColor: const Color.fromARGB(255, 123, 123, 123),
      activeShadowRadius: 8,
      activeShadowColor: AppColors.orange.withOpacity(0.1),
    ),
    widget: const CupboardScreen(),
  ),
  _PageData(
    title: 'Recipes',
    icon: IconProperties(
      icon: Icons.restaurant_menu_rounded,
      size: 24,
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
      icon: Icons.calendar_month_rounded,
      size: 24,
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
      icon: Icons.settings_rounded,
      size: 24,
      activeSize: 28,
      activeColor: AppColors.orange,
      inactiveColor: const Color.fromARGB(255, 123, 123, 123),
      activeShadowRadius: 8,
      activeShadowColor: AppColors.orange.withOpacity(0.1),
    ),
    widget: const SettingsScreen(),
  ),
];
