import 'package:flutter/material.dart';
import 'package:yum_quick/routes.dart';
import 'package:yum_quick_backend/yum_quick_backend.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await YumQuickBackend.initialize();

  runApp(MaterialApp.router(
    routerConfig: YumQuickRouter.router,
  ));
}
