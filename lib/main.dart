import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:riverpod_test/models/todo_model.dart';
import 'package:riverpod_test/navigation/app_router.dart';
import 'package:riverpod_test/providers/shared_pref_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  await Hive.initFlutter(); // Initialize Hive for Flutter
  Hive.registerAdapter(TodoAdapter()); // Register your Hive adapter(s)
  await Hive.openBox<Todo>(
    'todoBox',
  ); // Open a typed Hive box (improves safety)

  runApp(
    ProviderScope(
      overrides: [sharedPrefsProvider.overrideWithValue(prefs)],
      child: const RiverPodApp(),
    ),
  );
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
