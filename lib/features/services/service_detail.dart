import 'package:flutter/material.dart';
import 'package:flutter_easy_seo/flutter_easy_seo.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:washing_machine_doorstep_service/app/theme.dart';
import 'package:washing_machine_doorstep_service/content/owner_profile.dart';
import 'package:washing_machine_doorstep_service/shared/buttons.dart';
import 'package:washing_machine_doorstep_service/shared/section_frame.dart';

class ServiceDetail extends StatelessWidget {
  const ServiceDetail({
    super.key,
    required this.service,
    required this.brandsLine,
    required this.phoneUri,
  });

  final MachineService service;
  final String brandsLine;
  final Uri phoneUri;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final wide =
        MediaQuery.sizeOf(context).width >= ShopLayout.desktopBreakpoint;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          service.pageTitle,
          style: wide ? text.headlineLarge : text.headlineMedium,
        ).easySeoH1,
        const SizedBox(height: 20),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: Text(service.intro, style: text.bodyLarge).easySeoP,
        ),
        const SizedBox(height: 40),
        SectionFrame(
          title: 'Symptoms',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var index = 0; index < service.faults.length; index++) ...[
                if (index > 0) const SizedBox(height: 20),
                _FaultBlock(fault: service.faults[index]),
              ],
            ],
          ),
        ),
        const SizedBox(height: 40),
        SectionFrame(
          title: 'What the visit includes',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final line in service.visitIncludes) ...[
                Text(line, style: text.bodyLarge).easySeoP,
                const SizedBox(height: 8),
              ],
            ],
          ),
        ),
        const SizedBox(height: 40),
        SectionFrame(
          title: 'Brands',
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: Text(brandsLine, style: text.bodyLarge).easySeoP,
          ),
        ),
        const SizedBox(height: 36),
        ShopButton(
          label: 'Call',
          onPressed: () {
            launchUrl(phoneUri);
          },
        ),
      ],
    );
  }
}

class _FaultBlock extends StatelessWidget {
  const _FaultBlock({required this.fault});

  final FaultSymptoms fault;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(fault.fault, style: text.titleLarge).easySeoH3,
        const SizedBox(height: 8),
        for (final symptom in fault.symptoms)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text('– $symptom', style: text.bodyMedium).easySeoP,
          ),
      ],
    );
  }
}
