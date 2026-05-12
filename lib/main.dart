import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home/home_screen.dart';
import 'core/auth_service.dart';
import 'core/firebase_options.dart';

// Global notifier for dark mode
final ValueNotifier<ThemeMode> themeModeNotifier =
    ValueNotifier(ThemeMode.light);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Silence the Flutter Windows duplicate KeyDown assertion (engine bug)
  // See: https://github.com/flutter/flutter/issues/136419
  FlutterError.onError = (FlutterErrorDetails details) {
    final msg = details.exceptionAsString();
    if (msg.contains('KeyDownEvent is dispatched') ||
        msg.contains('_pressedKeys.containsKey')) {
      return; // swallow the Windows keyboard state assertion
    }
    FlutterError.presentError(details); // show everything else normally
  };

  // Firebase only supported on Android, iOS, Web — not Windows/Linux/macOS desktop
  final bool firebaseSupported =
      kIsWeb || Platform.isAndroid || Platform.isIOS;

  if (firebaseSupported) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  // Load persisted display name before the first frame renders
  await AuthService.loadSavedDisplayName();

  runApp(MyApp(firebaseSupported: firebaseSupported));
}

class MyApp extends StatelessWidget {
  final bool firebaseSupported;
  const MyApp({super.key, required this.firebaseSupported});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeModeNotifier,
      builder: (context, mode, child) => MaterialApp(
        title: 'Speakora',
        debugShowCheckedModeBanner: false,
        themeMode: mode,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF290451)),
          fontFamily: 'Poppins',
          brightness: Brightness.light,
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF290451),
            brightness: Brightness.dark,
          ),
          scaffoldBackgroundColor: const Color(0xFF0D0020),
          fontFamily: 'Poppins',
          brightness: Brightness.dark,
        ),
        home: firebaseSupported
            ? const AuthGate()
            : const LoginScreen(),
      ),
    );
  }
}

// ── Auth gate — decides which screen to show ───────────────────────────────
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingScreen();
        }
        if (snapshot.hasData && snapshot.data != null) {
          return const HomeScreen();
        }
        return const LoginScreen();
      },
    );
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF290451),
      body: Center(
        child: CircularProgressIndicator(color: Color(0xFFD4A8F0)),
      ),
    );
  }
}
