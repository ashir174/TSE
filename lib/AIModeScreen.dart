import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For HapticFeedback if needed

class AIModeScreen extends StatefulWidget {
  @override
  _AIModeScreenState createState() => _AIModeScreenState();
}

class _AIModeScreenState extends State<AIModeScreen> {
  // Initial values for upper limit
  int upperHour = 1;
  int upperMinute = 50;
  String upperPeriod = "PM";

  // Initial values for lower limit
  int lowerHour = 1;
  int lowerMinute = 10;
  String lowerPeriod = "AM";

  final List<Map<String, dynamic>> timeSlots = [
    {"time": "1:00 PM - 2:00 PM", "isActive": true},
    {"time": "2:00 PM - 3:00 PM", "isActive": false},
    {"time": "3:00 PM - 4:00 PM", "isActive": false},
  ];

  // Primary brand color
  static const Color primaryColor = Color(0xFFF25A1F);

  // Helper to format time for display
  String _formatTime(int hour, int minute, String period) {
    // Adjust hour for 12 AM/PM display if necessary (e.g., 0 becomes 12 AM)
    int displayHour = hour;
    if (hour == 0 && period == "AM") {
      displayHour = 12; // 0:XX AM should be 12:XX AM
    } else if (hour == 12 && period == "AM") {
      displayHour = 12; // 12:XX AM remains 12:XX AM
    } else if (hour == 0 && period == "PM") {
      displayHour = 12; // 0:XX PM should be 12:XX PM (this case might not occur with 1-12 picker)
    }

    String formattedHour = displayHour.toString();
    String formattedMinute = minute.toString().padLeft(2, '0');
    return '$formattedHour:$formattedMinute $period';
  }

  // Function to add the new timer to the list
  void _saveNewTimer() {
    final String formattedUpperTime = _formatTime(upperHour, upperMinute, upperPeriod);
    final String formattedLowerTime = _formatTime(lowerHour, lowerMinute, lowerPeriod);

    setState(() {
      timeSlots.add({"time": "$formattedLowerTime - $formattedUpperTime", "isActive": false});
    });

    // Show a confirmation message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('New timer saved: $formattedLowerTime - $formattedUpperTime'),
        backgroundColor: primaryColor,
        duration: Duration(seconds: 2),
      ),
    );
  }

  // Helper widget for hour/minute selection using ListWheelScrollView
  Widget _buildTimePickerColumn({
    required int currentValue,
    required int maxNumber, // Max number in the wheel (e.g., 12 for hours, 59 for minutes)
    required ValueChanged<int> onChanged,
    required bool isLooping, // Whether the picker should loop (e.g., minutes 0-59)
  }) {
    // Generate items for the picker based on whether it's hours (1-12) or minutes (0-59)
    List<int> pickerItems;
    if (maxNumber == 12) { // Special case for hours (1-12)
      pickerItems = List<int>.generate(12, (i) => i + 1);
    } else { // For minutes (0-59)
      pickerItems = List<int>.generate(maxNumber + 1, (i) => i);
    }

    // Determine the initial index for the scroll controller
    int initialIndex = 0;
    if (isLooping) {
      // Find the index of the current value in the non-looping list
      int foundIndex = pickerItems.indexOf(currentValue);
      // Set initial index to a central point in the large virtual list for smooth looping
      initialIndex = foundIndex + (pickerItems.length * 500); // Start in the middle of many loops
    } else {
      initialIndex = pickerItems.indexOf(currentValue);
    }


    FixedExtentScrollController scrollController = FixedExtentScrollController(
      initialItem: initialIndex,
    );

    return SizedBox(
      width: 60, // Fixed width for each picker column
      height: 100, // Fixed height for each picker column
      child: ListWheelScrollView.useDelegate(
        controller: scrollController,
        itemExtent: 40, // Height of each individual item in the wheel
        perspective: 0.003, // Adds a slight 3D perspective
        diameterRatio: 1.2, // Controls the "flatness" of the wheel
        physics: FixedExtentScrollPhysics(), // Ensures items snap into place
        onSelectedItemChanged: (index) {
          int selectedValue;
          if (isLooping) {
            selectedValue = pickerItems[index % pickerItems.length];
          } else {
            selectedValue = pickerItems[index];
          }
          onChanged(selectedValue);
        },
        childDelegate: ListWheelChildBuilderDelegate(
          builder: (context, index) {
            final int value = pickerItems[index % pickerItems.length];
            return Center(
              child: Text(
                value.toString().padLeft(2, '0'), // Format as two digits (e.g., 05 instead of 5)
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            );
          },
          // Use a large childCount to simulate infinite scrolling for looping pickers
          childCount: isLooping ? pickerItems.length * 1000 : pickerItems.length,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AI Mode'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
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
              color: primaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('Upper Limit', style: TextStyle(color: Colors.white, fontSize: 16)),
                    // Hour picker for Upper Limit
                    _buildTimePickerColumn(
                      currentValue: upperHour,
                      maxNumber: 12, // Hours go from 1 to 12
                      isLooping: true, // Hours loop
                      onChanged: (value) {
                        setState(() {
                          upperHour = value;
                        });
                      },
                    ),
                    Text(':', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                    // Minute picker for Upper Limit
                    _buildTimePickerColumn(
                      currentValue: upperMinute,
                      maxNumber: 59, // Minutes go from 0 to 59
                      isLooping: true, // Minutes loop
                      onChanged: (value) {
                        setState(() {
                          upperMinute = value;
                        });
                      },
                    ),
                    Theme(
                      data: Theme.of(context).copyWith(
                        canvasColor: Colors.white, // Background color of the dropdown menu
                      ),
                      child: DropdownButton<String>(
                        value: upperPeriod,
                        iconEnabledColor: Colors.white,
                        style: TextStyle(color: Colors.white, fontSize: 16), // Color of selected item on the orange card
                        dropdownColor: Colors.white, // Explicitly set dropdown background
                        items: ["AM", "PM"].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value, style: TextStyle(color: primaryColor, fontSize: 16)), // Color of menu items
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
              color: primaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('Lower Limit', style: TextStyle(color: Colors.white, fontSize: 16)),
                    // Hour picker for Lower Limit
                    _buildTimePickerColumn(
                      currentValue: lowerHour,
                      maxNumber: 12,
                      isLooping: true,
                      onChanged: (value) {
                        setState(() {
                          lowerHour = value;
                        });
                      },
                    ),
                    Text(':', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                    // Minute picker for Lower Limit
                    _buildTimePickerColumn(
                      currentValue: lowerMinute,
                      maxNumber: 59,
                      isLooping: true,
                      onChanged: (value) {
                        setState(() {
                          lowerMinute = value;
                        });
                      },
                    ),
                    Theme(
                      data: Theme.of(context).copyWith(
                        canvasColor: Colors.white, // Background color of the dropdown menu
                      ),
                      child: DropdownButton<String>(
                        value: lowerPeriod,
                        iconEnabledColor: Colors.white,
                        style: TextStyle(color: Colors.white, fontSize: 16), // Color of selected item on the orange card
                        dropdownColor: Colors.white, // Explicitly set dropdown background
                        items: ["AM", "PM"].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value, style: TextStyle(color: primaryColor, fontSize: 16)), // Color of menu items
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
            SizedBox(height: 20.0),
            Center(
              child: ElevatedButton(
                onPressed: _saveNewTimer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 5,
                ),
                child: Text(
                  'Save Timer',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Text('Your Timers', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: timeSlots.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    color: timeSlots[index]["isActive"] ? primaryColor : Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                    child: ListTile(
                      title: Text(
                        timeSlots[index]["time"],
                        style: TextStyle(
                          color: timeSlots[index]["isActive"] ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing: Switch(
                        value: timeSlots[index]["isActive"],
                        onChanged: (value) {
                          setState(() {
                            // Ensure only one timer can be active at a time
                            for (var slot in timeSlots) {
                              slot["isActive"] = false;
                            }
                            timeSlots[index]["isActive"] = value;
                          });
                        },
                        activeColor: Colors.white,
                        activeTrackColor: Colors.white.withOpacity(0.5),
                        inactiveThumbColor: Colors.grey[400],
                        inactiveTrackColor: Colors.grey[300],
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
