import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'routes/app_router.dart';

class PlayerPathApp extends StatelessWidget {
  const PlayerPathApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'PlayerPath',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: AppRouter.router,
    );
  }
}
