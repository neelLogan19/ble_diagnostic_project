import 'package:ble_project1/pages/data_page.dart';
import 'package:ble_project1/pages/home_page.dart';
import 'package:ble_project1/utils/routes.dart';
import 'package:flutter/material.dart';

void main() {
  return runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      routes:{
        MyRoutes.dataPage:(context) => DataPage()
      }
    );
  }
}
