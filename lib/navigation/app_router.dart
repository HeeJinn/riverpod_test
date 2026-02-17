import 'package:go_router/go_router.dart';
import 'package:riverpod_test/screens/first_screen.dart';
import 'package:riverpod_test/screens/second_screen.dart';

final appRouter = GoRouter(
  initialLocation: FirstScreen.routeName,
  routes: [
    GoRoute(
      path: FirstScreen.routeName,
      builder: (context, state) => const FirstScreen(),
    ),
    GoRoute(
      path: SecondScreen.routeName,
      builder: (context, state) => const SecondScreen(),
    ),
  ],
);
