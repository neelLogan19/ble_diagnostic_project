import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'dart:convert';
import 'dart:async'; // support for async programming with classes such as future and stream
import 'dart:io'
    show
        Platform; // porvides information such as os,hostname,enviroment variables
import 'package:location_permissions/location_permissions.dart';

class DataPage extends StatefulWidget {
  String name;
  var id;
  DataPage({required this.name, required this.id});

  @override
  State<DataPage> createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  var decoded;
  var resp;
  List<String> res = [];
  final Uuid serviceUuid = Uuid.parse("edd79b0f-4ae0-484a-8ba9-4a611f1cb47b");

  final Uuid characteristicUuid =
      Uuid.parse("d775dbdb-3b38-47be-9734-9ff022ba37ea");

  final flutterReactiveBle = FlutterReactiveBle();
  //instance of bluetooth created
  void retrieveData(dev) async {
    final characteristic = QualifiedCharacteristic(
        serviceId: serviceUuid,
        characteristicId: characteristicUuid,
        deviceId: dev);
    final response =
        await flutterReactiveBle.readCharacteristic(characteristic);
    decoded = utf8.decode(response);
    // print(response);
    print(decoded.toString());
    String ans = decoded.toString();
    print(ans);
    res.add(ans);
    print(res);
    setState(() {
      resp = decoded.toString();
      // res.add(ans);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('${widget.name}'),
        actions: <Widget>[
          FlatButton(
            textColor: Colors.white,
            onPressed: () {},
            child: Text("Disconnect"),
            shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: 3,
            ),
            Text(
              widget.id,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: Card(
                elevation: 5,
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 510,
                    color: Colors.white,
                    child: SingleChildScrollView(
                      child: Text(
                          res.toString().length <= 10 ? "" : res.toString(),
                          style: const TextStyle(color: Colors.black)),
                    )),
              ),
            ),
          ],
        ),
      ),
      // Center(
      //   child: Text('Your device id is ${widget.id} and ${resp}'
      //   ),

      // ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Container(height: 50.0),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          retrieveData(widget.id);
        },
        tooltip: 'Increment Counter',
        child: const Icon(Icons.search),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
