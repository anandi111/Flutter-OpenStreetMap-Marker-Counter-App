import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class MapViewController extends GetxController {
  final LatLng baseLocation = LatLng(48.8566, 2.3522); // Paris
  List<Marker> markers = [];
  List<LatLng> polygonPoints = [];
  LatLng? previewPoint;
  bool polygonCompleted = false;
  int selectedPinCount = 0;
  final int _randomMarkerCount = 200;

  @override
  void onInit() {
    generateRandomMarkers();
    super.onInit();
  }

  /// Generate Random Markers on Map
  void generateRandomMarkers() {
    final Random random = Random();
    List<Marker> newMarkers = [];

    for (int i = 0; i < _randomMarkerCount; i++) {
      double lat = baseLocation.latitude + (random.nextDouble() - 0.5) * 0.02;
      double lon = baseLocation.longitude + (random.nextDouble() - 0.5) * 0.02;

      newMarkers.add(
        Marker(
          point: LatLng(lat, lon),
          width: 40,
          height: 40,
          builder: (ctx) => const Icon(
            Icons.location_pin,
            color: Colors.red,
            size: 40,
          ),
        ),
      );
    }

    markers = newMarkers;
    update();
  }

  /// Handle map tap to draw polygon dynamically
  void onMapTap(LatLng tapPoint) {
    if (polygonCompleted) return;

    if (polygonPoints.isEmpty) {
      previewPoint = tapPoint;
    }

    // Close the polygon when clicking the first point again
    if (polygonPoints.isNotEmpty && _distanceBetween(polygonPoints.first, tapPoint) < 0.0005) {
      polygonCompleted = true;
      previewPoint = null;
    } else {
      // Add new point to polygon and reset preview
      polygonPoints.add(tapPoint);
      previewPoint = tapPoint;
    }

    // Update marker count dynamically
    _countMarkersInsidePolygon();
    update();
  }

  /// Update preview line while dragging
  void onMapDrag(LatLng dragPoint) {
    if (polygonCompleted || polygonPoints.isEmpty) return;

    previewPoint = dragPoint;
    update();
  }

  /// Count markers inside the growing polygon dynamically
  void _countMarkersInsidePolygon() {
    if (polygonPoints.length < 3) {
      selectedPinCount = 0;
      update();
      return;
    }

    selectedPinCount = markers.where((marker) {
      return _isPointInsidePolygon(marker.point, polygonPoints);
    }).length;

    update();
  }

  /// Check if a point is inside a polygon (Ray-casting algorithm)
  bool _isPointInsidePolygon(LatLng point, List<LatLng> polygon) {
    if (polygon.length < 3) return false;

    bool inside = false;
    int j = polygon.length - 1;

    for (int i = 0; i < polygon.length; i++) {
      double xi = polygon[i].latitude, yi = polygon[i].longitude;
      double xj = polygon[j].latitude, yj = polygon[j].longitude;

      bool intersect = ((yi > point.longitude) != (yj > point.longitude)) &&
          (point.latitude < (xj - xi) * (point.longitude - yi) / (yj - yi) + xi);

      if (intersect) inside = !inside;
      j = i;
    }

    return inside;
  }

  /// Calculate distance between two LatLng points
  double _distanceBetween(LatLng a, LatLng b) {
    return (a.latitude - b.latitude).abs() + (a.longitude - b.longitude).abs();
  }

  void onRefreshBtnCalled() {
    polygonPoints = [];
    polygonCompleted = false;
    selectedPinCount = 0;
    previewPoint = null;
    update();
  }
}
