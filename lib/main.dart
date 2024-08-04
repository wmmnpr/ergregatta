import 'dart:async';

import 'package:ergregatta/rowing_scene.dart';
import 'package:ergregatta/screens/bluetooth_off_screen.dart';
import 'package:ergregatta/screens/scan_screen.dart';
import 'package:ergregatta/session_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:logging/logging.dart';

import 'configuration_screen.dart';

class RowingSceneWidget extends StatefulWidget {
  const RowingSceneWidget({super.key});

  @override
  State<RowingSceneWidget> createState() => _RowingSceneWidgetState();
}

class _RowingSceneWidgetState extends State<RowingSceneWidget> {
  int pushCount = 0;
  late BluetoothDevice activeDevice;
  BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;

  late StreamSubscription<BluetoothAdapterState> _adapterStateStateSubscription;

  @override
  void initState() {
    super.initState();
    _adapterStateStateSubscription =
        FlutterBluePlus.adapterState.listen((state) {
      _adapterState = state;
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _adapterStateStateSubscription.cancel();
    super.dispose();
  }

  Future<void> _handleSelectDevice(BuildContext context) async {
    BluetoothDevice? returnedDevice = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ConfigurationScreen()),
    );
    if (returnedDevice != null) {
      setState(() {
        activeDevice = returnedDevice;
      });
    }
  }

  void _updateBoats() {
    pushCount++;
    for (var b in SessionContext().boats) {
      b.rowed = b.rowed + 10;
    }
    setState(() {
      // Trigger a repaint by updating the state
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget screen = _adapterState == BluetoothAdapterState.on
        ? const ScanScreen()
        : BluetoothOffScreen(adapterState: _adapterState);

    return Scaffold(
      body: Center(
        child: CustomPaint(
          painter: RowingScene(),
          child: Container(),
        ),
      ),
      floatingActionButton:
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        FloatingActionButton(
          heroTag: "updateBoatsTag",
          onPressed: _updateBoats,
          child: const Icon(Icons.refresh),
        ),
        FloatingActionButton(
            heroTag: "configureBleTag",
            onPressed: () => _handleSelectDevice(context),
            child: const Icon(Icons.bluetooth))
      ]),
    );
  }
}

//
// This observer listens for Bluetooth Off and dismisses the DeviceScreen
//
class BluetoothAdapterStateObserver extends NavigatorObserver {
  StreamSubscription<BluetoothAdapterState>? _adapterStateSubscription;

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    if (route.settings.name == '/DeviceScreen') {
      // Start listening to Bluetooth state changes when a new route is pushed
      _adapterStateSubscription ??=
          FlutterBluePlus.adapterState.listen((state) {
        if (state != BluetoothAdapterState.on) {
          // Pop the current route if Bluetooth is off
          navigator?.pop();
        }
      });
    }
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    // Cancel the subscription when the route is popped
    _adapterStateSubscription?.cancel();
    _adapterStateSubscription = null;
  }
}

var logger = Logger("main");

void main() {
  logger.info("Starting in {}", "main");
  runApp(MaterialApp(
    navigatorObservers: [BluetoothAdapterStateObserver()],
    home: RowingSceneWidget(),
  ));
}
