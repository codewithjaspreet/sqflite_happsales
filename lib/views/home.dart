import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:happysales_sqlite/providers/api_provider.dart';

import '../providers/my_db.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var isLoading = false;
  APIController apiController = Get.put(APIController());

@override
  void initState() {
    // TODO: implement initState
    apiController.getAllEmployees();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Api to sqlite'),
        centerTitle: true,
        actions: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: Icon(Icons.settings_input_antenna),
              onPressed: () async {
                await _loadFromApi();
              },
            ),
          ),
          Container(
            padding: EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                await _deleteData();
              },
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _buildEmployeeListView(),
    );
  }

  _loadFromApi() async {
    setState(() {
      isLoading = true;
    });

    await apiController.getAllEmployees();

  apiController.employeeList.refresh();
    // wait for 1 second to simulate loading of data

     await Future.delayed(Duration(seconds: 1));

    setState(() {
      isLoading = false;
    });
  }

  _deleteData() async {
    setState(() {
      isLoading = true;
    });

    await DBProvider.db.deleteAllEmployees();

    apiController.employeeList.clear();
    apiController.employeeList.refresh();
    apiController.downloaded.value = false;
    apiController.downloaded.refresh();
    // wait for 1 second to simulate loading of data

    setState(() {
      isLoading = false;
    });

    print('All employees deleted');
  }

  _buildEmployeeListView() {
    return GetX<APIController>(builder: (controller) {
      return ListView.builder(
          itemCount: controller.employeeList.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                title: Text(apiController.employeeList[index].accountName ??
                    "Failed to load"),
                subtitle: Text(
                    apiController.employeeList[index].contactID.toString() ??
                        " Failed to load"),
              ),
            );
          });
    });
  }
}
