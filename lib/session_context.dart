import 'dart:async';

import 'package:flutter_ble_c2pm/flutter_ble_c2pm.dart';
import 'package:logger/logger.dart';

import 'app_event_bus.dart';

class SessionContext {
  static final log = Logger();
  static final SessionContext _instance = SessionContext._internal();

  SessionContext._internal();

  factory SessionContext() {
    return _instance;
  }

  PmBleWrapper? localDevice;

  final List<Boat> boats = initBoats();

  static List<Boat> initBoats() {
    List<Boat> list = [];
    return list;
  }

  static bindPmToBoat(Boat boat, PmBleWrapper deviceWrapper) {
    deviceWrapper.pmBLEDevice!.subscribe<StrokeData>(StrokeData.uuid).listen(
        (strokeData) {
      boat.rowed = strokeData.distance * 100;
      log.i("bindPmToBoat - context strokeData ${boat.rowed}");
      AppEventBus()
          .sendEvent(AppEvent(AppEventType.PM_DATA_UPDATE, strokeData));
    }, onError: (error) {
      log.e(error);
    }, onDone: () {
      log.i("message");
    });
    SessionContext().boats.add(Boat("10000", 0));
  }

  StreamSubscription<dynamic> streamSubscription = AppEventBus().stream.listen(
      (appEvent)  {
            if (AppEventType.LOCAL_PM_ATTACHED == appEvent.type)
              {
                bindPmToBoat(Boat("10000", 0), appEvent.payLoad);
              }
            else
              {
                StrokeData strokeData = appEvent.payLoad as StrokeData;
                log.i("updated from bus ${strokeData.distance}");
              }
          },
      onError: (err) => {log.e(err.toString())});
}

class Boat {
  String distance;
  double rowed = 0;

  Boat(this.distance, this.rowed);
}
