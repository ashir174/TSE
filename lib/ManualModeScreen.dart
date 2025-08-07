import 'package:flutter/material.dart';
import 'SettingsScreen.dart';


class ManualModeScreen extends StatefulWidget {
  @override
  _ManualModeScreenState createState() => _ManualModeScreenState();
}

class _ManualModeScreenState extends State<ManualModeScreen> {
  bool heater1On = true;
  bool heater2On = false;
  int timerMinutes = 30;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manual Mode'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Card(
                  color: heater1On ? Colors.orange : Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text('Heater 1', style: TextStyle(fontSize: 16)),
                        Switch(
                          value: heater1On,
                          onChanged: (value) {
                            setState(() {
                              heater1On = value;
                            });
                          },
                          activeColor: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  color: heater2On ? Colors.orange : Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text('Heater 2', style: TextStyle(fontSize: 16)),
                        Switch(
                          value: heater2On,
                          onChanged: (value) {
                            setState(() {
                              heater2On = value;
                            });
                          },
                          activeColor: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Text('Set Timer (0 - 30 minutes)', style: TextStyle(fontSize: 16)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    setState(() {
                      if (timerMinutes > 0) timerMinutes -= 1;
                    });
                  },
                ),
                Text('$timerMinutes min', style: TextStyle(fontSize: 20)),
                IconButton(
                  icon: Icon(Icons.add, color: Colors.orange),
                  onPressed: () {
                    setState(() {
                      if (timerMinutes < 30) timerMinutes += 1;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                  onPressed: () {
                    // Implement start timer logic
                  },
                  child: Text('Start Timer'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[300]),
                  onPressed: () {
                    // Implement stop timer logic
                  },
                  child: Text('Stop Timer'),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(icon: Icon(Icons.home), onPressed: () {}),
            IconButton(icon: Icon(Icons.list), onPressed: () {}),
            IconButton(icon: Icon(Icons.settings), onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            }),
          ],
        ),
      ),
    );
  }
}