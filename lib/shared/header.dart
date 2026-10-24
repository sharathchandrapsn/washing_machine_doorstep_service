import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:washing_machine_doorstep_service/app/theme.dart';
import 'package:washing_machine_doorstep_service/content/owner_profile.dart';
import 'package:washing_machine_doorstep_service/shared/buttons.dart';
import 'package:washing_machine_doorstep_service/shared/site_links.dart';

class SiteHeader extends ConsumerStatefulWidget {
  const SiteHeader({super.key});

  @override
  ConsumerState<SiteHeader> createState() => _SiteHeaderState();
}

class _SiteHeaderState extends ConsumerState<SiteHeader> {
  GoRouter? _router;
  var _menuOpen = false;
  var _path = ShopPaths.home;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final router = GoRouter.of(context);
    if (!identical(router, _router)) {
      _router?.routerDelegate.removeListener(_onRoute);
      _router = router;
      router.routerDelegate.addListener(_onRoute);
    }
    _path = router.state.uri.path;
  }

  void _onRoute() {
    final next = _router?.state.uri.path;
    if (!mounted || next == null || next == _path) {
      return;
    }
    setState(() {
      _path = next;
      _menuOpen = false;
    });
  }

  List<Widget> _navLinks({required bool inMenu}) {
    return [
      for (final destination in shopDestinations) ...[
        ShopNavLink(
          label: destination.label,
          path: destination.path,
          selected: isShopPathSelected(_path, destination.path),
          stretch: inMenu,
          onNavigate: inMenu ? () => setState(() => _menuOpen = false) : null,
        ),
        if (destination.path == ShopPaths.home) ...[
          AnchorNavLink(label: 'About', onPressed: _openAbout, stretch: inMenu),
          AnchorNavLink(label: 'FAQ', onPressed: _openFaq, stretch: inMenu),
        ],
      ],
    ];
  }

  void _openAbout() => _openAnchor(openAbout);

  void _openFaq() => _openAnchor(openFaq);

  void _openAnchor(void Function(BuildContext context) open) {
    if (_menuOpen) {
      setState(() => _menuOpen = false);
    }
    open(context);
  }

  @override
  void dispose() {
    _router?.routerDelegate.removeListener(_onRoute);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(ownerProfileProvider);
    final wide =
        MediaQuery.sizeOf(context).width >= ShopLayout.desktopBreakpoint;
    final showMenu = !wide && _menuOpen;

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: ShopColors.ink.withValues(alpha: 0.14)),
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: ShopLayout.maxContentWidth,
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              wide ? 40 : 20,
              12,
              wide ? 40 : 20,
              12,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(child: _ShopName(name: profile.shopName)),
                    if (wide)
                      ..._navLinks(inMenu: false)
                    else
                      IconButton(
                        tooltip: showMenu ? 'Close menu' : 'Menu',
                        onPressed: () => setState(() => _menuOpen = !_menuOpen),
                        color: ShopColors.ink,
                        iconSize: 24,
                        constraints: const BoxConstraints(
                          minWidth: 48,
                          minHeight: 48,
                        ),
                        icon: Icon(showMenu ? Icons.close : Icons.menu),
                      ),
                    const SizedBox(width: 8),
                    ShopButton(
                      label: 'Call',
                      onPressed: () {
                        launchUrl(profile.phoneUri);
                      },
                    ),
                  ],
                ),
                if (showMenu) ...[
                  const SizedBox(height: 8),
                  for (final link in _navLinks(inMenu: true)) link,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ShopName extends StatelessWidget {
  const _ShopName({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton(
        onPressed: () => context.go(ShopPaths.home),
        style: TextButton.styleFrom(
          foregroundColor: ShopColors.ink,
          padding: const EdgeInsets.symmetric(vertical: 8),
          minimumSize: const Size(0, 48),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          alignment: Alignment.centerLeft,
        ),
        child: Text(
          name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}
