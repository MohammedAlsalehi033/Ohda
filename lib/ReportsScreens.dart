import 'package:flutter/material.dart';
import 'DataBaseManagment.dart'; // Import your database management file

class ReportScreen extends StatefulWidget {
  const ReportScreen({Key? key}) : super(key: key);

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  List<Map<String, dynamic>> ohdaData = [];

  @override
  void initState() {
    super.initState();
    // Call a function to retrieve data from the database
    fetchData();
  }

  // Function to fetch data from the database
  void fetchData() async {
    List<Map<String, dynamic>> data = await SQLHelper.getStudentInformation();
    setState(() {
      ohdaData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ohda Report', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          children: <Widget>[
            _buildStatCard('Student with Most Ohdas', _calculateMostOhdasStudent(), Colors.blue),
            _buildStatCard('Most Used Device', _calculateMostUsedDevice(), Colors.green),
            _buildStatCard('Total Ohdas Taken', _calculateTotalOhdasTaken(), Colors.orange),
            _buildStatCard('Total Ohdas Returned', _calculateTotalOhdasReturned(), Colors.purple),
            _buildStatCard('Average Ohdas Per Student', _calculateAverageOhdasPerStudent(), Colors.red),
            _buildStatCard('Most Common Course Code', _calculateMostCommonCourseCode(), Colors.teal),
            _buildStatCard('Ohdas by Device Type', _calculateOhdasByDeviceType(), Colors.indigo),
            _buildStatCard('Ohdas by Course Code', _calculateOhdasByCourseCode(), Colors.deepOrange),
          ],
        ),
      ),
    );
  }

  // Inside your _ReportScreenState class
  Widget _buildStatCard(String title, String value, Color color) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(fontSize: 20, color: color),
            ),
          ],
        ),
      ),
    );
  }

  String _calculateMostOhdasStudent() {
    Map<String, int> ohdaCount = {};

    for (var ohda in ohdaData) {
      String universityId = ohda['seekerUniversityId'];
      ohdaCount[universityId] = (ohdaCount[universityId] ?? 0) + 1;
    }

    if (ohdaCount.entries.isNotEmpty) {
      MapEntry<String, int> mostOhdasStudentEntry =
      ohdaCount.entries.reduce((a, b) => a.value > b.value ? a : b);
      String universityId = mostOhdasStudentEntry.key;
      String studentName = ohdaData.firstWhere((ohda) => ohda['seekerUniversityId'] == universityId)['seekerName'];
      return '$studentName ($universityId)';
    } else {
      return 'No data';
    }
  }

  String _calculateMostUsedDevice() {
    Map<String, int> deviceCount = {};

    for (var ohda in ohdaData) {
      String deviceType = ohda['OhdaType'];
      deviceCount[deviceType] = (deviceCount[deviceType] ?? 0) + 1;
    }

    return deviceCount.entries.isNotEmpty
        ? deviceCount.entries.reduce((a, b) => a.value > b.value ? a : b).key
        : 'No data';
  }

  String _calculateTotalOhdasTaken() {
    return ohdaData.length.toString();
  }

  String _calculateTotalOhdasReturned() {
    int returnedCount = ohdaData.where((ohda) => ohda['OhdaStat'] == 'returned').length;
    return returnedCount.toString();
  }

  String _calculateAverageOhdasPerStudent() {
    if (ohdaData.isNotEmpty) {
      double average = ohdaData.length / ohdaData.map<String>((ohda) => ohda['seekerUniversityId']).toSet().length;
      return average.toStringAsFixed(2);
    } else {
      return 'No data';
    }
  }

  String _calculateMostCommonCourseCode() {
    Map<String, int> courseCodeCount = {};

    for (var ohda in ohdaData) {
      String courseCode = ohda['courseCode'];
      courseCodeCount[courseCode] = (courseCodeCount[courseCode] ?? 0) + 1;
    }

    return courseCodeCount.entries.isNotEmpty
        ? courseCodeCount.entries.reduce((a, b) => a.value > b.value ? a : b).key
        : 'No data';
  }


  // Inside your _ReportScreenState class
  String _calculateOhdasByDeviceType() {
    Map<String, int> ohdasByDeviceType = {};

    for (var ohda in ohdaData) {
      String deviceType = ohda['OhdaType'];
      ohdasByDeviceType[deviceType] = (ohdasByDeviceType[deviceType] ?? 0) + 1;
    }

    if (ohdasByDeviceType.entries.isNotEmpty) {
      // Convert the map entries to a string representation
      return ohdasByDeviceType.entries.map((entry) => '${entry.key}: ${entry.value}').join(', ');
    } else {
      return 'No data';
    }
  }

  String _calculateOhdasByCourseCode() {
    Map<String, int> ohdasByCourseCode = {};

    for (var ohda in ohdaData) {
      String courseCode = ohda['courseCode'];
      ohdasByCourseCode[courseCode] = (ohdasByCourseCode[courseCode] ?? 0) + 1;
    }

    if (ohdasByCourseCode.entries.isNotEmpty) {
      // Convert the map entries to a string representation
      return ohdasByCourseCode.entries.map((entry) => '${entry.key}: ${entry.value}').join(', ');
    } else {
      return 'No data';
    }
  }


}
