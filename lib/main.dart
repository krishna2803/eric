import 'package:eric/constants/routes.dart';
import 'package:eric/firebase_options.dart';
import 'package:eric/views/email_verify_view.dart';
import 'package:eric/views/login_view.dart';
import 'package:eric/views/register_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';

import 'dart:developer' as Debug show log;

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

enum MenuAction { logout }

class DriverView extends StatefulWidget {
  const DriverView({super.key});

  @override
  State<DriverView> createState() => _DriverViewState();
}

class _DriverViewState extends State<DriverView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogoutDialog(context);
                  if (shouldLogout) {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(loginRoute, (_) => false);
                  }
                  break;
                default:
                  break;
              }
            },
            itemBuilder: (ctx) => [
              const PopupMenuItem<MenuAction>(
                value: MenuAction.logout,
                child: Text('Log out'),
              )
            ],
          )
        ],
        title: const Text('Choose a destination'),
      ),
      body: const Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Available e-ricks: 0'),
        ],
      ),
    );
  }
}

Future<bool> showLogoutDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Log out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text('Logout'),
          )
        ],
      );
    },
  ).then((value) => value ?? false);
}
