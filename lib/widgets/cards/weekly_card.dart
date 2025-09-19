import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/widgets/responsive/responsive_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:ai_cook_project/utils/responsive_utils.dart';

// Hardcoded meal data - add this at the beginning
class MealData {
  final String mealType;
  final String dishName;
  final bool isPlanned;

  MealData({
    required this.mealType,
    required this.dishName,
    required this.isPlanned,
  });
}

class WeeklyCard extends StatefulWidget {
  const WeeklyCard({super.key});

  @override
  State<WeeklyCard> createState() => _WeeklyCardState();
}

class _WeeklyCardState extends State<WeeklyCard> {
  @override
  Widget build(BuildContext context) {
    return Card.filled(
      color: AppColors.white,
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: _SampleCard(),
    );
  }
}

class _SampleCard extends StatelessWidget {
  const _SampleCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.mutedGreen, width: 2),
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.borderRadius(context, ResponsiveBorderRadius.xxxl),
        ),
      ),
      width: ResponsiveUtils.getOptimalContentWidth(context),
      height: ResponsiveUtils.spacing(context, ResponsiveSpacing.xxl) * 14.5,
      child: Padding(
        padding: ResponsiveUtils.padding(context, ResponsiveSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const ResponsiveSpacingWidget.vertical(ResponsiveSpacing.xxs),
            const WeekDaySlider(),
            SizedBox(
              height: ResponsiveUtils.spacing(context, ResponsiveSpacing.xl),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom:
                      ResponsiveUtils.spacing(context, ResponsiveSpacing.lg) *
                      0.02,
                ),
                child: InnerCard(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WeekDaySlider extends StatefulWidget {
  const WeekDaySlider({super.key});

  @override
  State<WeekDaySlider> createState() => _WeekDaySliderState();
}

class _WeekDaySliderState extends State<WeekDaySlider> {
  final PageController _pageController = PageController(viewportFraction: 0.35);
  int _selectedDay = 2; // Wednesday selected by default

  final List<Map<String, dynamic>> weekDays = [
    {'day': 'Mon', 'fullDay': 'Monday', 'date': '14', 'isActive': true},
    {'day': 'Tue', 'fullDay': 'Tuesday', 'date': '15', 'isActive': true},
    {'day': 'Wed', 'fullDay': 'Wednesday', 'date': '16', 'isActive': true},
    {'day': 'Thu', 'fullDay': 'Thursday', 'date': '17', 'isActive': false},
    {'day': 'Fri', 'fullDay': 'Friday', 'date': '18', 'isActive': false},
    {'day': 'Sat', 'fullDay': 'Saturday', 'date': '19', 'isActive': false},
    {'day': 'Sun', 'fullDay': 'Sunday', 'date': '20', 'isActive': false},
  ];

  @override
  void initState() {
    super.initState();
    // Center on the selected day after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pageController.animateToPage(
        _selectedDay,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Helper methods for arrow navigation
  bool get _canNavigateLeft => _selectedDay > 0;
  bool get _canNavigateRight => _selectedDay < weekDays.length - 1;

  void _navigateLeft() {
    if (_canNavigateLeft) {
      final newIndex = _selectedDay - 1;
      setState(() {
        _selectedDay = newIndex;
      });
      _pageController.animateToPage(
        newIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _navigateRight() {
    if (_canNavigateRight) {
      final newIndex = _selectedDay + 1;
      setState(() {
        _selectedDay = newIndex;
      });
      _pageController.animateToPage(
        newIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal:
            ResponsiveUtils.spacing(context, ResponsiveSpacing.xxs) * 0.2,
        vertical: ResponsiveUtils.spacing(context, ResponsiveSpacing.xs),
      ),
      child: Container(
        height: ResponsiveUtils.spacing(context, ResponsiveSpacing.xxl) * 4,
        decoration: BoxDecoration(
          gradient: AppColors.gradientOrange,
          borderRadius: BorderRadius.circular(
            ResponsiveUtils.borderRadius(context, ResponsiveBorderRadius.xxxl),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.orange.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            const ResponsiveSpacingWidget.vertical(ResponsiveSpacing.sm),
            // Current week label
            Padding(
              padding: EdgeInsets.symmetric(
                vertical:
                    ResponsiveUtils.spacing(context, ResponsiveSpacing.xxxs) *
                    0.8,
              ),
              child: Text(
                'Weekly Meal Plan ',
                style: AppTextStyles.casta(
                  fontSize:
                      ResponsiveUtils.fontSize(
                        context,
                        ResponsiveFontSize.xxl,
                      ) *
                      1.4,
                  fontWeight: AppFontWeights.bold,
                  color: AppColors.white,
                  letterSpacing: 0.5,
                ),
              ),
            ),

            // Days slider with navigation arrows
            Expanded(
              child: Stack(
                children: [
                  // Main PageView
                  ClipRect(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: ResponsiveUtils.spacing(
                          context,
                          ResponsiveSpacing.xxs,
                        ),
                        horizontal: ResponsiveUtils.spacing(
                          context,
                          ResponsiveSpacing.xs,
                        ),
                      ),
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: weekDays.length,
                        onPageChanged: (index) {
                          setState(() {
                            _selectedDay = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          final day = weekDays[index];
                          final isSelected = index == _selectedDay;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedDay = index;
                              });
                              _pageController.animateToPage(
                                index,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                            child: AnimatedScale(
                              scale: isSelected ? 1.0 : 0.85,
                              duration: const Duration(milliseconds: 200),
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                  horizontal: ResponsiveUtils.spacing(
                                    context,
                                    ResponsiveSpacing.xs,
                                  ),
                                  vertical: ResponsiveUtils.spacing(
                                    context,
                                    ResponsiveSpacing.xxs,
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      isSelected
                                          ? AppColors.white
                                          : AppColors.white.withValues(
                                            alpha: 0.8,
                                          ),
                                  borderRadius: BorderRadius.circular(
                                    ResponsiveUtils.borderRadius(
                                      context,
                                      ResponsiveBorderRadius.xl,
                                    ),
                                  ),
                                  boxShadow:
                                      isSelected
                                          ? [
                                            BoxShadow(
                                              color: Colors.black.withValues(
                                                alpha: 0.2,
                                              ),
                                              blurRadius: 10,
                                              offset: const Offset(0, 4),
                                            ),
                                          ]
                                          : null,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Date
                                    Text(
                                      day['date'],
                                      style: AppTextStyles.casta(
                                        fontSize:
                                            ResponsiveUtils.fontSize(
                                              context,
                                              ResponsiveFontSize.title,
                                            ) *
                                            1.2,
                                        fontWeight: AppFontWeights.bold,
                                        color: AppColors.button,
                                      ),
                                    ),

                                    const ResponsiveSpacingWidget.vertical(
                                      ResponsiveSpacing.xxxs,
                                    ),

                                    // Chip containing day and activity indicator
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: ResponsiveUtils.spacing(
                                          context,
                                          ResponsiveSpacing.sm,
                                        ),
                                        vertical: ResponsiveUtils.spacing(
                                          context,
                                          ResponsiveSpacing.xxs,
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                        color:
                                            isSelected
                                                ? AppColors.mutedGreen
                                                    .withValues(alpha: 0.1)
                                                : AppColors.mutedGreen
                                                    .withValues(alpha: 0.05),
                                        borderRadius: BorderRadius.circular(
                                          ResponsiveUtils.borderRadius(
                                            context,
                                            ResponsiveBorderRadius.lg,
                                          ),
                                        ),
                                        border: Border.all(
                                          color: AppColors.mutedGreen
                                              .withValues(
                                                alpha: isSelected ? 0.3 : 0.2,
                                              ),
                                          width: 1,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            day['day'],
                                            style: AppTextStyles.inter(
                                              fontSize:
                                                  ResponsiveUtils.fontSize(
                                                    context,
                                                    ResponsiveFontSize.sm,
                                                  ),
                                              fontWeight: AppFontWeights.medium,
                                              color:
                                                  isSelected
                                                      ? AppColors.mutedGreen
                                                      : AppColors.mutedGreen
                                                          .withValues(
                                                            alpha: 0.7,
                                                          ),
                                            ),
                                          ),

                                          const ResponsiveSpacingWidget.horizontal(
                                            ResponsiveSpacing.xs,
                                          ),

                                          // Activity indicator
                                          Icon(
                                            Icons.check_circle_rounded,
                                            color:
                                                day['isActive']
                                                    ? AppColors.mutedGreen
                                                    : Colors.grey.withValues(
                                                      alpha: 0.4,
                                                    ),
                                            size: ResponsiveUtils.iconSize(
                                              context,
                                              ResponsiveIconSize.xs,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  // Left arrow
                  Positioned(
                    left: ResponsiveUtils.spacing(
                      context,
                      ResponsiveSpacing.xs,
                    ),
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: AnimatedOpacity(
                        opacity: _canNavigateLeft ? 1.0 : 0.3,
                        duration: const Duration(milliseconds: 200),
                        child: GestureDetector(
                          onTap: _navigateLeft,
                          child: Container(
                            width: ResponsiveUtils.spacing(
                              context,
                              ResponsiveSpacing.xl,
                            ),
                            height: ResponsiveUtils.spacing(
                              context,
                              ResponsiveSpacing.xl,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.white.withValues(alpha: 0.9),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              CupertinoIcons.chevron_left,
                              color:
                                  _canNavigateLeft
                                      ? AppColors.button
                                      : AppColors.button.withValues(alpha: 0.4),
                              size: ResponsiveUtils.iconSize(
                                context,
                                ResponsiveIconSize.sm,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Right arrow
                  Positioned(
                    right: ResponsiveUtils.spacing(
                      context,
                      ResponsiveSpacing.xs,
                    ),
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: AnimatedOpacity(
                        opacity: _canNavigateRight ? 1.0 : 0.3,
                        duration: const Duration(milliseconds: 200),
                        child: GestureDetector(
                          onTap: _navigateRight,
                          child: Container(
                            width: ResponsiveUtils.spacing(
                              context,
                              ResponsiveSpacing.xl,
                            ),
                            height: ResponsiveUtils.spacing(
                              context,
                              ResponsiveSpacing.xl,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.white.withValues(alpha: 0.9),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              CupertinoIcons.chevron_right,
                              color:
                                  _canNavigateRight
                                      ? AppColors.button
                                      : AppColors.button.withValues(alpha: 0.4),
                              size: ResponsiveUtils.iconSize(
                                context,
                                ResponsiveIconSize.sm,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InnerCard extends StatelessWidget {
  InnerCard({super.key});

  // Hardcoded meal data for Wednesday (you can make this dynamic based on selected day)
  final List<MealData> meals = [
    MealData(
      mealType: 'Breakfast',
      dishName: 'Avocado Toast with Eggs',
      isPlanned: true,
    ),
    MealData(
      mealType: 'Lunch',
      dishName: 'Grilled Chicken Salad',
      isPlanned: true,
    ),
    MealData(
      mealType: 'Dinner',
      dishName: 'Salmon with Vegetables',
      isPlanned: false, // This meal is not planned, so it won't show
    ),
  ];

  // Filter only planned meals
  List<MealData> get plannedMeals =>
      meals.where((meal) => meal.isPlanned).toList();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ResponsiveUtils.getOptimalContentWidth(context),
      decoration: BoxDecoration(
        gradient: AppColors.gradientYellow,
        borderRadius: BorderRadius.all(
          Radius.circular(
            ResponsiveUtils.borderRadius(context, ResponsiveBorderRadius.xxl),
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(
          ResponsiveUtils.spacing(context, ResponsiveSpacing.sm) * 1.2,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(
                ResponsiveUtils.borderRadius(
                  context,
                  ResponsiveBorderRadius.xl,
                ),
              ),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(
              ResponsiveUtils.spacing(context, ResponsiveSpacing.md),
            ),
            child: Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    itemCount: plannedMeals.length,
                    separatorBuilder:
                        (context, index) => SizedBox(
                          height: ResponsiveUtils.spacing(
                            context,
                            ResponsiveSpacing.sm,
                          ),
                        ),
                    itemBuilder: (context, index) {
                      return _buildMealCard(context, plannedMeals[index]);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMealCard(BuildContext context, MealData meal) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveUtils.spacing(context, ResponsiveSpacing.lg),
        vertical: ResponsiveUtils.spacing(context, ResponsiveSpacing.md),
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.borderRadius(context, ResponsiveBorderRadius.lg),
        ),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Meal type (Breakfast, Lunch, Dinner)
          Text(
            meal.mealType,
            style: AppTextStyles.casta(
              color: AppColors.button,
              fontSize: ResponsiveUtils.fontSize(
                context,
                ResponsiveFontSize.title,
              ),
              fontWeight: AppFontWeights.bold,
              height: 1.2,
              letterSpacing: -0.3,
            ),
          ),

          const ResponsiveSpacingWidget.vertical(ResponsiveSpacing.xs),

          // Dish name
          Text(
            meal.dishName,
            style: AppTextStyles.inter(
              color: AppColors.button.withValues(alpha: 0.7),
              fontSize: ResponsiveUtils.fontSize(
                context,
                ResponsiveFontSize.md,
              ),
              fontWeight: AppFontWeights.medium,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}
