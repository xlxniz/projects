import 'package:flutter/material.dart';
import 'screens/login.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      //title: 'Flutter Demo',
      theme: new ThemeData(
        brightness: Brightness.dark,
        primaryColor: AppColors.grey,
        accentColor: AppColors.grey,
        scaffoldBackgroundColor: AppColors.grey,
      ),
      home: Scaffold(
        body: SafeArea(
          child: LoginForm(),
        ),
      ),
    );
  }
}


class AppColors {
  static const grey = const Color(0xFF455A64);
  static const white = const Color(0xFFFFFFFF);
  static const red = const Color(0xFFD50000);
}