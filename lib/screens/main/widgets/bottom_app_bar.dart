import 'package:ai_cook_project/screens/main/helpers/tabs.dart';
import 'package:ai_cook_project/screens/main/widgets/build_tab.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/widgets/buttons/ai_button.dart';
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
    super.key,
    required this.currentIndex,
    required this.onTabTapped,
    required this.toggleAiWindow,
    required this.isAiWindowOpen,
  });
  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    // Parámetros de animación
    final double normalSize = 64;
    final double activeSize = 88;
    final double normalTop = 3;
    final double activeTop =
        -24; // Suficiente para que la mitad quede sobre la bottom bar
    final Duration animDuration = const Duration(milliseconds: 250);

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
          AnimatedPositioned(
            duration: animDuration,
            curve: Curves.easeOut,
            top: isAiWindowOpen ? activeTop : normalTop,
            child: AnimatedContainer(
              duration: animDuration,
              curve: Curves.easeOut,
              width: isAiWindowOpen ? activeSize : normalSize,
              height: isAiWindowOpen ? activeSize : normalSize,
              child: AiButton(
                onPressed: toggleAiWindow,
                isActive: isAiWindowOpen,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
