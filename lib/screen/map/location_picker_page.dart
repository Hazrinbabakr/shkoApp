import 'dart:async';
import 'dart:io';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';


class LocationPickerPage extends StatefulWidget {
  final double xLongitude;
  final double yLatitude;

  const LocationPickerPage({Key key, this.xLongitude, this.yLatitude}) : super(key: key);

  @override
  State<LocationPickerPage> createState() => _LocationPickerPageState();
}

class _LocationPickerPageState extends State<LocationPickerPage> {
  final Completer<GoogleMapController> _mapController = Completer();
  Location _location;
  LocationData _locationData;
  LatLng _currentMapPosition;
  bool _gettingLocation = false;
  bool _permissionGranted = false;
  bool _locationServiceEnabled = false;
  final bool _cameraMoving = false;

  @override
  void initState() {
    _location = Location();
    super.initState();
    _fetchInitData();
  }

  _fetchInitData() async {
    try {
      if (widget.xLongitude == null && widget.yLatitude == null) {
        await _checkLocationPermission();
      } else {
        _currentMapPosition = LatLng(widget.yLatitude, widget.xLongitude);
      }
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {}
      _locationData = null;
    }
  }

  Future _checkLocationPermission() async {
    var hasLocationPermission = await _location.hasPermission();
    if (hasLocationPermission != PermissionStatus.granted) {
      var permissionResult = await _location.requestPermission();
      if (permissionResult != PermissionStatus.granted) {
        setState(() {
          _permissionGranted = false;
        });
      } else {
        setState(() {
          _permissionGranted = true;
        });
        await _checkLocationService();
      }
    } else {
      setState(() {
        _permissionGranted = true;
      });
      await _checkLocationService();
    }
  }

  Future _checkLocationService() async {
    var isLocationServiceEnabled = await _location.serviceEnabled();
    if (!isLocationServiceEnabled) {
      if(Platform.isIOS){
        await AppSettings.openLocationSettings();
      }
      else{
        isLocationServiceEnabled = await _location.serviceEnabled();
        if(isLocationServiceEnabled){
          setState(() {
            _locationServiceEnabled = true;
          });
          await _processCurrentLocation();
        }
        else {
          setState(() {
            _locationServiceEnabled = false;
          });
        }
      }
      var enableServiceResult = await _location.requestService();
      if (!enableServiceResult) {
        setState(() {
          _locationServiceEnabled = false;
        });
      } else {
        setState(() {
          _locationServiceEnabled = true;
        });
        await _processCurrentLocation();
      }
    } else {
      setState(() {
        _locationServiceEnabled = true;
      });
      await _processCurrentLocation();
    }
  }

  Future _processCurrentLocation() async {
    setState(() {
      _gettingLocation = true;
    });
    var userLocationData = await _location.getLocation();
    setState(() {
      _gettingLocation = false;
      _locationData = userLocationData;
      _currentMapPosition = LatLng(_locationData.latitude, _locationData.longitude);
    });
    if (_mapController.isCompleted) {
      var newPos = CameraPosition(target: _currentMapPosition, zoom: 12);
      var con = await _mapController.future;
      con.animateCamera(CameraUpdate.newCameraPosition(newPos));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Location"),
        titleSpacing: 0,
        actions: [
          Visibility(
            visible: (!_cameraMoving && _currentMapPosition != null),
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0, left: 8.0),
              child: IconButton(
                icon: const Icon(Icons.check),
                onPressed: () async {
                  if (Navigator.canPop(context)) {
                    var latLngResult = LocationData.fromMap({
                      "latitude" : _currentMapPosition.latitude,
                      "longitude": _currentMapPosition.longitude
                    });
                    Navigator.of(context).pop(latLngResult);
                  }
                },
              ),
            ),
          ),
        ],
      ),
      body: pageContent(),
    );
  }

  Widget pageContent() {
    if (_locationData == null && widget.yLatitude != null && widget.yLatitude != null) {
      return _makeMap(false);
    }
    if (!_permissionGranted) {
      return const Center(
        child: Text("Location Permission Required!")
        );
    } else {
      if (!_locationServiceEnabled) {
        return const Center(
            child: Text("Please turn on location Service!")
        );
      } else {
        if (_locationData == null) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return _makeMap(false);
        }
      }
    }
  }

  _makeMap(bool isLoading, {Set<Marker> markers}) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
            mapType: MapType.normal,
            zoomControlsEnabled: false,
            myLocationButtonEnabled: false,
            mapToolbarEnabled: false,
            initialCameraPosition: CameraPosition(target: _currentMapPosition, zoom: 12),
            onCameraMove: (value) {
              setState(() {
                _currentMapPosition = value.target;
              });
            },
            onCameraIdle: () {},
            onMapCreated: (GoogleMapController controller) async {
              _mapController.complete(controller);
            },
            markers: markers ?? {},
            gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
              Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer()),
            },
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 51),
              child: Center(
                child: Icon(
                  Icons.location_on_outlined,
                  size: 60,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: _gettingLocation ? const CircularProgressIndicator() : const Icon(Icons.my_location_outlined),
        onPressed: () async {
          if (!_gettingLocation) {
            await _checkLocationPermission();
          }
        },
      ),
    );
  }
}
