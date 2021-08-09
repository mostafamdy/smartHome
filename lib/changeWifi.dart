import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:async';
import 'package:usb_serial/usb_serial.dart';
import 'package:usb_serial/transaction.dart';

class ChangeWifi extends StatefulWidget {
  @override
  _ChangeWifiState createState() => _ChangeWifiState();
}

class _ChangeWifiState extends State<ChangeWifi> {
  UsbPort _port;
  String _status = "Idle";
  List<Widget> _ports = [];
  List<Widget> _serialData = [];
  StreamSubscription<String> _subscription;
  Transaction<String> _transaction;
  int _deviceId;
  TextEditingController _textController = TextEditingController();

  Future<bool> _connectTo(device) async {
    _serialData.clear();

    if (_subscription != null) {
      _subscription.cancel();
      _subscription = null;
    }

    if (_transaction != null) {
      _transaction.dispose();
      _transaction = null;
    }

    if (_port != null) {
      _port.close();
      _port = null;
    }

    if (device == null) {
      _deviceId = null;
      setState(() {
        _status = "Disconnected";
      });
      return true;
    }

    _port = await device.create();
    if (!await _port.open()) {
      setState(() {
        _status = "Failed to open port";
      });
      return false;
    }

    _deviceId = device.deviceId;
    await _port.setDTR(true);
    await _port.setRTS(true);
    await _port.setPortParameters(
        9600, UsbPort.DATABITS_8, UsbPort.STOPBITS_1, UsbPort.PARITY_NONE);

    _transaction = Transaction.stringTerminated(
        _port.inputStream, Uint8List.fromList([13, 10]));

    _subscription = _transaction.stream.listen((String line) {
      setState(() {
        _serialData.add(Text(line));
        if (_serialData.length > 20) {
          _serialData.removeAt(0);
        }
      });
    });

    setState(() {
      _status = "Connected";
    });
    return true;
  }

  void _getPorts() async {
    _ports = [];
    List<UsbDevice> devices = await UsbSerial.listDevices();
    print(devices);
    devices.forEach((device) {
      _ports.add(ListTile(
          leading: Icon(Icons.usb),
          title: Text(device.productName),
          subtitle: Text(device.manufacturerName),
          trailing: RaisedButton(
            child:
            Text(_deviceId == device.deviceId ? "Disconnect" : "Connect"),
            onPressed: () {
              _connectTo(_deviceId == device.deviceId ? null : device)
                  .then((res) {
                _getPorts();
              });
            },
          )));
    });

    setState(() {
      print(_ports);
    });
  }

  @override
  void initState() {
    super.initState();

    UsbSerial.usbEventStream.listen((UsbEvent event) {
      _getPorts();
    });

    _getPorts();
  }

  @override
  void dispose() {
    super.dispose();
    _connectTo(null);
  }


  String s= "wifi name";
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: Text("wifi setting"),
            centerTitle: true,
            backgroundColor: Colors.purple,
            elevation: 25,
            //leading: Icon(Icons.home,color: Colors.white,),
          ),
          body: ListView(
            children: <Widget>[
          Column(children: <Widget>[
            SizedBox(height: 50,),
          Text(
              _ports.length > 0
                  ? "Connected"
                  : "No Connection",
              style: Theme.of(context).textTheme.title),
          ..._ports,
          //Text('Status: $_status\n'),
          SizedBox(height: 25,),
        ListTile(
          title: TextField(
            controller: _textController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: s,
            ),
          ),
          trailing: RaisedButton(
            child: Text("Send"),
            onPressed: _port == null
                ? null
                : () async {
              if (_port == null) {
                return;
              }
//             setState(() {
//               s="wifi password";
//             });
              String data = _textController.text;

              await _port.write(Uint8List.fromList(data.codeUnits));
              _textController.text = "";
            },
          ),
        ),
        SizedBox(height: 25,),
        Text("Result Data", style: Theme.of(context).textTheme.title),
        ..._serialData,
        ])
            ],

        )));
  }
}