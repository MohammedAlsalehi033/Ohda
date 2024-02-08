import 'package:flutter/material.dart';
import 'CheckTheRow.dart';
import 'DataBaseManagment.dart'; // Make sure to import your database management file

class ShowDataScreen extends StatefulWidget {
  @override
  _ShowDataScreenState createState() => _ShowDataScreenState();
}

class _ShowDataScreenState extends State<ShowDataScreen> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Show Data'),
        actions: [
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              _searchController.clear();
              // Reset the search when the clear button is pressed
              setState(() {});
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search by Seeker University ID',
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: SQLHelper.getStudentInformation(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
                  return Center(child: Text('No data available.'));
                } else {
                  List<Map<String, dynamic>> data = snapshot.data as List<Map<String, dynamic>>;
                  List<Map<String, dynamic>> filteredData = data
                      .where((entry) =>
                      entry['seekerUniversityId'].toString().toLowerCase().contains(_searchController.text.toLowerCase()))
                      .toList();

                  return Expanded(
                    child: ListView.builder(
                      itemCount: filteredData.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => ManageRecord(studentInfo: filteredData[index])));
                          },
                          child: Card(
                            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            elevation: 2,
                            color: filteredData[index]['OhdaStat'] == 'returned' ? Colors.blue[800] : Colors.black26,
                            child: ListTile(
                              title: Text(
                                'Seeker Name: ${filteredData[index]['seekerName']}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: filteredData[index]['OhdaStat'] == 'returned' ? Colors.white : Colors.white),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 4),
                                  Text('University ID: ${filteredData[index]['seekerUniversityId']}'),
                                  Text('OhdaType: ${filteredData[index]['OhdaType']}'),
                                  Text('Date: ${filteredData[index]['date']}'),
                                  Text('Course Code: ${filteredData[index]['courseCode']}'),
                                  Text("${index + 1} out of ${filteredData.length}"),
                                  // Add more details as needed
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
