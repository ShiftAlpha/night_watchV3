import 'package:google_maps_flutter/google_maps_flutter.dart';

class GuardUser {
  final String uid;
  GuardUser({required this.uid});
}

class Coffee {
  String shopName;
  String address;
  String description;
  String thumbNail;
  LatLng locationCoords;

  Coffee(
      {required this.shopName,
      required this.address,
      required this.description,
      required this.thumbNail,
      required this.locationCoords});
}

final List<Coffee> evStations = [
  Coffee(
      shopName: '',
      address: '',
      description: '',
      locationCoords: const LatLng(-29.729520, 31.063350),
      thumbNail:
          ""),
  Coffee(
      shopName: '',
      address: '',
      description: '',
      locationCoords: const LatLng(-29.729509, 31.063330),
      thumbNail:
          ''),
  Coffee(
      shopName: '',
      description: '',
      address: '',
      locationCoords: const LatLng(-29.726461, 31.065037),
      thumbNail:
          ''),
  Coffee(
      shopName: '',
      description: '',
      address: '',
      locationCoords: const LatLng(-29.725045, 31.084281),
      thumbNail:
          ''),
];
