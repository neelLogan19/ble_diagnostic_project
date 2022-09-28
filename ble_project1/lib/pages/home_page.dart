import 'dart:collection';

import 'package:ble_project1/pages/data_page.dart';
import 'package:ble_project1/utils/routes.dart';
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

  //loader
  bool loader = false;
  bool search = true;

  //decoded value
  String decodedByteArray = "";
  //this is the real data, byte array conversion to json data

  //-->used to fetch data from the ble device
  late QualifiedCharacteristic _rxCharacteristic;

  //connetion state stream
  late StreamSubscription<ConnectionStateUpdate> _connection;

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
      _scanStream =
          flutterReactiveBle.scanForDevices(withServices: []).listen((device) {
        //code for handling results
        String res = device.name.toString();
        if (!hs.contains(res)) {
          devicesList.add(device);
          hs.add(res);
        }
        print("scan started");
        // print(hm);
        // print(device);
        setState(() {
          _foundDeviceWaitingToConnect = true;
          _scanStarted = false;
        });
      }, onError: (ErrorDescription) {
        //code for handling error
        // print(ErrorDescription);
      });

      Timer(const Duration(seconds: 4), () {
        _scanStream.cancel();
      });
    }
  }

//-----> this function is used to connect to ble device
  void _connectToDevice(deviceIde, devName) {
    // Let's listen to our connection so we can make updates on a state change
    Stream<ConnectionStateUpdate> _currentConnectionStream = flutterReactiveBle
        .connectToAdvertisingDevice(
            id: deviceIde,
            prescanDuration: const Duration(seconds: 1),
            withServices: [serviceUuid, characteristicUuid]);
    _connection = _currentConnectionStream.listen((event) {
      switch (event.connectionState) {
        // We're connected and good to go!
        case DeviceConnectionState.connected:
          {
            _rxCharacteristic = QualifiedCharacteristic(
                serviceId: serviceUuid,
                characteristicId: characteristicUuid,
                deviceId: event.deviceId);
            print("good to go");
            setState(() {
              loader = false;
              search = true;
            });

            print(_connection);
            String nm = devName.toString();
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => DataPage(
                      name: nm,
                      id: deviceIde,
                      streaming: _connection,
                    )));
            final characteristic = QualifiedCharacteristic(
                serviceId: serviceUuid,
                characteristicId: characteristicUuid,
                deviceId: deviceIde);

            // retrieveData(deviceIde);
            print(decodedByteArray);

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
            setState(() {
              loader = false;
              search = true;
            });
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
        backgroundColor: Color(0xFF0085ba),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          "Diagnostic App",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: loader
          ? Center(
              child: new CircularProgressIndicator(
                value: null,
                strokeWidth: 7.0,
              ),
            )
          : Container(
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
                              setState(() {
                                loader = true;
                                search = false;
                              });
                              _connectToDevice(devicesList[index].id,
                                  devicesList[index].name);
                            },
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Text(
                        "No device found",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
            ),
      floatingActionButton: Wrap(
        direction: Axis.horizontal,
        children: [
          _scanStarted
              ? Container(
                  margin: const EdgeInsets.all(10),
                  child: search
                      ? FloatingActionButton(
                          backgroundColor: Color(0xFF0085ba),
                          child: const Icon(Icons.search),
                          onPressed: _startScan,
                        )
                      : Container(),
                )
              : Container(
                  margin: const EdgeInsets.all(10),
                  child: search
                      ? FloatingActionButton(
                          backgroundColor: Color(0xFF0085ba),
                          child: Icon(Icons.search),
                          onPressed: _startScan,
                        )
                      : Container(),
                ),
        ],
      ),
    );
  }
}
