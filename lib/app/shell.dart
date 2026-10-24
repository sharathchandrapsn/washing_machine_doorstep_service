import 'package:flutter/material.dart';
import 'package:washing_machine_doorstep_service/app/theme.dart';
import 'package:washing_machine_doorstep_service/shared/footer.dart';
import 'package:washing_machine_doorstep_service/shared/header.dart';

/// Desktop keeps one centered column. Narrow widths use the full screen.
class ShopShell extends StatelessWidget {
  const ShopShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SiteHeader(),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final desktop =
                    constraints.maxWidth >= ShopLayout.desktopBreakpoint;
                final contentWidth = desktop
                    ? constraints.maxWidth
                          .clamp(0, ShopLayout.maxContentWidth)
                          .toDouble()
                    : constraints.maxWidth;

                return Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    width: contentWidth,
                    height: constraints.maxHeight,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        desktop ? 40 : 20,
                        desktop ? 36 : 24,
                        desktop ? 40 : 20,
                        24,
                      ),
                      child: child,
                    ),
                  ),
                );
              },
            ),
          ),
          const SiteFooter(),
        ],
      ),
    );
  }
}
