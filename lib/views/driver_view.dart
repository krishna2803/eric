import 'dart:math';

import 'package:eric/constants/destinations.dart';
import 'package:eric/constants/routes.dart';
import 'package:eric/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class DriverView extends StatefulWidget {
  const DriverView({super.key});

  @override
  State<DriverView> createState() => _DriverViewState();
}

class _DriverViewState extends State<DriverView> {
  static const double pointSize = 65;
  static const double pointY = 250;
  LatLng? _destination;

  final mapController = MapController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => updatePoint(context));
  }

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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text('Available e-ricks: 0'),
          const Text('Choose a destination:'),
          Text('Dropped pin is nearest to ${determineNearest()}'),
          Container(
            height: 500,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            child: FlutterMap(
              mapController: mapController,
              options: MapOptions(
                initialCenter: const LatLng(29.865608, 77.894412),
                onPositionChanged: (position, hasGesture) =>
                    updatePoint(context),
                initialZoom: 17.0,
                minZoom: 15.25,
                maxZoom: 18,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.eric',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _destination ?? const LatLng(0.0, 0.0),
                      child: const Icon(
                        Icons.pin_drop_sharp,
                        size: 20,
                        color: Colors.black,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {

            },
            child: const Text('Confirm destination'),
          )
        ],
      ),
    );
  }

  void updatePoint(BuildContext context) => setState(() => _destination =
      mapController.camera.pointToLatLng(Point(_getPointX(context), pointY)));

  double _getPointX(BuildContext context) =>
      MediaQuery.sizeOf(context).width / 2;

  String determineNearest() {
    Bhawan? bhawan;
    double minDist = double.infinity;
    try {
      for (Bhawan b in Bhawans) {
        double d = Geolocator.distanceBetween(b.pos.latitude, b.pos.longitude,
            _destination!.latitude, _destination!.longitude);
        if (d < minDist) {
          minDist = d;
          bhawan = b;
        }
      }
    } catch (ex) {
      return "null";
    }
    switch (bhawan!.ID) {
      case BhawanCode.ab:
        return "Azad bhawan";
      case BhawanCode.cb:
        return "Cautley bhawan";
      case BhawanCode.gb:
        return "Govind bhawan";
      case BhawanCode.jb:
        return "Jawahar bhawan";
      case BhawanCode.rjb:
        return "Rajendra bhawan";
      case BhawanCode.rkb:
        return "Radhakrishnan bhawan";
      case BhawanCode.rb:
        return "Rajiv bhawan";
      case BhawanCode.rvb:
        return "Ravindra bhawan";
      case BhawanCode.sb:
        return "Sarojini bhawan";
      case BhawanCode.kb:
        return "Kasturba bhawan";
      case BhawanCode.vk:
        return "Vigyan Kunj";
      default:
        return "None";
    }
  }
}

enum MenuAction { logout }

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
