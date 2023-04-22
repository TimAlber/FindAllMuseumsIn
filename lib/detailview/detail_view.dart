import 'dart:async';

import 'package:all_museums_in/geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:all_museums_in/services/museums.dart' as musem;
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';

class DetailView extends StatefulWidget {
  final musem.Element element;

  const DetailView({required this.element, Key? key}) : super(key: key);

  @override
  State<DetailView> createState() => _DetailViewState();
}

class _DetailViewState extends State<DetailView> {
  Timer? timer;
  Position? devicePosition;

  @override
  void initState() {
    timer = Timer.periodic(
        const Duration(seconds: 2),
        (Timer t) => {
              determinePosition().then((position) => {
                    setState(() {
                      devicePosition = position;
                      print(devicePosition);
                    }),
                  }),
            });

    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.element.tags.name ?? ''),
        ),
        body: ListView(
          children: [
            SizedBox(
              height: 300,
              width: MediaQuery.of(context).size.width,
              child: FlutterMap(
                options: MapOptions(
                  zoom: 12,
                  center: LatLng(widget.element.lat, widget.element.lon),
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.app',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: LatLng(widget.element.lat, widget.element.lon),
                        width: 20,
                        height: 20,
                        builder: (context) => const Icon(Icons.place_sharp),
                      ),
                      if(devicePosition != null)
                      Marker(
                        point: LatLng(devicePosition!.latitude, devicePosition!.longitude),
                        width: 20,
                        height: 20,
                        builder: (context) => const Icon(Icons.circle, color: Colors.blue,),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.place_outlined),
              title: Text(
                  '${widget.element.tags.addrStreet ?? ''} ${widget.element.tags.addrHousenumber ?? ''} ${widget.element.tags.addrPostcode ?? ''} ${widget.element.tags.addrCity ?? ''}'),
            ),
            const Divider(
              color: Colors.grey,
            ),
            ListTile(
              leading: const Icon(Icons.attach_money),
              title: Text(widget.element.tags.fee ?? ''),
            ),
            const Divider(
              color: Colors.grey,
            ),
            ListTile(
              leading: const Icon(Icons.timer),
              title: Text(widget.element.tags.openingHours ?? ''),
            ),
            const Divider(
              color: Colors.grey,
            ),
            ListTile(
              onTap: () async {
                if (widget.element.tags.website != null &&
                    widget.element.tags.website!.isNotEmpty) {
                  if (!await launchUrl(
                      Uri.parse(widget.element.tags.website!))) {
                    Logger().e('Cant open that website');
                  }
                }
              },
              leading: const Icon(Icons.web_outlined),
              title: Text(widget.element.tags.website ?? ''),
            ),
            const Divider(
              color: Colors.grey,
            ),
            ListTile(
              onTap: () async {
                if (widget.element.tags.contactPhone != null &&
                    widget.element.tags.contactPhone!.isNotEmpty) {
                  if (!await launchUrl(
                    Uri(
                      scheme: 'tel',
                      path: widget.element.tags.contactPhone!,
                    ),
                  )) {
                    Logger().e('Cant open that website');
                  }
                }
              },
              leading: const Icon(Icons.phone),
              title: Text(widget.element.tags.contactPhone ?? ''),
            ),
            const Divider(
              color: Colors.grey,
            ),
            ListTile(
              leading: const Icon(Icons.wheelchair_pickup),
              title: Text(widget.element.tags.wheelchair ?? ''),
            ),
            const Divider(
              color: Colors.grey,
            ),
          ],
        ));
  }
}
