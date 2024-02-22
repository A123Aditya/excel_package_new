import 'package:master_lists/excel_package/Excel Code/UI/Excel/MenuRead.dart';
import 'package:flutter/material.dart';
import 'package:master_lists/excel_package/Excel%20Code/FirebaseClass.dart';
import 'package:master_lists/mastersScreen/services/services.dart';

class MyHomePage extends StatefulWidget {
  String API_ENDPOINT_URL;
  MyHomePage({required this.API_ENDPOINT_URL});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseLogic().API_ENDPOINT_URL = API_ENDPOINT_URL;
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MenuRead(),
            ));
      },
      child: Icon(Icons.upload),
    );
  }
}
