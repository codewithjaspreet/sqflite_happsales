import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/Employee.dart';
import 'package:path_provider/path_provider.dart';

class DBProvider{

  static Database? _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {
    if(_database != null) return _database!;

    _database = await initDB();
    return _database!;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'employee_manager.db');

    final String categoryTable = "categoryTable";
    final String contactId = "contactId";
    final String accountName = "accountName";
    final String contactName = "contactName";

    return await openDatabase(path, version: 5, onOpen: (db) {},
        onCreate: (Database db, int version) async {
          await db.execute(
              "CREATE TABLE $categoryTable("
                  "$contactId INTEGER PRIMARY KEY, "
                  "$contactName TEXT, "
                  "$accountName TEXT)"
          );
        });
  }

  // insert employee
  createEmployee(Employee newEmployee) async {
    conflictAlgorithm: ConflictAlgorithm.replace;

    final db = await database;
    final int? contactId = newEmployee.contactID;
    final String? contactName = newEmployee.contactName;
    final String? accountName = newEmployee.accountName;

    final res = await db.rawInsert(


        "INSERT INTO categoryTable (contactId, contactName, accountName) VALUES ($contactId, '$contactName', '$accountName')"

    );
    return res;
  }


  // get all employees

  Future<List<Employee>> getAllEmployees() async {
    final db = await database;
    final res = await db.query('categoryTable');

    List<Employee> list = res.isNotEmpty ? res.map((c) => Employee.fromJson(c)).toList() : [];
    return list;
  }

  // get employee by id

  Future<Employee> getEmployeeById(int id) async {
    final db = await database;
    final res = await db.query('categoryTable', where: 'id = ?', whereArgs: [id]);

    return res.isNotEmpty ? Employee.fromJson(res.first) : Employee();
  }


  Future<int> updateEmployee(Employee newEmployee) async {
    final db = await database;
    final res = await db.update('categoryTable', newEmployee.toJson(), where: 'id = ?', whereArgs: [newEmployee.contactID]);

    return res;
  }

  // delete employee

  Future<int> deleteEmployee(int id) async {
    final db = await database;
    final res = await db.delete('categoryTable', where: 'id = ?', whereArgs: [id]);

    return res;
  }

  // delete all employees

  Future<int> deleteAllEmployees() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM categoryTable');

    return res;
  }

}