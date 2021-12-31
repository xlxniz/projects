import 'package:night_board/screens/welcome.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'game_model/service.dart';
import 'game_model/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) {
        return GameBoardProvider(service: GameService());
      },
      child: MaterialApp(
        title: 'Night Board!',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          backgroundColor: Colors.blue,
          primaryColor: AppColors.blue,
          primarySwatch: Colors.blue,
        ),
        home: Welcome(),
      ),
    );
  }
}

class AppColors {
  static const blue = const Color(0xFF2C5A63);
  static const orange = const Color(0xFFFFB74D);
  static const darkBlue = const Color(0xFF071C7D);
  static const white = const Color(0xFFFFFFFF);
  static const red = const Color(0xFFD50000);
}