import 'package:flutter/material.dart';
import 'package:flutter_easy_seo/flutter_easy_seo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:washing_machine_doorstep_service/app/seo.dart';
import 'package:washing_machine_doorstep_service/app/theme.dart';
import 'package:washing_machine_doorstep_service/content/owner_profile.dart';
import 'package:washing_machine_doorstep_service/features/contact/contact_panel.dart';
import 'package:washing_machine_doorstep_service/shared/buttons.dart';
import 'package:washing_machine_doorstep_service/shared/section_frame.dart';
import 'package:washing_machine_doorstep_service/shared/section_motion.dart';
import 'package:washing_machine_doorstep_service/shared/site_links.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(ownerProfileProvider);
    final wide =
        MediaQuery.sizeOf(context).width >= ShopLayout.desktopBreakpoint;
    final gap = SizedBox(height: wide ? 64 : 48);

    return EasySEOPage(
      key: const ValueKey(ShopPaths.home),
      title: '${profile.shopName} | ${profile.heroHeadline}',
      description: profile.intro,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          fadeUpOnce(context, _Hero(profile: profile, wide: wide)),
          gap,
          fadeUpOnce(context, _TrustRow(profile: profile, wide: wide)),
          gap,
          fadeUpOnce(context, _VisitSteps(profile: profile, wide: wide)),
          gap,
          fadeUpOnce(context, _ServiceCards(profile: profile, wide: wide)),
          gap,
          fadeUpOnce(context, _BrandTiles(profile: profile, wide: wide)),
          gap,
          fadeUpOnce(context, _CommonFaults(profile: profile, wide: wide)),
          gap,
          fadeUpOnce(context, _Gallery(profile: profile, wide: wide)),
          gap,
          fadeUpOnce(
            context,
            _AboutSection(key: aboutSectionKey, profile: profile, wide: wide),
          ),
          gap,
          fadeUpOnce(
            context,
            _FaqSection(key: faqSectionKey, profile: profile),
          ),
          gap,
          fadeUpOnce(
            context,
            SectionFrame(
              title: 'Contact',
              child: ContactPanel(wide: wide),
            ),
          ),
        ],
      ).easySeoSection(jsonLd: localBusinessJsonLd(profile)),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({required this.profile, required this.wide});

  final OwnerProfile profile;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Text(
            profile.heroHeadline,
            style: wide ? text.displayMedium : text.headlineMedium,
          ).easySeoH1,
        ),
        const SizedBox(height: 16),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: Text(profile.intro, style: text.bodyLarge).easySeoP,
        ),
        const SizedBox(height: 16),
        Text(
          profile.machineLayoutsLine,
          style: text.titleMedium?.copyWith(color: ShopColors.accent),
        ).easySeoP,
        const SizedBox(height: 24),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            ShopButton(
              label: 'Call',
              onPressed: () {
                launchUrl(profile.phoneUri);
              },
            ),
            TextButton(
              onPressed: () => context.go(ShopPaths.contact),
              style: TextButton.styleFrom(
                foregroundColor: ShopColors.ink,
                minimumSize: const Size(48, 48),
                padding: const EdgeInsets.symmetric(horizontal: 18),
                textStyle: text.labelLarge,
              ),
              child: const Text('Contact'),
            ),
          ],
        ),
      ],
    );
  }
}

class _TrustRow extends StatelessWidget {
  const _TrustRow({required this.profile, required this.wide});

  final OwnerProfile profile;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    final facts = <Widget>[
      _YearsFact(years: profile.yearsFact),
      if (profile.doorstepVisits) _DoorstepFact(label: profile.doorstepFact),
      _BrandsFact(
        label: profile.brandsServedLabel,
        brands: profile.brandsServed,
      ),
    ];

    return SectionFrame(
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.symmetric(
            horizontal: BorderSide(
              color: ShopColors.ink.withValues(alpha: 0.14),
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: wide
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var index = 0; index < facts.length; index++)
                      Expanded(
                        child: _TrustCell(
                          showRule: index > 0,
                          child: facts[index],
                        ),
                      ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var index = 0; index < facts.length; index++) ...[
                      if (index > 0) const SizedBox(height: 16),
                      facts[index],
                    ],
                  ],
                ),
        ),
      ),
    );
  }
}

class _TrustCell extends StatelessWidget {
  const _TrustCell({required this.child, required this.showRule});

  final Widget child;
  final bool showRule;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: showRule
            ? Border(
                left: BorderSide(color: ShopColors.ink.withValues(alpha: 0.14)),
              )
            : null,
      ),
      child: Padding(
        padding: EdgeInsets.only(left: showRule ? 20 : 0, right: 20),
        child: child,
      ),
    );
  }
}

class _YearsFact extends StatelessWidget {
  const _YearsFact({required this.years});

  final String years;

  @override
  Widget build(BuildContext context) {
    return Text(
      years,
      style: Theme.of(context).textTheme.headlineMedium,
    ).easySeoH3;
  }
}

class _DoorstepFact extends StatelessWidget {
  const _DoorstepFact({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: Theme.of(context).textTheme.headlineSmall,
    ).easySeoH3;
  }
}

class _BrandsFact extends StatelessWidget {
  const _BrandsFact({required this.label, required this.brands});

  final String label;
  final String brands;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: text.labelMedium),
        const SizedBox(height: 6),
        Text(brands, style: text.bodyLarge).easySeoP,
      ],
    );
  }
}

class _VisitSteps extends StatelessWidget {
  const _VisitSteps({required this.profile, required this.wide});

  final OwnerProfile profile;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    final steps = [
      for (var index = 0; index < profile.visitSteps.length; index++)
        _Step(number: index + 1, step: profile.visitSteps[index]),
    ];

    return SectionFrame(
      child: wide
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var index = 0; index < steps.length; index++)
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: index == 0 ? 0 : 20),
                      child: steps[index],
                    ),
                  ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var index = 0; index < steps.length; index++) ...[
                  if (index > 0) const SizedBox(height: 24),
                  steps[index],
                ],
              ],
            ),
    );
  }
}

class _ServiceCards extends StatelessWidget {
  const _ServiceCards({required this.profile, required this.wide});

  final OwnerProfile profile;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    final cards = [
      _ServiceCard(service: profile.topLoad, path: ShopPaths.topLoad),
      _ServiceCard(service: profile.frontLoad, path: ShopPaths.frontLoad),
    ];

    if (wide) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var index = 0; index < cards.length; index++)
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: index == 0 ? 0 : 20),
                child: cards[index],
              ),
            ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var index = 0; index < cards.length; index++) ...[
          if (index > 0) const SizedBox(height: 16),
          cards[index],
        ],
      ],
    );
  }
}

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({required this.service, required this.path});

  final MachineService service;
  final String path;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: ShopColors.ink.withValues(alpha: 0.14)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(service.cardTitle, style: text.headlineSmall).easySeoH3,
            const SizedBox(height: 8),
            Text(service.summary, style: text.bodyLarge).easySeoP,
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => context.go(path),
              style: TextButton.styleFrom(
                foregroundColor: ShopColors.accent,
                minimumSize: const Size(0, 48),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                alignment: Alignment.centerLeft,
              ),
              child: Text(
                'See the faults',
                style: text.labelLarge?.copyWith(
                  color: ShopColors.accent,
                  decoration: TextDecoration.underline,
                  decorationColor: ShopColors.accent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BrandTiles extends StatelessWidget {
  const _BrandTiles({required this.profile, required this.wide});

  final OwnerProfile profile;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return SectionFrame(
      title: 'Brands',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TileGrid(
            columns: wide ? profile.brands.length : 2,
            children: [
              for (final brand in profile.brands) _NameTile(name: brand),
            ],
          ),
          const SizedBox(height: 16),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Text(profile.brandsNote, style: text.bodyLarge).easySeoP,
          ),
        ],
      ),
    );
  }
}

class _NameTile extends StatelessWidget {
  const _NameTile({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: ShopColors.ink.withValues(alpha: 0.14)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
        child: Center(
          child: Text(
            name,
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class _CommonFaults extends StatelessWidget {
  const _CommonFaults({required this.profile, required this.wide});

  final OwnerProfile profile;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    return SectionFrame(
      title: 'Common faults',
      child: _TileGrid(
        columns: wide ? 2 : 1,
        gap: 20,
        children: [
          for (final fault in profile.commonFaults) _FaultTile(fault: fault),
        ],
      ),
    );
  }
}

class _FaultTile extends StatelessWidget {
  const _FaultTile({required this.fault});

  final CommonFault fault;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(fault.title, style: text.titleLarge).easySeoH3,
        const SizedBox(height: 8),
        Text(fault.checks, style: text.bodyMedium).easySeoP,
      ],
    );
  }
}

class _TileGrid extends StatelessWidget {
  const _TileGrid({
    required this.columns,
    required this.children,
    this.gap = 12,
  });

  final int columns;
  final List<Widget> children;
  final double gap;

  @override
  Widget build(BuildContext context) {
    final count = columns < 1 ? 1 : columns;
    final rows = <Widget>[];
    for (var start = 0; start < children.length; start += count) {
      final end = start + count > children.length
          ? children.length
          : start + count;
      final slice = children.sublist(start, end);
      rows.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var index = 0; index < count; index++)
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: index == 0 ? 0 : gap),
                  child: index < slice.length
                      ? slice[index]
                      : const SizedBox.shrink(),
                ),
              ),
          ],
        ),
      );
    }

    return Column(
      children: [
        for (var index = 0; index < rows.length; index++) ...[
          if (index > 0) SizedBox(height: gap),
          rows[index],
        ],
      ],
    );
  }
}

class _Gallery extends StatelessWidget {
  const _Gallery({required this.profile, required this.wide});

  final OwnerProfile profile;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    final items = profile.gallery;
    return SectionFrame(
      title: 'Gallery',
      child: wide
          ? LayoutBuilder(
              builder: (context, constraints) {
                const gap = 16.0;
                const columns = 3;
                final tileWidth =
                    (constraints.maxWidth - gap * (columns - 1)) / columns;
                return Wrap(
                  spacing: gap,
                  runSpacing: 20,
                  children: [
                    for (final item in items)
                      SizedBox(
                        width: tileWidth,
                        child: _GalleryCard(item: item),
                      ),
                  ],
                );
              },
            )
          : SizedBox(
              height: 320,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: items.length,
                separatorBuilder: (context, index) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  return SizedBox(
                    width: 220,
                    child: _GalleryCard(item: items[index]),
                  );
                },
              ),
            ),
    );
  }
}

class _GalleryCard extends StatelessWidget {
  const _GalleryCard({required this.item});

  final GalleryItem item;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 4 / 3,
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(color: ShopColors.ink.withValues(alpha: 0.14)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(1),
              child: Image.asset(
                item.asset,
                fit: BoxFit.cover,
                excludeFromSemantics: true,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          item.caption,
          style: Theme.of(context).textTheme.bodyMedium,
        ).easySeoP,
      ],
    );
  }
}

class _AboutSection extends StatefulWidget {
  const _AboutSection({super.key, required this.profile, required this.wide});

  final OwnerProfile profile;
  final bool wide;

  @override
  State<_AboutSection> createState() => _AboutSectionState();
}

class _AboutSectionState extends State<_AboutSection> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _revealIfAnchored());
  }

  void _revealIfAnchored() {
    if (!mounted) {
      return;
    }
    if (GoRouterState.of(context).uri.fragment != aboutFragment) {
      return;
    }
    scrollToAboutSection();
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final profile = widget.profile;
    final paragraphs = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (
          var index = 0;
          index < profile.aboutParagraphs.length;
          index++
        ) ...[
          if (index > 0) const SizedBox(height: 12),
          Text(profile.aboutParagraphs[index], style: text.bodyLarge).easySeoP,
        ],
      ],
    );
    final monogram = _Monogram(initials: profile.ownerInitials);

    return SectionFrame(
      title: 'About',
      child: widget.wide
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                monogram,
                const SizedBox(width: 28),
                Expanded(child: paragraphs),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [monogram, const SizedBox(height: 20), paragraphs],
            ),
    );
  }
}

class _Monogram extends StatelessWidget {
  const _Monogram({required this.initials});

  final String initials;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: SizedBox(
        width: 148,
        height: 148,
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(color: ShopColors.ink.withValues(alpha: 0.14)),
          ),
          child: Center(
            child: Text(
              initials,
              style: Theme.of(context).textTheme.displaySmall
                  ?.copyWith(color: ShopColors.accent),
            ),
          ),
        ),
      ),
    );
  }
}

class _Step extends StatelessWidget {
  const _Step({required this.number, required this.step});

  final int number;
  final VisitStep step;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$number',
          style: text.headlineMedium?.copyWith(color: ShopColors.accent),
        ),
        const SizedBox(height: 8),
        Text(step.title, style: text.titleLarge).easySeoH3,
        const SizedBox(height: 8),
        Text(step.detail, style: text.bodyMedium).easySeoP,
      ],
    );
  }
}

class _FaqSection extends StatefulWidget {
  const _FaqSection({super.key, required this.profile});

  final OwnerProfile profile;

  @override
  State<_FaqSection> createState() => _FaqSectionState();
}

class _FaqSectionState extends State<_FaqSection> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _revealIfAnchored());
  }

  void _revealIfAnchored() {
    if (!mounted) {
      return;
    }
    if (GoRouterState.of(context).uri.fragment != faqFragment) {
      return;
    }
    scrollHomeTo(faqSectionKey);
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final items = widget.profile.faq;
    final rule = BorderSide(color: ShopColors.ink.withValues(alpha: 0.14));
    return SectionFrame(
      title: 'FAQ',
      child:
          Column(
            children: [
              for (var index = 0; index < items.length; index++)
                ExpansionTile(
                  initiallyExpanded: index == 0,
                  tilePadding: EdgeInsets.zero,
                  minTileHeight: 48,
                  childrenPadding: const EdgeInsets.only(bottom: 20),
                  iconColor: ShopColors.ink,
                  collapsedIconColor: ShopColors.ink,
                  textColor: ShopColors.ink,
                  collapsedTextColor: ShopColors.ink,
                  shape: Border(bottom: rule),
                  collapsedShape: Border(bottom: rule),
                  expandedCrossAxisAlignment: CrossAxisAlignment.start,
                  title: Text(
                    items[index].question,
                    style: text.titleMedium,
                  ).easySeoH3,
                  children: [
                    Text(items[index].answer, style: text.bodyLarge).easySeoP,
                  ],
                ),
            ],
          ).easySeoFaq(
            items: [
              for (final item in items)
                EasySEOFaqItem(question: item.question, answer: item.answer),
            ],
          ),
    );
  }
}
