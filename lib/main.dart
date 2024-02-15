import 'package:authentication/firebase_options.dart';
import 'package:authentication/screens/home_screen.dart';
import 'package:authentication/screens/login_email_password_screen.dart';
import 'package:authentication/screens/login_screen.dart';
import 'package:authentication/screens/phone_screen.dart';
import 'package:authentication/screens/signup_email_password_screen.dart';
import 'package:authentication/services/firebase_auth_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await FacebookAuth.i.webAndDesktopInitialize(
      appId: '302880489138808',
      cookie: true,
      xfbml: true,
      version: "v13.0",
    );
  }
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirebaseAuthMethods>(
          create: (_) => FirebaseAuthMethods(),
        ),
        StreamProvider(
            create: (context) => context.read<FirebaseAuthMethods>().authState,
            initialData: null)
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Firebase Auth Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const AuthWrapper(),
        routes: {
          EmailPasswordLogin.routeName: (context) => const EmailPasswordLogin(),
          EmailPasswordSignup.routeName: (context) =>
              const EmailPasswordSignup(),
          PhoneScreen.routeName: (context) => const PhoneScreen(),
          HomeScreen.routeName: (context) => const HomeScreen(),
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();
    if (firebaseUser != null) {
      return const HomeScreen();
    }
    return const LoginScreen();
  }
}
