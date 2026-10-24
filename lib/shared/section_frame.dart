import 'package:flutter/material.dart';

/// A single column with an optional heading. Pages do not use it yet.
class SectionFrame extends StatelessWidget {
  const SectionFrame({super.key, required this.child, this.title});

  final String? title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final heading = title;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (heading != null) ...[
          Text(heading, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 12),
        ],
        child,
      ],
    );
  }
}
