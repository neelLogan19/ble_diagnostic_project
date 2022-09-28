import 'package:flutter/material.dart';

class DeviceDetails extends StatefulWidget {
  bool uartpage1;
  bool statuspage2;
  bool flashpage3;
  bool fullpage4;
  DeviceDetails(
      {required this.uartpage1,
      required this.statuspage2,
      required this.flashpage3,
      required this.fullpage4});

  @override
  State<DeviceDetails> createState() => _DeviceDetailsState();
}

class _DeviceDetailsState extends State<DeviceDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0085ba),
        centerTitle: true,
        title: Text(widget.uartpage1
            ? "UART"
            : widget.statuspage2
                ? "STATUS"
                : widget.flashpage3
                    ? "FLASH"
                    : widget.fullpage4
                        ? "FULL SCAN"
                        : ""),
      ),
      body: Container(
        child: Text("Khana khalo"),
      ),
    );
  }
}
