import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class SessionContext {
  static final SessionContext _instance = SessionContext._internal();

  SessionContext._internal();

  factory SessionContext() {
    return _instance;
  }

  BluetoothDevice? localDevice;

  final List<Boat> boats = initBoats();

  static List<Boat> initBoats() {
    List<Boat> list = [];
    list.add(Boat(" 900", 0));
    list.add(Boat("1000", 200));
    list.add(Boat("1000", 210));
    return list;
  }
}

class Boat {
  String distance;
  double rowed = 0;

  Boat(this.distance, this.rowed);
}
