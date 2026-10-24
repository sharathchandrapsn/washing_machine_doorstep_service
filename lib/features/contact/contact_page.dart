import 'package:flutter/material.dart';
import 'package:flutter_easy_seo/flutter_easy_seo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:washing_machine_doorstep_service/app/seo.dart';
import 'package:washing_machine_doorstep_service/app/theme.dart';
import 'package:washing_machine_doorstep_service/content/owner_profile.dart';
import 'package:washing_machine_doorstep_service/features/contact/contact_panel.dart';
import 'package:washing_machine_doorstep_service/shared/site_links.dart';

class ContactPage extends ConsumerWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(ownerProfileProvider);
    final text = Theme.of(context).textTheme;
    final wide =
        MediaQuery.sizeOf(context).width >= ShopLayout.desktopBreakpoint;
    return EasySEOPage(
      key: const ValueKey(ShopPaths.contact),
      title: 'Contact | ${profile.shopName}',
      description: profile.contactCopy,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contact',
            style: wide ? text.headlineLarge : text.headlineMedium,
          ).easySeoH1,
          const SizedBox(height: 28),
          ContactPanel(wide: wide),
        ],
      ).easySeoSection(jsonLd: localBusinessJsonLd(profile)),
    );
  }
}
