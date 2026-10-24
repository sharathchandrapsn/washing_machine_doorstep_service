import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:go_router/go_router.dart';
import 'package:washing_machine_doorstep_service/app/theme.dart';

abstract final class ShopPaths {
  static const home = '/';
  static const topLoad = '/top-load';
  static const frontLoad = '/front-load';
  static const contact = '/contact';
}

class ShopDestination {
  const ShopDestination({required this.label, required this.path});

  final String label;
  final String path;
}

const aboutFragment = 'about';
const faqFragment = 'faq';

final aboutSectionKey = GlobalKey(debugLabel: 'about');
final faqSectionKey = GlobalKey(debugLabel: 'faq');

final homeScrollController = ScrollController();

/// Scrolls when [key] is already on the home page. Otherwise opens `/#fragment`.
void openHomeAnchor(
  BuildContext context, {
  required GlobalKey key,
  required String fragment,
}) {
  if (key.currentContext != null) {
    scrollHomeTo(key);
    return;
  }
  context.go('/#$fragment');
}

void openAbout(BuildContext context) {
  openHomeAnchor(context, key: aboutSectionKey, fragment: aboutFragment);
}

void openFaq(BuildContext context) {
  openHomeAnchor(context, key: faqSectionKey, fragment: faqFragment);
}

void scrollToAboutSection() => scrollHomeTo(aboutSectionKey);

void scrollHomeTo(GlobalKey key) {
  final targetContext = key.currentContext;
  if (targetContext == null || !homeScrollController.hasClients) {
    return;
  }
  final object = targetContext.findRenderObject();
  if (object == null || !object.attached) {
    return;
  }
  final revealed = RenderAbstractViewport.of(object)
      .getOffsetToReveal(object, 0)
      .offset;
  final position = homeScrollController.position;
  final target = revealed.clamp(
    position.minScrollExtent,
    position.maxScrollExtent,
  );
  if ((position.pixels - target).abs() < 1) {
    return;
  }
  position.animateTo(
    target,
    duration: const Duration(milliseconds: 320),
    curve: Curves.easeOut,
  );
}

const shopDestinations = <ShopDestination>[
  ShopDestination(label: 'Home', path: ShopPaths.home),
  ShopDestination(label: 'Top load', path: ShopPaths.topLoad),
  ShopDestination(label: 'Front load', path: ShopPaths.frontLoad),
  ShopDestination(label: 'Contact', path: ShopPaths.contact),
];

bool isShopPathSelected(String location, String path) {
  final current = _normalize(location);
  final target = _normalize(path);
  return current == target;
}

String _normalize(String path) {
  if (path.isEmpty) {
    return ShopPaths.home;
  }
  if (path.length > 1 && path.endsWith('/')) {
    return path.substring(0, path.length - 1);
  }
  return path;
}

class AnchorNavLink extends StatelessWidget {
  const AnchorNavLink({
    super.key,
    required this.label,
    required this.onPressed,
    this.stretch = false,
  });

  final String label;
  final VoidCallback onPressed;
  final bool stretch;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: ExcludeSemantics(
        child: _NavHit(
          stretch: stretch,
          child: TextButton(
            onPressed: onPressed,
            style: _navStyle(color: ShopColors.ink, stretch: stretch),
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelLarge
                  ?.copyWith(color: ShopColors.ink),
            ),
          ),
        ),
      ),
    );
  }
}

class ShopNavLink extends StatelessWidget {
  const ShopNavLink({
    super.key,
    required this.label,
    required this.path,
    required this.selected,
    this.onNavigate,
    this.stretch = false,
  });

  final String label;
  final String path;
  final bool selected;
  final VoidCallback? onNavigate;
  final bool stretch;

  @override
  Widget build(BuildContext context) {
    final color = selected ? ShopColors.accent : ShopColors.ink;
    return Semantics(
      selected: selected,
      button: true,
      label: label,
      child: ExcludeSemantics(
        child: _NavHit(
          stretch: stretch,
          child: TextButton(
            onPressed: () {
              onNavigate?.call();
              context.go(path);
            },
            style: _navStyle(color: color, stretch: stretch),
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: color,
                decoration: selected ? TextDecoration.underline : null,
                decorationColor: ShopColors.accent,
                decorationThickness: 2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

ButtonStyle _navStyle({required Color color, required bool stretch}) {
  return TextButton.styleFrom(
    foregroundColor: color,
    minimumSize: const Size(48, 48),
    padding: const EdgeInsets.symmetric(horizontal: 8),
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    alignment: stretch ? Alignment.centerLeft : Alignment.center,
  );
}

class _NavHit extends StatelessWidget {
  const _NavHit({required this.stretch, required this.child});

  final bool stretch;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!stretch) {
      return child;
    }
    return SizedBox(width: double.infinity, height: 48, child: child);
  }
}
