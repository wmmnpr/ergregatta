import 'dart:async';

import 'package:ergc2_pm_csafe/ergc2_pm_csafe.dart';

enum AppEventType { LOCAL_PM_ATTACHED }

class AppEvent<E> {
  AppEventType type;
  E payLoad;

  AppEvent(this.type, this.payLoad);
}

class AppEventBus {
  AppEventBus._privateConstructor();

  static final AppEventBus _instance = AppEventBus._privateConstructor();

  factory AppEventBus() {
    return _instance;
  }

  final _controller = StreamController<dynamic>.broadcast();

  Stream<dynamic> get stream => _controller.stream;

  void sendEvent(dynamic event) {
    _controller.sink.add(event);
  }

  void dispose() {
    _controller.close();
  }
}
