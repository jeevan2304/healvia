import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<ScanResult> _scanResults = [];
  BluetoothDevice? _connectedDevice;
  String _status = "Not connected";
  List<BluetoothService> _services = [];

  int? _heartRate;
  int? _bloodPressure;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    await [
      Permission.bluetooth,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.location
    ].request();
  }

  void _startScan() {
    _scanResults.clear();
    FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));
    FlutterBluePlus.scanResults.listen((results) {
      setState(() {
        _scanResults = results;
      });
    });
  }

  Future<void> _connectToDevice(BluetoothDevice device) async {
    await FlutterBluePlus.stopScan();

    try {
      setState(() {
        _status = "Connecting to ${device.name}...";
      });

      await device.connect(autoConnect: false);
      setState(() {
        _connectedDevice = device;
        _status = "Connected to ${device.name}";
      });

      _services = await device.discoverServices();

      for (var service in _services) {
        for (var characteristic in service.characteristics) {
          final uuid = characteristic.uuid.toString();

          if (uuid == "00002a37-0000-1000-8000-00805f9b34fb" || // Heart Rate
              uuid == "00002a35-0000-1000-8000-00805f9b34fb") { // Blood Pressure

            if (characteristic.properties.read) {
              var value = await characteristic.read();
              print("Read $uuid value: $value");

              // Parse value
              if (uuid == "00002a37-0000-1000-8000-00805f9b34fb") {
                setState(() {
                  _heartRate = value[1]; // Heart rate typically at index 1
                });
              } else if (uuid == "00002a35-0000-1000-8000-00805f9b34fb") {
                setState(() {
                  _bloodPressure = value[1]; // Systolic or measurement value
                });
              }
            }
          }
        }
      }
    } catch (e) {
      print("Connection error: $e");
      setState(() {
        _status = "Connection failed";
      });
    }
  }

  Future<void> _disconnectDevice() async {
    if (_connectedDevice != null) {
      await _connectedDevice!.disconnect();
      setState(() {
        _connectedDevice = null;
        _status = "Disconnected";
        _heartRate = null;
        _bloodPressure = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _startScan,
              child: const Text("Scan for Devices"),
            ),
            const SizedBox(height: 10),
            Text(
              _status,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            if (_connectedDevice != null) ...[
              const SizedBox(height: 10),
              Card(
                elevation: 4,
                child: ListTile(
                  title: const Text("Connected Device"),
                  subtitle: Text(_connectedDevice!.name),
                  trailing: IconButton(
                    icon: const Icon(Icons.cancel, color: Colors.red),
                    onPressed: _disconnectDevice,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              if (_heartRate != null)
                Text("❤️ Heart Rate: $_heartRate bpm", style: const TextStyle(fontSize: 18)),
              if (_bloodPressure != null)
                Text("💓 Blood Pressure: $_bloodPressure mmHg", style: const TextStyle(fontSize: 18)),
            ],
            const Divider(height: 30),
            const Text("Nearby Devices", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: _scanResults.length,
                itemBuilder: (context, index) {
                  final device = _scanResults[index].device;
                  return Card(
                    child: ListTile(
                      title: Text(device.name.isNotEmpty ? device.name : "(unknown)"),
                      subtitle: Text(device.id.toString()),
                      trailing: const Icon(Icons.bluetooth),
                      onTap: () => _connectToDevice(device),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
