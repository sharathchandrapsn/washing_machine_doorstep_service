import 'package:flutter/material.dart';
import 'package:flutter_easy_seo/flutter_easy_seo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:washing_machine_doorstep_service/app/seo.dart';
import 'package:washing_machine_doorstep_service/content/owner_profile.dart';
import 'package:washing_machine_doorstep_service/features/services/service_detail.dart';
import 'package:washing_machine_doorstep_service/shared/site_links.dart';

class FrontLoadPage extends ConsumerWidget {
  const FrontLoadPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(ownerProfileProvider);
    return EasySEOPage(
      key: const ValueKey(ShopPaths.frontLoad),
      title: '${profile.frontLoad.pageTitle} repair | ${profile.shopName}',
      description: profile.frontLoad.intro,
      child: ServiceDetail(
        service: profile.frontLoad,
        brandsLine: profile.brandsCopy,
        phoneUri: profile.phoneUri,
      ).easySeoSection(jsonLd: localBusinessJsonLd(profile)),
    );
  }
}
