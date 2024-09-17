import 'dart:async';

import 'package:flutter_ble_c2pm/flutter_ble_c2pm.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

abstract class DeviceCharacteristic<T> extends PmBleCharacteristic<T> {
  BluetoothCharacteristic bluetoothCharacteristic;

  DeviceCharacteristic(this.bluetoothCharacteristic);

  @override
  void listen(StreamSink sink) {
    bluetoothCharacteristic.setNotifyValue(true);
    bluetoothCharacteristic.onValueReceived.listen((data) {
      sink.add(data);
    }, onError: (error, stackTrace) {
      sink.addError(error);
    }, onDone: () {
      sink.close();
    });
  }
}

class StrokeDataCharacteristic extends DeviceCharacteristic<StrokeData> {
  StrokeDataCharacteristic(super.characteristic);

  @override
  StrokeData create() {
    return StrokeData();
  }
}

class CsafeBufferCharacteristic extends DeviceCharacteristic<CsafeBuffer> {
  CsafeBufferCharacteristic(super.characteristic);

  @override
  Future<void> writeCsafe(IntList csafeCmd) async {
    return super.bluetoothCharacteristic.write(csafeCmd);
  }

  @override
  Future<List<int>> readCsafe() async {
    super.bluetoothCharacteristic.setNotifyValue(true);
    return super.bluetoothCharacteristic.read();
    //return Future(() => [0x68, 0x65, 0x6C, 0x6C, 0x6F, 0x20, 0x77, 0x6F, 0x72, 0x6C, 0x64]);
  }

  @override
  CsafeBuffer create() {
    return CsafeBuffer();
  }
}
