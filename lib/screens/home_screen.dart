import 'package:ai_cook_project/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;
    return const Center(child: Text('Home Screen'));
  }
}
// This is the home screen of the app. It is a simple screen that displays a text widget with the text 'Home Screen'.
// The screen is a stateful widget, which means it can maintain its own state.