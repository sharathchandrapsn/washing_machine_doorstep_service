import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:washing_machine_doorstep_service/app/app.dart';
import 'package:washing_machine_doorstep_service/app/router.dart';
import 'package:washing_machine_doorstep_service/content/owner_profile.dart';
import 'package:washing_machine_doorstep_service/shared/footer.dart';
import 'package:washing_machine_doorstep_service/shared/site_links.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('route shells show a plain title', (tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    tester.view.physicalSize = const Size(1280, 1100);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const ClearCycleApp(),
      ),
    );
    await tester.pump();

    expect(find.text('Sri Sai Durga Enterprises'), findsWidgets);
    expect(find.text('Home'), findsWidgets);

    container.read(routerProvider).go('/top-load');
    await tester.pumpAndSettle();
    expect(find.text('Top-load'), findsOneWidget);
    expect(_selectedLabels(), contains('Top load'));

    container.read(routerProvider).go('/front-load');
    await tester.pumpAndSettle();
    expect(find.text('Front-load'), findsOneWidget);
    expect(_selectedLabels(), contains('Front load'));

    container.read(routerProvider).go('/contact');
    await tester.pumpAndSettle();
    expect(find.text('Contact'), findsWidgets);
    expect(_selectedLabels(), contains('Contact'));

    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('header keeps the call button on a medium screen', (
    tester,
  ) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    tester.view.physicalSize = const Size(900, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const ClearCycleApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    final calls = find.text('Call');
    expect(calls, findsNWidgets(3));
    expect(find.text('Contact'), findsWidgets);
    for (var index = 0; index < calls.evaluate().length; index++) {
      expect(tester.getRect(calls.at(index)).right, lessThanOrEqualTo(900));
    }

    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('narrow header collapses links into a menu', (tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    tester.view.physicalSize = const Size(390, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const ClearCycleApp(),
      ),
    );
    await tester.pump();

    expect(find.byTooltip('Menu'), findsOneWidget);
    expect(find.text('V. Rama Swamy'), findsOneWidget);
    expect(find.text('vallala.ramaswami@gmail.com'), findsNWidgets(2));

    await tester.tap(find.byTooltip('Menu'));
    await tester.pumpAndSettle();

    expect(find.byTooltip('Close menu'), findsOneWidget);
    expect(find.text('Top load'), findsNWidgets(3));

    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('about link scrolls on home and anchors from another route', (
    tester,
  ) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    tester.view.physicalSize = const Size(1280, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const ClearCycleApp(),
      ),
    );
    await tester.pumpAndSettle();

    final aboutCopy = find.textContaining('person who comes to the house');
    expect(aboutCopy, findsOneWidget);
    expect(tester.getTopLeft(aboutCopy).dy, greaterThan(900));

    await tester.tap(find.widgetWithText(TextButton, 'About'));
    await tester.pumpAndSettle();
    expect(tester.getTopLeft(aboutCopy).dy, lessThan(700));

    container.read(routerProvider).go('/contact');
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'About'));
    await tester.pumpAndSettle();

    final uri = container.read(routerProvider).state.uri;
    expect(uri.path, '/');
    expect(uri.fragment, 'about');
    expect(aboutCopy, findsOneWidget);
    expect(tester.getTopLeft(aboutCopy).dy, lessThan(700));

    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('faq link scrolls on home and the first answer starts open', (
    tester,
  ) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    tester.view.physicalSize = const Size(1280, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const ClearCycleApp(),
      ),
    );
    await tester.pumpAndSettle();

    final firstAnswer = find.textContaining('He services all brands');
    expect(tester.getSize(firstAnswer).height, greaterThan(0));
    final tiles = tester.widgetList<ExpansionTile>(find.byType(ExpansionTile));
    expect(tiles.first.initiallyExpanded, isTrue);
    expect(tiles.skip(1).every((tile) => !tile.initiallyExpanded), isTrue);

    await tester.tap(find.widgetWithText(TextButton, 'FAQ'));
    await tester.pumpAndSettle();
    expect(tester.getTopLeft(firstAnswer).dy, lessThan(700));

    container.read(routerProvider).go('/contact');
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'FAQ'));
    await tester.pumpAndSettle();

    final uri = container.read(routerProvider).state.uri;
    expect(uri.path, '/');
    expect(uri.fragment, 'faq');
    expect(tester.getSize(firstAnswer).height, greaterThan(0));

    await tester.pumpWidget(const SizedBox.shrink());
  });

  test('profile builds the whatsapp and maps links', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final profile = container.read(ownerProfileProvider);

    expect(
      profile.whatsappUri.toString(),
      'https://wa.me/919390495672?text=Hello+Sri+Sai+Durga+Enterprises.',
    );
    expect(profile.mapsUri.host, 'www.google.com');
    expect(profile.mapsUri.path, '/maps/search/');
    expect(profile.mapsUri.queryParameters['api'], '1');
    expect(profile.mapsUri.queryParameters['query'], profile.address);
  });

  testWidgets('contact form rejects a short phone and then attempts WhatsApp', (
    tester,
  ) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    tester.view.physicalSize = const Size(1280, 1600);
    const channel = MethodChannel('plugins.flutter.io/url_launcher');
    String? launchedUrl;
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(channel, (
      call,
    ) async {
      if (call.method == 'launch') {
        launchedUrl = (call.arguments as Map)['url'] as String;
      }
      return true;
    });
    addTearDown(() {
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        channel,
        null,
      );
    });
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const ClearCycleApp(),
      ),
    );
    container.read(routerProvider).go('/contact');
    await tester.pumpAndSettle();

    await tester.tap(find.text('Send on WhatsApp'));
    await tester.pump();
    expect(find.text('Enter your name.'), findsOneWidget);
    expect(find.text('Enter your phone number.'), findsOneWidget);

    await tester.enterText(find.widgetWithText(TextField, 'Name'), 'Meera');
    await tester.enterText(find.widgetWithText(TextField, 'Phone'), '12345');
    await tester.tap(find.text('Send on WhatsApp'));
    await tester.pump();
    expect(find.text('Enter your name.'), findsNothing);
    expect(find.text('Enter a 10-digit phone number.'), findsOneWidget);

    await tester.enterText(
      find.widgetWithText(TextField, 'Phone'),
      '9000012345',
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'Problem'),
      'It will not spin.',
    );
    await tester.tap(find.text('Send on WhatsApp'));
    await tester.pumpAndSettle();
    expect(find.text('WhatsApp opened with your note.'), findsOneWidget);
    expect(launchedUrl, contains('https://wa.me/919390495672'));
    expect(launchedUrl, contains('Meera'));
    expect(launchedUrl, contains('9000012345'));
    expect(launchedUrl, contains('It+will+not+spin'));

    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('pages fit at phone and desktop widths', (tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    Future<void> show(Size size, String path) async {
      tester.view.physicalSize = size;
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const ClearCycleApp(),
        ),
      );
      container.read(routerProvider).go(path);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    }

    for (final path in const ['/', '/top-load', '/front-load', '/contact']) {
      await show(const Size(390, 844), path);
      await show(const Size(1280, 900), path);
    }

    tester.view.physicalSize = const Size(390, 844);
    container.read(routerProvider).go('/');
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Menu'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(
      tester.getSize(find.byTooltip('Close menu')).height,
      greaterThanOrEqualTo(48),
    );
    expect(
      tester.getSize(find.widgetWithText(TextButton, 'About')).height,
      greaterThanOrEqualTo(48),
    );
    expect(
      tester.getSize(find.byType(FilledButton).first).height,
      greaterThanOrEqualTo(48),
    );

    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('the footer sits at the end of the page scroll', (tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1280, 900);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const ClearCycleApp(),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    final footer = find.byType(SiteFooter);
    expect(tester.getTopLeft(footer).dy, greaterThan(900));

    final position = homeScrollController.position;
    expect(position.maxScrollExtent, greaterThan(0));
    position.jumpTo(position.maxScrollExtent);
    await tester.pump();

    expect(tester.getTopLeft(footer).dy, lessThan(900));
    final hours = find.descendant(
      of: footer,
      matching: find.textContaining('Monday–Saturday 9:00 AM–7:00 PM'),
    );
    expect(tester.getRect(hours).bottom, lessThanOrEqualTo(900));

    await tester.pumpWidget(const SizedBox.shrink());
  });
}

Set<String> _selectedLabels() {
  return find
      .byType(Semantics)
      .evaluate()
      .map((element) {
        final widget = element.widget;
        if (widget is! Semantics || widget.properties.selected != true) {
          return null;
        }
        return widget.properties.label;
      })
      .whereType<String>()
      .toSet();
}
