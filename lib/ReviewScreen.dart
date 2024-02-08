import 'package:flutter/material.dart';

import 'DataBaseManagment.dart';
import 'main.dart';

class ReviewScreen extends StatefulWidget {
  final Map<String, String> studentInfo;

  const ReviewScreen({Key? key, required this.studentInfo}) : super(key: key);

  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  late TextEditingController _punishmentDetailsController;

  @override
  void initState() {
    super.initState();
    _punishmentDetailsController = TextEditingController();
  }

  @override
  void dispose() {
    _punishmentDetailsController.dispose();
    super.dispose();
  }
  String authorizedPassword = '123';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Information', style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildInfoRow('Date:', widget.studentInfo['date']),
              _buildInfoRow('Course Code:', widget.studentInfo['courseCode']),
              _buildInfoRow('Exam Type:', widget.studentInfo['examType']),
              _buildInfoRow('Room Number:', widget.studentInfo['roomNumber']),
              _buildInfoRow('Term:', widget.studentInfo['term']),
              _buildInfoRow('Period:', widget.studentInfo['period']),
              _buildInfoRow('Seeker Name:', widget.studentInfo['seekerName']),
              _buildInfoRow('Seeker University ID:', widget.studentInfo['seekerUniversityId']),
              _buildInfoRow('Seeker Phone Number:', widget.studentInfo['seekerPhoneNumber']),
              _buildInfoRow('Ohda Type:', widget.studentInfo['OhdaType']),
              _buildInfoRow('Device Number:', widget.studentInfo['deviceNumber']),
              _buildInfoRow('Repeated:', widget.studentInfo['repeated']),
              _buildEditableInfoRow('Punishment Details (Entered by the reviewer)', _punishmentDetailsController),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _confirmDetails,
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue[800],
                ),
                child: const Text('Confirm', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(value ?? 'N/A', style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildEditableInfoRow(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          TextField(
            controller: controller,
            decoration: InputDecoration(border: OutlineInputBorder()),
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  void _confirmDetails() async{
    int ohdaTaken = await SQLHelper.getRowCountByUniversityId(widget.studentInfo['seekerUniversityId']!);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController passwordController = TextEditingController();

        return AlertDialog(
          title: Text('${ohdaTaken}, Ohda taken before'),
          content: TextField(
            controller: passwordController,
            obscureText: true, // Hide the entered text
            decoration: InputDecoration(labelText: 'Password'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Check if the entered password is correct
                if (passwordController.text == authorizedPassword) {
                  Navigator.of(context).pop(); // Close the dialog
                  // User is authorized, proceed with confirming details
                  insertIntoDB();
                } else {
                  // Incorrect password, show an error message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Incorrect password. Please try again.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void insertIntoDB() async {
    // Show loading overlay with text
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent user from dismissing the dialog
      builder: (BuildContext context) {
        return Center(
          child: Container(
            padding: EdgeInsets.all(20),
            color: Colors.black.withOpacity(0.5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text(
                  'Inserting Row...',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        );
      },
    );

    Map<String, String> studentInfo = {
      'date': widget.studentInfo['date']!,
      'courseCode': widget.studentInfo['courseCode']!,
      'examType': widget.studentInfo['examType']!,
      'roomNumber': widget.studentInfo['roomNumber']!,
      'term': widget.studentInfo['term']!,
      'period': widget.studentInfo['period']!,
      'seekerName': widget.studentInfo['seekerName']!,
      'seekerUniversityId': widget.studentInfo['seekerUniversityId']!,
      'seekerPhoneNumber': widget.studentInfo['seekerPhoneNumber']!,
      'OhdaType': widget.studentInfo['OhdaType']!,
      'deviceNumber': widget.studentInfo['deviceNumber']!,
      'repeated': widget.studentInfo['repeated']!,
      'punishmentDetails': _punishmentDetailsController.text,
      'OhdaID': DateTime.now().millisecondsSinceEpoch.toString(),
    };

    try {

      int id = await SQLHelper.createItem(studentInfo);
      int howManyOhdaAlready = await SQLHelper.getRowCountByUniversityId(widget.studentInfo['seekerUniversityId']!);
      print(howManyOhdaAlready);

      await Future.delayed(Duration(seconds: 1));


      Navigator.pop(context);


      if (id == 0) {
        final snackBar = SnackBar(
          content: Text("This student has an Ohda already"),
          backgroundColor: Colors.blue[800],
        );
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(snackBar);

      } else if (id != -1) {
        final snackBar = SnackBar(
          content: Text('The record is inserted'),
          backgroundColor: Colors.blue,
        );
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        print(await SQLHelper.getStudentInformation());


        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyApp()));

      } else {
        print('Failed to insert student details.');
      }
    } catch (e) {
      print('Error inserting student details: $e');
      // Handle error
      // Hide loading overlay
      Navigator.pop(context);
    }
  }





}
