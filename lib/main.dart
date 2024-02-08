import 'package:flutter/material.dart';
import 'AddNewStudentScreen.dart';
import 'ReportsScreens.dart';
import 'ShowDataScreen.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ohda App',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.blue[800],
        scaffoldBackgroundColor: Colors.grey[900],
        appBarTheme: const AppBarTheme(
          centerTitle: true,
        ),
      ),
      home: const OhdaScreen(),
    );
  }
}

class OhdaScreen extends StatelessWidget {
  const OhdaScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ohda', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue[800],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => AddNewStudentScreen()));

              },
              style: ElevatedButton.styleFrom(
                primary: Colors.blue[800],
              ),
              child: const Text(
                'Add New Student',
                style: TextStyle(color: Colors.white),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ShowDataScreen()));
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.blue[800],
              ),
              child: const Text(
                'List of Students who took devices',
                style: TextStyle(color: Colors.white),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ReportScreen()));
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.blue[800],
              ),
              child: const Text(
                'Reports',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
