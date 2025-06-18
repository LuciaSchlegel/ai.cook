import 'package:ai_cook_project/screens/main/helpers/tabs.dart';
import 'package:ai_cook_project/screens/main/widgets/build_tab.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/widgets/ai_button.dart';
import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabTapped;

  const CustomBottomNavBar({
    required this.currentIndex,
    required this.onTabTapped,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: AppColors.white,
      elevation: 8,
      notchMargin: 8,
      shape: const CircularNotchedRectangle(),
      child: SizedBox(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ...List.generate(
              2,
              (index) => Expanded(
                child: TabItem(
                  icon: pages[index].icon,
                  label: pages[index].title,
                  isActive: currentIndex == index,
                  onTap: () => onTabTapped(index),
                ),
              ),
            ),
            const Expanded(child: SizedBox()),
            ...List.generate(
              2,
              (index) => Expanded(
                child: TabItem(
                  icon: pages[index + 2].icon,
                  label: pages[index + 2].title,
                  isActive: currentIndex == index + 2,
                  onTap: () => onTabTapped(index + 2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NavBarBuilder extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabTapped;
  final VoidCallback toggleAiWindow;
  final bool isAiWindowOpen;

  const NavBarBuilder({
    required this.currentIndex,
    required this.onTabTapped,
    required this.toggleAiWindow,
    required this.isAiWindowOpen,
  });
  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    return SizedBox(
      height: 70 + bottomPadding,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          CustomBottomNavBar(
            currentIndex: currentIndex,
            onTabTapped: onTabTapped,
          ),
          Positioned(
            top: -25,
            child: AiButton(
              onPressed: toggleAiWindow,
              isActive: isAiWindowOpen,
            ),
          ),
        ],
      ),
    );
  }
}
