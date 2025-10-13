import 'package:ai_cook_project/utils/responsive_utils.dart';
import 'package:ai_cook_project/widgets/cards/ingredients_card.dart';
import 'package:ai_cook_project/widgets/responsive/responsive_builder.dart';
import 'package:ai_cook_project/widgets/utils/social_widget.dart';
import 'package:ai_cook_project/widgets/cards/weekly_card.dart';
import 'package:flutter/material.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:ai_cook_project/widgets/utils/screen_header.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback? onProfileTap;
  final VoidCallback? onFeedTap;
  final VoidCallback? onLogoutTap;

  const HomeScreen({
    super.key,
    this.onProfileTap,
    this.onFeedTap,
    this.onLogoutTap,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false).getUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            ScreenHeader(
              onProfileTap: widget.onProfileTap ?? () {},
              onFeedTap: widget.onFeedTap ?? () {},
              onLogoutTap: widget.onLogoutTap ?? () {},
              currentIndex: -1,
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveUtils.spacing(
                          context,
                          ResponsiveSpacing.lg,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const ResponsiveSpacingWidget.vertical(
                            ResponsiveSpacing.lg,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome,',
                                style: TextStyle(
                                  fontFamily: AppFontFamilies.casta,
                                  fontSize:
                                      ResponsiveUtils.fontSize(
                                        context,
                                        ResponsiveFontSize.title2,
                                      ) *
                                      1.5,
                                  color: Colors.white,
                                  fontWeight: AppFontWeights.bold,
                                  height: 1,
                                  letterSpacing: 0.8,
                                ),
                              ),
                              Consumer<UserProvider>(
                                builder: (context, userProvider, _) {
                                  final name = userProvider.user?.name;
                                  final isLoading = userProvider.isLoading;

                                  return AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 500),
                                    transitionBuilder: (child, animation) {
                                      return FadeTransition(
                                        opacity: animation,
                                        child: child,
                                      );
                                    },
                                    child:
                                        isLoading || name == null
                                            ? SizedBox(
                                              height: ResponsiveUtils.spacing(
                                                context,
                                                ResponsiveSpacing.xxl,
                                              ),
                                            )
                                            : Text(
                                              "Lucia",
                                              key: ValueKey(name),
                                              style: TextStyle(
                                                fontFamily:
                                                    AppFontFamilies.casta,
                                                fontSize:
                                                    ResponsiveUtils.fontSize(
                                                      context,
                                                      ResponsiveFontSize.title2,
                                                    ) *
                                                    1.5,
                                                color: Colors.white,
                                                fontWeight: AppFontWeights.bold,
                                                height: 1,
                                                letterSpacing: 0.8,
                                              ),
                                            ),
                                  );
                                },
                              ),
                            ],
                          ),
                          const ResponsiveSpacingWidget.vertical(
                            ResponsiveSpacing.xl,
                          ),
                          const Divider(
                            color: Color.fromRGBO(238, 238, 238, 0.498),
                            thickness: 1,
                          ),
                          const ResponsiveSpacingWidget.vertical(
                            ResponsiveSpacing.xl,
                          ),
                          const Center(child: WeeklyCard()),
                        ],
                      ),
                    ),
                    const ResponsiveSpacingWidget.vertical(
                      ResponsiveSpacing.xl,
                    ),
                    const ShoppingRemindersCard(),
                    const ResponsiveSpacingWidget.vertical(
                      ResponsiveSpacing.xxl,
                    ),
                    const SocialCarousel(),
                    const ResponsiveSpacingWidget.vertical(
                      ResponsiveSpacing.xxl,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
