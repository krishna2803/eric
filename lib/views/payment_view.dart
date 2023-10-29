import 'package:eric/constants/routes.dart';
import 'package:eric/views/driver_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

class PaymentView extends StatefulWidget {
  const PaymentView({super.key});

  @override
  State<PaymentView> createState() => _PaymentViewState();
}

enum Urgency { normal, high }

class _PaymentViewState extends State<PaymentView> {
  final mapController = MapController();
  Urgency? _character = Urgency.normal;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(
            color: const Color(0xff74ff18),
            height: 2.0,
          ),
        ),
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
        title: const Text('Payment'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text.rich(
            TextSpan(
              text: 'Choose Urgency:',
              style: TextStyle(fontSize: 16),
            ),
          ),
          ListTile(
            title: const Text('Normal (Rs. 10)'),
            leading: Radio<Urgency>(
              value: Urgency.normal,
              groupValue: _character,
              onChanged: (Urgency? value) {
                setState(() {
                  _character = value;
                });
              },
            ),
          ),
          ListTile(
            title: const Text('High (Rs. 15)'),
            leading: Radio<Urgency>(
              value: Urgency.high,
              groupValue: _character,
              onChanged: (Urgency? value) {
                setState(() {
                  _character = value;
                });
              },
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              await comingSoon(context);
            },
            child: const Text('Pay'),
          )
        ],
      ),
    );
  }
}

Future<void> comingSoon(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Not yet implemented!'),
        content: const Text(
            'This feature is still WIP. Coming soon!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Ok'),
          )
        ],
      );
    },
  );
}
