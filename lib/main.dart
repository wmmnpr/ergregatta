import 'package:ergregatta/regatta_manager.dart';
import 'package:ergregatta/rowing_scene.dart';
import 'package:flutter/material.dart';

class RowingSceneWidget extends StatefulWidget {
  const RowingSceneWidget({super.key});

  @override
  _RowingSceneWidgetState createState() => _RowingSceneWidgetState();
}

class _RowingSceneWidgetState extends State<RowingSceneWidget> {
  int pushCount = 0;

  void _updateBoats() {
    pushCount++;
    for (var b in RegattaManager.boats) {
      b.rowed = b.rowed + 10;
    }
    setState(() {
      // Trigger a repaint by updating the state
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomPaint(
          painter: RowingScene(),
          child: Container(),
        ),
      ),
      floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
                child: const Icon(Icons.refresh),
                onPressed: _updateBoats
            ),
            FloatingActionButton(
                child: const Icon(Icons.bluetooth),
                onPressed: () => {
                  Navigator.pop(context, null)
                }
            )
          ]
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: RowingSceneWidget(),
  ));
}
