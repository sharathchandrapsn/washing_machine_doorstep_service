import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:washing_machine_doorstep_service/app/app.dart';
import 'package:washing_machine_doorstep_service/app/router.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('route shells show a plain title', (tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const ClearCycleApp(),
      ),
    );
    await tester.pump();

    expect(find.text('ClearCycle Repairs'), findsOneWidget);

    container.read(routerProvider).go('/top-load');
    await tester.pumpAndSettle();
    expect(find.text('Top-load'), findsOneWidget);

    container.read(routerProvider).go('/front-load');
    await tester.pumpAndSettle();
    expect(find.text('Front-load'), findsOneWidget);

    container.read(routerProvider).go('/contact');
    await tester.pumpAndSettle();
    expect(find.text('Contact'), findsOneWidget);
  });
}
