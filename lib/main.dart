import 'package:flutter/material.dart';
import 'package:yum_quick/routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await api.initializeApi(kDebugMode: true);

  runApp(MaterialApp.router(
    routerConfig: AppRouter.router,
    debugShowCheckedModeBanner: false,
  ));
}
