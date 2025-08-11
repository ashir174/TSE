import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:math';
import 'SettingsScreen.dart';
import 'UtilitySelectionScreen.dart';
import 'AIModeScreen.dart';
import 'ManualModeScreen.dart';
import 'TimerSettingsScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  String location = "Faisalabad";
  String userName = "Ashir";

  // State variables for controls
  bool autoModeOn = true;
  bool manualModeOn = false;
  bool utilitySelectOn = false;
  bool timerOn = false;
  bool boostModeOn = false;
  bool smartControlOn = false;
  bool energySaverOn = false;

  bool gasStatusOn = true;
  bool waterStatusOn = false;

  // State variables for filter. The default filter is 'All'.
  String selectedFilter = 'All';

  String currentTime = "";
  String weatherStatus = "Sunny Today!";
  int temperature = 50;
  int currentNavIndex = 0;

  Timer? _timer;
  Timer? _temperatureTimer;
  late AnimationController _navAnimationController;
  late Animation<double> _navSlideAnimation;
  late PageController _pageController;

  // Main brand color
  static const Color primaryColor = Color(0xFFF25A1F);
  static const Color lightGrey = Color(0xFFF5F5F5);

  final List<String> pakistanCities = [
    'Faisalabad', 'Lahore', 'Islamabad', 'Rawalpindi', 'Karachi',
    'Multan', 'Peshawar', 'Quetta', 'Gujranwala', 'Sialkot',
    'Bahawalpur', 'Sargodha', 'Sukkur', 'Larkana', 'Hyderabad',
    'Chakwal', 'Mardan', 'Kasur', 'Rahim Yar Khan', 'Sahiwal'
  ];

  // A complete list of all controls for easy filtering.
  final List<Map<String, dynamic>> _allControls = [
    {'title': 'Auto Mode', 'image': 'assets/images/automode.png', 'screenName': 'ai_mode'},
    {'title': 'Manual Mode', 'icon': Icons.touch_app, 'screenName': 'manual_screen'},
    {'title': 'Utility Select', 'image': 'assets/images/utility.png', 'screenName': 'UtilitySelectionScreen'},
    {'title': 'Timer Settings', 'image': 'assets/images/timer.png', 'screenName': 'time_screen'},
    {'title': 'Boost Mode', 'image': 'assets/images/boost.png', 'screenName': 'boost_mode'},
    {'title': 'Smart Control', 'icon': Icons.smart_button, 'screenName': 'smart_control'},
    {'title': 'Energy Saver', 'icon': Icons.eco, 'screenName': 'energy_saver'},
  ];

  @override
  void initState() {
    super.initState();
    _updateTime();
    _startRealTimeUpdates();
    _startTemperatureSimulation();

    _pageController = PageController(initialPage: 0);
    _navAnimationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _navSlideAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _navAnimationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _timer?.cancel();
    _temperatureTimer?.cancel();
    _navAnimationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _updateTime() {
    final now = DateTime.now();
    final hour = now.hour == 0 ? 12 : (now.hour > 12 ? now.hour - 12 : now.hour);
    final minute = now.minute.toString().padLeft(2, '0');
    final period = now.hour >= 12 ? 'PM' : 'AM';

    setState(() {
      currentTime = '$hour:$minute $period';
    });
  }

  void _startRealTimeUpdates() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _updateTime();
    });
  }

  void _startTemperatureSimulation() {
    _temperatureTimer = Timer.periodic(Duration(seconds: 5), (timer) {
      setState(() {
        temperature = 45 + Random().nextInt(11);
      });
    });
  }

  void _onNavItemTapped(int index) {
    if (index == 2) { // Settings button
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SettingsScreen()),
      );
    } else {
      if (currentNavIndex != index) {
        setState(() {
          currentNavIndex = index;
        });
        _pageController.animateToPage(
          index,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  void _navigateToScreen(String screenName) {
    Widget? targetScreen;

    switch (screenName) {
      case 'ai_mode':
        targetScreen = AIModeScreen();
        break;
      case 'manual_screen':
        targetScreen = ManualModeScreen();
        break;
      case 'time_screen':
        targetScreen = TimerSettingsScreen();
        break;
      case 'UtilitySelectionScreen':
        targetScreen = UtilitySelectionScreen();
        break;
      case 'SettingsScreen':
        targetScreen = SettingsScreen();
        break;
      default:
        _showComingSoonDialog(screenName);
        return;
    }

    if (targetScreen != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => targetScreen!),
      );
    }
  }

  void _showComingSoonDialog(String screenName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.info_outline, color: primaryColor),
              SizedBox(width: 8),
              Text('Coming Soon'),
            ],
          ),
          content: Text('$screenName will be available in the next update.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK', style: TextStyle(color: primaryColor)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGrey,
      appBar: _buildAppBar(),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            currentNavIndex = index;
          });
        },
        children: [
          _buildHomePage(),
          _buildMenuPage(),
          SettingsScreen()
          // The settings page is no longer here. Navigation is handled directly.
        ],
      ),
      bottomNavigationBar: _buildCompactBottomNavigation(),
    );
  }

  Widget _buildHomePage() {
    return SafeArea(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCurrentCard(),
            SizedBox(height: 20),
            _buildFilterSection(),
            SizedBox(height: 16),
            _buildControlsList(),
            SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuPage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.menu, size: 64, color: primaryColor),
          SizedBox(height: 16),
          Text(
            'Menu Page',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Coming Soon...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: lightGrey,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: primaryColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.3),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Icon(Icons.person, color: Colors.white, size: 20),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello, $userName',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              _showLocationPicker();
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[400]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.location_on, color: primaryColor, size: 16),
                  SizedBox(width: 4),
                  Text(
                    location,
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.keyboard_arrow_down, color: Colors.grey[700], size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLocationPicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.location_on, color: primaryColor),
              SizedBox(width: 8),
              Text('Select Location'),
            ],
          ),
          content: Container(
            width: double.maxFinite,
            height: 300,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: pakistanCities.length,
              itemBuilder: (context, index) {
                final city = pakistanCities[index];
                final isSelected = city == location;
                return ListTile(
                  leading: Icon(
                    Icons.location_city,
                    color: isSelected ? primaryColor : Colors.grey[600],
                  ),
                  title: Text(
                    city,
                    style: TextStyle(
                      color: isSelected ? primaryColor : Colors.black,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                  trailing: isSelected
                      ? Icon(Icons.check_circle, color: primaryColor)
                      : null,
                  onTap: () {
                    setState(() {
                      location = city;
                    });
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: TextStyle(color: Colors.grey[600])),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCurrentCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryColor, Color(0xFFE64A19)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.3),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CURRENT',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  Text(
                    weatherStatus,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              _buildTemperatureSection(),
            ],
          ),
          SizedBox(height: 16),
          Text(
            currentTime,
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          // --- Updated status and utility section ---
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Current Utility',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  Text(
                    'Gas',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Status',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  SizedBox(
                    width: 44,
                    height: 24,
                    child: Switch(
                      value: gasStatusOn,
                      onChanged: (value) {
                        setState(() {
                          gasStatusOn = value;
                        });
                      },
                      activeColor: Colors.white,
                      activeTrackColor: Colors.white.withOpacity(0.3),
                      inactiveThumbColor: Colors.white.withOpacity(0.7),
                      inactiveTrackColor: Colors.white.withOpacity(0.2),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Auto Status',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  SizedBox(
                    width: 44,
                    height: 24,
                    child: Switch(
                      value: waterStatusOn,
                      onChanged: (value) {
                        setState(() {
                          waterStatusOn = value;
                        });
                      },
                      activeColor: Colors.white,
                      activeTrackColor: Colors.white.withOpacity(0.3),
                      inactiveThumbColor: Colors.white.withOpacity(0.7),
                      inactiveTrackColor: Colors.white.withOpacity(0.2),
                    ),
                  ),
                ],
              ),
            ],
          ),
          // --- End of updated section ---
        ],
      ),
    );
  }

  Widget _buildTemperatureSection() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset(
          'assets/images/outter_temp.png',
          width: 100,
          height: 100,
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$temperature°',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'temperature',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // The _buildStatusToggle method has been removed from here.

  // Gets the list of controls based on the selected filter.
  List<Map<String, dynamic>> _getFilteredControls() {
    if (selectedFilter == 'All') {
      return _allControls;
    }
    // Find the control that matches the selected filter title.
    final filtered = _allControls.where((control) {
      return control['title'] == selectedFilter;
    }).toList();

    return filtered;
  }

  Widget _buildControlsList() {
    final filteredControls = _getFilteredControls();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Always build the first control as the large one if it exists.
        if (filteredControls.isNotEmpty)
          _buildLargeControlButton(filteredControls.first),
        SizedBox(height: 12),
        // Build the remaining controls in a two-column layout.
        for (int i = 1; i < filteredControls.length; i += 2)
          Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Expanded(
                  child: _buildSmallControlButton(filteredControls[i]),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: i + 1 < filteredControls.length
                      ? _buildSmallControlButton(filteredControls[i + 1])
                      : SizedBox(),
                ),
              ],
            ),
          ),
      ],
    );
  }

  bool _getControlState(String title) {
    switch (title) {
      case 'Auto Mode':
        return autoModeOn;
      case 'Manual Mode':
        return manualModeOn;
      case 'Utility Select':
        return utilitySelectOn;
      case 'Timer Settings':
        return timerOn;
      case 'Boost Mode':
        return boostModeOn;
      case 'Smart Control':
        return smartControlOn;
      case 'Energy Saver':
        return energySaverOn;
      default:
        return false;
    }
  }

  void _toggleControlState(String title, bool value) {
    setState(() {
      switch (title) {
        case 'Auto Mode':
          autoModeOn = value;
          break;
        case 'Manual Mode':
          manualModeOn = value;
          break;
        case 'Utility Select':
          utilitySelectOn = value;
          break;
        case 'Timer Settings':
          timerOn = value;
          break;
        case 'Boost Mode':
          boostModeOn = value;
          break;
        case 'Smart Control':
          smartControlOn = value;
          break;
        case 'Energy Saver':
          energySaverOn = value;
          break;
      }
    });
  }

  Widget _buildFilterSection() {
    final filters = ['All', ..._allControls.map((e) => e['title'] as String)];
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = selectedFilter == filter;
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedFilter = filter;
              });
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              margin: EdgeInsets.only(right: 8),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? primaryColor : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: isSelected
                    ? [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ]
                    : null,
              ),
              child: Center(
                child: Text(
                  filter,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLargeControlButton(Map<String, dynamic> control) {
    final title = control['title'] as String;
    final screenName = control['screenName'] as String;
    final isActive = _getControlState(title);

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        _navigateToScreen(screenName);
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        height: 130,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isActive ? primaryColor : Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          boxShadow: [
            BoxShadow(
              color: isActive ? primaryColor.withOpacity(0.3) : Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (control.containsKey('icon'))
                  Icon(
                    control['icon'] as IconData,
                    color: isActive ? Colors.white : primaryColor,
                    size: 32,
                  )
                else if (control.containsKey('image'))
                  Image.asset(
                    control['image'] as String,
                    width: 32,
                    height: 32,
                    color: isActive ? Colors.white : primaryColor,
                  ),
                Transform.scale(
                  scale: 1.0,
                  child: Switch(
                    value: isActive,
                    onChanged: (value) {
                      HapticFeedback.selectionClick();
                      _toggleControlState(title, value);
                    },
                    activeColor: Colors.white,
                    activeTrackColor: Colors.white.withOpacity(0.3),
                    inactiveThumbColor: Colors.grey[400],
                    inactiveTrackColor: Colors.grey[300],
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: isActive ? Colors.white : primaryColor,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Automatic system control',
              style: TextStyle(
                color: isActive ? Colors.white.withOpacity(0.8) : primaryColor.withOpacity(0.8),
                fontSize: 12,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallControlButton(Map<String, dynamic> control) {
    final title = control['title'] as String;
    final screenName = control['screenName'] as String;
    final isActive = _getControlState(title);

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        _navigateToScreen(screenName);
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        height: 190,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isActive ? primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: isActive ? primaryColor.withOpacity(0.3) : Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (control.containsKey('icon'))
                  Icon(
                    control['icon'] as IconData,
                    color: isActive ? Colors.white : primaryColor,
                    size: 24,
                  )
                else if (control.containsKey('image'))
                  Image.asset(
                    control['image'] as String,
                    width: 24,
                    height: 24,
                    color: isActive ? Colors.white : primaryColor,
                  ),
                Transform.scale(
                  scale: 0.8,
                  child: Switch(
                    value: isActive,
                    onChanged: (value) {
                      HapticFeedback.selectionClick();
                      _toggleControlState(title, value);
                    },
                    activeColor: isActive ? Colors.white : primaryColor,
                    activeTrackColor: isActive
                        ? Colors.white.withOpacity(0.3)
                        : primaryColor.withOpacity(0.3),
                    inactiveThumbColor: Colors.grey[400],
                    inactiveTrackColor: Colors.grey[300],
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: isActive ? Colors.white : primaryColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Control system',
              style: TextStyle(
                color: isActive
                    ? Colors.white.withOpacity(0.8)
                    : primaryColor.withOpacity(0.8),
                fontSize: 10,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactBottomNavigation() {
    return Container(
      height: 60,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildCompactNavItem(Icons.home_rounded, 0),
          Container(width: 1, height: 25, color: Colors.grey[300]),
          _buildCompactNavItem(Icons.menu_rounded, 1),
          Container(width: 1, height: 25, color: Colors.grey[300]),
          _buildCompactNavItem(Icons.settings_rounded, 2),
        ],
      ),
    );
  }

  Widget _buildCompactNavItem(IconData icon, int index) {
    bool isActive = currentNavIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          HapticFeedback.selectionClick();
          _onNavItemTapped(index);
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          padding: EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isActive ? primaryColor.withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Icon(
            icon,
            color: isActive ? primaryColor : Colors.grey[500],
            size: isActive ? 30 : 26,
          ),
        ),
      ),
    );
  }
}