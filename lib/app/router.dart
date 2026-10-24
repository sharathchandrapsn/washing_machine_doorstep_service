import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:washing_machine_doorstep_service/app/shell.dart';
import 'package:washing_machine_doorstep_service/features/contact/contact_page.dart';
import 'package:washing_machine_doorstep_service/features/home/home_page.dart';
import 'package:washing_machine_doorstep_service/features/services/front_load_page.dart';
import 'package:washing_machine_doorstep_service/features/services/top_load_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    routes: [
      ShellRoute(
        builder: (context, state, child) => ShopShell(child: child),
        routes: [
          GoRoute(path: '/', builder: (context, state) => const HomePage()),
          GoRoute(
            path: '/top-load',
            builder: (context, state) => const TopLoadPage(),
          ),
          GoRoute(
            path: '/front-load',
            builder: (context, state) => const FrontLoadPage(),
          ),
          GoRoute(
            path: '/contact',
            builder: (context, state) => const ContactPage(),
          ),
        ],
      ),
    ],
  );

  ref.onDispose(router.dispose);
  return router;
});
