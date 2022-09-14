import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'dart:async'; // support for async programming with classes such as future and stream
import 'dart:io'
    show
        Platform; // porvides information such as os,hostname,enviroment variables
import 'package:location_permissions/location_permissions.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final flutterReactiveBle =
      FlutterReactiveBle(); //instance of bluetooth created

  //scanning variable is set to true when scanning starts
  bool _scanStarted = false;
  //if we are connected to any device make it true
  bool _connected = false;
  //stream for scanning bluetooth devices
  late StreamSubscription<DiscoveredDevice> _scanStream;
  //storing bluetooth devices
  List<DiscoveredDevice> devicesList = [];
  //this hashset is used to filter out dupliate devices
  final hs = HashSet<String>();

  var decoded;

  late QualifiedCharacteristic _rxCharacteristic;

  // if there is no device available after scanning we print this message
  String _deviceMsg = "";
  //--> when are scanning is completed and we have all the devie in the list this variable is set to true
  bool _foundDeviceWaitingToConnect = false;

  //serviceUid and characteristic uuid
  final Uuid serviceUuid = Uuid.parse("edd79b0f-4ae0-484a-8ba9-4a611f1cb47b");
  final Uuid characteristicUuid =
      Uuid.parse("d775dbdb-3b38-47be-9734-9ff022ba37ea");

  //this function is called on button click so that scanning for bluetooth device starts.
  void _startScan() async {
// Platform permissions handling for android and ios--> location permission
    bool permGranted = false;
    setState(() {
      _scanStarted = true;
    });
    PermissionStatus permission;
    if (Platform.isAndroid) {
      permission = await LocationPermissions().requestPermissions();
      if (permission == PermissionStatus.granted) permGranted = true;
    } else if (Platform.isIOS) {
      permGranted = true;
    }
// Main scanning logic happens here -->here we add all devices into a list so that we can display it late
    if (permGranted) {
      _scanStream = flutterReactiveBle
          .scanForDevices(withServices: [serviceUuid]).listen((device) {
        //code for handling results
        String res = device.name.toString();
        if (!hs.contains(res)) {
          devicesList.add(device);
          hs.add(res);
        }

        // print(hm);
        // print(device);
        setState(() {
          _foundDeviceWaitingToConnect = true;
        });
      }, onError: (ErrorDescription) {
        //code for handling error
        // print(ErrorDescription);
      });

      Timer(Duration(seconds: 2), () {
        _scanStream.cancel();
      });
    }
  }

  void performTask(dev) async {
    final characteristic = QualifiedCharacteristic(
        serviceId: serviceUuid,
        characteristicId: characteristicUuid,
        deviceId: dev);
    final response =
        await flutterReactiveBle.readCharacteristic(characteristic);
    decoded = utf8.decode(response);
    print(response);
    print(decoded);
  }

  void _connectToDevice(deviceIde) {
    // We're done scanning, we can cancel it
    _scanStream.cancel();
    // Let's listen to our connection so we can make updates on a state change
    Stream<ConnectionStateUpdate> _currentConnectionStream = flutterReactiveBle
        .connectToAdvertisingDevice(
            id: deviceIde,
            prescanDuration: const Duration(seconds: 1),
            withServices: [serviceUuid, characteristicUuid]);
    _currentConnectionStream.listen((event) {
      switch (event.connectionState) {
        // We're connected and good to go!
        case DeviceConnectionState.connected:
          {
            _rxCharacteristic = QualifiedCharacteristic(
                serviceId: serviceUuid,
                characteristicId: characteristicUuid,
                deviceId: event.deviceId);
            print("good to go");
            final characteristic = QualifiedCharacteristic(
                serviceId: serviceUuid,
                characteristicId: characteristicUuid,
                deviceId: deviceIde);
            performTask(deviceIde);
            setState(() {
              // _foundDeviceWaitingToConnect = false;
              _connected = true;
            });
            break;
          }
        // Can add various state state updates on disconnect
        case DeviceConnectionState.disconnected:
          {
            print("not good to go");
            break;
          }
        default:
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Diagnostic App",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        child: (_foundDeviceWaitingToConnect && devicesList.length > 0)
            ? ListView.builder(
                itemCount: devicesList.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(devicesList[index].name),
                      subtitle: Text(devicesList[index].id),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        _connectToDevice(devicesList[index].id);
                      },
                    ),
                  );
                },
              )
            : Center(
                child: Text("no device found"),
              ),
      ),
      floatingActionButton: Wrap(
        direction: Axis.horizontal,
        children: [
          _scanStarted
              ? Container(
                  margin: const EdgeInsets.all(10),
                  child: FloatingActionButton(
                    backgroundColor: Colors.blue,
                    child: const Icon(Icons.search),
                    onPressed: () {},
                  ),
                )
              : Container(
                  margin: const EdgeInsets.all(10),
                  child: FloatingActionButton(
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.search),
                    onPressed: _startScan,
                  ),
                ),
        ],
      ),
    );
  }
}
