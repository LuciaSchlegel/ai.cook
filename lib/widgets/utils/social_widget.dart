import 'package:flutter/material.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/utils/responsive_utils.dart';

class SocialCarousel extends StatefulWidget {
  const SocialCarousel({super.key});

  @override
  State<SocialCarousel> createState() => _SocialCarouselState();
}

class _SocialCarouselState extends State<SocialCarousel> {
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, String>> socialPosts = [
    {
      'image': 'assets/images/baking.jpg',
      'title': 'Fresh Sourdough',
      'subtitle': 'Perfect golden crust',
      'author': '@miacooks',
    },
    {
      'image': 'assets/images/cooking.jpg',
      'title': 'Farm to Table',
      'subtitle': 'Seasonal vegetables',
      'author': '@chefmark',
    },
    {
      'image': 'assets/images/grilling.jpg',
      'title': 'BBQ Masters',
      'subtitle': 'Smoky perfection',
      'author': '@grillmaster',
    },
    // Adding more posts for better scrolling demonstration
    {
      'image': 'assets/images/baking.jpg',
      'title': 'Artisan Bread',
      'subtitle': 'Handcrafted with love',
      'author': '@breadlover',
    },
    {
      'image': 'assets/images/cooking.jpg',
      'title': 'Mediterranean Bowl',
      'subtitle': 'Fresh and healthy',
      'author': '@healthyeats',
    },
    {
      'image': 'assets/images/grilling.jpg',
      'title': 'Weekend Cookout',
      'subtitle': 'Family gathering',
      'author': '@familychef',
    },
  ];

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: ResponsiveUtils.spacing(context, ResponsiveSpacing.lg),
      ),
      height: ResponsiveUtils.spacing(context, ResponsiveSpacing.xxl) * 13.5,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.white, AppColors.white.withValues(alpha: 0.98)],
          ),
          borderRadius: BorderRadius.circular(
            ResponsiveUtils.borderRadius(context, ResponsiveBorderRadius.xxxl),
          ),
          border: Border.all(
            color: AppColors.mutedGreen.withValues(alpha: 0.8),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.mutedGreen.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 40,
              offset: const Offset(0, 16),
              spreadRadius: -8,
            ),
          ],
        ),
        child: Container(
          margin: EdgeInsets.all(
            ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
          ),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(
              ResponsiveUtils.borderRadius(
                    context,
                    ResponsiveBorderRadius.xxxl,
                  ) -
                  6,
            ),
            border: Border.all(
              color: AppColors.mutedGreen.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(
              ResponsiveUtils.borderRadius(
                    context,
                    ResponsiveBorderRadius.xxxl,
                  ) -
                  6,
            ),
            child: Column(
              children: [
                _buildHeader(context),
                Expanded(child: _buildScrollableFeed(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveUtils.spacing(context, ResponsiveSpacing.lg),
        vertical: ResponsiveUtils.spacing(context, ResponsiveSpacing.lg),
      ),
      child: Column(
        children: [
          SizedBox(
            height: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
          ),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'ai.',
                  style: AppTextStyles.casta(
                    fontSize:
                        ResponsiveUtils.fontSize(
                          context,
                          ResponsiveFontSize.title2,
                        ) *
                        1.4,
                    color: AppColors.button,
                    fontWeight: AppFontWeights.bold,
                    letterSpacing: -0.5,
                  ),
                ),
                TextSpan(
                  text: 'Cook',
                  style: AppTextStyles.casta(
                    fontSize:
                        ResponsiveUtils.fontSize(
                          context,
                          ResponsiveFontSize.title2,
                        ) *
                        1.4,
                    color: AppColors.button,
                    fontWeight: AppFontWeights.bold,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveUtils.spacing(
                context,
                ResponsiveSpacing.xl,
              ),
              vertical: ResponsiveUtils.spacing(context, ResponsiveSpacing.xs),
            ),
            decoration: BoxDecoration(
              gradient: AppColors.gradientOrange,
              borderRadius: BorderRadius.circular(
                ResponsiveUtils.borderRadius(
                  context,
                  ResponsiveBorderRadius.xxxl,
                ),
              ),
            ),
            child: Text(
              'COMMUNITY',
              style: AppTextStyles.casta(
                fontSize:
                    ResponsiveUtils.fontSize(context, ResponsiveFontSize.xl) *
                    1.1,
                color: AppColors.white,
                fontWeight: AppFontWeights.bold,
                letterSpacing: 1.8,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScrollableFeed(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
      ),
      child: ListView.builder(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.only(
          bottom: ResponsiveUtils.spacing(context, ResponsiveSpacing.lg),
        ),
        itemCount: socialPosts.length,
        itemBuilder: (context, index) {
          return _buildPostCard(context, index);
        },
      ),
    );
  }

  Widget _buildPostCard(BuildContext context, int index) {
    final post = socialPosts[index];
    final cardHeight =
        ResponsiveUtils.spacing(context, ResponsiveSpacing.xxl) * 6;

    return Container(
      height: cardHeight,
      margin: EdgeInsets.only(
        bottom: ResponsiveUtils.spacing(context, ResponsiveSpacing.lg),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.borderRadius(context, ResponsiveBorderRadius.xxl),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 15,
            offset: const Offset(0, 6),
            spreadRadius: -2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.borderRadius(context, ResponsiveBorderRadius.xxl),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            _buildImageBackground(context, post),
            _buildGradientOverlay(context),
            _buildContentOverlay(context, post),
          ],
        ),
      ),
    );
  }

  Widget _buildImageBackground(BuildContext context, Map<String, String> post) {
    return Image.asset(
      post['image']!,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.grey[700]!, Colors.grey[900]!],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.restaurant,
                  color: Colors.white.withValues(alpha: 0.7),
                  size: ResponsiveUtils.iconSize(
                    context,
                    ResponsiveIconSize.xxl,
                  ),
                ),
                SizedBox(
                  height: ResponsiveUtils.spacing(
                    context,
                    ResponsiveSpacing.sm,
                  ),
                ),
                Text(
                  'Image not found',
                  style: AppTextStyles.casta(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: ResponsiveUtils.fontSize(
                      context,
                      ResponsiveFontSize.md,
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

  Widget _buildGradientOverlay(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black.withValues(alpha: 0.2),
            Colors.black.withValues(alpha: 0.6),
          ],
          stops: const [0.0, 0.7, 1.0],
        ),
      ),
    );
  }

  Widget _buildContentOverlay(BuildContext context, Map<String, String> post) {
    return Positioned(
      bottom: ResponsiveUtils.spacing(context, ResponsiveSpacing.lg),
      left: ResponsiveUtils.spacing(context, ResponsiveSpacing.lg),
      right: ResponsiveUtils.spacing(context, ResponsiveSpacing.lg),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveUtils.spacing(context, ResponsiveSpacing.lg),
          vertical: ResponsiveUtils.spacing(context, ResponsiveSpacing.md),
        ),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(
            ResponsiveUtils.borderRadius(context, ResponsiveBorderRadius.lg),
          ),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              post['title']!,
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
            Row(
              children: [
                Text(
                  post['author']!,
                  style: AppTextStyles.casta(
                    color: AppColors.button,
                    fontSize:
                        ResponsiveUtils.fontSize(
                          context,
                          ResponsiveFontSize.lg,
                        ) *
                        1.1,
                    fontWeight: AppFontWeights.bold,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
