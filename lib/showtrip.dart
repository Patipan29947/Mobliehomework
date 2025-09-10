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
  late Future<void> loadData;

  @override
  void initState() {
    super.initState();
    Configuration.getConfig().then((config) {
      url = config['apiEndpoint'];
      getTrips();
    });
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
                // Navigate to profile page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(idx: widget.cid),
                  ),
                );
              } else if (value == 'logout') {
                // Perform logout operation
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
                  Text('ปลายทาง'),
                  SizedBox(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          FilledButton(
                            onPressed: () => getTrips(),
                            child: const Text('ทั้งหมด'),
                          ),
                          FilledButton(
                            onPressed: () {
                              List<Tripgetres> eurotrip = [];
                              for (var trip in tripGetResponses) {
                                if (trip.destinationZone == 'ยุโรป') {
                                  eurotrip.add(trip);
                                }
                              }
                              setState(() {
                                tripGetResponses = eurotrip;
                              });
                            },
                            child: const Text('ยุโรป'),
                          ),
                          FilledButton(
                            onPressed: () {
                              List<Tripgetres> eurotrip = [];
                              for (var trip in tripGetResponses) {
                                if (trip.destinationZone == 'อาเซียน') {
                                  eurotrip.add(trip);
                                }
                              }
                              setState(() {
                                tripGetResponses = eurotrip;
                              });
                            },
                            child: const Text('อาเซียน'),
                          ),
                          FilledButton(
                            onPressed: () {
                              List<Tripgetres> eurotrip = [];
                              for (var trip in tripGetResponses) {
                                if (trip.destinationZone == 'เอเชีย') {
                                  eurotrip.add(trip);
                                }
                              }
                              setState(() {
                                tripGetResponses = eurotrip;
                              });
                            },
                            child: const Text('เอเชีย'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Text('รายการทริป'),
                  Card(
                    child: Column(
                      children: tripGetResponses
                          .map(
                            (trip) => ListTile(
                              leading: Image.network(trip.coverimage),
                              title: Text(trip.name),
                              subtitle: Text(trip.destinationZone),
                              trailing: FilledButton(
                                onPressed: () => gotoTrip(trip.idx),
                                child: Text('ดูรายละเอียด'),
                              ),
                            ),
                          )
                          .toList(),
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
    tripGetResponses = tripgetresFromJson(res.body);
    log(tripGetResponses.length.toString());
  }

  void gotoTrip(int idx) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TripPage(idx: idx)),
    );
  }
}
