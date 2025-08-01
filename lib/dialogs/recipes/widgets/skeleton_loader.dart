import 'package:flutter/material.dart';
import 'package:ai_cook_project/theme.dart';

class SkeletonLoader extends StatefulWidget {
  const SkeletonLoader({super.key});

  @override
  State<SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<SkeletonLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Success indicator skeleton
            _buildSkeletonCard(
              height: 60,
              child: Row(
                children: [
                  _buildSkeletonElement(24, 24, BorderRadius.circular(12)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildSkeletonElement(
                      16,
                      double.infinity,
                      BorderRadius.circular(8),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // AI Recommendations skeleton - Made flexible
            _buildFlexibleSkeletonCard(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      _buildSkeletonElement(32, 32, BorderRadius.circular(8)),
                      const SizedBox(width: 12),
                      Flexible(
                        child: _buildSkeletonElement(
                          20,
                          200,
                          BorderRadius.circular(6),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Content box - Flexible height
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.button.withOpacity(0.02),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.mutedGreen.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildSkeletonElement(
                          14,
                          double.infinity,
                          BorderRadius.circular(4),
                        ),
                        const SizedBox(height: 10),
                        _buildSkeletonElement(
                          14,
                          double.infinity,
                          BorderRadius.circular(4),
                        ),
                        const SizedBox(height: 10),
                        _buildSkeletonElement(
                          14,
                          MediaQuery.of(context).size.width * 0.6,
                          BorderRadius.circular(4),
                        ),
                        const SizedBox(height: 12),
                        _buildSkeletonElement(
                          14,
                          double.infinity,
                          BorderRadius.circular(4),
                        ),
                        const SizedBox(height: 8),
                        _buildSkeletonElement(
                          14,
                          MediaQuery.of(context).size.width * 0.45,
                          BorderRadius.circular(4),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Recipe cards skeleton - Reduced spacing
            _buildRecipeCardSkeleton(),
            const SizedBox(height: 10),
            _buildRecipeCardSkeleton(),
          ],
        );
      },
    );
  }

  Widget _buildSkeletonCard({required double height, required Widget child}) {
    return Container(
      constraints: BoxConstraints(minHeight: height - 20),
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.mutedGreen.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
        border: Border.all(
          color: AppColors.mutedGreen.withOpacity(0.12),
          width: 1,
        ),
      ),
      child: child,
    );
  }

  Widget _buildFlexibleSkeletonCard({required Widget child}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.mutedGreen.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
        border: Border.all(
          color: AppColors.mutedGreen.withOpacity(0.12),
          width: 1,
        ),
      ),
      child: child,
    );
  }

  Widget _buildRecipeCardSkeleton() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: AppColors.mutedGreen.withOpacity(0.15),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              _buildSkeletonElement(18, 18, BorderRadius.circular(9)),
              const SizedBox(width: 8),
              Expanded(
                child: _buildSkeletonElement(
                  14,
                  double.infinity,
                  BorderRadius.circular(4),
                ),
              ),
              _buildSkeletonElement(20, 36, BorderRadius.circular(10)),
            ],
          ),
          const SizedBox(height: 12),
          // Content with responsive spacing
          _buildSkeletonElement(10, double.infinity, BorderRadius.circular(4)),
          const SizedBox(height: 8),
          LayoutBuilder(
            builder: (context, constraints) {
              final maxWidth = constraints.maxWidth;
              return _buildSkeletonElement(
                10,
                maxWidth * 0.7,
                BorderRadius.circular(4),
              );
            },
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _buildSkeletonElement(10, 50, BorderRadius.circular(4)),
              const SizedBox(width: 12),
              _buildSkeletonElement(10, 70, BorderRadius.circular(4)),
              const Spacer(), // Push elements to the left, leave space on the right
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSkeletonElement(
    double height,
    double width,
    BorderRadius borderRadius,
  ) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: [
            (_animation.value - 1).clamp(0.0, 1.0),
            _animation.value.clamp(0.0, 1.0),
            (_animation.value + 1).clamp(0.0, 1.0),
          ],
          colors: [
            AppColors.mutedGreen.withOpacity(0.08),
            AppColors.mutedGreen.withOpacity(0.15),
            AppColors.mutedGreen.withOpacity(0.08),
          ],
        ),
      ),
    );
  }
}
