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

  void _toggleSelection(String option) {
    setState(() {
      wapdaSelected = option == 'wapda';
      gasSelected = option == 'gas';
      autoSelected = option == 'auto';
      aiSelected = option == 'ai';
      customizedSelected = option == 'customized';
      flightSelected = option == 'flight';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Utility Selection'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
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
                        backgroundColor: wapdaSelected ? Color(0xFFF25A1F) : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        minimumSize: Size(150, 150), // Uniform square size
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.power, size: 40, color: wapdaSelected ? Colors.white : Colors.black),
                          SizedBox(height: 8),
                          Text('Wapda', style: TextStyle(fontSize: 18, color: wapdaSelected ? Colors.white : Colors.black)),
                          SizedBox(height: 8),
                          Icon(
                            wapdaSelected ? Icons.check : Icons.close,
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
                        backgroundColor: gasSelected ? Color(0xFFF25A1F) : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        minimumSize: Size(150, 150), // Uniform square size
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.local_gas_station, size: 40, color: gasSelected ? Colors.white : Colors.black),
                          SizedBox(height: 8),
                          Text('Gas/LPG', style: TextStyle(fontSize: 18, color: gasSelected ? Colors.white : Colors.black)),
                          SizedBox(height: 8),
                          Icon(
                            gasSelected ? Icons.check : Icons.close,
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
                        backgroundColor: autoSelected ? Color(0xFFF25A1F) : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        minimumSize: Size(150, 150), // Uniform square size
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.autorenew, size: 40, color: autoSelected ? Colors.white : Colors.black),
                          SizedBox(height: 8),
                          Text('Auto Mode', style: TextStyle(fontSize: 18, color: autoSelected ? Colors.white : Colors.black)),
                          SizedBox(height: 8),
                          Icon(
                            autoSelected ? Icons.check : Icons.close,
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
                        backgroundColor: aiSelected ? Color(0xFFF25A1F) : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        minimumSize: Size(150, 150), // Uniform square size
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.cloud, size: 40, color: aiSelected ? Colors.white : Colors.black),
                          SizedBox(height: 8),
                          Text('AI Mode', style: TextStyle(fontSize: 18, color: aiSelected ? Colors.white : Colors.black)),
                          SizedBox(height: 8),
                          Icon(
                            aiSelected ? Icons.check : Icons.close,
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
                        backgroundColor: customizedSelected ? Color(0xFFF25A1F) : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        minimumSize: Size(150, 150), // Uniform square size
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.settings, size: 40, color: customizedSelected ? Colors.white : Colors.black),
                          SizedBox(height: 8),
                          Text('Customized Mode', style: TextStyle(fontSize: 18, color: customizedSelected ? Colors.white : Colors.black)),
                          SizedBox(height: 8),
                          Icon(
                            customizedSelected ? Icons.check : Icons.close,
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
                        backgroundColor: flightSelected ? Color(0xFFF25A1F) : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        minimumSize: Size(150, 150), // Uniform square size
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.flight, size: 40, color: flightSelected ? Colors.white : Colors.black),
                          SizedBox(height: 8),
                          Text('Flight Mode', style: TextStyle(fontSize: 18, color: flightSelected ? Colors.white : Colors.black)),
                          SizedBox(height: 8),
                          Icon(
                            flightSelected ? Icons.check : Icons.close,
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