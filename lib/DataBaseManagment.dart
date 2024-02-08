import 'package:sqflite/sqflite.dart';

class SQLHelper {
  static Future<void> createTable(Database database) async {
    try {
      await database.execute('''
  CREATE TABLE IF NOT EXISTS student_information (
    OhdaID TEXT PRIMARY KEY,
    seekerUniversityId TEXT,
    date TEXT,
    courseCode TEXT,
    examType TEXT,
    roomNumber TEXT,
    term TEXT,
    period TEXT,
    seekerName TEXT,
    seekerPhoneNumber TEXT,
    OhdaType TEXT,
    deviceNumber TEXT,
    repeated TEXT,
    punishmentDetails TEXT,
    returnDate TEXT,
    OhdaStat TEXT
  )
''');
    } catch (e) {
      print('Error creating table: $e');
    }
  }

  static Future<Database> db() async {
    return openDatabase('dbStudentInfo', version: 1, onCreate: (Database db, int version) async {
      await createTable(db);
    });
  }

  static Future<int> createItem(Map<String, String> studentInfo) async {
    final db = await SQLHelper.db();
    try {
      final id = await db.insert('student_information', studentInfo, conflictAlgorithm: ConflictAlgorithm.ignore);
      return id;
    } catch (e) {
      print('Error creating item: $e');
      return -1;
    }
  }

  static Future<List<Map<String, dynamic>>> getStudentInformation() async {
    final db = await SQLHelper.db();
    return db.query("student_information", orderBy: "seekerName");
  }

  static Future<void> dropTable() async {
    try {
      final db = await SQLHelper.db();
      await db.execute('DROP TABLE IF EXISTS student_information');
    } catch (e) {
      print('Error dropping table: $e');
    }
  }

  static Future<int> deleteItem(String OhdaID) async {
    try {
      final db = await SQLHelper.db();
      return await db.delete('student_information', where: 'OhdaID = ?', whereArgs: [OhdaID]);
    } catch (e) {
      print('Error deleting item: $e');
      return -1;
    }
  }

  static Future<int> getRowCountByUniversityId(String seekerUniversityId) async {
    final db = await SQLHelper.db();
    try {
      final count = Sqflite.firstIntValue(await db.rawQuery('''
      SELECT COUNT(*) FROM student_information WHERE seekerUniversityId = ?
    ''', [seekerUniversityId]));

      return count ?? 0;
    } catch (e) {
      print('Error getting row count: $e');
      return 0;
    }
  }

  static Future<int> updateOhdaState(String OhdaID, String OhdaStat) async {
    try {
      final db = await SQLHelper.db();
      final result = await db.update(
        'student_information',
        {
          'OhdaStat': OhdaStat,
          'returnDate': DateTime.now().toLocal().toString().substring(0,19),
        },
        where: 'OhdaID = ?',
        whereArgs: [OhdaID],
      );
      return result;
    } catch (e) {
      print('Error updating OhdaState: $e');
      return -1;
    }
  }
}
