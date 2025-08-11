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
  double timerMinutes = 15; // Initial timer value
  Timer? _timer;
  int _countdownSeconds = 0;
  bool _timerIsRunning = false;

  // Variables for fast button press
  Timer? _buttonPressTimer;
  bool _isButtonHeld = false;

  @override
  void dispose() {
    _timer?.cancel();
    _buttonPressTimer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    if (_timerIsRunning || timerMinutes <= 0) {
      return;
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

  void _stopTimer() {
    _timer?.cancel();
    setState(() {
      _timerIsRunning = false;
      _countdownSeconds = 0;
    });
  }

  void _updateTimerMinutes(int change) {
    setState(() {
      double newTime = timerMinutes + change;
      // Allow timerMinutes to be 0 or greater, no upper limit
      if (newTime >= 0) {
        timerMinutes = newTime;
      }
    });
  }

  void _startFastUpdate(int change) {
    // Initial change on press
    _updateTimerMinutes(change);
    // Start a periodic timer for continuous updates
    _buttonPressTimer = Timer.periodic(Duration(milliseconds: 200), (timer) {
      _updateTimerMinutes(change);
    });
  }

  void _stopFastUpdate() {
    _buttonPressTimer?.cancel();
    _isButtonHeld = false;
  }

  String get _formattedTime {
    int minutes = (_countdownSeconds ~/ 60);
    int seconds = _countdownSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = Color(0xFFF25A1F);
    final inactiveTextColor = Colors.black87;
    final activeTextColor = Colors.white;

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
        // centerTitle: true,
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
                    accentColor: accentColor,
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTapDown: (_) {
                      _isButtonHeld = true;
                      _startFastUpdate(-1);
                    },
                    onTapUp: (_) => _stopFastUpdate(),
                    onTapCancel: () => _stopFastUpdate(),
                    child: IconButton(
                      iconSize: 36, // Smaller icon size
                      icon: Icon(
                        Icons.remove_circle_outline,
                        color: timerMinutes > 0 ? accentColor : Colors.grey,
                      ),
                      onPressed: null, // onPressed is null since we're using GestureDetector
                    ),
                  ),
                  SizedBox(width: 16), // Smaller spacing
                  Text(
                    '${timerMinutes.round()} min',
                    style: TextStyle(
                      fontSize: 36, // Smaller font size
                      fontWeight: FontWeight.bold,
                      color: inactiveTextColor,
                    ),
                  ),
                  SizedBox(width: 16),
                  GestureDetector(
                    onTapDown: (_) {
                      _isButtonHeld = true;
                      _startFastUpdate(1);
                    },
                    onTapUp: (_) => _stopFastUpdate(),
                    onTapCancel: () => _stopFastUpdate(),
                    child: IconButton(
                      iconSize: 36, // Smaller icon size
                      icon: Icon(
                        Icons.add_circle_outline,
                        color: accentColor,
                      ),
                      onPressed: null, // onPressed is null since we're using GestureDetector
                    ),
                  ),
                ],
              ),
            SizedBox(height: 40),
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
                    onPressed: _timerIsRunning || timerMinutes == 0 ? null : _startTimer,
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
                    onPressed: _timerIsRunning ? _stopTimer : null,
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