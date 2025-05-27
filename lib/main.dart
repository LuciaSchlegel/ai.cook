import 'package:ai_cook_project/screens/login_screen.dart';
import 'package:ai_cook_project/screens/main_screen.dart';
import 'package:ai_cook_project/screens/signup_screen.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart'; // generado por el CLI de Firebase
import 'package:ai_cook_project/screens/first_screen.dart';
import 'package:ai_cook_project/providers/auth_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    ChangeNotifierProvider(
      create: (_) => FBAuthProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ai.Cook',
      theme: appTheme,
      debugShowCheckedModeBanner: false,
      home: Consumer<FBAuthProvider>(
        builder: (context, auth, _) {
          if (auth.user == null) {
            return const FirstScreen(); // usuario no autenticado
          } else {
            return const MainScreen(); // usuario autenticado
          }
        },
      ),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/sign_up': (context) => const SignupScreen(),
      },
    );
  }
}
