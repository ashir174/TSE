import 'package:flutter/material.dart';

class TimerSettingsScreen extends StatefulWidget {
  @override
  _TimerSettingsScreenState createState() => _TimerSettingsScreenState();
}

class _TimerSettingsScreenState extends State<TimerSettingsScreen> {
  // A cleaner, more descriptive data model for time slots.
  final List<Map<String, dynamic>> timeSlots = [
    {"time": "1:00 PM - 2:00 PM", "isActive": true},
    {"time": "2:00 PM - 3:00 PM", "isActive": false},
    {"time": "3:00 PM - 4:00 PM", "isActive": false},
    {"time": "5:00 PM - 8:00 PM", "isActive": false},
    {"time": "6:00 AM - 8:00 AM", "isActive": false},
    {"time": "8:00 AM - 9:00 AM", "isActive": false},
    {"time": "10:00 AM - 12:00 PM", "isActive": false},
  ];

  void _showTimePickerDialog(int index) async {
    // We can use a more modern and user-friendly time picker.
    // For this example, we'll use Flutter's built-in TimePicker.
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      // You'll need a bit more logic here to handle both start and end times,
      // but this shows how to get a clean time value.
      setState(() {
        timeSlots[index]["time"] = picked.format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // We use a dark color scheme to create a sense of focus and calm.
    // The accent color will make the active selection stand out.
    final accentColor = Color(0xFFF25A1F);
    final inactiveColor = Colors.grey[200];
    final activeTextColor = Colors.white;
    final inactiveTextColor = Colors.black87;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Timer Settings',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemCount: timeSlots.length,
        itemBuilder: (context, index) {
          final isSelected = timeSlots[index]["isActive"];
          return AnimatedContainer(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            margin: EdgeInsets.symmetric(vertical: 8.0),
            decoration: BoxDecoration(
              color: isSelected ? accentColor : inactiveColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: isSelected
                  ? [
                BoxShadow(
                  color: accentColor.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ]
                  : [],
            ),
            child: InkWell(
              onTap: () {
                setState(() {
                  // Only one time slot can be active at a time.
                  for (var slot in timeSlots) {
                    slot["isActive"] = false;
                  }
                  timeSlots[index]["isActive"] = true;
                });
              },
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      timeSlots[index]["time"],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? activeTextColor : inactiveTextColor,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: isSelected ? activeTextColor : Colors.grey[600]),
                          onPressed: () => _showTimePickerDialog(index),
                        ),
                        SizedBox(width: 8),
                        Switch(
                          value: isSelected,
                          onChanged: (value) {
                            setState(() {
                              for (var slot in timeSlots) {
                                slot["isActive"] = false;
                              }
                              timeSlots[index]["isActive"] = value;
                            });
                          },
                          activeColor: activeTextColor,
                          inactiveThumbColor: Colors.white,
                          inactiveTrackColor: Colors.grey[400],
                          activeTrackColor: Colors.white.withOpacity(0.5),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}