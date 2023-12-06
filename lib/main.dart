import 'package:firebase_core/firebase_core.dart'; // Untuk memanggil firebase dan flutter fire
import 'package:firebase_database/firebase_database.dart'; // Untuk memanggil realtime database
import 'package:flutter/material.dart'; // Untuk mengatur atau mematerialisasikan widget atau kontainer yang akan digunakan
import 'package:url_launcher/url_launcher.dart'; // Untuk button yang memakai link didalamnya

import 'firebase_options.dart';

final Uri _url = Uri.parse('https://flutter.dev'); //

void main() async { // Untuk mengkoneksikan agar data dapat sinkron dengan firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget { // Mendeklarasikan aplikasi ini adalah sebuah aplikasi sattefulwidget atau sebuah aplikasi yang dapat mengupdate data
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> { // Mendeklarasi tipe data yang akan dipanggil
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();
  late double _temperatureValue;
  late double _pHValue;
  late double _tdsValue;

  @override // Mendeklarasi nilai awal
  void initState() {
    super.initState();
    // initial value
    _temperatureValue = 0.0;
    _pHValue = 0.0;
    _tdsValue = 0.0;
      // 
    _databaseRef.child("Temp").onValue.listen((event) {
      try {
        double? value = event.snapshot.value as double?;
        setState(() {
          _temperatureValue = value ?? 0.0;
        });
      } catch (e) {
        print("Error reading Temperature: $e");
      }
    });
      //
    _databaseRef.child("pH").onValue.listen((event) {
      try {
        double? value = event.snapshot.value as double?;
        setState(() {
          _pHValue = value ?? 0.0;
        });
      } catch (e) {
        print("Error reading pH: $e");
      }
    });
      //
    _databaseRef.child("TDS").onValue.listen((event) {
      try {
        double? value = event.snapshot.value as double?;
        setState(() {
          _tdsValue = value ?? 0.0;
        });
      } catch (e) {
        print("Error reading TDS: $e");
      }
    });
  }

  void _openBrowser() async {
    if (await canLaunch(_url.toString())) {
      await launch(_url.toString());
    } else {
      throw 'Could not launch $_url';
    }
  }

  Widget dataContainer(String label, double value) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.fromLTRB(50, 0, 50, 25),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 209, 224, 215),
        borderRadius: BorderRadius.circular(15.0), // Adjust the value as needed
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            color: Color.fromARGB(255, 200, 207, 217),
            child: Text(
              "$value",
              style: const TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget openStorage() {
  return Container(
    color: Color.fromARGB(255, 239, 228, 226),
    width: double.infinity, // Make the pink section full width
    padding: const EdgeInsets.all(20),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: double.infinity, // Make the red box full width
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 16, 33, 25),
            borderRadius: BorderRadius.circular(15.0), // Adjust the value as needed
          ),
          child: ElevatedButton(
            onPressed: _openBrowser,
            style: ElevatedButton.styleFrom(
              primary: Colors.transparent,
              onPrimary: Colors.black,
              shadowColor: Colors.transparent,
              padding: EdgeInsets.all(20),
            ),
            child: Text(
              'OPEN STORAGE',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
        SizedBox(height: 20), // Adjust the height as needed for spacing
      ],
    ),
  );
}





  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tamagofish',
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 0, 0, 0),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 50, 0, 10),
                    child: Text(
                      'Kolam X',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 45,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text(
                    _getCurrentDateTime(),
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 45,
            ),
            dataContainer("Temperature", _temperatureValue),
            dataContainer("pH", _pHValue),
            dataContainer("TDS", _tdsValue),
            Spacer(),
            openStorage(),
          ],
        ),
      ),
    );
  }

  String _getCurrentDateTime() {
    DateTime now = DateTime.now();
    return "${now.day}/${now.month}/${now.year} ${now.hour}:${now.minute}:${now.second}";
  }
}
