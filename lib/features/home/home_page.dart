import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:washing_machine_doorstep_service/content/owner_profile.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shopName = ref.watch(ownerProfileProvider).shopName;
    return Text(shopName, style: Theme.of(context).textTheme.headlineLarge);
  }
}
