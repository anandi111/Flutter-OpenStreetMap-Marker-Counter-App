import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:map_task/controllers/map_view_controller.dart';
import 'package:map_task/utils/colors.dart';
import 'package:map_task/utils/constants.dart';
import 'package:map_task/utils/strings.dart';

class MapScreen extends GetView<MapViewController> {
  const MapScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Str.appName),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              controller.generateRandomMarkers();
              controller.onRefreshBtnCalled();
            },
          ),
        ],
      ),
      body: GetBuilder<MapViewController>(
        builder: (controller) {
          return FlutterMap(
            options: MapOptions(
              center: controller.baseLocation,
              zoom: 15,
              onTap: (tapPosition, point) {
                controller.onMapTap(point);
              },
              onPositionChanged: (position, hasGesture) {
                if (hasGesture && controller.previewPoint != null) {
                  controller.onMapDrag(position.center!);
                }
              },
            ),
            children: [
              TileLayer(
                urlTemplate: Constants.mapURLTemplate,
                subdomains: Constants.mapSubDomains,
              ),
              MarkerLayer(markers: controller.markers),
              // Draw the polygon
              if (controller.polygonPoints.isNotEmpty)
                PolygonLayer(
                  polygons: [
                    Polygon(
                      points: controller.polygonPoints,
                      borderColor: MyColors.polygoneLineColor,
                      borderStrokeWidth: 3,
                      isFilled: true,
                      color: MyColors.polygoneFillColor,
                    ),
                  ],
                ),
              // Draw preview line
              if (controller.polygonPoints.isNotEmpty && controller.previewPoint != null)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: [controller.polygonPoints.last, controller.previewPoint!],
                      color: MyColors.polygonePreviewLineColor,
                      strokeWidth: 2,
                    ),
                  ],
                ),
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  color: MyColors.whiteColor,
                  child: Text(
                    "${Str.counterText} ${controller.selectedPinCount}",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
