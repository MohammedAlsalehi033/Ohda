import 'package:flutter/material.dart';

import 'DataBaseManagment.dart';
import 'main.dart';

class ManageRecord extends StatefulWidget {
  final Map<String, dynamic> studentInfo;

  const ManageRecord({Key? key, required this.studentInfo}) : super(key: key);

  @override
  _ManageRecordState createState() => _ManageRecordState();
}

class _ManageRecordState extends State<ManageRecord> {
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
            child: 

            Container(
              height: MediaQuery.of(context).size.height,
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _buildInfoRow('OhadID:', widget.studentInfo['OhdaID']),
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
                        _buildInfoRow('returnDate:', widget.studentInfo['returnDate']),
                        _buildInfoRow('Ohda Stat:', widget.studentInfo['OhdaStat']),
                        SizedBox(height: 16),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: _deleteRecord,
                              style: ElevatedButton.styleFrom(
                                primary: Colors.red[800],
                              ),
                              child: const Text('Delete the Record', style: TextStyle(color: Colors.white)),
                            ),
                            ElevatedButton(
                              onPressed: _ohdaReturned,
                              style: ElevatedButton.styleFrom(
                                primary: Colors.blue[800],
                              ),
                              child: const Text('Ohda Returned', style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                ],
              ),

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


  void _deleteRecord() async{
    _confirmDetails(() async{
     int deleted = await SQLHelper.deleteItem(widget.studentInfo['OhdaID']);
      if (deleted != -1){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('The record is deleted'),
            backgroundColor: Colors.red,
          ),

        );
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MyApp()));
      }

    });
  }

  void _ohdaReturned() {
    _confirmDetails(() async{
     int updated = await SQLHelper.updateOhdaState(widget.studentInfo['OhdaID'], "returned");
     if (updated != -1){
       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
           content: Text('The Ohda is returned'),
           backgroundColor: Colors.blue[800],
         ),

       );
       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyApp()));

     }
    });
  }

  void _confirmDetails(Function? onConfirm) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController passwordController = TextEditingController();

        return AlertDialog(
          title: Text('Enter Password'),
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
                if (passwordController.text == authorizedPassword) {
                  Navigator.of(context).pop();
                  if (onConfirm != null) {
                    onConfirm();
                  }
                } else {
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

}
