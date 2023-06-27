import 'dart:math' show sin, cos, sqrt, atan2;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:onvocation/screens/profile_screen.dart';
import 'package:onvocation/screens/home_screen.dart';
import 'package:onvocation/sharedfoto/image_watuulo.dart';

class P_watu extends StatefulWidget {
  const P_watu({Key? key}) : super(key: key);

  @override
  State<P_watu> createState() => _MainScreenState();
}

class _MainScreenState extends State<P_watu> {
  final String menuName = 'Pantai Watu Ulo';
  String name = '';
  String category = '';
  String address = '';
  String price = '';
  String lati = '';
  String langi = '';
  String currentAddress = '';
  String destinationAddress = '';
  LatLng currentPosition = LatLng(0, 0);
  LatLng destinationPosition = LatLng(-8.423428411689372, 113.56138166858123);

  MapController mapController = MapController();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _getDestinationAddress();
    getMenuData();
  }

  void getMenuData() async {
    try {
      QuerySnapshot menuSnapshot = await FirebaseFirestore.instance
          .collection('menus')
          .where('name', isEqualTo: menuName)
          .get();

      if (menuSnapshot.size > 0) {
        DocumentSnapshot menuData = menuSnapshot.docs[0];
        setState(() {
          name = menuData.get('name') ?? '';
          category = menuData.get('kategori') ?? '';
          address = menuData.get('alamat') ?? '';
          price = menuData.get('harga') ?? '';
          lati = menuData.get('lat') ?? '';
          langi = menuData.get('long') ?? '';
        });
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> _getCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    final addresses = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    if (addresses.isNotEmpty) {
      final address = addresses.first;
      final formattedAddress =
          '${address.street}, ${address.locality}, ${address.country}';
      setState(() {
        currentAddress = formattedAddress;
      });
    }

    setState(() {
      currentPosition = LatLng(position.latitude, position.longitude);
    });
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.https("www.google.com",
        "maps/place/Pantai+Watu+Ulo/@-8.4252539,113.5412973,14z/data=!4m14!1m7!3m6!1s0x2dd69d2fffffffff:0x6f3d7097accf3209!2sPantai+Watu+Ulo!8m2!3d-8.425297!4d113.561897!16s%2Fg%2F120m19h0!3m5!1s0x2dd69d2fffffffff:0x6f3d7097accf3209!8m2!3d-8.425297!4d113.561897!16s%2Fg%2F120m19h0?entry=ttu");
    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      throw "Can not launch url";
    }
  }

  Future<void> _getDestinationAddress() async {
    final addresses = await placemarkFromCoordinates(
      destinationPosition.latitude,
      destinationPosition.longitude,
    );

    if (addresses.isNotEmpty) {
      final address = addresses.first;
      final formattedAddress =
          '${address.street}, ${address.locality}, ${address.country}';
      setState(() {
        destinationAddress = formattedAddress;
      });
    }
  }

  double calculateDistance(
      double startLat, double startLng, double endLat, double endLng) {
    const int earthRadius = 6371;

    double latDiff = degreesToRadians(endLat - startLat);
    double lngDiff = degreesToRadians(endLng - startLng);

    double a = sin(latDiff / 2) * sin(latDiff / 2) +
        cos(degreesToRadians(startLat)) *
            cos(degreesToRadians(endLat)) *
            sin(lngDiff / 2) *
            sin(lngDiff / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    double distance = earthRadius * c;
    return distance;
  }

  double degreesToRadians(double degrees) {
    return degrees * (pi / 180);
  }

  @override
  Widget build(BuildContext context) {
    double distance = calculateDistance(
      currentPosition.latitude,
      currentPosition.longitude,
      destinationPosition.latitude,
      destinationPosition.longitude,
    );

    return Scaffold(
      backgroundColor: Color.fromRGBO(102, 218, 255, 1.0),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 50.0),
            child: Container(
              width: 350,
              height: 210,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                image: DecorationImage(
                  image: NetworkImage(
                      "https://firebasestorage.googleapis.com/v0/b/onvocation-81249.appspot.com/o/Group%201737.png?alt=media&token=3a3e7814-71b9-4621-b64a-4ce4c811eb1b&_gl=1*1dx894e*_ga*NTYyMDIyOTE4LjE2ODQxNzY3MzU.*_ga_CW55HF8NVT*MTY4NTYxNTIzMC4yMy4xLjE2ODU2MTg4ODUuMC4wLjA."),
                  fit: BoxFit.cover,
                ),
              ),
              child: Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage(
                                "https://firebasestorage.googleapis.com/v0/b/onvocation-81249.appspot.com/o/621d417530178.jpg?alt=media&token=28befe58-d444-4ba9-9ff0-4ca50c1481c4&_gl=1*1g5x86n*_ga*NTYyMDIyOTE4LjE2ODQxNzY3MzU.*_ga_CW55HF8NVT*MTY4NjMwMTU2OC4zMC4xLjE2ODYzMDUzMjcuMC4wLjA."),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        'Jarak:',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${distance.toStringAsFixed(2)} km',
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ],
                  ),
                  SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$name',
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '$category',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Colors.white,
                            size: 20,
                          ),
                          Container(
                            width: 150,
                            child: Text(
                              '$address',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.money,
                            color: Colors.white,
                            size: 20,
                          ),
                          Container(
                            width: 150,
                            child: Text(
                              'Harga Mulai : $price',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          Icon(
                            Icons.star_half,
                            color: Colors.amber,
                          ),
                          Icon(
                            Icons.star_border,
                            color: Colors.amber,
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Container(
                            height: 25,
                            width: 90,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ImageWatuUlo()),
                                );
                              },
                              child: Text(
                                'Upload Foto',
                                style: TextStyle(
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Container(
                            height: 25,
                            child: ElevatedButton(
                              onPressed: () {
                                _launchURL(
                                    "https://www.google.com/maps/search/?api=1&query=-8.164972,113.717556");
                              },
                              child: Text(
                                'Menuju Lokasi',
                                style: TextStyle(
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: FlutterMap(
              mapController: mapController,
              options: MapOptions(
                center: destinationPosition,
                zoom: 13.0,
              ),
              layers: [
                TileLayerOptions(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                ),
                MarkerLayerOptions(
                  markers: [
                    Marker(
                      width: 40.0,
                      height: 40.0,
                      point: destinationPosition,
                      builder: (ctx) => Container(
                        child: Column(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Colors.red,
                              size: 40.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Lokasi Tujuan:',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${destinationPosition.latitude.toStringAsFixed(6)},${destinationPosition.longitude.toStringAsFixed(6)}',
                            style: TextStyle(fontSize: 12),
                          ),
                          Text(
                            'Alamat: $destinationAddress',
                            style: TextStyle(fontSize: 12),
                          ),
                          SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Lokasimu Saat Ini:',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${currentPosition.latitude.toStringAsFixed(6)},${currentPosition.longitude.toStringAsFixed(6)}',
                            style: TextStyle(fontSize: 12),
                          ),
                          Text(
                            'Alamat: $currentAddress',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 70,
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Color.fromARGB(255, 255, 255, 255),
            iconSize: 20.0,
            selectedIconTheme: IconThemeData(size: 28.0),
            selectedItemColor: Color.fromARGB(255, 46, 90, 172),
            unselectedItemColor: Colors.black,
            selectedFontSize: 16.0,
            unselectedFontSize: 12,
            currentIndex: 1,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: GestureDetector(
                  child: Icon(Icons.home),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  },
                ),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: GestureDetector(
                  child: Icon(Icons.navigation),
                  onTap: () {},
                ),
                label: "Map",
              ),
              BottomNavigationBarItem(
                icon: GestureDetector(
                  child: Icon(Icons.person),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfileScreen()),
                    );
                  },
                ),
                label: "Profile",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
