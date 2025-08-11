import 'package:flutter/material.dart';
import 'LoginScreen.dart';
import 'HomeScreen.dart';

class SettingsScreen extends StatelessWidget {
  // Define the primary brand color for consistency
  static const Color primaryColor = Color(0xFFF25A1F);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor, // Use defined primaryColor
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        minimumSize: Size(150, 150), // Increased button size
                        padding: EdgeInsets.zero, // Remove default padding
                        elevation: 4, // Add a slight shadow
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Using profile.png with white tint
                          Image.asset(
                            'assets/images/profile.png',
                            width: 40,
                            height: 40,
                            color: Colors.white, // Tint image white
                          ),
                          SizedBox(height: 8),
                          Text('Profile', style: TextStyle(color: Colors.white, fontSize: 14)),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        minimumSize: Size(150, 150), // Increased button size
                        padding: EdgeInsets.zero,
                        elevation: 4,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Using add_new.png with black tint
                          Image.asset(
                            'assets/images/add_new.png',
                            width: 40,
                            height: 40,
                            color: Colors.black, // Tint image black
                          ),
                          SizedBox(height: 8),
                          Text('Add New Device', style: TextStyle(fontSize: 14, color: Colors.black)), // Set text color to black
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0), // Added spacing between rows
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        minimumSize: Size(150, 150), // Increased button size
                        padding: EdgeInsets.zero,
                        elevation: 4,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Using connect.png with black tint
                          Image.asset(
                            'assets/images/connect.png',
                            width: 40,
                            height: 40,
                            color: Colors.black, // Tint image black
                          ),
                          SizedBox(height: 8),
                          Text('Connect Device to WiFi', style: TextStyle(fontSize: 14, color: Colors.black)), // Set text color to black
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        minimumSize: Size(150, 150), // Increased button size
                        padding: EdgeInsets.zero,
                        elevation: 4,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Using logout.png with black tint
                          Image.asset(
                            'assets/images/logout.png',
                            width: 40,
                            height: 40,
                            color: Colors.black, // Tint image black
                          ),
                          SizedBox(height: 8),
                          Text('Log Out', style: TextStyle(fontSize: 14, color: Colors.black)), // Set text color to black
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0), // Added spacing between rows
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  minimumSize: Size(double.infinity, 150), // Make button full width
                  padding: EdgeInsets.zero,
                  elevation: 4,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Using set_temp.png with black tint
                    Image.asset(
                      'assets/images/set_temp.png',
                      width: 40,
                      height: 40,
                      color: Colors.black, // Tint image black
                    ),
                    SizedBox(height: 8),
                    Text('Set Temperature', style: TextStyle(fontSize: 14, color: Colors.black)), // Set text color to black
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
