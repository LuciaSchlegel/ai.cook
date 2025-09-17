import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/utils/responsive_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ErrorBuild extends StatelessWidget {
  final String error;

  const ErrorBuild({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Container(
      height:
          ResponsiveUtils.spacing(context, ResponsiveSpacing.xxl) * 4 +
          ResponsiveUtils.spacing(context, ResponsiveSpacing.xl),
      margin: EdgeInsets.symmetric(
        vertical: ResponsiveUtils.spacing(context, ResponsiveSpacing.xs),
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.borderRadius(context, ResponsiveBorderRadius.lg),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.orange.withValues(alpha: 0.08),
            blurRadius: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
        border: Border.all(
          color: AppColors.orange.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Stack(
        children: [
          // Subtle gradient background
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                ResponsiveUtils.borderRadius(
                  context,
                  ResponsiveBorderRadius.lg,
                ),
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.orange.withValues(alpha: 0.03),
                  AppColors.lightYellow.withValues(alpha: 0.03),
                ],
              ),
            ),
          ),
          // Main content
          Center(
            child: Padding(
              padding: ResponsiveUtils.padding(context, ResponsiveSpacing.md),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Error icon
                  Container(
                    width:
                        ResponsiveUtils.iconSize(
                          context,
                          ResponsiveIconSize.xxl,
                        ) +
                        ResponsiveUtils.spacing(context, ResponsiveSpacing.lg),
                    height:
                        ResponsiveUtils.iconSize(
                          context,
                          ResponsiveIconSize.xxl,
                        ) +
                        ResponsiveUtils.spacing(context, ResponsiveSpacing.lg),
                    decoration: BoxDecoration(
                      color: AppColors.orange.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      CupertinoIcons.exclamationmark_triangle,
                      size: ResponsiveUtils.iconSize(
                        context,
                        ResponsiveIconSize.xl,
                      ),
                      color: AppColors.orange,
                    ),
                  ),
                  SizedBox(
                    height: ResponsiveUtils.spacing(
                      context,
                      ResponsiveSpacing.md,
                    ),
                  ),
                  // Title
                  Text(
                    'AI Chef Unavailable',
                    style: MelodramaTextStyles.semiBold(
                      fontSize: ResponsiveUtils.fontSize(
                        context,
                        ResponsiveFontSize.lg,
                      ),
                      color: AppColors.button,
                    ).copyWith(letterSpacing: 0.3),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: ResponsiveUtils.spacing(
                      context,
                      ResponsiveSpacing.sm,
                    ),
                  ),
                  // Error message
                  Text(
                    error,
                    style: MelodramaTextStyles.regular(
                      fontSize: ResponsiveUtils.fontSize(
                        context,
                        ResponsiveFontSize.sm,
                      ),
                      color: AppColors.button.withValues(alpha: 0.7),
                      height: 1.4,
                    ).copyWith(letterSpacing: 0.1),
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
