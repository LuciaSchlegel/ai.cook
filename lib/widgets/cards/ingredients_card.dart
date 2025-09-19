import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/widgets/responsive/responsive_builder.dart';
import 'package:flutter/material.dart';
import 'package:ai_cook_project/utils/responsive_utils.dart';

class ShoppingRemindersCard extends StatelessWidget {
  const ShoppingRemindersCard({super.key});

  static const List<Map<String, dynamic>> _shoppingReminders = [
    {'name': 'Tomatoes', 'priority': 'high', 'quantity': '2 kg'},
    {'name': 'Chicken Breast', 'priority': 'high', 'quantity': '1 kg'},
    {'name': 'Olive Oil', 'priority': 'medium', 'quantity': '1 bottle'},
    {'name': 'Rice', 'priority': 'low', 'quantity': '1 bag'},
    {'name': 'Bell Peppers', 'priority': 'medium', 'quantity': '3 pieces'},
    {'name': 'Greek Yogurt', 'priority': 'high', 'quantity': '2 cups'},
  ];

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return const Color(0xFFE53E3E); // More refined red
      case 'medium':
        return const Color(0xFFFF8C00); // Warmer orange
      case 'low':
        return const Color(0xFF38A169); // Better green
      default:
        return const Color(0xFF718096);
    }
  }

  IconData _getPriorityIcon(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Icons.arrow_upward_rounded;
      case 'medium':
        return Icons.drag_handle_rounded;
      case 'low':
        return Icons.arrow_downward_rounded;
      default:
        return Icons.help_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, deviceType) {
        return Center(
          // Wrap the entire content in Center
          child: Container(
            width: ResponsiveUtils.getOptimalContentWidth(context),
            margin: EdgeInsets.symmetric(
              horizontal: ResponsiveUtils.spacing(
                context,
                ResponsiveSpacing.md,
              ),
            ),
            child: Column(
              children: [
                const ResponsiveSpacingWidget.vertical(ResponsiveSpacing.sm),
                Container(
                  decoration: BoxDecoration(
                    gradient: AppColors.gradientOrange,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.gradientOrange.colors[0].withValues(
                          alpha: 0.3,
                        ),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(
                      ResponsiveUtils.spacing(context, ResponsiveSpacing.lg),
                    ),
                    child: Column(
                      children: [
                        // Header Section
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.all(
                                ResponsiveUtils.spacing(
                                  context,
                                  ResponsiveSpacing.xs,
                                ),
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.shopping_bag_outlined,
                                color: Colors.white,
                                size: ResponsiveUtils.iconSize(
                                  context,
                                  ResponsiveIconSize.lg,
                                ),
                              ),
                            ),
                            const ResponsiveSpacingWidget.horizontal(
                              ResponsiveSpacing.sm,
                            ),
                            Text(
                              'Shopping List',
                              style: AppTextStyles.casta(
                                fontSize:
                                    ResponsiveUtils.fontSize(
                                      context,
                                      ResponsiveFontSize.xxl,
                                    ) *
                                    1.4,
                                fontWeight: AppFontWeights.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),

                        const ResponsiveSpacingWidget.vertical(
                          ResponsiveSpacing.md,
                        ),

                        // Items Container
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.08),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(
                              ResponsiveUtils.spacing(
                                context,
                                ResponsiveSpacing.md,
                              ),
                            ),
                            child: Column(
                              children: [
                                // Items count indicator
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: ResponsiveUtils.spacing(
                                      context,
                                      ResponsiveSpacing.sm,
                                    ),
                                    vertical: ResponsiveUtils.spacing(
                                      context,
                                      ResponsiveSpacing.xs,
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.gradientOrange.colors[0]
                                        .withValues(alpha: 0.1)
                                        .withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    '${_shoppingReminders.length} items to buy',
                                    style: AppTextStyles.inter(
                                      fontSize: ResponsiveUtils.fontSize(
                                        context,
                                        ResponsiveFontSize.sm,
                                      ),
                                      fontWeight: AppFontWeights.medium,
                                      color: AppColors.gradientOrange.colors[0],
                                    ),
                                  ),
                                ),

                                const ResponsiveSpacingWidget.vertical(
                                  ResponsiveSpacing.md,
                                ),

                                // Items List
                                Container(
                                  constraints: BoxConstraints(
                                    maxHeight:
                                        ResponsiveUtils.spacing(
                                          context,
                                          ResponsiveSpacing.xxl,
                                        ) *
                                        3.5,
                                  ),
                                  child: ListView.separated(
                                    shrinkWrap: true,
                                    physics: const BouncingScrollPhysics(),
                                    itemCount: _shoppingReminders.length,
                                    separatorBuilder:
                                        (context, index) =>
                                            const ResponsiveSpacingWidget.vertical(
                                              ResponsiveSpacing.sm,
                                            ),
                                    itemBuilder: (context, index) {
                                      final item = _shoppingReminders[index];
                                      final priorityColor = _getPriorityColor(
                                        item['priority'],
                                      );
                                      final priorityIcon = _getPriorityIcon(
                                        item['priority'],
                                      );

                                      return Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey[50],
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                          border: Border.all(
                                            color: Colors.grey[200]!,
                                            width: 1,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(
                                            ResponsiveUtils.spacing(
                                              context,
                                              ResponsiveSpacing.md,
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              // Checkbox style indicator
                                              Container(
                                                width: 24,
                                                height: 24,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color: priorityColor,
                                                    width: 2,
                                                  ),
                                                ),
                                                child: Center(
                                                  child: Container(
                                                    width: 8,
                                                    height: 8,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: priorityColor,
                                                    ),
                                                  ),
                                                ),
                                              ),

                                              const ResponsiveSpacingWidget.horizontal(
                                                ResponsiveSpacing.md,
                                              ),

                                              // Item details
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      item['name'],
                                                      style: AppTextStyles.casta(
                                                        fontWeight:
                                                            AppFontWeights.bold,
                                                        fontSize:
                                                            ResponsiveUtils.fontSize(
                                                              context,
                                                              ResponsiveFontSize
                                                                  .xl,
                                                            ),
                                                        color: const Color(
                                                          0xFF2D3748,
                                                        ),
                                                      ),
                                                    ),
                                                    const ResponsiveSpacingWidget.vertical(
                                                      ResponsiveSpacing.xxxs,
                                                    ),
                                                    Text(
                                                      item['quantity'],
                                                      style: AppTextStyles.inter(
                                                        fontWeight:
                                                            AppFontWeights
                                                                .regular,
                                                        fontSize:
                                                            ResponsiveUtils.fontSize(
                                                              context,
                                                              ResponsiveFontSize
                                                                  .md,
                                                            ),
                                                        color: const Color(
                                                          0xFF718096,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              // Priority indicator
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      ResponsiveUtils.spacing(
                                                        context,
                                                        ResponsiveSpacing.sm,
                                                      ),
                                                  vertical:
                                                      ResponsiveUtils.spacing(
                                                        context,
                                                        ResponsiveSpacing.xs,
                                                      ),
                                                ),
                                                decoration: BoxDecoration(
                                                  color: priorityColor
                                                      .withValues(alpha: 0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Icon(
                                                      priorityIcon,
                                                      size:
                                                          ResponsiveUtils.iconSize(
                                                            context,
                                                            ResponsiveIconSize
                                                                .xs,
                                                          ),
                                                      color: priorityColor,
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      item['priority']
                                                          .toUpperCase(),
                                                      style: AppTextStyles.inter(
                                                        fontSize:
                                                            ResponsiveUtils.fontSize(
                                                              context,
                                                              ResponsiveFontSize
                                                                  .xs,
                                                            ),
                                                        fontWeight:
                                                            AppFontWeights.bold,
                                                        color: priorityColor,
                                                        letterSpacing: 0.5,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
