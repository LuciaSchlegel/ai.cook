import 'package:ai_cook_project/screens/main/helpers/tabs.dart';
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
    final color =
        isActive ? AppColors.orange : const Color.fromARGB(255, 123, 123, 123);

    final iconSize = isActive ? (icon.activeSize ?? icon.size) : icon.size;
    final iconColor =
        isActive ? (icon.activeColor ?? color) : (icon.inactiveColor ?? color);

    Widget iconWidget;
    if (icon.svgAsset != null) {
      // Handle SVG asset
      iconWidget = SvgPicture.asset(
        icon.svgAsset!,
        width: iconSize,
        height: iconSize,
        colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
      );
    } else {
      // Handle Flutter icon
      iconWidget = Icon(icon.icon, size: iconSize, color: iconColor);
    }

    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration:
                isActive && icon.activeShadowRadius != null
                    ? BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color:
                              icon.activeShadowColor ??
                              iconColor.withOpacity(0.3),
                          blurRadius: icon.activeShadowRadius!,
                          spreadRadius: 0,
                        ),
                      ],
                    )
                    : null,
            child: iconWidget,
          ),
          const SizedBox(height: 4),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
