import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:washing_machine_doorstep_service/content/owner_profile.dart';

class ContactFormState {
  const ContactFormState({
    this.name = '',
    this.phone = '',
    this.machineType = 'top-load',
    this.problem = '',
    this.nameError,
    this.phoneError,
    this.confirmation,
  });

  final String name;
  final String phone;
  final String machineType;
  final String problem;
  final String? nameError;
  final String? phoneError;
  final String? confirmation;

  ContactFormState copyWith({
    String? name,
    String? phone,
    String? machineType,
    String? problem,
    String? nameError,
    String? phoneError,
    String? confirmation,
    bool clearNameError = false,
    bool clearPhoneError = false,
    bool clearConfirmation = false,
  }) {
    return ContactFormState(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      machineType: machineType ?? this.machineType,
      problem: problem ?? this.problem,
      nameError: clearNameError ? null : nameError ?? this.nameError,
      phoneError: clearPhoneError ? null : phoneError ?? this.phoneError,
      confirmation: clearConfirmation
          ? null
          : confirmation ?? this.confirmation,
    );
  }
}

String contactMachineLabel(String layout) {
  if (layout.isEmpty) {
    return layout;
  }
  return '${layout[0].toUpperCase()}${layout.substring(1)}';
}

class ContactFormNotifier extends Notifier<ContactFormState> {
  @override
  ContactFormState build() => const ContactFormState();

  void setName(String value) {
    state = state.copyWith(
      name: value,
      clearNameError: true,
      clearConfirmation: true,
    );
  }

  void setPhone(String value) {
    state = state.copyWith(
      phone: value,
      clearPhoneError: true,
      clearConfirmation: true,
    );
  }

  void setMachineType(String value) {
    state = state.copyWith(machineType: value, clearConfirmation: true);
  }

  void setProblem(String value) {
    state = state.copyWith(problem: value, clearConfirmation: true);
  }

  /// The WhatsApp body when the form is valid. Null stores the field errors.
  String? validatedMessage(OwnerProfile profile) {
    final name = state.name.trim();
    final phone = state.phone.trim();
    final digits = phone.replaceAll(RegExp(r'\s'), '');
    final nameError = name.isEmpty ? 'Enter your name.' : null;
    final phoneError = phone.isEmpty
        ? 'Enter your phone number.'
        : RegExp(r'^\d{10}$').hasMatch(digits)
        ? null
        : 'Enter a 10-digit phone number.';

    if (nameError != null || phoneError != null) {
      state = state.copyWith(
        nameError: nameError,
        phoneError: phoneError,
        clearNameError: nameError == null,
        clearPhoneError: phoneError == null,
        clearConfirmation: true,
      );
      return null;
    }

    state = state.copyWith(clearNameError: true, clearPhoneError: true);
    return [
      'Hello ${profile.shopName}.',
      'Name: $name',
      'Phone: $phone',
      'Machine: ${contactMachineLabel(state.machineType)}',
      'Problem: ${state.problem.trim()}',
    ].join('\n');
  }

  void noteLaunch(bool opened) {
    state = state.copyWith(
      confirmation: opened
          ? 'WhatsApp opened with your note.'
          : 'WhatsApp did not open.',
    );
  }
}

final contactFormProvider =
    NotifierProvider<ContactFormNotifier, ContactFormState>(
      ContactFormNotifier.new,
    );
