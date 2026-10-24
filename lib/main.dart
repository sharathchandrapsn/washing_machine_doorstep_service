import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easy_seo/flutter_easy_seo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';
import 'package:washing_machine_doorstep_service/app/app.dart';
import 'package:washing_machine_doorstep_service/app/seo.dart';
import 'package:washing_machine_doorstep_service/shared/site_links.dart';

void main() {
  usePathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  EasySEOManager.instance.init(
    baseUrl: siteBaseUrl,
    pages: [
      ShopPaths.home,
      ShopPaths.topLoad,
      ShopPaths.frontLoad,
      ShopPaths.contact,
    ],
    enableInteractiveMode: kDebugMode,
    pathProvider: (context) {
      return GoRouter.maybeOf(context)?.routerDelegate.currentConfiguration.uri
          .toString();
    },
  );
  runApp(const ProviderScope(child: ClearCycleApp()));
}
