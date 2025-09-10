import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/profile.dart';
import 'package:flutter_application_1/trip.dart';
import 'package:http/http.dart' as http;

import 'config/config.dart';
import 'model/respone/trip_get_res.dart';

class showtrip extends StatefulWidget {
  int cid = 0;
  showtrip({super.key, required this.cid});

  @override
  State<showtrip> createState() => _showtripState();
}

class _showtripState extends State<showtrip> {
  String url = '';
  List<Tripgetres> tripGetResponses = [];
  List<Tripgetres> allTrips = [];
  late Future<void> loadData;

  @override
  void initState() {
    super.initState();
    loadData = loadDataAsync();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('รายการทริป'),
        automaticallyImplyLeading: false,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              log(value);
              if (value == 'profile') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(idx: widget.cid),
                  ),
                );
              } else if (value == 'logout') {
                Navigator.of(context).popUntil((route) => route.isFirst);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem<String>(
                value: 'profile',
                child: Text('ข้อมูลส่วนตัว'),
              ),
              const PopupMenuItem<String>(
                value: 'logout',
                child: Text('ออกจากระบบ'),
              ),
            ],
          ),
        ],
      ),
      body: FutureBuilder(
        future: loadData,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('ปลายทาง'),
                  SizedBox(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          FilledButton(
                            onPressed: () {
                              setState(() {
                                tripGetResponses = List.from(allTrips);
                              });
                            },
                            child: const Text('ทั้งหมด'),
                          ),
                          FilledButton(
                            onPressed: () {
                              setState(() {
                                tripGetResponses = allTrips
                                    .where((t) => t.destinationZone == 'ยุโรป')
                                    .toList();
                              });
                            },
                            child: const Text('ยุโรป'),
                          ),
                          FilledButton(
                            onPressed: () {
                              setState(() {
                                tripGetResponses = allTrips
                                    .where(
                                      (t) => t.destinationZone == 'อาเซียน',
                                    )
                                    .toList();
                              });
                            },
                            child: const Text('อาเซียน'),
                          ),
                          FilledButton(
                            onPressed: () {
                              setState(() {
                                tripGetResponses = allTrips
                                    .where((t) => t.destinationZone == 'เอเชีย')
                                    .toList();
                              });
                            },
                            child: const Text('เอเชีย'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('รายการทริป'),
                  Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: tripGetResponses.map((trip) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 🔹 ชื่อทริป
                              Text(
                                trip.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),

                              // 🔹 เนื้อหาหลัก
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // รูปภาพ
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      trip.coverimage,
                                      width: 160,
                                      height: 120,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(
                                                Icons.image_not_supported,
                                                size: 60,
                                              ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),

                                  // รายละเอียด
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("ประเทศ ${trip.country}"),
                                        const SizedBox(height: 4),
                                        Text("ระยะเวลา ${trip.duration} วัน"),
                                        const SizedBox(height: 4),
                                        Text("ราคา ${trip.price} บาท"),
                                        const SizedBox(height: 8),

                                        // ปุ่ม
                                        FilledButton(
                                          onPressed: () => gotoTrip(trip.idx),
                                          child: const Text(
                                            "รายละเอียดเพิ่มเติม",
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void getTrips() async {
    var res = await http.get(Uri.parse('$url/trips'));
    log(res.body);
    setState(() {
      tripGetResponses = tripgetresFromJson(res.body);
    });
    log(tripGetResponses.length.toString());
  }

  Future<void> loadDataAsync() async {
    var config = await Configuration.getConfig();
    url = config['apiEndpoint'];

    var res = await http.get(Uri.parse('$url/trips'));
    log(res.body);
    allTrips = tripgetresFromJson(res.body); // เก็บข้อมูลดิบทั้งหมด
    tripGetResponses = List.from(allTrips); // โชว์ครั้งแรก = ทั้งหมด
    log(tripGetResponses.length.toString());
  }

  void gotoTrip(int idx) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TripPage(idx: idx)),
    );
  }
}
