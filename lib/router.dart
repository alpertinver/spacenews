import 'package:spacenews/Screens/Myhomepage.dart';
import 'package:spacenews/Screens/hakkindascreen.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'Screens/detailednews.dart';
import 'Screens/launchespage.dart';

GoRouter Rotalar() {
  return GoRouter(
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return MyHomePage();
        },
        routes: <RouteBase>[
          GoRoute(
            path: 'hakkinda',
            builder: (BuildContext context, GoRouterState state) {
              return const HakkinPage();
            },
          ),
          GoRoute(
            path: 'detailednews',
            builder: (context, state) {
              return DetailednewsPage();
            },
          ),
          GoRoute(
            path: 'launches',
            builder: (context, state) {
              return LaunchesPage();
            },
          ),
        ],
      ),
    ],
  );
}
