import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Hours the bench is open. Sunday is a closed day, not a short day.
class ShopHours {
  const ShopHours({
    required this.daysOpen,
    required this.opensAt,
    required this.closesAt,
    required this.daysClosed,
  });

  final String daysOpen;
  final String opensAt;
  final String closesAt;
  final String daysClosed;

  String get label => '$daysOpen $opensAt–$closesAt, $daysClosed closed';
}

/// Every fact and sentence the site is allowed to say about the shop.
class OwnerProfile {
  const OwnerProfile({
    required this.shopName,
    required this.ownerName,
    required this.ownerRole,
    required this.phoneDisplay,
    required this.phoneE164,
    required this.whatsappDisplay,
    required this.email,
    required this.street,
    required this.locality,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.hours,
    required this.areas,
    required this.brands,
    required this.yearsExperience,
    required this.doorstepVisits,
    required this.layouts,
    required this.claims,
    required this.intro,
    required this.topLoadCopy,
    required this.frontLoadCopy,
    required this.coverageCopy,
    required this.brandsCopy,
    required this.contactCopy,
  });

  final String shopName;
  final String ownerName;
  final String ownerRole;
  final String phoneDisplay;
  final String phoneE164;
  final String whatsappDisplay;
  final String email;
  final String street;
  final String locality;
  final String city;
  final String state;
  final String postalCode;
  final ShopHours hours;
  final List<String> areas;
  final List<String> brands;
  final int yearsExperience;
  final bool doorstepVisits;
  final List<String> layouts;
  final List<String> claims;
  final String intro;
  final String topLoadCopy;
  final String frontLoadCopy;
  final String coverageCopy;
  final String brandsCopy;
  final String contactCopy;

  String get address => '$street, $locality, $city, $state $postalCode';

  Uri get phoneUri => Uri.parse('tel:$phoneE164');

  Uri get whatsappUri => Uri.https('wa.me', phoneE164.replaceFirst('+', ''));

  Uri get emailUri => Uri.parse('mailto:$email');
}

const OwnerProfile _ownerProfile = OwnerProfile(
  shopName: 'ClearCycle Repairs',
  ownerName: 'Arun Mehta',
  ownerRole: 'sole technician',
  phoneDisplay: '+91 90000 12345',
  phoneE164: '+919000012345',
  whatsappDisplay: '+91 90000 12345',
  email: 'hello@clearcycle.example',
  street: '18 Lalitha Nagar',
  locality: 'Boduppal',
  city: 'Hyderabad',
  state: 'Telangana',
  postalCode: '500092',
  hours: ShopHours(
    daysOpen: 'Monday–Saturday',
    opensAt: '9:00',
    closesAt: '19:00',
    daysClosed: 'Sunday',
  ),
  areas: ['Boduppal', 'Uppal', 'Habsiguda', 'Nagole', 'Tarnaka'],
  brands: ['LG', 'Samsung', 'Whirlpool', 'IFB', 'Bosch', 'Godrej'],
  yearsExperience: 12,
  doorstepVisits: true,
  layouts: ['front-load', 'top-load'],
  claims: ['12 years', 'doorstep visits', 'front-load and top-load'],
  intro: 'ClearCycle Repairs is Arun Mehta’s bench in Lalitha Nagar. He is the only technician, and he has been taking washing machines apart in this part of Hyderabad for twelve years.',
  topLoadCopy: 'Top-load calls are usually a lid that will not lock, water that will not enter, or a tub that spins with a knock. He keeps those parts in the van and works at the machine, not back at the shop.',
  frontLoadCopy: 'Front-load jobs are the long ones: a leaking door seal, a pump that hums and does nothing, or a drum that growls on the spin. He pulls the machine out, says what it will cost, and only then starts.',
  coverageCopy: 'Visits stay inside Boduppal, Uppal, Habsiguda, Nagole, and Tarnaka. The hours are Monday to Saturday, 9:00 to 19:00. Sunday the phone is off.',
  brandsCopy: 'He services LG, Samsung, Whirlpool, IFB, Bosch, and Godrej, both the front-load and the top-load models.',
  contactCopy: 'The surest way to reach him is the mobile number, on a call or on WhatsApp. Email works too, and he answers it when he is back from a visit.',
);

/// The only source of shop facts. Pages read this; they do not hard-code the business.
final ownerProfileProvider = Provider<OwnerProfile>((ref) => _ownerProfile);
