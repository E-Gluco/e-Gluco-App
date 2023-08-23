// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:gluco/db/dbtest.dart';
import 'package:gluco/services/bluetoothhelper.dart';
import 'package:gluco/services/customlog.dart';
import 'package:gluco/pages/devicepage.dart';
import 'package:gluco/pages/firstloginpage.dart';
import 'package:gluco/pages/historypage.dart';
import 'package:gluco/pages/homepage.dart';
import 'package:gluco/pages/loginpage.dart';
import 'package:gluco/pages/profilepage.dart';
import 'package:gluco/pages/signuppage.dart';
import 'package:gluco/pages/splashscreen.dart';
import 'package:gluco/services/api.dart';
import 'package:gluco/services/btletest.dart';
import 'package:gluco/styles/customcolors.dart';
import 'package:gluco/views/historyvo.dart';

String _defaultHome = '/login';
bool offline = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('pt_BR', null);

  await logInit();

  if (await API.instance.login()) {
    switch (API.instance.responseMessage) {
      case APIResponseMessages.success:
        _defaultHome = '/home';
        await HistoryVO.fetchHistory();
        break;
      case APIResponseMessages.offlineMode:
        _defaultHome = '/home';
        offline = true;
        await HistoryVO.fetchHistory();
        break;
      case APIResponseMessages.emptyProfile:
        _defaultHome = '/welcome';
        break;
    }
  }

  BluetoothHelper.instance.autoConnect();

  runApp(
    MaterialApp(
      home: Main(),
    ),
  );
}

class Main extends StatefulWidget {
  @override
  MainState createState() => MainState();
}

class MainState extends State<Main> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.transparent,
        primarySwatch: Colors.green,
        // backgroundColor: Colors.white,  // color Schema
        // // accentColor: Colors.grey[600],
        // errorColor: Colors.red[900],
        fontFamily: 'OpenSans',
        textTheme: ThemeData.light().textTheme.copyWith(
              titleLarge: TextStyle(
                color: Colors.black,
                fontFamily: 'OpenSans',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              labelLarge: TextStyle(color: Colors.white),
            ), /* deprec
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                titleLarge: TextStyle(
                  color: Colors.white,
                  fontFamily: 'OpenSans',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
        ),*/
      ),
      routes: {
        '/': (context) => SplashScreen(route: _defaultHome),
        '/home': (context) => HomePage(offline: offline),
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignUpPage(),
        '/welcome': (context) => FirstLoginPage(),
        '/devices': (context) => DevicePage(),
        '/history': (context) => HistoryPage(),
        '/profile': (context) => ProfilePage(),
        '/teste': (context) => FlutterBlueApp(),
        // '/teste': (context) => DBTest(),
      },
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
