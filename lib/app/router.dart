import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:washing_machine_doorstep_service/app/shell.dart';
import 'package:washing_machine_doorstep_service/features/contact/contact_page.dart';
import 'package:washing_machine_doorstep_service/features/home/home_page.dart';
import 'package:washing_machine_doorstep_service/features/services/front_load_page.dart';
import 'package:washing_machine_doorstep_service/features/services/top_load_page.dart';
import 'package:washing_machine_doorstep_service/shared/site_links.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    routes: [
      ShellRoute(
        builder: (context, state, child) => ShopShell(child: child),
        routes: [
          GoRoute(
            path: ShopPaths.home,
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: ShopPaths.topLoad,
            builder: (context, state) => const TopLoadPage(),
          ),
          GoRoute(
            path: ShopPaths.frontLoad,
            builder: (context, state) => const FrontLoadPage(),
          ),
          GoRoute(
            path: ShopPaths.contact,
            builder: (context, state) => const ContactPage(),
          ),
        ],
      ),
    ],
  );

  ref.onDispose(router.dispose);
  return router;
});
