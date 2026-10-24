import 'package:flutter/material.dart';
import 'package:flutter_easy_seo/flutter_easy_seo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:washing_machine_doorstep_service/app/theme.dart';
import 'package:washing_machine_doorstep_service/content/owner_profile.dart';
import 'package:washing_machine_doorstep_service/features/contact/contact_form.dart';
import 'package:washing_machine_doorstep_service/shared/buttons.dart';

class ContactPanel extends ConsumerStatefulWidget {
  const ContactPanel({super.key, required this.wide});

  final bool wide;

  @override
  ConsumerState<ContactPanel> createState() => _ContactPanelState();
}

class _ContactPanelState extends ConsumerState<ContactPanel> {
  late final TextEditingController _name;
  late final TextEditingController _phone;
  late final TextEditingController _problem;

  @override
  void initState() {
    super.initState();
    final form = ref.read(contactFormProvider);
    _name = TextEditingController(text: form.name);
    _phone = TextEditingController(text: form.phone);
    _problem = TextEditingController(text: form.problem);
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _problem.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(ownerProfileProvider);
    final form = ref.watch(contactFormProvider);
    final details = _Details(profile: profile);
    final note = _NoteForm(
      profile: profile,
      form: form,
      name: _name,
      phone: _phone,
      problem: _problem,
    );

    if (widget.wide) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: details),
          const SizedBox(width: 32),
          Expanded(child: note),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [details, const SizedBox(height: 32), note],
    );
  }
}

class _Details extends StatelessWidget {
  const _Details({required this.profile});

  final OwnerProfile profile;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Fact(label: 'Address', value: profile.address),
        const SizedBox(height: 14),
        _Fact(label: 'Hours', value: profile.hours.label),
        const SizedBox(height: 14),
        _Fact(label: 'Service areas', value: profile.areas.join(', ')),
        const SizedBox(height: 14),
        _Fact(label: 'Phone', value: profile.phoneDisplay),
        const SizedBox(height: 14),
        _Fact(label: 'WhatsApp', value: profile.whatsappDisplay),
        const SizedBox(height: 14),
        _Fact(label: 'Email', value: profile.email),
        const SizedBox(height: 20),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            ShopButton(
              label: 'Call',
              onPressed: () {
                launchUrl(profile.phoneUri);
              },
            ),
            _ActionLink(
              label: 'WhatsApp',
              onPressed: () {
                launchUrl(profile.whatsappUri);
              },
            ),
            _ActionLink(
              label: 'Email',
              onPressed: () {
                launchUrl(profile.emailUri);
              },
            ),
            _ActionLink(
              label: 'Open in Google Maps',
              onPressed: () {
                launchUrl(profile.mapsUri);
              },
            ),
          ],
        ),
      ],
    );
  }
}

class _Fact extends StatelessWidget {
  const _Fact({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: text.labelMedium),
        const SizedBox(height: 4),
        Text(value, style: text.bodyLarge).easySeoP,
      ],
    );
  }
}

class _ActionLink extends StatelessWidget {
  const _ActionLink({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: ShopColors.accent,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        minimumSize: const Size(0, 48),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(label),
    );
  }
}

class _NoteForm extends ConsumerWidget {
  const _NoteForm({
    required this.profile,
    required this.form,
    required this.name,
    required this.phone,
    required this.problem,
  });

  final OwnerProfile profile;
  final ContactFormState form;
  final TextEditingController name;
  final TextEditingController phone;
  final TextEditingController problem;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = Theme.of(context).textTheme;
    final notifier = ref.read(contactFormProvider.notifier);
    final machine = profile.layouts.contains(form.machineType)
        ? form.machineType
        : profile.layouts.first;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Send a note', style: text.titleLarge).easySeoH3,
        const SizedBox(height: 12),
        TextField(
          controller: name,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.name,
          decoration: _field('Name', form.nameError),
          onChanged: notifier.setName,
        ),
        const SizedBox(height: 12),
        TextField(
          controller: phone,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.phone,
          decoration: _field('Phone', form.phoneError),
          onChanged: notifier.setPhone,
        ),
        const SizedBox(height: 12),
        InputDecorator(
          decoration: _field('Machine'),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: machine,
              isExpanded: true,
              dropdownColor: ShopColors.paper,
              style: text.bodyLarge,
              items: [
                for (final layout in profile.layouts)
                  DropdownMenuItem(
                    value: layout,
                    child: Text(contactMachineLabel(layout)),
                  ),
              ],
              onChanged: (value) {
                if (value != null) {
                  notifier.setMachineType(value);
                }
              },
            ),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: problem,
          minLines: 3,
          maxLines: 5,
          keyboardType: TextInputType.multiline,
          decoration: _field('Problem'),
          onChanged: notifier.setProblem,
        ),
        const SizedBox(height: 16),
        ShopButton(
          label: 'Send on WhatsApp',
          onPressed: () {
            _sendNote(ref, profile);
          },
        ),
        if (form.confirmation != null) ...[
          const SizedBox(height: 12),
          Text(
            form.confirmation!,
            style: text.bodyMedium?.copyWith(color: ShopColors.accent),
          ),
        ],
      ],
    );
  }
}

Future<void> _sendNote(WidgetRef ref, OwnerProfile profile) async {
  final message = ref
      .read(contactFormProvider.notifier)
      .validatedMessage(profile);
  if (message == null) {
    return;
  }
  final opened = await _tryLaunch(profile.whatsappMessage(message));
  ref.read(contactFormProvider.notifier).noteLaunch(opened);
}

Future<bool> _tryLaunch(Uri uri) async {
  try {
    return await launchUrl(uri);
  } catch (_) {
    return false;
  }
}

InputDecoration _field(String label, [String? error]) {
  final border = OutlineInputBorder(
    borderRadius: const BorderRadius.all(Radius.circular(2)),
    borderSide: BorderSide(color: ShopColors.ink.withValues(alpha: 0.28)),
  );
  return InputDecoration(
    labelText: label,
    errorText: error,
    filled: true,
    fillColor: ShopColors.paper,
    border: border,
    enabledBorder: border,
    focusedBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(2)),
      borderSide: BorderSide(color: ShopColors.accent, width: 1.5),
    ),
  );
}
