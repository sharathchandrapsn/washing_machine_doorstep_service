import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:washing_machine_doorstep_service/app/router.dart';
import 'package:washing_machine_doorstep_service/app/theme.dart';
import 'package:washing_machine_doorstep_service/content/owner_profile.dart';

class ClearCycleApp extends ConsumerWidget {
  const ClearCycleApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shopName = ref.watch(ownerProfileProvider).shopName;
    return MaterialApp.router(
      title: shopName,
      theme: buildClearCycleTheme(),
      routerConfig: ref.watch(routerProvider),
      debugShowCheckedModeBanner: false,
    );
  }
}
