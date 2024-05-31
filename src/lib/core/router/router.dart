import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:src/core/router/router_info.dart';
import 'package:src/presentation/current_status/current_status_screen.dart';
import 'package:src/presentation/home/home_screen.dart';
import 'package:src/presentation/ignore_numbers/ignore_numbers_screen.dart';

part 'router.g.dart';

// このGlobalKeyは、GoRouterのインスタンスを取得するために必要です。
final _rootNavigatorKey = GlobalKey<NavigatorState>();

@Riverpod(keepAlive: true)
GoRouter goRouterController(GoRouterControllerRef ref) {
  return GoRouter(
    debugLogDiagnostics: true,
    // navigatorKeyとは、GoRouterのインスタンスを取得するために必要です。
    navigatorKey: _rootNavigatorKey,
    // initialLocationは、アプリの最初のルートを指定します。
    initialLocation: RouterInfo.home.path,
    routes: <RouteBase>[
      GoRoute(
        path: RouterInfo.home.path,
        builder: (context, state) {
          return const HomeScreen();
        },
      ),
      GoRoute(
        path: RouterInfo.ignoreNumbers.path,
        builder: (context, state) {
          return const IgnoreNumbersScreen();
        },
      ),
      GoRoute(
        path: RouterInfo.currentStatus.path,
        builder: (context, state) {
          return const CurrentStatusScreen();
        },
      ),
    ],
  );
}
