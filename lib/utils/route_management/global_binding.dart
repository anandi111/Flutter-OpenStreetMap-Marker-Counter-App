import 'package:get/get.dart';
import 'package:map_task/controllers/map_view_controller.dart';

class GlobalBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MapViewController>(() => MapViewController());
  }
}
