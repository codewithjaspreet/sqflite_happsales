import 'package:dio/dio.dart';
import 'package:happysales_sqlite/models/Employee.dart';

import 'my_db.dart';

import 'package:get/get.dart';

class APIController extends GetxController {
  var employeeList = RxList<Employee>();
  RxBool downloaded = false.obs;

  Future<void> getAllEmployeesFromServer() async {
    var url = "http://13.68.210.77:8080/api/v1/ManagerRequest/GetContactPaged";
    var response = await Dio().post(url,
        data: {"UserData": 1611, "SearchText": ""},
        options: Options(
          headers: {
            'Authorization':
                "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1laWRlbnRpZmllciI6InNhaSIsImh0dHA6Ly9zY2hlbWFzLnhtbHNvYXAub3JnL3dzLzIwMDUvMDUvaWRlbnRpdHkvY2xhaW1zL3VwbiI6IkhBUFBTQUxFU0RFViIsImh0dHA6Ly9zY2hlbWFzLm1pY3Jvc29mdC5jb20vd3MvMjAwOC8wNi9pZGVudGl0eS9jbGFpbXMvcHJpbWFyeXNpZCI6IjE2MTEiLCJodHRwOi8vc2NoZW1hcy5taWNyb3NvZnQuY29tL3dzLzIwMDgvMDYvaWRlbnRpdHkvY2xhaW1zL3ByaW1hcnlncm91cHNpZCI6IjEiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9zaWQiOiI2MmM4OTIxYi1lOWQyLTU0OTMtYjhjZC0xNjhlMWVjZTczZGUiLCJodHRwOi8vc2NoZW1hcy5taWNyb3NvZnQuY29tL3dzLzIwMDgvMDYvaWRlbnRpdHkvY2xhaW1zL2dyb3Vwc2lkIjoiMTU3YTJjY2EtMTk1NC00ZTg5LTlkMzUtYTAzYmJkNzEzNjNkIiwianRpIjoiYTBiNDZkNWMtMDFlMy00OGU4LTlmZTQtNDI4OTEyZWMzZTQ1IiwiZXhwIjoxNzA3MTAzNjkxLCJpc3MiOiJoYXBwc2FsZXMuY29tIiwiYXVkIjoiaGFwcHNhbGVzLmNvbSJ9.d4L4bEIz1lvpFW_4BmwL5Rwh78bKV6OfDXyoD-6QPOo",
          },
        ));

    // sort response data

    (response.data as List).forEach((employee) {
      // print('Inserting $employee');
      DBProvider.db.createEmployee(employee);
    });

    downloaded.value = true;
    downloaded.refresh();
    employeeList.value = await DBProvider.db.getAllEmployees();
    employeeList.refresh();
    //  return await DBProvider.db.getAllEmployees();
  }

  Future<void> getAllEmployees() async {
    if (!downloaded.value) {
      getAllEmployeesFromServer();
    } else {
      employeeList.value = await DBProvider.db.getAllEmployees();
      employeeList.refresh();
    }
  }
}
