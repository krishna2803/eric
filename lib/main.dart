import 'package:eric/constants/routes.dart';
import 'package:eric/firebase_options.dart';
import 'package:eric/views/driver_view.dart';
import 'package:eric/views/email_verify_view.dart';
import 'package:eric/views/login_view.dart';
import 'package:eric/views/register_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';

void main() {
  debugPrint = (message, {wrapWidth}) => {};
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'eric',
      home: const HomePage(),
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        driverRoute: (context) => const DriverView(),
        verifyEmailRoute: (context) => const EmailVerifyView(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(options: DefaultFirebaseOptions.android),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;
            if (user == null) {
              return const LoginView();
            }
            if (user.emailVerified) {
              return const DriverView();
            }
            return const EmailVerifyView();
          default:
            return Scaffold(
              appBar: AppBar(
                title: const Text('Loading...'),
              ),
              body: const LinearProgressIndicator(),
            );
        }
      },
    );
  }
}
