import 'package:sqflite/sqflite.dart';

import '../models/Employee.dart';

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
    return await openDatabase(
      'my_db.db',
      version: 1,
      onOpen: (db) {},
      onCreate: (Database db, int version) async {
        await db.execute('CREATE TABLE Contact ('
            'ContactID INTEGER PRIMARY KEY,'
            'ContactName TEXT,'
            'AccountName TEXT,'
            ')'
        );
      }
    );
  }

  // insert employee

 createEmployee(Employee newEmployee) async {
    final db = await database;
    final res = await db.rawInsert(
      "INSERT Into Employee (id, name, age)"
      " VALUES (${newEmployee.contactID}, ${newEmployee.contactName}, ${newEmployee.accountName})"
    );
    return res;
  }

  // get all employees

  Future<List<Employee>> getAllEmployees() async {
    final db = await database;
    final res = await db.query('Employee');

    List<Employee> list = res.isNotEmpty ? res.map((c) => Employee.fromJson(c)).toList() : [];
    return list;
  }

  // get employee by id

  Future<Employee> getEmployeeById(int id) async {
    final db = await database;
    final res = await db.query('Employee', where: 'id = ?', whereArgs: [id]);

    return res.isNotEmpty ? Employee.fromJson(res.first) : Employee();
  }


  Future<int> updateEmployee(Employee newEmployee) async {
    final db = await database;
    final res = await db.update('Employee', newEmployee.toJson(), where: 'id = ?', whereArgs: [newEmployee.contactID]);

    return res;
  }

  // delete employee

  Future<int> deleteEmployee(int id) async {
    final db = await database;
    final res = await db.delete('Employee', where: 'id = ?', whereArgs: [id]);

    return res;
  }

  // delete all employees

  Future<int> deleteAllEmployees() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM Employee');

    return res;
  }

}