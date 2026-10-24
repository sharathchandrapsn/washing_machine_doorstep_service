import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';

const _motion = Duration(milliseconds: 280);

/// Plays a short fade-up once. Skips it when the platform asks for reduced motion.
Widget fadeUpOnce(BuildContext context, Widget child) {
  if (MediaQuery.disableAnimationsOf(context)) {
    return child;
  }
  return child
      .animate()
      .fadeIn(duration: _motion, curve: Curves.easeOut)
      .moveY(begin: 12, end: 0);
}
