import 'package:eric/constants/routes.dart';
import 'package:eric/utils/show_error_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
        centerTitle: true,
        title: const Text('Login'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(
            color: const Color(0xff74ff18),
            height: 2.0,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              prefixIcon: Icon(
                Icons.email_outlined,
                color: Color(0xff74ff18),
              ),
              hintText: 'Email',
            ),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
              prefixIcon: Icon(
                Icons.password,
                color: Color(0xff74ff18),
              ),
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
                final user = FirebaseAuth.instance.currentUser;
                if (user?.emailVerified ?? false) {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(driverRoute, (route) => false);
                } else {
                  Navigator.of(context).pushNamed(verifyEmailRoute);
                }
              } on FirebaseAuthException catch (ex) {
                if (ex.code == 'INVALID_LOGIN_CREDENTIALS') {
                  await showErrorDialog(
                      context, 'Please recheck your email and password.');
                } else {
                  await showErrorDialog(context,
                      'An unexpected error has occured.\nError code: "${ex.code}"');
                }
              } catch (ex) {
                await showErrorDialog(context,
                    'An unexpected error has occured.\nError code: "${ex.toString()}"');
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
