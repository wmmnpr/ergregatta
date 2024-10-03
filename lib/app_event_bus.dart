import 'dart:async';

enum AppEventType { LOCAL_PM_ATTACHED, PM_DATA_UPDATE }

class AppEvent {
  AppEventType type;
  dynamic payLoad;

  AppEvent(this.type, this.payLoad);
}

class AppEventBus {
  AppEventBus._internal();

  static final AppEventBus _instance = AppEventBus._internal();

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
