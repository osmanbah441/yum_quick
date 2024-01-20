import 'package:flutter/material.dart';
import 'package:yum_quick/routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp.router(
    routerConfig: AppRouter.router,
    debugShowCheckedModeBanner: false,
  ));
}
