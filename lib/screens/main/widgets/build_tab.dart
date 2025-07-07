import 'package:ai_cook_project/screens/main/helpers/tabs.dart';
import 'package:flutter/material.dart';
import 'package:ai_cook_project/theme.dart';

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
            child: Icon(icon.icon, size: iconSize, color: iconColor),
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
