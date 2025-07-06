import 'package:flutter/material.dart';
import 'package:ai_cook_project/widgets/main_floating_button.dart';
import 'package:ai_cook_project/widgets/search_bar.dart';
import 'package:ai_cook_project/providers/search_provider.dart';
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

    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.05,
      ),
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
          const SizedBox(width: 8),
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
  }
}