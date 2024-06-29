import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:provider/provider.dart';
import 'modules/login/Login.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AwesomeNotifications().initialize(null, [
    NotificationChannel(
      channelKey: 'basic_channel',
      channelName: 'Basic notifications',
      channelDescription: 'Notification channel for basic notifications',
      defaultColor: Colors.teal,
      ledColor: Colors.teal,
      criticalAlerts: true,
      enableVibration: true,
      playSound: true,
    ),
  ]);
  AwesomeNotifications().initialize(null, [
    NotificationChannel(
      channelKey: 'basic_channel',
      channelName: 'Basic notifications',
      channelDescription: 'Notification channel for basic notifications',
      defaultColor: Colors.teal,
      ledColor: Colors.teal,
      criticalAlerts: true,
      enableVibration: true,
      playSound: true,
    ),
  ]);
  runApp(MyApp());
}

class ThemeNotifier extends ChangeNotifier {
  bool isDarkMode = false;

  ThemeMode get currentTheme => isDarkMode ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    isDarkMode = !isDarkMode;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: Consumer<ThemeNotifier>(
        builder: (context, themeNotifier, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Nurse Call System',
            theme: ThemeData(
              primarySwatch: Colors.teal,
              buttonTheme: ButtonThemeData(
                buttonColor: Colors.teal,
                textTheme: ButtonTextTheme.primary,
              ),
              appBarTheme: AppBarTheme(
                color: Colors.teal,
              ),
            ),
            darkTheme: ThemeData.dark(),
            themeMode: themeNotifier.currentTheme,
            home: login(),
          );
        },
      ),
    );
  }
}
