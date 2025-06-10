import 'package:ai_cook_project/providers/ingredients_provider.dart';
import 'package:ai_cook_project/screens/login_screen.dart';
import 'package:ai_cook_project/screens/main_screen.dart';
import 'package:ai_cook_project/screens/signup_screen.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'firebase_options.dart'; // generado por el CLI de Firebase
import 'package:ai_cook_project/screens/first_screen.dart';
import 'package:ai_cook_project/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:ai_cook_project/providers/search_provider.dart';
import 'package:ai_cook_project/providers/user_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FBAuthProvider()),
        ChangeNotifierProvider(create: (_) => SearchProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => IngredientsProvider()),
      ],
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
