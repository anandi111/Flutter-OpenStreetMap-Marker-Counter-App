import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:map_task/utils/route_management/global_binding.dart';
import 'package:map_task/utils/route_management/route_generator.dart';
import 'package:map_task/utils/route_management/route_names.dart';
import 'package:map_task/utils/strings.dart';

///Version Information: Flutter 3.7.6, Dart 2.19.3
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: Str.appName,
      theme: ThemeData(useMaterial3: true),
      initialBinding: GlobalBindings(),
      getPages: RouteGenerator.generate(),
      initialRoute: RouteNames.mapScreenRoute,
    );
  }
}
