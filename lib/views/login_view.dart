import 'package:eric/constants/routes.dart';
import 'package:eric/firebase_options.dart';
import 'package:eric/utils/show_error_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(hintText: 'Email'),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
              hintText: 'Password',
            ),
          ),
          TextButton(
            child: const Text('Log in'),
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: email,
                  password: password,
                );
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(driverRoute, (route) => false);
              } on FirebaseAuthException catch (ex) {
                if (ex.code == 'INVALID_LOGIN_CREDENTIALS') {
                  await showErrorDialog(
                      context, 'Please recheck your email and password.');
                } else {
                  await showErrorDialog(
                      context, 'An unexpected error has occured.\nError code: \"${ex.code}\"');
                }
              } catch (ex) {
                await showErrorDialog(
                      context, 'An unexpected error has occured.\nError code: \"${ex.toString()}\"');
              }
            },
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(registerRoute, (route) => false);
            },
            child: const Text('Not registered yet? Click here to Register'),
          ),
        ],
      ),
    );
  }
}
