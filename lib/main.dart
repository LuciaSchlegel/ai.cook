import 'package:ai_cook_project/providers/api_rec_provider.dart';
import 'package:ai_cook_project/providers/ingredients_provider.dart';
import 'package:ai_cook_project/providers/resource_provider.dart';
import 'package:ai_cook_project/providers/ai_recommendations_provider.dart';
import 'package:ai_cook_project/screens/auth/0_login/login_screen.dart';
import 'package:ai_cook_project/screens/main/main_screen.dart';
import 'package:ai_cook_project/screens/auth/0_signup/signup_screen.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'firebase_options.dart';
import 'package:ai_cook_project/screens/first_screen.dart';
import 'package:ai_cook_project/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:ai_cook_project/providers/search_provider.dart';
import 'package:ai_cook_project/providers/user_provider.dart';
import 'package:ai_cook_project/providers/recipes_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Para que sea transparente
      statusBarIconBrightness:
          Brightness.light, // Íconos en blanco para Android
      statusBarBrightness:
          Brightness.dark, // Para iOS: fondo oscuro => texto blanco
    ),
  );

  // Captura errores globales de Flutter
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint('Stacktrace: ${details.stack}');
  };

  // Captura errores globales de la plataforma
  PlatformDispatcher.instance.onError = (error, stack) {
    debugPrint('PlatformDispatcher error: $error');
    debugPrint('Stacktrace: $stack');
    return true;
  };

  // Cargar las variables de entorno primero
  try {
    await dotenv.load(fileName: '.env');
    debugPrint('✅ Environment variables loaded successfully');
  } catch (e) {
    debugPrint('❌ Error loading environment variables: $e');
  }

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
        ChangeNotifierProvider<AIRecommendationsProvider>(
          create: (_) => AIRecommendationsProvider(),
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
      home: const FirebaseInitializer(),
      builder: (context, child) {
        // Ensure status bar is always white on iOS
        SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
          ),
        );
        return child!;
      },
      routes: {
        '/first': (context) => const FirstScreen(),
        '/main': (context) => const MainScreen(),
        '/login': (context) => const LoginScreen(),
        '/sign_up': (context) => const SignupScreen(),
      },
    );
  }
}

class FirebaseInitializer extends StatelessWidget {
  const FirebaseInitializer({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        // Si hay error en la inicialización de Firebase
        if (snapshot.hasError) {
          debugPrint('🔥 Firebase initialization error: ${snapshot.error}');
          debugPrint('🔥 Stacktrace: ${snapshot.stackTrace}');
          return Scaffold(
            backgroundColor: Colors.red,
            body: SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Colors.white,
                          size: 64,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Firebase Error',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          // Muestra el error y stacktrace en un scroll
                          '${snapshot.error}\n\nSTACKTRACE:\n${snapshot.stackTrace}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            // Reintentar inicialización
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => const FirebaseInitializer(),
                              ),
                            );
                          },
                          child: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }

        // Si Firebase se inicializó correctamente
        if (snapshot.connectionState == ConnectionState.done) {
          debugPrint('🔥 Firebase initialized successfully');
          return const AuthWrapper();
        }

        // Pantalla de carga mientras Firebase se inicializa
        return Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          body: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
                SizedBox(height: 20),
                Text(
                  'Iniciando Firebase...',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
          ),
        );
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
