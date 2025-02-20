import 'package:get/get.dart';
import 'package:map_task/utils/route_management/global_binding.dart';
import 'package:map_task/utils/route_management/route_names.dart';
import 'package:map_task/views/map_screen.dart';

class RouteGenerator {
  static List<GetPage<dynamic>> generate() => <GetPage<dynamic>>[
        GetPage(
          name: RouteNames.mapScreenRoute,
          page: () => const MapScreen(),
          binding: GlobalBindings(),
        ),
      ];
}
