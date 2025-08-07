import 'dart:async';
import 'package:flutter/material.dart';

class ManualModeScreen extends StatefulWidget {
  @override
  _ManualModeScreenState createState() => _ManualModeScreenState();
}

class _ManualModeScreenState extends State<ManualModeScreen> {
  // State variables for the heaters
  bool heater1On = true;
  bool heater2On = false;

  // State variables for the timer functionality
  double timerMinutes = 30; // Use double for the slider
  Timer? _timer;
  int _countdownSeconds = 0;
  bool _timerIsRunning = false;

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed to prevent memory leaks
    _timer?.cancel();
    super.dispose();
  }

  // Method to start the timer
  void _startTimer() {
    if (_timerIsRunning) {
      return; // Do nothing if the timer is already running
    }

    setState(() {
      _countdownSeconds = (timerMinutes * 60).round();
      _timerIsRunning = true;
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_countdownSeconds <= 0) {
        _stopTimer();
      } else {
        setState(() {
          _countdownSeconds--;
        });
      }
    });
  }

  // Method to stop the timer
  void _stopTimer() {
    _timer?.cancel();
    setState(() {
      _timerIsRunning = false;
      _countdownSeconds = 0;
      timerMinutes = 0;
    });
  }

  // A helper to format the time for display
  String get _formattedTime {
    int minutes = (_countdownSeconds ~/ 60);
    int seconds = _countdownSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    // Define a modern color scheme
    final accentColor = Color(0xFFF25A1F);
    final inactiveColor = Colors.grey[200];
    final activeTextColor = Colors.white;
    final inactiveTextColor = Colors.black87;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Manual Mode',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: inactiveTextColor,
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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Heater Cards
            Text(
              'Control Heaters',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: inactiveTextColor,
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: _buildHeaterCard(
                    context,
                    label: 'Heater 1',
                    isOn: heater1On,
                    onToggle: (value) {
                      setState(() {
                        heater1On = value;
                      });
                    },
                    accentColor: accentColor!,
                  ),
                ),
                SizedBox(width: 24),
                Expanded(
                  child: _buildHeaterCard(
                    context,
                    label: 'Heater 2',
                    isOn: heater2On,
                    onToggle: (value) {
                      setState(() {
                        heater2On = value;
                      });
                    },
                    accentColor: accentColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 40),
            // Timer Section
            Text(
              'Set Timer',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: inactiveTextColor,
              ),
            ),
            SizedBox(height: 24),
            if (_timerIsRunning)
              Center(
                child: Text(
                  _formattedTime,
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: accentColor,
                  ),
                ),
              )
            else
              Row(
                children: [
                  Expanded(
                    child: Slider(
                      value: timerMinutes,
                      min: 0,
                      max: 30,
                      divisions: 30, // 1 minute increments
                      label: '${timerMinutes.round()} min',
                      activeColor: accentColor,
                      inactiveColor: Colors.grey[350],
                      onChanged: (value) {
                        setState(() {
                          timerMinutes = value;
                        });
                      },
                    ),
                  ),
                  Text(
                    '${timerMinutes.round()} min',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: inactiveTextColor,
                    ),
                  ),
                ],
              ),
            SizedBox(height: 40),
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                    ),
                    onPressed: _timerIsRunning ? null : _startTimer, // Disable if timer is running
                    icon: Icon(Icons.timer, color: activeTextColor),
                    label: Text(
                      'Start Timer',
                      style: TextStyle(color: activeTextColor),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey[400]!),
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _timerIsRunning ? _stopTimer : null, // Disable if timer is not running
                    icon: Icon(Icons.stop, color: inactiveTextColor),
                    label: Text(
                      'Stop Timer',
                      style: TextStyle(color: inactiveTextColor),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(Icons.home_outlined),
                onPressed: () {},
                color: Colors.grey,
              ),
              IconButton(
                icon: Icon(Icons.list_alt_outlined),
                onPressed: () {},
                color: Colors.grey,
              ),
              IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {
                  // Navigate to SettingsScreen
                },
                color: accentColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaterCard(BuildContext context, {
    required String label,
    required bool isOn,
    required ValueChanged<bool> onToggle,
    required Color accentColor,
  }) {
    // ... (This widget remains the same as in the previous response)
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: isOn ? accentColor : Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
        boxShadow: isOn
            ? [
          BoxShadow(
            color: accentColor.withOpacity(0.4),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ]
            : [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isOn ? Colors.white : Colors.black87,
            ),
          ),
          SizedBox(height: 8),
          Switch(
            value: isOn,
            onChanged: onToggle,
            activeColor: Colors.white,
            activeTrackColor: Colors.white.withOpacity(0.5),
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: Colors.grey[400],
          ),
        ],
      ),
    );
  }
}