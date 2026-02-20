import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_test/navigation/app_router.dart';

void main() {
  runApp(const ProviderScope(child: RiverPodApp()));
}

class RiverPodApp extends StatelessWidget {
  const RiverPodApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      theme: ThemeData(useMaterial3: true),
    );
  }
}