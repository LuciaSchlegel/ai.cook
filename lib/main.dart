import 'package:ai_cook_project/providers/api_rec_provider.dart';
import 'package:ai_cook_project/providers/ingredients_provider.dart';
import 'package:ai_cook_project/providers/resource_provider.dart';
import 'package:ai_cook_project/screens/auth/0_login/login_screen.dart';
import 'package:ai_cook_project/screens/main/main_screen.dart';
import 'package:ai_cook_project/screens/auth/0_signup/signup_screen.dart';
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
import 'package:ai_cook_project/providers/recipes_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<FBAuthProvider>(create: (_) => FBAuthProvider()),
        ChangeNotifierProvider<SearchProvider>(create: (_) => SearchProvider()),
        ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider()),
        ChangeNotifierProvider<IngredientsProvider>(
          create: (_) => IngredientsProvider(),
        ),
        ChangeNotifierProvider<RecipesProvider>(
          create: (_) => RecipesProvider(),
        ),
        ChangeNotifierProvider<ResourceProvider>(
          create: (_) => ResourceProvider(),
        ),
        ChangeNotifierProvider<ExtRecipesProvider>(
          create: (_) => ExtRecipesProvider(),
        ),
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
      home: const AuthWrapper(),
      routes: {
        '/first': (context) => const FirstScreen(),
        '/main': (context) => const MainScreen(),
        '/login': (context) => const LoginScreen(),
        '/sign_up': (context) => const SignupScreen(),
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<FBAuthProvider>(context);
    if (auth.user == null) {
      // Solo al inicio, navega a FirstScreen
      Future.microtask(() {
        Navigator.pushReplacementNamed(context, '/first');
      });
      return const SizedBox.shrink();
    } else {
      Future.microtask(() {
        Navigator.pushReplacementNamed(context, '/main');
      });
      return const SizedBox.shrink();
    }
  }
}
