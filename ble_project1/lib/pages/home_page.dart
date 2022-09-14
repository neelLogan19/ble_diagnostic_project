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
  late DiscoveredDevice _napinoDevice;
  late StreamSubscription<DiscoveredDevice> _scanStream;

  List<DiscoveredDevice> devicesList = [];
  String _deviceName = "";
  // if there is no device available after scanning we print this message
  String _deviceMsg = "";
  //--> when are scanning is completed and we have all the devie in the list this variable is set to true
  bool _foundDeviceWaitingToConnect = false;

  //serviceUid and characteristic uuid
  final Uuid serviceUuid = Uuid.parse("edd79b0f-4ae0-484a-8ba9-4a611f1cb47b");
  final Uuid characteristicUuid =
      Uuid.parse("6ACF4F08-CC9D-D495-6B41-AA7E60C4E8A6");

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
        // String res = device.name.toString();
        print(device);
        // setState(() {
        //   _napinoDevice = device;
        //   _foundDeviceWaitingToConnect = true;
        // });
      }, onError: (ErrorDescription) {
        //code for handling error
        // print(ErrorDescription);
      });

      Timer(Duration(seconds: 5), () {
        _scanStream.cancel();
      });
    }

    // print(_napinoDevice);
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
      body: ListView(),
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
          Container(
            margin: EdgeInsets.all(10),
            child: FloatingActionButton(
              child: Icon(Icons.bluetooth),
              onPressed: () {},
              backgroundColor: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
