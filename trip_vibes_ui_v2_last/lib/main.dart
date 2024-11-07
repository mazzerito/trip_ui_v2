import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'package:trip_vibes_ui_v2/screens/pages/add_ttrip_na.dart';
import 'package:trip_vibes_ui_v2/screens/dummy_test/trip_add_test_v.dart';
import 'package:trip_vibes_ui_v2/test_user/login_screen_test.dart';
import 'package:trip_vibes_ui_v2/test_user/profile_test.dart';
import 'package:trip_vibes_ui_v2/test_user/signup_screen_test.dart';
//import 'package:trip_vibes_ui_v2/screens/pages/trip_screen/edit_trip_screen.txt';
import 'providers/theme_provider.dart';
import 'screens/pages/activitiy_screen/activity_screen.dart';
import 'screens/pages/auth_screen/login_screen.dart';
import 'screens/pages/auth_screen/signup_screen.dart';
import 'screens/pages/booking_screen/booking_screen.dart';
import 'screens/pages/destination_screen/destination_screen.dart';
import 'screens/pages/drawer_screen/settings.dart';
import 'screens/pages/splash_screen.dart';
import 'screens/pages/trip_screen/add_trip_screen.dart';
import 'screens/dummy_test/dum-edit_trip_screen.dart';
import 'screens/pages/trip_screen/trip_detail.dart';
import 'screens/pages/trip_screen/trip_screen.dart';
import 'screens/pages/user_screen/edit_profile_screen.dart';
import 'screens/pages/user_screen/profile_screen.dart';
import 'theme/them.dart';


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Trip Vibes',
          theme: AppThemes.lightTheme,
          darkTheme: AppThemes.darkTheme,
          themeMode: themeProvider.themeMode, // Apply current theme
          home: LoginScreen(),
          routes:{
                  '/splash': (BuildContext context) => SplashScreen(),
                //======Auth
                  '/login': (BuildContext context) => LoginScreen(),
                  '/signup': (BuildContext context) => SignupScreen(),
                //======User
                  //'/profile': (BuildContext context) => ProfileScreen(),
                  //'/edit-profile': (BuildContext context) => EditProfileScreen(),
                //======Drawer
                '/settings':(BuildContext context)=> SettingsScreen(),
                //======Trip
                  '/trip': (BuildContext context) => TripScreen(),
                  //'/trip-detail': (BuildContext context) => TripDetailScreen(),
                  '/add-trip': (BuildContext context) => AddTripScreen(),
                  //'/edit-trip': (BuildContext context) => EditTripScreen(),
                //======Booking
                 // '/booking': (BuildContext context) => BookingScreen(),
                //======Desintaion
                 // '/destination': (BuildContext context) => DestinationsScreen(),
                //======Activity
                  //'/activity': (BuildContext context) => ActivityScreen(),
                },
        );
      },
    );
  }
}
