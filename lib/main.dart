import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import 'app.dart';
import 'core/datasources/hive/hive_init.dart';
import 'dependency_initializer.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

    // device orientation
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // initialize dependencies
  await init();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  await DatabaseInit.registerAdapters();
  await DatabaseInit.initFlutter(appDocumentDir.path);

  runApp(const Intercess());
}