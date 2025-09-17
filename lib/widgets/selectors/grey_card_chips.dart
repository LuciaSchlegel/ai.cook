import 'package:ai_cook_project/utils/responsive_utils.dart';
import 'package:ai_cook_project/utils/text_utils.dart';
import 'package:ai_cook_project/widgets/responsive/responsive_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ai_cook_project/theme.dart';
import 'dart:ui';

class GreyCardChips extends StatelessWidget {
  final List<String> items;
  final List<String> selectedItems;
  final void Function(List<String>) onSelected;
  final ResponsiveSpacing horizontalPadding;
  final ResponsiveSpacing verticalPadding;

  const GreyCardChips({
    super.key,
    required this.items,
    required this.selectedItems,
    required this.onSelected,
    this.horizontalPadding = ResponsiveSpacing.sm,
    this.verticalPadding = ResponsiveSpacing.xs,
  });

  void _handleChipTap(String label) {
    List<String> newSelectedItems = List.from(selectedItems);

    if (newSelectedItems.contains(label)) {
      // Deselect if already selected
      newSelectedItems.remove(label);
    } else {
      // Select if not selected
      newSelectedItems.add(label);
    }

    onSelected(newSelectedItems);
  }

  /// Premium spacing for sophisticated chips
  double _getChipSpacing(BuildContext context, ResponsiveSpacing size) {
    final deviceType = ResponsiveUtils.getDeviceType(context);
    final baseSpacing = ResponsiveUtils.spacing(context, size);

    // More refined scaling for premium appearance
    return switch (deviceType) {
      DeviceType.iPhone => baseSpacing * 0.9, // Slightly tighter
      DeviceType.iPadMini => baseSpacing * 0.95, // Conservative scaling
      DeviceType.iPadPro => baseSpacing * 1.0, // Controlled scaling
    };
  }

  /// Sophisticated chip container height with better proportions
  double _getChipContainerHeight(BuildContext context) {
    final deviceType = ResponsiveUtils.getDeviceType(context);
    final baseHeight = ResponsiveUtils.spacing(context, ResponsiveSpacing.xxl);

    return switch (deviceType) {
      DeviceType.iPhone => baseHeight * 1.3, // More compact
      DeviceType.iPadMini => baseHeight * 1.35, // Refined proportions
      DeviceType.iPadPro => baseHeight * 1.3, // Elegant on large screens
    };
  }

  /// Premium gradient for unselected chips
  LinearGradient _getUnselectedGradient() {
    return LinearGradient(
      colors: [
        AppColors.mutedGreen.withValues(alpha: 0.08),
        AppColors.mutedGreen.withValues(alpha: 0.12),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  /// Premium gradient for selected chips
  LinearGradient _getSelectedGradient() {
    return const LinearGradient(
      colors: [
        Color(0xFFF8D794), // lightYellow
        Color(0xFFBB6830), // orange
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  /// Sophisticated shadow system
  List<BoxShadow> _getChipShadows(BuildContext context, bool isSelected) {
    if (isSelected) {
      return [
        // Primary shadow with orange tint
        BoxShadow(
          color: AppColors.orange.withValues(alpha: 0.25),
          blurRadius: ResponsiveUtils.spacing(context, ResponsiveSpacing.xxs),
          offset: Offset(
            0,
            ResponsiveUtils.spacing(context, ResponsiveSpacing.xxs),
          ),
          spreadRadius: 0,
        ),
        // Secondary ambient shadow
        BoxShadow(
          color: AppColors.orange.withValues(alpha: 0.08),
          blurRadius: ResponsiveUtils.spacing(context, ResponsiveSpacing.xxs),
          offset: Offset(
            0,
            ResponsiveUtils.spacing(context, ResponsiveSpacing.xxs),
          ),
          spreadRadius: 0,
        ),
      ];
    } else {
      return [
        // Subtle shadow for unselected
        BoxShadow(
          color: AppColors.mutedGreen.withValues(alpha: 0.12),
          blurRadius: ResponsiveUtils.spacing(context, ResponsiveSpacing.xxs),
          offset: Offset(
            0,
            ResponsiveUtils.spacing(context, ResponsiveSpacing.xxs),
          ),
          spreadRadius: 0,
        ),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, deviceType) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              ResponsiveUtils.borderRadius(context, ResponsiveBorderRadius.xl),
            ),
            // Premium glassmorphism effect
            boxShadow: [
              // Primary shadow
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
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
              // Secondary ambient shadow
              BoxShadow(
                color: AppColors.mutedGreen.withValues(alpha: 0.06),
                blurRadius: ResponsiveUtils.spacing(
                  context,
                  ResponsiveSpacing.xxl,
                ),
                offset: Offset(
                  0,
                  ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
                ),
                spreadRadius: 0,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(
              ResponsiveUtils.borderRadius(context, ResponsiveBorderRadius.xl),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(
                    ResponsiveUtils.borderRadius(
                      context,
                      ResponsiveBorderRadius.xl,
                    ),
                  ),
                  border: Border.all(
                    color: AppColors.mutedGreen.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: _getChipSpacing(context, ResponsiveSpacing.sm),
                    vertical: _getChipSpacing(context, ResponsiveSpacing.sm),
                  ),
                  child: Container(
                    height: _getChipContainerHeight(context),
                    padding: EdgeInsets.symmetric(
                      horizontal: _getChipSpacing(context, horizontalPadding),
                      vertical: _getChipSpacing(context, verticalPadding),
                    ),
                    child: ShaderMask(
                      shaderCallback: (Rect bounds) {
                        return LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Colors.black,
                            Colors.black,
                            Colors.transparent,
                          ],
                          stops: [0.0, 0.92, 1.0],
                        ).createShader(bounds);
                      },
                      blendMode: BlendMode.dstIn,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          ResponsiveUtils.borderRadius(
                            context,
                            ResponsiveBorderRadius.lg,
                          ),
                        ),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: items.length,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            final label = items[index];
                            final isSelected = selectedItems.contains(label);

                            return Padding(
                              padding: EdgeInsets.only(
                                left: _getChipSpacing(
                                  context,
                                  ResponsiveSpacing.xs,
                                ),
                                right: _getChipSpacing(
                                  context,
                                  ResponsiveSpacing.xs,
                                ),
                              ),
                              child: TweenAnimationBuilder<double>(
                                duration: const Duration(milliseconds: 350),
                                curve: Curves.easeOutCubic,
                                tween: Tween(
                                  begin: 0.0,
                                  end: isSelected ? 1.0 : 0.0,
                                ),
                                builder: (context, animationValue, child) {
                                  return Transform.scale(
                                    scale:
                                        1.0 +
                                        (animationValue * 0.02), // Subtle scale
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(
                                          ResponsiveUtils.borderRadius(
                                            context,
                                            ResponsiveBorderRadius.xl,
                                          ),
                                        ),
                                        onTap: () => _handleChipTap(label),
                                        child: AnimatedContainer(
                                          duration: const Duration(
                                            milliseconds: 350,
                                          ),
                                          curve: Curves.easeOutCubic,
                                          padding: EdgeInsets.symmetric(
                                            horizontal: _getChipSpacing(
                                              context,
                                              ResponsiveSpacing.md,
                                            ),
                                            vertical: _getChipSpacing(
                                              context,
                                              ResponsiveSpacing.sm,
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              ResponsiveUtils.borderRadius(
                                                context,
                                                ResponsiveBorderRadius.xxl,
                                              ),
                                            ),
                                            gradient:
                                                isSelected
                                                    ? _getSelectedGradient()
                                                    : _getUnselectedGradient(),
                                            border: Border.all(
                                              color:
                                                  isSelected
                                                      ? AppColors.orange
                                                          .withValues(
                                                            alpha: 0.3,
                                                          )
                                                      : AppColors.mutedGreen
                                                          .withValues(
                                                            alpha: 0.15,
                                                          ),
                                              width: isSelected ? 1.5 : 1.0,
                                            ),
                                            boxShadow: _getChipShadows(
                                              context,
                                              isSelected,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              // Sophisticated selected indicator
                                              if (isSelected) ...[
                                                TweenAnimationBuilder<double>(
                                                  duration: const Duration(
                                                    milliseconds: 300,
                                                  ),
                                                  curve: Curves.elasticOut,
                                                  tween: Tween(
                                                    begin: 0.0,
                                                    end: 1.0,
                                                  ),
                                                  builder: (
                                                    context,
                                                    scale,
                                                    child,
                                                  ) {
                                                    return Transform.scale(
                                                      scale: scale,
                                                      child: Container(
                                                        width:
                                                            ResponsiveUtils.iconSize(
                                                              context,
                                                              ResponsiveIconSize
                                                                  .sm,
                                                            ),
                                                        height:
                                                            ResponsiveUtils.iconSize(
                                                              context,
                                                              ResponsiveIconSize
                                                                  .sm,
                                                            ),
                                                        decoration: BoxDecoration(
                                                          color:
                                                              AppColors.white,
                                                          shape:
                                                              BoxShape.circle,
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: AppColors
                                                                  .orange
                                                                  .withValues(
                                                                    alpha: 0.3,
                                                                  ),
                                                              blurRadius: 4,
                                                              offset:
                                                                  const Offset(
                                                                    0,
                                                                    1,
                                                                  ),
                                                            ),
                                                          ],
                                                        ),
                                                        child: Icon(
                                                          CupertinoIcons
                                                              .checkmark_alt,
                                                          size: ResponsiveUtils.iconSize(
                                                            context,
                                                            ResponsiveIconSize
                                                                .xs,
                                                          ),
                                                          color:
                                                              AppColors.orange,
                                                          weight: 600,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                                SizedBox(
                                                  width: _getChipSpacing(
                                                    context,
                                                    ResponsiveSpacing.xs,
                                                  ),
                                                ),
                                              ],
                                              Text(
                                                TextUtils.capitalizeFirstLetter(
                                                  label,
                                                ),
                                                style: TextStyle(
                                                  color:
                                                      isSelected
                                                          ? AppColors.white
                                                          : AppColors.button,
                                                  fontWeight:
                                                      isSelected
                                                          ? AppFontWeights
                                                              .medium
                                                          : FontWeight.w500,
                                                  fontSize:
                                                      ResponsiveUtils.fontSize(
                                                        context,
                                                        ResponsiveFontSize.sm,
                                                      ),
                                                  letterSpacing: 0.3,
                                                  fontFamily: 'Inter',
                                                  shadows:
                                                      isSelected
                                                          ? [
                                                            Shadow(
                                                              color: AppColors
                                                                  .orange
                                                                  .withValues(
                                                                    alpha: 0.3,
                                                                  ),
                                                              offset:
                                                                  const Offset(
                                                                    0,
                                                                    1,
                                                                  ),
                                                              blurRadius: 2,
                                                            ),
                                                          ]
                                                          : null,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
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
