import 'package:ble_project1/utils/routes.dart';
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
  StreamSubscription<ConnectionStateUpdate> streaming;
  DataPage({required this.name, required this.id, required this.streaming});

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

  void streamingCancel() async {
    await widget.streaming.cancel();
    Navigator.pushNamed(context, MyRoutes.HomePage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('${widget.name}'),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(4),
                color: Color.fromARGB(187, 238, 238, 238),
              ),
              child: TextButton(
                style: TextButton.styleFrom(
                    textStyle: const TextStyle(
                  fontSize: 15,
                )),
                onPressed: streamingCancel,
                child: Text(
                  "Disconnect",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ),
        ],
      ),

      body: Padding(
        padding: EdgeInsets.all(7.5),
        child: ListView(
          children: [
            Card(
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFDFE4EA),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                height: 100,
                child: Center(
                  child: ListTile(
                    leading: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      
                      width: 50,
                      height: 50,
                      child: const Icon(
                        Icons.search,
                        size: 40,
                        color: Colors.blue,
                      ),
                    ),
                    // leading: CircleAvatar(
                    //   child: Icon(
                    //     Icons.search,
                    //     color: Colors.white,
                    //   ),
                    //   backgroundColor: Color(0xFF47b881),
                    // ),
                    title: Text(
                      "UART",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              elevation: 10,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            Card(
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFDFE4EA),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                height: 100,
                child: Center(
                  child: ListTile(
                    leading: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      width: 50,
                      height: 50,
                      child: const Icon(
                        Icons.search,
                        size: 40,
                        color: Colors.blue,
                      ),
                    ),
                    // leading: CircleAvatar(
                    //   child: Icon(
                    //     Icons.search,
                    //     color: Colors.white,
                    //   ),
                    //   backgroundColor: Color(0xFF47b881),
                    // ),
                    title: Text(
                      "STATUS",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              elevation: 10,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            Card(
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFDFE4EA),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                height: 100,
                child: Center(
                  child: ListTile(
                    leading: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      width: 50,
                      height: 50,
                      child: const Icon(
                        Icons.search,
                        size: 40,
                        color: Colors.blue,
                      ),
                    ),
                    // leading: CircleAvatar(
                    //   child: Icon(
                    //     Icons.search,
                    //     color: Colors.white,
                    //   ),
                    //   backgroundColor: Color(0xFF47b881),
                    // ),
                    title: Text(
                      "FLASH",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              elevation: 10,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            Card(
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFDFE4EA),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                height: 100,
                child: Center(
                  child: ListTile(
                    leading: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      width: 50,
                      height: 50,
                      child: const Icon(
                        Icons.search,
                        size: 40,
                        color: Colors.blue,
                      ),
                    ),
                    // leading: CircleAvatar(
                    //   child: Icon(
                    //     Icons.search,
                    //     color: Colors.white,
                    //   ),
                    //   backgroundColor: Color(0xFF47b881),
                    // ),
                    title: Text(
                      "FULL SCAN",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              elevation: 10,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          ],
        ),
      ),
      // body: Padding(
      //   padding: const EdgeInsets.all(8.0),
      //   child: Column(
      //     children: [
      //       SizedBox(
      //         height: 3,
      //       ),
      //       Text(
      //         widget.id,
      //         style: const TextStyle(fontWeight: FontWeight.bold),
      //       ),
      //       SizedBox(
      //         height: 20,
      //       ),
      //       Center(
      //         child: Card(
      //           elevation: 5,
      //           child: Container(
      //               width: MediaQuery.of(context).size.width,
      //               height: 510,
      //               color: Colors.white,
      //               child: SingleChildScrollView(
      //                 child: Text(
      //                     res.toString().length <= 10 ? "" : res.toString(),
      //                     style: const TextStyle(color: Colors.black)),
      //               )),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
      // Center(
      //   child: Text('Your device id is ${widget.id} and ${resp}'
      //   ),

      // ),
      // bottomNavigationBar: BottomAppBar(
      //   shape: const CircularNotchedRectangle(),
      //   child: Container(height: 50.0),
      // ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     retrieveData(widget.id);
      //   },
      //   tooltip: 'Increment Counter',
      //   child: const Icon(Icons.search),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
