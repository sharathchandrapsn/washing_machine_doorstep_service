import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:washing_machine_doorstep_service/app/theme.dart';
import 'package:washing_machine_doorstep_service/content/owner_profile.dart';
import 'package:washing_machine_doorstep_service/shared/site_links.dart';

class SiteFooter extends ConsumerWidget {
  const SiteFooter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(ownerProfileProvider);
    final router = GoRouter.of(context);
    final wide =
        MediaQuery.sizeOf(context).width >= ShopLayout.desktopBreakpoint;

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: ShopColors.ink.withValues(alpha: 0.14)),
        ),
      ),
      child: ListenableBuilder(
        listenable: router.routerDelegate,
        builder: (context, _) {
          final path = router.state.uri.path;
          final identity = _Identity(profile: profile);
          final contact = _Contact(profile: profile);
          final links = _FooterLinks(path: path);

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: ShopLayout.maxContentWidth,
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  wide ? 40 : 20,
                  28,
                  wide ? 40 : 20,
                  32,
                ),
                child: wide
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 5, child: identity),
                          const SizedBox(width: 32),
                          Expanded(flex: 4, child: contact),
                          const SizedBox(width: 32),
                          Expanded(flex: 3, child: links),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          identity,
                          const SizedBox(height: 20),
                          contact,
                          const SizedBox(height: 20),
                          links,
                        ],
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Identity extends StatelessWidget {
  const _Identity({required this.profile});

  final OwnerProfile profile;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(profile.shopName, style: text.titleLarge),
        const SizedBox(height: 8),
        Text(profile.ownerName, style: text.bodyLarge),
        const SizedBox(height: 8),
        Text(profile.address, style: text.bodyMedium),
        const SizedBox(height: 4),
        Text(profile.hours.label, style: text.bodyMedium),
      ],
    );
  }
}

class _Contact extends StatelessWidget {
  const _Contact({required this.profile});

  final OwnerProfile profile;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FooterLink(
          label: profile.phoneDisplay,
          onPressed: () {
            launchUrl(profile.phoneUri);
          },
        ),
        const SizedBox(height: 4),
        _FooterLink(
          label: profile.email,
          onPressed: () {
            launchUrl(profile.emailUri);
          },
        ),
        const SizedBox(height: 16),
        Text('Service areas', style: text.labelMedium),
        const SizedBox(height: 4),
        Text(profile.areas.join(', '), style: text.bodyMedium),
      ],
    );
  }
}

class _FooterLinks extends StatelessWidget {
  const _FooterLinks({required this.path});

  final String path;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: [
        for (final destination in shopDestinations)
          ShopNavLink(
            label: destination.label,
            path: destination.path,
            selected: isShopPathSelected(path, destination.path),
          ),
      ],
    );
  }
}

class _FooterLink extends StatelessWidget {
  const _FooterLink({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: ShopColors.accent,
        padding: const EdgeInsets.symmetric(vertical: 12),
        minimumSize: const Size(0, 48),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        alignment: Alignment.centerLeft,
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: ShopColors.accent,
          decoration: TextDecoration.underline,
          decorationColor: ShopColors.accent,
        ),
      ),
    );
  }
}
