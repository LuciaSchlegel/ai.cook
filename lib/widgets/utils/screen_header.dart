import 'package:flutter/material.dart';
import 'package:ai_cook_project/widgets/buttons/main_floating_button.dart';
import 'package:ai_cook_project/widgets/utils/search_bar.dart';
import 'package:ai_cook_project/providers/search_provider.dart';
import 'package:ai_cook_project/utils/responsive_utils.dart';
import 'package:ai_cook_project/widgets/responsive/responsive_builder.dart';
import 'package:provider/provider.dart';

class ScreenHeader extends StatelessWidget {
  final VoidCallback onProfileTap;
  final VoidCallback onFeedTap;
  final VoidCallback onLogoutTap;
  final int currentIndex;

  const ScreenHeader({
    super.key,
    required this.onProfileTap,
    required this.onFeedTap,
    required this.onLogoutTap,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    final searchProvider = Provider.of<SearchProvider>(context);

    return ResponsiveBuilder(
      builder: (context, deviceType) {
        return ResponsiveContainer(
          padding: ResponsiveSpacing.lg,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MainFloatingButton(
                onProfileTap: onProfileTap,
                onFeedTap: onFeedTap,
                onLogoutTap: onLogoutTap,
                currentIndex: currentIndex,
                onMenuStateChanged: (isOpen) {
                  searchProvider.setMenuOpen(isOpen);
                },
              ),
              ResponsiveSpacingWidget.horizontal(ResponsiveSpacing.xs),
              Expanded(
                child: CustomSearchBar(
                  controller: searchProvider.searchController,
                  hintText: searchProvider.getSearchHint(),
                  onChanged: searchProvider.onSearch,
                  isMenuOpen: searchProvider.isMenuOpen,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
