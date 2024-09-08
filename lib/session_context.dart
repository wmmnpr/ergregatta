import 'dart:async';

import 'package:ergc2_pm_csafe/ergc2_pm_csafe.dart';
import 'package:ergregatta/pm_ble_wrapper.dart';
import 'package:logging/logging.dart';

import 'app_event_bus.dart';

class SessionContext {
  static final log = Logger('SessionContext');
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
      print("bindPmToBoat - context strokeData ${boat.rowed}");
      AppEventBus().sendEvent(AppEvent(AppEventType.PM_DATA_UPDATE, "data received"));
    }, onError: (error) {log.severe(error);}, onDone: () {log.info("message");});
    SessionContext().boats.add(Boat("10000", 0));
  }

  StreamSubscription<dynamic> streamSubscription = AppEventBus().stream.listen(
      (appEvent) => {
            if (AppEventType.LOCAL_PM_ATTACHED == appEvent.type)
              {bindPmToBoat(Boat("10000", 0), appEvent.payLoad)} else {
              print("updated from bus")
            }
          },
      onError: (err) => {print(err.toString())});
}

class Boat {
  String distance;
  double rowed = 0;

  Boat(this.distance, this.rowed);
}
