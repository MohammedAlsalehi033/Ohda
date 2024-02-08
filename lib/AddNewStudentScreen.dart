import 'package:flutter/material.dart';

import 'ReviewScreen.dart';

class AddNewStudentScreen extends StatefulWidget {
  const AddNewStudentScreen({Key? key}) : super(key: key);

  @override
  _AddNewStudentScreenState createState() => _AddNewStudentScreenState();
}

class _AddNewStudentScreenState extends State<AddNewStudentScreen> {
  TextEditingController dateController = TextEditingController();
  String date = '';
  String courseCode = '';
  String examType = '';
  String roomNumber = '';
  String term = '';
  String period = '';
  String seekerName = '';
  String seekerUniversityId = '';
  String seekerPhoneNumber = '';
  String OhdaType = '';
  String deviceNumber = '';
  String repeated = '';
  String punishmentDetails = '';
  bool agreedToTerms = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(
          onPressed: _clearFields,
          icon: Icon(Icons.clear),
          tooltip: 'Clear Fields',
        ),
      ],
        title: const Text('Add New Student', style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildSectionTitle('Exam Information'),
            _buildSeparator(),
            _buildTextField('Date', dateController, (value) => date = value, onTap: _pickDate),
            _buildTextField('Course Code', null, (value) => courseCode = value),
            SizedBox(height: 16),

            _buildDropdownField('Exam Type', ['Midterm', 'Final'], examType, (value) => examType = value),
            _buildTextField('Room Number', null, (value) => roomNumber = value, numericOnly: true),
            SizedBox(height: 16),
            _buildDropdownField('Term', ['First', 'Second', 'Third', 'Summer'], term, (value) => term = value),
            _buildDropdownField('Period', ['1', '2', '3', '4'], period, (value) => period = value),
            SizedBox(height: 16),
            _buildSectionTitle('Ohda Seeker Information'),
            _buildSeparator(),
            _buildTextField('Seeker Name', null, (value) => seekerName = value),
            _buildTextField('University ID', null, (value) => seekerUniversityId = value),
            _buildTextField('Phone Number', null, (value) => seekerPhoneNumber = value, numericOnly: true),
            SizedBox(height: 16), // Adjusted spacing
            _buildSectionTitle('Ohda Information'),
            _buildSeparator(),
            SizedBox(height: 16),
            _buildDropdownField('Ohda Type', ['Laptop', 'Charger', 'Other'], OhdaType, (value) => OhdaType = value),
            _buildTextField('Device Number', null, (value) => deviceNumber = value, numericOnly: true),
            SizedBox(height: 16),
            _buildDropdownField('Repeated', ['Yes', 'No'], repeated, (value) => repeated = value),
            SizedBox(height: 16),
            SizedBox(height: 16),
            _buildSeparator(),

            Text(
              'I, the undersigned, declare that I will not forget my devices and their accessories, and that I will adhere to the exam instructions and their regulatory rules. In the event of a repeat violation, I will have exposed myself to the penalties due according to the student disciplinary regulations at the Saudi Electronic University.',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 8), // Adjusted spacing
            Row(
              children: [
                Checkbox(
                  value: agreedToTerms,
                  onChanged: (bool? value) {
                    setState(() {
                      agreedToTerms = value ?? false; // Update the state based on the checkbox value.
                    });
                  },
                ),
                Text('I agree to the statement'),
              ],
            ),
            SizedBox(height: 24),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController? controller, Function(String) onChanged,
      {VoidCallback? onTap, bool numericOnly = false}) {
    return TextField(
      controller: controller,
      keyboardType: numericOnly ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(labelText: label),
      onChanged: onChanged,
      onTap: onTap,
    );
  }

  Widget _buildDropdownField(String label, List<String> options, String selectedValue, Function(String) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        SizedBox(height: 8),
        DropdownButton(
          value: selectedValue.isNotEmpty ? selectedValue : null,
          items: options.map((String value) {
            return DropdownMenuItem(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (value) {
            onChanged(value.toString());
            setState(() {

            });
          },
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSeparator() {
    return Container(
      height: 2,
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Center(
      child: ElevatedButton(
        onPressed: _handleSubmit,
        style: ElevatedButton.styleFrom(
          primary: Colors.blue[800],
        ),
        child: const Text('Save Student Information', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  void _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != DateTime.now()) {
      dateController.text = pickedDate.toString().split(' ')[0];
      date = dateController.text;
    }
  }

  void _handleSubmit() {
    if (_validateData()) {
      // If data is valid, navigate to the ReviewScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ReviewScreen(
            studentInfo: {
              'date': date,
              'courseCode': courseCode,
              'examType': examType,
              'roomNumber': roomNumber,
              'term': term,
              'period': period,
              'seekerName': seekerName,
              'seekerUniversityId': seekerUniversityId,
              'seekerPhoneNumber': seekerPhoneNumber,
              'OhdaType': OhdaType,
              'deviceNumber': deviceNumber,
              'repeated': repeated,

            },
          ),
        ),
      );
    }
    else {
      // Display error message to the user
      final snackBar = SnackBar(
        content: Text('Please fill in all required fields.'),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  bool _validateData() {
    if (_isEmpty(date, 'Date') ||
        _isEmpty(courseCode, 'Course Code') ||
        _isEmpty(examType, 'Exam Type') ||
        _isEmpty(roomNumber, 'Room Number') ||
        _isEmpty(term, 'Term') ||
        _isEmpty(period, 'Period') ||
        _isEmpty(seekerName, 'Seeker Name') ||
        _isEmpty(seekerUniversityId, 'Seeker University ID') ||
        _isEmpty(seekerPhoneNumber, 'Seeker Phone Number') ||
        _isEmpty(OhdaType, 'Ohda Type') ||
        _isEmpty(deviceNumber, 'Device Number') ||
        _isEmpty(repeated, 'Repeated')
        ) {
      return false;
    }


    return true;
  }

  bool _isEmpty(String value, String fieldName) {
    if (value.isEmpty) {
      print('Invalid data. Please fill in the required field: $fieldName');
      return true;
    }
    return false;
  }


  void _clearFields() {
    setState(() {
      dateController.text = '';
      date = '';
      courseCode = '';
      examType = '';
      roomNumber = '';
      term = '';
      period = '';
      seekerName = '';
      seekerUniversityId = '';
      seekerPhoneNumber = '';
      OhdaType = '';
      deviceNumber = '';
      repeated = '';
      punishmentDetails = '';
      agreedToTerms = false;
      setState(() {

      });
    });
  }

}
