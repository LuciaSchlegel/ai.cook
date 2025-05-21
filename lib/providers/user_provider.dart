import 'package:flutter/cupertino.dart';

class UserProvider with ChangeNotifier {
  String _user = '';

  String get user => _user;

  void setUser(String user) {
    _user = user;
    notifyListeners();
  }

  void clearUser() {
    _user = '';
    notifyListeners();
  }

  void updateUser(String user) {
    _user = user;
    notifyListeners();
  }

  void removeUser() {
    _user = '';
    notifyListeners();
  }
}
