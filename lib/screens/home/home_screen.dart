import 'package:ai_cook_project/widgets/cards/ingredients_card.dart';
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
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ScreenHeader(
                onProfileTap: widget.onProfileTap ?? () {},
                onFeedTap: widget.onFeedTap ?? () {},
                onLogoutTap: widget.onLogoutTap ?? () {},
                currentIndex: -1,
              ),
              SizedBox(height: size.height * 0.03),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: size.height * 0.02),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Welcome,',
                          style: TextStyle(
                            fontFamily: 'Casta',
                            fontSize: 48,
                            color: Colors.white,
                            height: 1.1,
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
                                      ? const SizedBox(height: 48)
                                      : Text(
                                        name,
                                        key: ValueKey(name),
                                        style: const TextStyle(
                                          fontFamily: 'Casta',
                                          fontSize: 48,
                                          color: Colors.white,
                                          height: 1.1,
                                        ),
                                      ),
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: size.height * 0.03),
                    const Divider(
                      color: Color.fromRGBO(238, 238, 238, 0.498),
                      thickness: 1,
                    ),
                    SizedBox(height: size.height * 0.03),
                    const Center(child: WeeklyCard()),
                  ],
                ),
              ),
              SizedBox(height: size.height * 0.04),
              const SocialCarousel(),
              SizedBox(height: size.height * 0.04),
              const IngredientsCard(),
              SizedBox(height: size.height * 0.04),
            ],
          ),
        ),
      ),
    );
  }
}
