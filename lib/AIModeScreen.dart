import 'package:flutter/material.dart';

class AIModeScreen extends StatefulWidget {
  @override
  _AIModeScreenState createState() => _AIModeScreenState();
}

class _AIModeScreenState extends State<AIModeScreen> {
  int upperHour = 1;
  int upperMinute = 50;
  String upperPeriod = "PM";
  int lowerHour = 1;
  int lowerMinute = 10;
  String lowerPeriod = "AM";

  final List<Map<String, dynamic>> timeSlots = [
    {"time": "1:00-2:00 PM", "isActive": true},
    {"time": "2:00-3:00 PM", "isActive": false},
    {"time": "3:00-4:00 PM", "isActive": false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AI Mode'),
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
            Text('Set Your Limit', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 16.0),
            Card(
              color: Color(0xFFF25A1F),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('Upper Limit', style: TextStyle(color: Colors.white)),
                    Text(upperHour.toString().padLeft(2, '0'), style: TextStyle(color: Colors.white)),
                    Text(upperMinute.toString().padLeft(2, '0'), style: TextStyle(color: Colors.white)),
                    Theme(
                      data: Theme.of(context).copyWith(
                        canvasColor: Colors.white, // Background color of the dropdown menu
                      ),
                      child: DropdownButton<String>(
                        value: upperPeriod,
                        iconEnabledColor: Colors.white,
                        style: TextStyle(color: Colors.white), // Color of selected item on the orange card
                        items: ["AM", "PM"].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value, style: TextStyle(color: Color(0xFFF25A1F))), // Color of menu items
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            upperPeriod = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Card(
              color: Color(0xFFF25A1F),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('Lower Limit', style: TextStyle(color: Colors.white)),
                    Text(lowerHour.toString().padLeft(2, '0'), style: TextStyle(color: Colors.white)),
                    Text(lowerMinute.toString().padLeft(2, '0'), style: TextStyle(color: Colors.white)),
                    Theme(
                      data: Theme.of(context).copyWith(
                        canvasColor: Colors.white, // Background color of the dropdown menu
                      ),
                      child: DropdownButton<String>(
                        value: lowerPeriod,
                        iconEnabledColor: Colors.white,
                        style: TextStyle(color: Colors.white), // Color of selected item on the orange card
                        items: ["AM", "PM"].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value, style: TextStyle(color: Color(0xFFF25A1F))), // Color of menu items
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            lowerPeriod = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Text('Your Timers', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: timeSlots.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: timeSlots[index]["isActive"] ? Color(0xFFF25A1F) : Colors.white,
                    child: ListTile(
                      title: Text(
                        timeSlots[index]["time"],
                        style: TextStyle(
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
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}