import 'dart:isolate';

import 'package:flutter_ble_c2pm/flutter_ble_c2pm.dart';
import 'package:logger/logger.dart';

class SessionContext {
  static final SessionContext _instance = SessionContext._internal();

  SessionContext._internal();

  static final log = Logger();
  PmBleWrapper? localDevice;
  List<Boat> boats = [];
  SendPort? sendPort;

  factory SessionContext() {
    return _instance;
  }

  addDevice(PmBleWrapper deviceWrapper) {
    _bindPmDeviceToBoatAvatar(Boat("1000", 0), deviceWrapper);
  }

  _bindPmDeviceToBoatAvatar(Boat boat, PmBleWrapper deviceWrapper) {
    boats.add(boat);
    deviceWrapper.pmBLEDevice!.subscribe<StrokeData>(StrokeData.uuid).listen(
        (strokeData) {
      boat.rowed = strokeData.distance * 10;
      log.i("strokeData rowed ${boat.rowed}");
      sendPort?.send(strokeData);
    }, onError: (error) {
      log.e(error);
    }, onDone: () {
      log.i("message");
    });

    deviceWrapper.pmBLEDevice!
        .subscribe<AdditionalStatus1>(AdditionalStatus1.uuid)
        .listen((additionalStatus1) {
      //boat.rowed = additionalStatus1.restTime;
      log.i("additionalStatus1 rowed ${boat.rowed}");
      sendPort?.send(additionalStatus1);
    }, onError: (error) {
      log.e(error);
    }, onDone: () {
      log.i("message");
    });
  }
}

class Boat {
  String distance;
  double rowed = 0;

  Boat(this.distance, this.rowed);
}
