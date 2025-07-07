import 'package:flutter/material.dart';

class SearchProvider with ChangeNotifier {
  final TextEditingController _searchController = TextEditingController();
  String _currentScreen = 'home';
  bool _isMenuOpen = false;

  TextEditingController get searchController => _searchController;
  String get currentScreen => _currentScreen;
  bool get isMenuOpen => _isMenuOpen;

  void setCurrentScreen(String screen) {
    _currentScreen = screen;
    notifyListeners();
  }

  void setMenuOpen(bool isOpen) {
    _isMenuOpen = isOpen;
    notifyListeners();
  }

  String getSearchHint() {
    switch (_currentScreen) {
      case 'cupboard':
        return 'Find ingredients...';
      case 'recipes':
        return 'Find recipes...';
      default:
        return 'Discover...';
    }
  }

  void onSearch(String value) {
    notifyListeners();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
