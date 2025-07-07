import 'package:flutter/material.dart';
import 'package:ai_cook_project/theme.dart';

class SocialCarousel extends StatefulWidget {
  const SocialCarousel({super.key});

  @override
  State<SocialCarousel> createState() => _SocialCarouselState();
}

class _SocialCarouselState extends State<SocialCarousel> {
  final PageController _pageController = PageController(
    viewportFraction: 0.92,
    initialPage: 0,
  );
  int _currentPage = 0;

  final List<Map<String, String>> socialPosts = [
    {
      'image': 'assets/images/baking.jpg',
      'title': 'Baking...',
      'author': '@miacooks',
    },
    {
      'image': 'assets/images/cooking.jpg',
      'title': 'Cooking...',
      'author': '@chefmark',
    },
    {
      'image': 'assets/images/grilling.jpg',
      'title': 'Grilling...',
      'author': '@grillmaster',
    },
  ];

  @override
  void initState() {
    super.initState();
    _startAutoPlay();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoPlay() {
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        final nextPage = (_currentPage + 1) % socialPosts.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
        _startAutoPlay();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'my',
                style: TextStyle(
                  fontFamily: 'Casta',
                  fontSize: 42,
                  color: Colors.white,
                  height: 0.9,
                  letterSpacing: 0.8,
                ),
              ),
              Text(
                'cooking community',
                style: TextStyle(
                  fontFamily: 'Casta',
                  fontSize: 42,
                  color: Colors.white,
                  height: 0.9,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 24),
        SizedBox(
          height: 220,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: socialPosts.length,
            itemBuilder: (context, index) {
              final isCurrentPage = index == _currentPage;
              return AnimatedScale(
                scale: isCurrentPage ? 1.0 : 0.95,
                duration: const Duration(milliseconds: 300),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: AppColors.white,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Image.asset(
                                socialPosts[index]['image']!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey[800],
                                    child: const Center(
                                      child: Icon(
                                        Icons.image_not_supported,
                                        color: Colors.white54,
                                        size: 40,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            Positioned(
                              bottom: 15,
                              left: 15,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    socialPosts[index]['title']!,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontFamily: 'Times New Roman',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    socialPosts[index]['author']!,
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.8),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Times New Roman',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
