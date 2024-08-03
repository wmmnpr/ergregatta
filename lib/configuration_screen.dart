

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class ConfigurationScreen extends StatefulWidget {
  @override
  _ConfigurationScreenState createState() => _ConfigurationScreenState();
}

class _ConfigurationScreenState extends State<ConfigurationScreen> {
  final log = Logger('_HomeScreenState');

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // This will be called when the widget is rebuilt
  }

  final TextEditingController _outputTextController = TextEditingController();

  void _updateDropdownItems(List<String> items) {
    setState(() {
    });
  }

  Future<void> _handleSelectDevice(BuildContext context) async {
    _outputTextController.text += 'clicked _handleSelectDevice\n';


  }

  void _handleConnect() {
    _outputTextController.text += 'clicked _handleConnect\n';
  }

  void _handleSetupWorkout() {
    _outputTextController.text += 'clicked _handleSetupWorkout\n';
  }

  void _subscribeNotifications() {
    //_notificationEnablerCharacteristic.write(List.from([0x01,0x00]));
    _outputTextController.text += 'clicked _subscribeNotifications\n';
  }

  void _handleReadCharacteristic() {
    _outputTextController.text += 'clicked _handleReadCharacteristic\n';
  }

  void _handleSubscribeSelected() {
    //_notificationEnablerCharacteristic.write(List.from([0x01,0x00]));
    _outputTextController.text += 'clicked _handleSubscribeSelected\n';
  }

  @override
  Widget build(BuildContext context) {
    const title = 'PM Diagnostics';

    return Scaffold(
      backgroundColor: Colors.lightBlue,
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: const Text(title),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: const Text("Select Device (Step 1)"),
            trailing: IconButton(
              icon: const Icon(Icons.start),
              tooltip: 'Select Device',
              onPressed: () => _handleSelectDevice(context),
            ),
          ),
          ListTile(
            title: const Text("Connect (Step 2)"),
            trailing: IconButton(
                icon: const Icon(Icons.start),
                tooltip: 'Connect',
                onPressed: () => _handleConnect()),
          ),
          ListTile(
            title: const Text("Setup Workout - hard coded"),
            trailing: IconButton(
                icon: const Icon(Icons.start),
                tooltip: 'Setup workout',
                onPressed: () => _handleSetupWorkout()),
          ),
          ListTile(
            title: const Text("Subscribe StrokeData Characteristic"),
            trailing: IconButton(
                icon: const Icon(Icons.start),
                tooltip: 'Subscribe Notification',
                onPressed: () => _subscribeNotifications()),
          ),
          ListTile(
            title: const Text("Read selected 'Read Characteristic'"),
            trailing: IconButton(
                icon: const Icon(Icons.start),
                tooltip: 'Read characteristic0x0022',
                onPressed: () => _handleReadCharacteristic()),
          ),
          ListTile(
            title: const Text("Subscribe to selected 'Read Characteristic'"),
            trailing: IconButton(
                icon: const Icon(Icons.start),
                tooltip: 'Increase volume by 10',
                onPressed: () => _handleSubscribeSelected()),
          ),
          ListTile(
            title: const Text(
                "Send command 'Input/Output Window' to selected 'Write Characteristic'"),
            trailing: IconButton(
                icon: const Icon(Icons.start),
                tooltip: 'Send command',
                onPressed: () => {}),
          ),
          ListTile(
            title: const Text("Send Command using API'"),
            trailing: IconButton(
                icon: const Icon(Icons.start),
                tooltip: 'Send Command using API',
                onPressed: () => () => {}),
          ),
          ListTile(
            title: const Text("Read Characteristic"),
            trailing: DropdownButton<String>(
              value: "",
              icon: const Icon(Icons.list),
              elevation: 16,
              style: const TextStyle(color: Colors.deepPurple),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (String? value) {
                // This is called when the user selects an item.
                setState(() {
                });
              },
              items: []
            ),
          ),
          ListTile(
            title: const Text("Write Characteristic"),
            trailing: DropdownButton<String>(
              value: "",
              icon: const Icon(Icons.list),
              elevation: 16,
              style: const TextStyle(color: Colors.deepPurple),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (String? value) {
                // This is called when the user selects an item.
                setState(() {

                });
              },
              items: []
            ),
          ),
          TextField(
            controller: _outputTextController,
            readOnly: false,
            maxLines: 10, // Allows multiline input
            decoration: const InputDecoration(
              labelText: 'Input/Output Window',
              border: OutlineInputBorder(),
            ),
          )
        ],
      ),
    );
  }
}
