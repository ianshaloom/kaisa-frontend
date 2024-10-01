import 'package:flutter/material.dart';

import 'router/router.dart';
import 'theme/color_schemes.dart';
import 'theme/theme.dart';

class KaisaApp extends StatelessWidget {
  const KaisaApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = MaterialTheme();

    return MaterialApp.router(
      theme: ThemeData(
          useMaterial3: true,
          colorScheme: lightColorScheme,
          fontFamily: 'montserrat'),
      darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: darkColorScheme,
          fontFamily: 'montserrat'),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      routerDelegate: router.routerDelegate,
      routeInformationParser: router.routeInformationParser,
      routeInformationProvider: router.routeInformationProvider,
    );
  }
}
