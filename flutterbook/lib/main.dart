///David Davis
///Adilene Alaniz

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'tasks/Tasks.dart';
import 'alarms/Alarms.dart';
import 'appointments/Appointments.dart';
import 'notes/Notes.dart';

void main() {
  startMeUp() async {
    WidgetsFlutterBinding.ensureInitialized();
    //Avatar.docsDir = await getApplicationDocumentsDirectory();
    runApp(FlutterBook());
  }
  startMeUp();
}

class FlutterBook extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Book',
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
        ),
        home: DefaultTabController(
          ///5 Tabs, some names get faded out due to size
            length: 5,
            child: Scaffold(
                appBar: AppBar(
                    title: Text('Flutterbook - David Davis and Adi Alaniz'),
                    bottom: TabBar(
                        tabs: [
                          Tab(icon: Icon(Icons.date_range), text: 'Appointments'),
                          Tab(icon: Icon(Icons.contacts), text: 'Contacts'),
                          Tab(icon: Icon(Icons.note), text: 'Notes'),
                          Tab(icon: Icon(Icons.assignment_turned_in), text: 'Tasks'),
                          Tab(icon: Icon(Icons.alarm), text: 'Alarm'),
                        ]
                    )
                ),
                body: TabBarView(
                    children: [
                      Appointments(),
                      Text('Contacts'),
                      Notes(),
                      Tasks(),
                      Alarms(),
                    ]
                )
            )
        )
    );
  }
}

class Dummy extends StatelessWidget {
  final String _title;

  Dummy(this._title);
  @override
  Widget build(BuildContext context) {
    return Center(child: Text(_title));
  }
}

class AppColors {
  static const grey = const Color(0xFF616161);
  static const white = const Color(0xFFFFFFFF);
  static const red = const Color(0xFFD50000);
}

