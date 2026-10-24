import 'package:flutter/material.dart';
import 'package:flutter_easy_seo/flutter_easy_seo.dart';
import 'package:washing_machine_doorstep_service/app/theme.dart';

/// A single column with an optional heading.
class SectionFrame extends StatelessWidget {
  const SectionFrame({super.key, required this.child, this.title});

  final String? title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final heading = title;
    final wide =
        MediaQuery.sizeOf(context).width >= ShopLayout.desktopBreakpoint;
    final text = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (heading != null) ...[
          Text(
            heading,
            style: wide ? text.headlineMedium : text.headlineSmall,
          ).easySeoH2,
          const SizedBox(height: 16),
        ],
        child,
      ],
    );
  }
}
