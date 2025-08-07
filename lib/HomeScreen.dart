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
  String location = "Karachi";
  String userName = "Ashir";
  bool autoModeOn = true;
  bool utilitySelectOn = false;
  bool boostModeOn = false;
  bool timerOn = false;
  bool gasStatusOn = true;
  bool smartControlOn = false;
  bool energySaverOn = false;

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
    'Karachi', 'Lahore', 'Islamabad', 'Rawalpindi', 'Faisalabad',
    'Multan', 'Peshawar', 'Quetta', 'Gujranwala', 'Sialkot',
    'Bahawalpur', 'Sargodha', 'Sukkur', 'Larkana', 'Hyderabad',
    'Chakwal', 'Mardan', 'Kasur', 'Rahim Yar Khan', 'Sahiwal'
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
        // Simulate temperature changes (45-55°C range)
        temperature = 45 + Random().nextInt(11);
      });
    });
  }

  void _onNavItemTapped(int index) {
    if (currentNavIndex != index) {
      setState(() {
        currentNavIndex = index;
      });
      _pageController.animateToPage(
        index,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _navAnimationController.forward().then((_) {
        _navAnimationController.reset();
      });
    }
  }

  void _navigateToScreen(String screenName) {
    Widget? targetScreen;

    switch (screenName) {
      case 'ai_mode':
      targetScreen = AIModeScreen();
        _showComingSoonDialog('AI Mode');
        return;
      case 'manual_screen':
      targetScreen = ManualModeScreen();
        _showComingSoonDialog('Manual Screen');
        return;
      case 'time_screen':
      targetScreen = TimerSettingsScreen();
        _showComingSoonDialog('Time Screen');
        return;
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
          _buildSettingsPage(),
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
          children: [
            _buildCurrentCard(),
            SizedBox(height: 16),
            _buildControlsGrid(),
            SizedBox(height: 20), // Extra padding for bottom navigation
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

  Widget _buildSettingsPage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.settings, size: 64, color: primaryColor),
          SizedBox(height: 16),
          Text(
            'Settings Page',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Configure your preferences',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _navigateToScreen('SettingsScreen'),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: Text('Open Settings'),
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
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                currentTime,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              _buildTemperatureGauge(),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Current Utility',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  Text(
                    'Status',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  Text(
                    'Auto Status',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Gas',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  SizedBox(height: 8),
                  Container(
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
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTemperatureGauge() {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 80,
          height: 80,
          child: CircularProgressIndicator(
            value: temperature / 100,
            strokeWidth: 3,
            backgroundColor: Colors.white.withOpacity(0.3),
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
        Column(
          children: [
            Text(
              '$temperature°',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'temperature',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildControlsGrid() {
    return Container(
      height: 450, // Fixed height to prevent overflow
      child: Column(
        children: [
          // First row - Auto Mode (large) and AI Mode (small)
          Expanded(
            flex: 2,
            child: Row(
              children: [
                // Auto Mode - Large container (55% width)
                Expanded(
                  flex: 48,
                  child: _buildControlCard({
                    'title': 'Auto Mode',
                    'subtitle': 'Automatic system control',
                    'icon': Icons.auto_awesome,
                    'getValue': () => autoModeOn,
                    'setValue': (bool value) => setState(() => autoModeOn = value),
                    'screen': 'auto_mode',
                    'cardType': 'large',
                  }),
                ),
                SizedBox(width: 12),
                // AI Mode - Smaller container (35% width)
                Expanded(
                  flex: 38,
                  child: _buildControlCard({
                    'title': 'AI Mode',
                    'subtitle': 'Smart control',
                    'icon': Icons.psychology,
                    'getValue': () => false,
                    'setValue': (bool value) {},
                    'screen': 'ai_mode',
                    'cardType': 'medium',
                  }),
                ),
              ],
            ),
          ),
          SizedBox(height: 18),
          // Second row - Manual (medium) and Settings (small)
          Expanded(
            flex: 1,
            child: Container(
              width: double.infinity,
              child: Row(
                children: [
                  // Manual - Medium container (40% width)
                  Expanded(
                    flex: 28,
                    child: _buildControlCard({
                      'title': 'Manual',
                      'subtitle': 'Manual control',
                      'icon': Icons.touch_app,
                      'getValue': () => false,
                      'setValue': (bool value) {},
                      'screen': 'manual_screen',
                      'cardType': 'small',
                    }),
                  ),
                  SizedBox(width: 4),
                  // Utility Select - Medium container (30% width)
                  Expanded(
                    flex: 33,
                    child: _buildControlCard({
                      'title': 'Utility',
                      'subtitle': 'Select utilities',
                      'icon': Icons.build_circle,
                      'getValue': () => utilitySelectOn,
                      'setValue': (bool value) => setState(() => utilitySelectOn = value),
                      'screen': 'UtilitySelectionScreen',
                      'cardType': 'small',
                    }),
                  ),
                  SizedBox(width: 4),
                  // Timer - Small container (30% width)
                  Expanded(
                    flex: 28,
                    child: _buildControlCard({
                      'title': 'Timer',
                      'subtitle': 'Schedule',
                      'icon': Icons.schedule,
                      'getValue': () => timerOn,
                      'setValue': (bool value) => setState(() => timerOn = value),
                      'screen': 'time_screen',
                      'cardType': 'small',
                    }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlCard(Map<String, dynamic> control) {
    final title = control['title'] as String;
    final subtitle = control['subtitle'] as String;
    final icon = control['icon'] as IconData;
    final getValue = control['getValue'] as bool Function();
    final setValue = control['setValue'] as Function(bool);
    final screen = control['screen'] as String;
    final cardType = control['cardType'] as String;
    final isActive = getValue();

    // Different styling based on card type
    Color cardColor = Colors.white;
    Color shadowColor = Colors.grey.withOpacity(0.1);
    double borderRadius = 16;
    EdgeInsets padding = EdgeInsets.all(16);

    if (cardType == 'large' && isActive) {
      cardColor = primaryColor;
      shadowColor = primaryColor.withOpacity(0.3);
    } else if (cardType == 'medium' && isActive) {
      cardColor = primaryColor.withOpacity(0.1);
      shadowColor = primaryColor.withOpacity(0.2);
    }

    return GestureDetector(
      onLongPress: () {
        HapticFeedback.mediumImpact();
        _navigateToScreen(screen);
      },
      onTap: () {
        // Quick tap to toggle switch if applicable
        if (setValue != null) {
          setValue(!isActive);
        }
      },
      child: Container(
        width: double.infinity,
        height: double.infinity,
        padding: padding,
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(borderRadius),
          border: isActive && cardType != 'large'
              ? Border.all(color: primaryColor.withOpacity(0.3), width: 1)
              : null,
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: _buildCardContent(title, subtitle, icon, isActive, setValue, cardType),
      ),
    );
  }

  Widget _buildCardContent(String title, String subtitle, IconData icon, bool isActive, Function(bool) onChanged, String cardType) {
    // Color scheme based on card type and active state
    Color textColor = Colors.black;
    Color subtitleColor = Colors.grey[600]!;
    Color iconColor = Colors.grey[600]!;

    if (cardType == 'large' && isActive) {
      textColor = Colors.white;
      subtitleColor = Colors.white.withOpacity(0.8);
      iconColor = Colors.white;
    } else if (isActive) {
      textColor = primaryColor;
      iconColor = primaryColor;
    }

    if (cardType == 'large') {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: iconColor,
            size: 36,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: subtitleColor,
                    fontSize: 12,
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  width: 48,
                  height: 28,
                  child: Switch(
                    value: isActive,
                    onChanged: onChanged,
                    activeColor: cardType == 'large' && isActive ? Colors.white : primaryColor,
                    activeTrackColor: cardType == 'large' && isActive
                        ? Colors.white.withOpacity(0.3)
                        : primaryColor.withOpacity(0.3),
                    inactiveThumbColor: Colors.grey[400],
                    inactiveTrackColor: Colors.grey[300],
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    } else if (cardType == 'medium') {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                icon,
                color: iconColor,
                size: 28,
              ),
              Transform.scale(
                scale: 0.85,
                child: Switch(
                  value: isActive,
                  onChanged: onChanged,
                  activeColor: primaryColor,
                  activeTrackColor: primaryColor.withOpacity(0.3),
                  inactiveThumbColor: Colors.grey[400],
                  inactiveTrackColor: Colors.grey[300],
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  color: subtitleColor,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      );
    } else { // small cards
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                icon,
                color: iconColor,
                size: 24,
              ),
              Transform.scale(
                scale: 0.75,
                child: Switch(
                  value: isActive,
                  onChanged: onChanged,
                  activeColor: primaryColor,
                  activeTrackColor: primaryColor.withOpacity(0.3),
                  inactiveThumbColor: Colors.grey[400],
                  inactiveTrackColor: Colors.grey[300],
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: textColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  color: subtitleColor,
                  fontSize: 9,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      );
    }
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
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildCompactNavItem(Icons.home_rounded, 0),
          Container(width: 1, height: 30, color: Colors.grey[300]),
          _buildCompactNavItem(Icons.menu_rounded, 1),
          Container(width: 1, height: 30, color: Colors.grey[300]),
          _buildCompactNavItem(Icons.settings_rounded, 2),
        ],
      ),
    );
  }

  Widget _buildCompactNavItem(IconData icon, int index) {
    bool isActive = currentNavIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => _onNavItemTapped(index),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Icon(
            icon,
            color: isActive ? primaryColor : Colors.grey[500],
            size: 28,
          ),
        ),
      ),
    );
  }
}