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
  bool aiModeOn = false;
  bool manualModeOn = false;

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
            SizedBox(height: 20),
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
              Expanded(
                child: Text(
                  currentTime,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
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

  Widget _buildControlsList() {
    final controlButtons = [
      {
        'title': 'Auto Mode',
        'subtitle': 'Automatic system control',
        'icon': Icons.auto_awesome,
        'isActive': autoModeOn,
        'onToggle': (bool value) => setState(() => autoModeOn = value),
        'screenName': 'auto_mode',
        'size': 'large'
      },
      {
        'title': 'AI Mode',
        'subtitle': 'Smart AI control',
        'icon': Icons.psychology,
        'isActive': aiModeOn,
        'onToggle': (bool value) => setState(() => aiModeOn = value),
        'screenName': 'ai_mode',
        'size': 'medium'
      },
      {
        'title': 'Manual Mode',
        'subtitle': 'Manual control',
        'icon': Icons.touch_app,
        'isActive': manualModeOn,
        'onToggle': (bool value) => setState(() => manualModeOn = value),
        'screenName': 'manual_screen',
        'size': 'medium'
      },
      {
        'title': 'Utility Select',
        'subtitle': 'Choose utilities',
        'icon': Icons.build_circle,
        'isActive': utilitySelectOn,
        'onToggle': (bool value) => setState(() => utilitySelectOn = value),
        'screenName': 'UtilitySelectionScreen',
        'size': 'medium'
      },
      {
        'title': 'Timer Settings',
        'subtitle': 'Schedule control',
        'icon': Icons.schedule,
        'isActive': timerOn,
        'onToggle': (bool value) => setState(() => timerOn = value),
        'screenName': 'time_screen',
        'size': 'medium'
      },
      {
        'title': 'Boost Mode',
        'subtitle': 'Enhanced performance',
        'icon': Icons.flash_on,
        'isActive': boostModeOn,
        'onToggle': (bool value) => setState(() => boostModeOn = value),
        'screenName': 'boost_mode',
        'size': 'medium'
      },
      {
        'title': 'Smart Control',
        'subtitle': 'Intelligent automation',
        'icon': Icons.smart_button,
        'isActive': smartControlOn,
        'onToggle': (bool value) => setState(() => smartControlOn = value),
        'screenName': 'smart_control',
        'size': 'medium'
      },
      {
        'title': 'Energy Saver',
        'subtitle': 'Optimize consumption',
        'icon': Icons.eco,
        'isActive': energySaverOn,
        'onToggle': (bool value) => setState(() => energySaverOn = value),
        'screenName': 'energy_saver',
        'size': 'medium'
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Controls',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: 16),
        _buildControlButton(controlButtons[0]),
        SizedBox(height: 12),
        for (int i = 1; i < controlButtons.length; i += 2)
          Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Expanded(child: _buildControlButton(controlButtons[i])),
                SizedBox(width: 12),
                Expanded(
                  child: i + 1 < controlButtons.length
                      ? _buildControlButton(controlButtons[i + 1])
                      : SizedBox(),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildControlButton(Map<String, dynamic> control) {
    final title = control['title'] as String;
    final subtitle = control['subtitle'] as String;
    final icon = control['icon'] as IconData;
    final isActive = control['isActive'] as bool;
    final onToggle = control['onToggle'] as Function(bool);
    final screenName = control['screenName'] as String; // Get screen name for navigation
    final size = control['size'] as String;

    final isLarge = size == 'large';
    final height = isLarge ? 130.0 : 190.0;

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        // Here you can either keep the original onTap logic or remove it if you only want long press to navigate
      },
      onLongPress: () {
        HapticFeedback.heavyImpact();
        _navigateToScreen(screenName);
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        height: height,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isActive ? primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: isActive && !isLarge
              ? Border.all(color: primaryColor.withOpacity(0.3), width: 1)
              : null,
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
                Icon(
                  icon,
                  color: isActive ? Colors.white : primaryColor,
                  size: isLarge ? 32 : 24,
                ),
                Transform.scale(
                  scale: isLarge ? 1.0 : 0.8,
                  child: Switch(
                    value: isActive,
                    onChanged: (value) {
                      HapticFeedback.selectionClick();
                      onToggle(value);
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
                fontSize: isLarge ? 18 : 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (subtitle.isNotEmpty)
              Text(
                subtitle,
                style: TextStyle(
                  color: isActive
                      ? Colors.white.withOpacity(0.8)
                      : primaryColor.withOpacity(0.8),
                  fontSize: isLarge ? 12 : 10,
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