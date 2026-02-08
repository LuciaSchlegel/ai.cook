import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/utils/responsive_utils.dart';
import 'package:flutter/cupertino.dart';

class ErrorBuild extends StatelessWidget {
  final String error;

  const ErrorBuild({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: ResponsiveUtils.spacing(context, ResponsiveSpacing.xs),
      ),
      padding: ResponsiveUtils.padding(context, ResponsiveSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.borderRadius(context, ResponsiveBorderRadius.lg),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.button.withValues(alpha: 0.04),
            blurRadius: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: AppColors.button.withValues(alpha: 0.08),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width:
                ResponsiveUtils.iconSize(context, ResponsiveIconSize.xxl) +
                ResponsiveUtils.spacing(context, ResponsiveSpacing.md),
            height:
                ResponsiveUtils.iconSize(context, ResponsiveIconSize.xxl) +
                ResponsiveUtils.spacing(context, ResponsiveSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.orange.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              CupertinoIcons.exclamationmark_triangle,
              size: ResponsiveUtils.iconSize(context, ResponsiveIconSize.xl),
              color: AppColors.orange,
            ),
          ),
          SizedBox(
            height: ResponsiveUtils.spacing(context, ResponsiveSpacing.md),
          ),
          Text(
            'Something Went Wrong',
            style: AppTextStyles.casta(
              fontSize: ResponsiveUtils.fontSize(
                context,
                ResponsiveFontSize.title,
              ),
              fontWeight: AppFontWeights.semiBold,
              color: AppColors.button,
              letterSpacing: 0.4,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
          ),
          Text(
            error,
            style: AppTextStyles.inter(
              fontSize: ResponsiveUtils.fontSize(
                context,
                ResponsiveFontSize.sm,
              ),
              fontWeight: AppFontWeights.regular,
              color: AppColors.button.withValues(alpha: 0.5),
              letterSpacing: 0.2,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
