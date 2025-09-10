import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/config.dart';
import 'package:flutter_application_1/model/respone/tripidx_res_post.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';

class TripPage extends StatefulWidget {
  int idx = 0;
  TripPage({super.key, required this.idx});

  @override
  State<TripPage> createState() => _TripPageState();
}

class _TripPageState extends State<TripPage> {
  String url = '';

  late TripIdxGetRes tripIdxGetResponse;
  late Future<void> loadData;

  void initState() {
    super.initState();
    loadData = loadDataAsync();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      // Loding data with FutureBuilder
      body: FutureBuilder(
        future: loadData,
        builder: (context, snapshot) {
          // Loading...
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          // Load Done
          return Column(
            children: [
              Card(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    
                    Text(tripIdxGetResponse.name,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    Image.network(tripIdxGetResponse.coverimage),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("ราคา "+tripIdxGetResponse.price.toString(),
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        Text("โซนประเทศ"+tripIdxGetResponse.destinationZone,
                            style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(tripIdxGetResponse.detail),
                    ),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }

  Future<void> loadDataAsync() async {
    var config = await Configuration.getConfig();
    url = config['apiEndpoint'];
    var res = await http.get(Uri.parse('$url/trips/${widget.idx}'));
    log(res.body);
    tripIdxGetResponse = tripIdxGetResFromJson(res.body);
  }
}
