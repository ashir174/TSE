import 'package:flutter/material.dart';

class UtilitySelectionScreen extends StatefulWidget {
  @override
  _UtilitySelectionScreenState createState() => _UtilitySelectionScreenState();
}

class _UtilitySelectionScreenState extends State<UtilitySelectionScreen> {
  bool wapdaSelected = true;
  bool gasSelected = false;
  bool autoSelected = false;
  bool aiSelected = false;
  bool customizedSelected = false;
  bool flightSelected = false;

  // Main brand color
  static const Color primaryColor = Color(0xFFF25A1F);

  void _toggleSelection(String option) {
    setState(() {
      wapdaSelected = option == 'wapda';
      gasSelected = option == 'gas';
      autoSelected = option == 'auto';
      aiSelected = option == 'ai'; // Assuming 'ai' mode should use automode.png for consistency
      customizedSelected = option == 'customized';
      flightSelected = option == 'flight';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Utility Selection'),
        backgroundColor: Colors.white, // Adjusted for better visual
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black), // Changed icon color
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () => _toggleSelection('wapda'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: wapdaSelected ? primaryColor : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        minimumSize: Size(150, 150), // Uniform square size
                        padding: EdgeInsets.zero, // Remove default padding
                        elevation: 4, // Add a slight shadow
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Using Image.asset for wapda.png
                          Image.asset(
                            'assets/images/wapda.png',
                            width: 40,
                            height: 40,
                            color: wapdaSelected ? Colors.white : Colors.black, // Apply tint
                          ),
                          SizedBox(height: 8),
                          Text('Wapda', style: TextStyle(fontSize: 18, color: wapdaSelected ? Colors.white : Colors.black)),
                          SizedBox(height: 8),
                          Icon(
                            wapdaSelected ? Icons.check_circle : Icons.radio_button_unchecked, // More distinct check
                            size: 30,
                            color: wapdaSelected ? Colors.white : Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () => _toggleSelection('gas'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: gasSelected ? primaryColor : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        minimumSize: Size(150, 150), // Uniform square size
                        padding: EdgeInsets.zero,
                        elevation: 4,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Using Image.asset for gas_lpg.png
                          Image.asset(
                            'assets/images/gas_lpg.png',
                            width: 40,
                            height: 40,
                            color: gasSelected ? Colors.white : Colors.black, // Apply tint
                          ),
                          SizedBox(height: 8),
                          Text('Gas/LPG', style: TextStyle(fontSize: 18, color: gasSelected ? Colors.white : Colors.black)),
                          SizedBox(height: 8),
                          Icon(
                            gasSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                            size: 30,
                            color: gasSelected ? Colors.white : Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () => _toggleSelection('auto'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: autoSelected ? primaryColor : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        minimumSize: Size(150, 150), // Uniform square size
                        padding: EdgeInsets.zero,
                        elevation: 4,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Using Image.asset for auto.png
                          Image.asset(
                            'assets/images/auto.png',
                            width: 40,
                            height: 40,
                            color: autoSelected ? Colors.white : Colors.black, // Apply tint
                          ),
                          SizedBox(height: 8),
                          Text('Auto Mode', style: TextStyle(fontSize: 18, color: autoSelected ? Colors.white : Colors.black)),
                          SizedBox(height: 8),
                          Icon(
                            autoSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                            size: 30,
                            color: autoSelected ? Colors.white : Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () => _toggleSelection('ai'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: aiSelected ? primaryColor : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        minimumSize: Size(150, 150), // Uniform square size
                        padding: EdgeInsets.zero,
                        elevation: 4,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Using Image.asset for automode.png (or another appropriate image for AI)
                          Image.asset(
                            'assets/images/automode.png', // Assuming automode.png is for AI
                            width: 40,
                            height: 40,
                            color: aiSelected ? Colors.white : Colors.black, // Apply tint
                          ),
                          SizedBox(height: 8),
                          Text('AI Mode', style: TextStyle(fontSize: 18, color: aiSelected ? Colors.white : Colors.black)),
                          SizedBox(height: 8),
                          Icon(
                            aiSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                            size: 30,
                            color: aiSelected ? Colors.white : Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () => _toggleSelection('customized'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: customizedSelected ? primaryColor : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        minimumSize: Size(150, 150), // Uniform square size
                        padding: EdgeInsets.zero,
                        elevation: 4,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Using Image.asset for customized.png
                          Image.asset(
                            'assets/images/customized.png',
                            width: 40,
                            height: 40,
                            color: customizedSelected ? Colors.white : Colors.black, // Apply tint
                          ),
                          SizedBox(height: 8),
                          Text('Customized Mode', style: TextStyle(fontSize: 18, color: customizedSelected ? Colors.white : Colors.black)),
                          SizedBox(height: 8),
                          Icon(
                            customizedSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                            size: 30,
                            color: customizedSelected ? Colors.white : Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () => _toggleSelection('flight'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: flightSelected ? primaryColor : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        minimumSize: Size(150, 150), // Uniform square size
                        padding: EdgeInsets.zero,
                        elevation: 4,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Using Image.asset for flight.png
                          Image.asset(
                            'assets/images/flight.png',
                            width: 40,
                            height: 40,
                            color: flightSelected ? Colors.white : Colors.black, // Apply tint
                          ),
                          SizedBox(height: 8),
                          Text('Flight Mode', style: TextStyle(fontSize: 18, color: flightSelected ? Colors.white : Colors.black)),
                          SizedBox(height: 8),
                          Icon(
                            flightSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                            size: 30,
                            color: flightSelected ? Colors.white : Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
