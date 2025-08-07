import 'package:flutter/material.dart';

class TimerSettingsScreen extends StatefulWidget {
  @override
  _TimerSettingsScreenState createState() => _TimerSettingsScreenState();
}

class _TimerSettingsScreenState extends State<TimerSettingsScreen> {
  final List<Map<String, dynamic>> timeSlots = [
    {"time": "1:00-2:00 PM", "isActive": true},
    {"time": "2:00-3:00 PM", "isActive": false},
    {"time": "3:00-4:00 PM", "isActive": false},
    {"time": "5:00-8:00 PM", "isActive": false},
    {"time": "6:00-8:00 AM", "isActive": false},
    {"time": "8:00-9:00 AM", "isActive": false},
    {"time": "10:00-12:00 AM", "isActive": false},
  ];

  void _showTimePickerDialog(int index) async {
    int selectedHour = 1;
    int selectedMinute = 0;
    String selectedPeriod = "AM";

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Set Time'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  DropdownButton<int>(
                    value: selectedHour,
                    items: List.generate(12, (i) => i + 1)
                        .map<DropdownMenuItem<int>>((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text(value.toString().padLeft(2, '0')),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedHour = value!;
                      });
                    },
                  ),
                  DropdownButton<int>(
                    value: selectedMinute,
                    items: [0, 15, 30, 45]
                        .map<DropdownMenuItem<int>>((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text(value.toString().padLeft(2, '0')),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedMinute = value!;
                      });
                    },
                  ),
                  DropdownButton<String>(
                    value: selectedPeriod,
                    items: ["AM", "PM"].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedPeriod = value!;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text('Set'),
              onPressed: () {
                setState(() {
                  timeSlots[index]["time"] = '$selectedHour:$selectedMinute-$selectedHour:${selectedMinute + 1} $selectedPeriod';
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Timer'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(8.0),
        itemCount: timeSlots.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.symmetric(vertical: 4.0),
            decoration: BoxDecoration(
              color: timeSlots[index]["isActive"] ? Colors.orange : Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              title: Text(
                timeSlots[index]["time"],
                style: TextStyle(
                  fontSize: 16,
                  color: timeSlots[index]["isActive"] ? Colors.white : Colors.black,
                ),
              ),
              trailing: Switch(
                value: timeSlots[index]["isActive"],
                onChanged: (value) {
                  setState(() {
                    for (var slot in timeSlots) {
                      slot["isActive"] = false;
                    }
                    timeSlots[index]["isActive"] = value;
                  });
                },
                activeColor: Colors.white,
                activeTrackColor: Colors.grey[300],
                inactiveThumbColor: Colors.grey[400],
                inactiveTrackColor: Colors.grey[300],
              ),
              onLongPress: () => _showTimePickerDialog(index),
            ),
          );
        },
      ),
    );
  }
}