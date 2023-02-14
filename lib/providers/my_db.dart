import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/Employee.dart';
import 'package:path_provider/path_provider.dart';

class DBProvider {
  static Database? _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDB();
    return _database!;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'employee_manager.db');

    const String categoryTable = "categoryTable";
    const String contactId = "contactId";
    const String accountName = "accountName";
    const String contactName = "contactName";

    var temp_db = await openDatabase(path, version: 5, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE $categoryTable("
          "$contactId INTEGER PRIMARY KEY, "
          "$contactName TEXT, "
          "$accountName TEXT )");
    });
    // print("DB )
    var result = await temp_db.rawQuery("SELECT * FROM $categoryTable");
    return temp_db;
  }

  // insert employee
  createEmployee(Map<String, dynamic> newEmployee) async {
    conflictAlgorithm:
    ConflictAlgorithm.replace;

    final db = await database;
    final int? contactId = newEmployee['ContactID'];
    final String? contactName = newEmployee['ContactName'];
    final String? accountName = newEmployee['AccountName'];

    try {
      final res = await db.rawInsert(
          "INSERT INTO categoryTable (contactId, contactName, accountName) VALUES ($contactId, '$contactName', '$accountName')");
      return res;
    } catch (e) {
      // check if the value is already in the database
      final res = await db
          .rawQuery("SELECT * FROM categoryTable WHERE contactId = $contactId");
      if (res.isNotEmpty) {
        print("Already in database =  $res");
      } else {
        print("Failed to insert $contactId  | $contactName | $accountName");
        // print(e);
        // print("\n");
      }
      // print("Failed to insert $contactId  | $contactName | $accountName");
      // print(e);
      // print("\n");
    }
  }

  // get all employees

  Future<List<Employee>> getAllEmployees() async {
    final db = await database;
    final res = await db.query('categoryTable');
    // print("Replay from db =>$res");

    List<Employee> list =
        res.isNotEmpty ? res.map((c) => Employee.fromJson(c)).toList() : [];

    // print("Made Employee List => ");
    // list.forEach((element) {
    //   print(element.accountName);
    //   print("\n\n\n");
    // });
    return list;
  }

  // get employee by id

  Future<Employee> getEmployeeById(int id) async {
    final db = await database;
    final res =
        await db.query('categoryTable', where: 'id = ?', whereArgs: [id]);

    return res.isNotEmpty ? Employee.fromJson(res.first) : Employee();
  }

  Future<int> updateEmployee(Employee newEmployee) async {
    final db = await database;
    final res = await db.update('categoryTable', newEmployee.toJson(),
        where: 'id = ?', whereArgs: [newEmployee.contactID]);

    return res;
  }

  // delete employee

  Future<int> deleteEmployee(int id) async {
    final db = await database;
    final res =
        await db.delete('categoryTable', where: 'id = ?', whereArgs: [id]);

    return res;
  }

  // delete all employees

  Future<int> deleteAllEmployees() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM categoryTable');

    return res;
  }
}
