import 'package:ai_cook_project/providers/search_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainScreenInit {
  static updateSearchScreen({
    required BuildContext context,
    required currentIndex,
  }) {
    final searchProvider = Provider.of<SearchProvider>(context, listen: false);
    if (currentIndex == -1) {
      searchProvider.setCurrentScreen('home');
    } else if (currentIndex == 0) {
      searchProvider.setCurrentScreen('cupboard');
    } else if (currentIndex == 1) {
      searchProvider.setCurrentScreen('recipes');
    } else {
      searchProvider.setCurrentScreen('other');
    }
  }
}
