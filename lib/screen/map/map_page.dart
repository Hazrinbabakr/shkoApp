import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapWidget extends StatefulWidget {
  final LatLng defaultPosition;
  final List<Marker>? markers;

  const MapWidget({Key? key, required this.defaultPosition, this.markers}) : super(key: key);

  @override
  State<MapWidget> createState() => MapWidgetState();
}

class MapWidgetState extends State<MapWidget> {
  final Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    return
      // ClipRRect(
      // borderRadius: BorderRadius.circular(25),
      // child:
    GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(target: widget.defaultPosition, zoom: 14),
        markers: widget.markers?.toSet()??{
          Marker(markerId: MarkerId("location"),position: widget.defaultPosition)
        },
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        gestureRecognizers: {},
        scrollGesturesEnabled: false,
        rotateGesturesEnabled: false,
        myLocationButtonEnabled: false,
        myLocationEnabled: false,
      );
    // );
  }
}