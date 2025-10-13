import 'package:ai_cook_project/screens/main/helpers/tabs.dart';
import 'package:ai_cook_project/widgets/responsive/responsive_builder.dart';
import 'package:ai_cook_project/utils/responsive_utils.dart';
import 'package:flutter/material.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TabItem extends StatelessWidget {
  final IconProperties icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const TabItem({
    super.key,
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Consistent font size using responsive system
    final fontSize = ResponsiveUtils.fontSize(context, ResponsiveFontSize.xs);

    final iconSize = isActive ? (icon.activeSize ?? icon.size) : icon.size;
    final color =
        isActive ? AppColors.orange : const Color.fromARGB(255, 123, 123, 123);
    final iconColor =
        isActive ? (icon.activeColor ?? color) : (icon.inactiveColor ?? color);

    // Consistent spacing between icon and text
    final iconTextSpacing = ResponsiveSpacing.xxs;

    Widget iconWidget;
    if (icon.svgAsset != null) {
      iconWidget = SvgPicture.asset(
        icon.svgAsset!,
        width: iconSize,
        height: iconSize,
        colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
      );
    } else {
      iconWidget = Icon(icon.icon, size: iconSize, color: iconColor);
    }

    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      borderRadius: BorderRadius.circular(
        ResponsiveUtils.borderRadius(context, ResponsiveBorderRadius.md),
      ),
      child: Container(
        // Use full available height with consistent padding
        height: double.infinity,
        padding: ResponsiveUtils.verticalPadding(context, ResponsiveSpacing.xs),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icono con shadow condicional
            Container(
              decoration:
                  isActive && icon.activeShadowRadius != null
                      ? BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color:
                                icon.activeShadowColor ??
                                iconColor.withValues(alpha: 0.3),
                            blurRadius: icon.activeShadowRadius!,
                            spreadRadius: 0,
                          ),
                        ],
                      )
                      : null,
              child: iconWidget,
            ),

            // Spacing responsivo
            ResponsiveSpacingWidget.vertical(iconTextSpacing),

            // Responsive text with consistent styling
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontSize: fontSize,
                    fontWeight: AppFontWeights.medium,
                    fontFamily: 'Inter',
                    height: 1.0,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
