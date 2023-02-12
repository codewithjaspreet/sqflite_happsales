import 'package:dio/dio.dart';
import 'package:happysales_sqlite/models/Employee.dart';

import 'my_db.dart';

class ApiProvider{

  Future<List<Null>> getAllEmployees() async {
    var url  = "http://13.68.210.77:8080/api/v1/ManagerRequest/GetContactPaged";
    Response response = await Dio().get(url);
    return (response.data as List).map((employee) {
      print('Inserting $employee');
      DBProvider.db.createEmployee(Employee.fromJson(employee));
    }).toList();



  }
}