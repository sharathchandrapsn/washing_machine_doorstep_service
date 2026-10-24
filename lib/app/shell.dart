import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:washing_machine_doorstep_service/app/theme.dart';
import 'package:washing_machine_doorstep_service/shared/footer.dart';
import 'package:washing_machine_doorstep_service/shared/header.dart';
import 'package:washing_machine_doorstep_service/shared/site_links.dart';

/// The header stays put. The page and the footer share one scroll, so the
/// footer is the last block on the page.
class ShopShell extends StatefulWidget {
  const ShopShell({super.key, required this.child});

  final Widget child;

  @override
  State<ShopShell> createState() => _ShopShellState();
}

class _ShopShellState extends State<ShopShell> {
  GoRouter? _router;
  String? _path;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final router = GoRouter.of(context);
    if (!identical(router, _router)) {
      _router?.routerDelegate.removeListener(_onRoute);
      _router = router;
      router.routerDelegate.addListener(_onRoute);
    }
    _syncPath();
  }

  @override
  void dispose() {
    _router?.routerDelegate.removeListener(_onRoute);
    super.dispose();
  }

  void _onRoute() {
    if (!mounted) {
      return;
    }
    _syncPath();
  }

  void _syncPath() {
    final path = _router?.state.uri.path;
    if (path == null) {
      return;
    }
    if (_path != null && _path != path && homeScrollController.hasClients) {
      homeScrollController.jumpTo(0);
    }
    _path = path;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SiteHeader(),
          Expanded(
            child: SingleChildScrollView(
              controller: homeScrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _PageSlot(child: widget.child),
                  const SiteFooter(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PageSlot extends StatelessWidget {
  const _PageSlot({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final desktop = constraints.maxWidth >= ShopLayout.desktopBreakpoint;
        final contentWidth = desktop
            ? constraints.maxWidth
                  .clamp(0, ShopLayout.maxContentWidth)
                  .toDouble()
            : constraints.maxWidth;

        return Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: contentWidth,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                desktop ? 40 : 20,
                desktop ? 48 : 32,
                desktop ? 40 : 20,
                desktop ? 40 : 32,
              ),
              child: child,
            ),
          ),
        );
      },
    );
  }
}
