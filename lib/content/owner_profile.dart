import 'package:flutter_riverpod/flutter_riverpod.dart';

/// When the bench is open. [summary] replaces the clock line when set.
class ShopHours {
  const ShopHours({
    required this.daysOpen,
    required this.opensAt,
    required this.closesAt,
    required this.daysClosed,
    this.summary,
  });

  final String daysOpen;
  final String opensAt;
  final String closesAt;
  final String daysClosed;
  final String? summary;

  String get label {
    if (summary != null) {
      return summary!;
    }
    final span = '$daysOpen $opensAt–$closesAt';
    if (daysClosed.isEmpty) {
      return span;
    }
    return '$span, $daysClosed closed';
  }
}

/// One beat of a doorstep visit, in the order a customer meets it.
class VisitStep {
  const VisitStep({required this.title, required this.detail});

  final String title;
  final String detail;
}

/// A fault the technician is called for, and the signs that point to it.
class FaultSymptoms {
  const FaultSymptoms({required this.fault, required this.symptoms});

  final String fault;
  final List<String> symptoms;
}

/// One machine layout: the card sentence, the faults, and the visit.
class MachineService {
  const MachineService({
    required this.cardTitle,
    required this.pageTitle,
    required this.summary,
    required this.intro,
    required this.faults,
    required this.visitIncludes,
  });

  final String cardTitle;
  final String pageTitle;
  final String summary;
  final String intro;
  final List<FaultSymptoms> faults;
  final List<String> visitIncludes;
}

/// One question on the home page, and the answer under it.
class FaqItem {
  const FaqItem({required this.question, required this.answer});

  final String question;
  final String answer;
}

/// One local gallery card and the sentence under it.
class GalleryItem {
  const GalleryItem({required this.asset, required this.caption});

  final String asset;
  final String caption;
}

/// A fault customers ask about, and what the visit looks at.
class CommonFault {
  const CommonFault({required this.title, required this.checks});

  final String title;

  /// Two sentences. No price.
  final String checks;
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
    required this.topLoad,
    required this.frontLoad,
    required this.coverageCopy,
    required this.brandsCopy,
    required this.brandsNote,
    required this.commonFaults,
    required this.gallery,
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
  final MachineService topLoad;
  final MachineService frontLoad;
  final String coverageCopy;
  final String brandsCopy;
  final String brandsNote;
  final List<CommonFault> commonFaults;
  final List<GalleryItem> gallery;
  final String contactCopy;

  String get address => '$street, $locality, $city, $state $postalCode';

  Uri get phoneUri => Uri.parse('tel:$phoneE164');

  /// `https://wa.me/<number>?text=...` with a short line that names the shop.
  Uri get whatsappUri => whatsappMessage('Hello $shopName.');

  Uri whatsappMessage(String text) {
    return Uri.https('wa.me', phoneE164.replaceFirst('+', ''), {'text': text});
  }

  Uri get emailUri => Uri.parse('mailto:$email');

  /// A Google Maps search for the street address. No API key.
  Uri get mapsUri => Uri.https('www.google.com', '/maps/search/', {
    'api': '1',
    'query': address,
  });

  String get heroHeadline =>
      'Doorstep washing-machine and microwave-oven repair in $city.';

  /// Front-load and top-load, in the order stored on the profile.
  String get machineLayoutsLine {
    final labels = [for (final layout in layouts) _layoutLabel(layout)];
    if (labels.isEmpty) {
      return '';
    }
    if (labels.length == 1) {
      return labels.single;
    }
    final lead = labels.sublist(0, labels.length - 1).join(', ');
    return '$lead and ${labels.last}';
  }

  String get yearsFact => '$yearsExperience years';

  String get doorstepFact => 'Doorstep visits';

  String get brandsServedLabel => 'Brands served';

  String get brandsServed => brands.join(', ');

  /// Two short paragraphs: who visits, then where the shop is.
  List<String> get aboutParagraphs {
    return [
      '$ownerName is the $ownerRole at $shopName, and he is the person who comes to the house. He has been doing this work for $yearsExperience years, on washing machines and microwave ovens.',
      'The shop is at $address. All types of spare parts are available here.',
    ];
  }

  /// Eight questions. The first is the one the page opens.
  List<FaqItem> get faq {
    final areaList = _joinAnd(areas);
    return [
      FaqItem(question: 'Which brands does he repair?', answer: brandsCopy),
      FaqItem(
        question: 'Does he repair front-load and top-load machines?',
        answer: 'Yes. A front-load visit is the longer one, often a door seal, a pump, or a drum. A top-load visit is usually a lid, the fill, or a spin. He works on the machine where it stands.',
      ),
      FaqItem(
        question: 'Does he repair microwave ovens?',
        answer: 'Yes. $shopName services washing machines and microwave ovens.',
      ),
      FaqItem(
        question: 'Can he come the same day?',
        answer: 'Call or WhatsApp and he will say whether he can reach the house that day. When he does come, most of the usual faults are finished in that visit.',
      ),
      FaqItem(
        question: 'What should I tell him on the call?',
        answer: 'The brand, whether it is a front-load machine, a top-load machine, or a microwave oven, and what it is doing.',
      ),
      FaqItem(
        question: 'Where does he visit?',
        answer: 'The shop is in $areaList. He comes to the house from there.',
      ),
      FaqItem(
        question: 'Are spare parts available?',
        answer: 'Yes. All types of spare parts are available here.',
      ),
      FaqItem(
        question: 'How does payment work?',
        answer: 'You pay the technician after the repair. There is no online payment.',
      ),
    ];
  }

  /// Up to two letters, taken from the owner name.
  String get ownerInitials {
    final parts = ownerName
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty);
    return parts.take(2).map((part) => part[0].toUpperCase()).join();
  }

  List<VisitStep> get visitSteps => [
    VisitStep(title: 'Call or WhatsApp', detail: contactCopy),
    VisitStep(
      title: 'The technician visits',
      detail:
          '$ownerName, the $ownerRole, comes to the house and works at the machine.',
    ),
    const VisitStep(
      title: 'Repaired and explained',
      detail: 'He finishes the repair where the machine stands, and he tells you what failed.',
    ),
  ];
}

String _joinAnd(List<String> items) {
  if (items.isEmpty) {
    return '';
  }
  if (items.length == 1) {
    return items.single;
  }
  if (items.length == 2) {
    return '${items[0]} and ${items[1]}';
  }
  final lead = items.sublist(0, items.length - 1).join(', ');
  return '$lead, and ${items.last}';
}

String _layoutLabel(String layout) {
  if (layout.isEmpty) {
    return layout;
  }
  return '${layout[0].toUpperCase()}${layout.substring(1)}';
}

const MachineService _topLoad = MachineService(
  cardTitle: 'Top load',
  pageTitle: 'Top-load',
  summary: 'He fixes top-load machines at the door, from a dead agitator to a spin that knocks.',
  intro: 'Top-load calls are usually a lid that will not lock, water that will not enter, or a tub that spins with a knock. He keeps those parts in the van and works at the machine, not back at the shop.',
  faults: [
    FaultSymptoms(
      fault: 'Agitator',
      symptoms: [
        'Clothes twist into a rope and hardly turn over.',
        'The post in the middle clicks, then sits still.',
        'The tub has water in it and the agitator does not move.',
      ],
    ),
    FaultSymptoms(
      fault: 'Lid switch',
      symptoms: [
        'The lid is down and nothing starts.',
        'It fills, then waits until someone presses the lid.',
        'Spin will not begin if the lid is even slightly open.',
      ],
    ),
    FaultSymptoms(
      fault: 'Drain',
      symptoms: [
        'The tub is still full when the cycle should be over.',
        'Water leaves as a trickle and then stops.',
        'The pump sounds busy and the hose at the back stays dry.',
      ],
    ),
    FaultSymptoms(
      fault: 'Spin',
      symptoms: [
        'The tub turns a short way and the machine gives up.',
        'Clothes are still dripping after the cycle ends.',
        'It starts to spin, pauses, and tries again.',
      ],
    ),
    FaultSymptoms(
      fault: 'Noise',
      symptoms: [
        'One knock for each turn of the tub.',
        'A grind right as the spin gets going.',
        'A rattle in the cabinet only while it agitates.',
      ],
    ),
  ],
  visitIncludes: [
    'The usual parts for these faults are kept for the visit, and all types of spare parts are available at the shop.',
    'He works beside the machine, not back at the shop.',
    'He names the fault and what it will cost before a part goes in.',
  ],
);

const MachineService _frontLoad = MachineService(
  cardTitle: 'Front load',
  pageTitle: 'Front-load',
  summary: 'Front-load work is the longer visit: a leaking door, a growling drum, or a pump that will not empty.',
  intro: 'Front-load jobs are the long ones: a leaking door seal, a pump that hums and does nothing, or a drum that growls on the spin. He pulls the machine out, says what it will cost, and only then starts.',
  faults: [
    FaultSymptoms(
      fault: 'Door boot',
      symptoms: [
        'A puddle in front of the door after a wash.',
        'Dark slime in the fold of the rubber seal.',
        'The door shuts, and a thin leak starts on the rinse.',
      ],
    ),
    FaultSymptoms(
      fault: 'Bearings',
      symptoms: [
        'A growl that rises as the spin gets faster.',
        'The drum shifts when you push it with a hand.',
        'A rusty mark on the floor under a hot wash.',
      ],
    ),
    FaultSymptoms(
      fault: 'Pump',
      symptoms: [
        'A hum at the end of the cycle while the water stays put.',
        'Something small rattles in the pump housing.',
        'The machine stops and never reaches the spin.',
      ],
    ),
    FaultSymptoms(
      fault: 'Drain',
      symptoms: [
        'The cycle finishes with water still in the drum.',
        'The hose is clear, and the drum still will not empty.',
        'The water drops a little, then stops for good.',
      ],
    ),
    FaultSymptoms(
      fault: 'Error codes',
      symptoms: [
        'A code stays on the display and the buttons do nothing.',
        'Switching the power off does not clear it.',
        'The code appears as soon as a cycle is chosen.',
      ],
    ),
  ],
  visitIncludes: [
    'He pulls the machine out and allows a longer slot for this work.',
    'The price is said before a panel comes off. All types of spare parts are available at the shop.',
    'He tells you what failed before he leaves.',
  ],
);

const OwnerProfile _ownerProfile = OwnerProfile(
  shopName: 'Sri Sai Durga Enterprises',
  ownerName: 'V. Rama Swamy',
  ownerRole: 'contact person',
  phoneDisplay: '+91 93904 95572',
  phoneE164: '+919390495572',
  whatsappDisplay: '+91 93904 95572',
  email: 'vallala.ramaswami@gmail.com',
  street: '# 3-3-112/1/A, Sri Nagar Colony',
  locality: 'Ramanthapur',
  city: 'Hyderabad',
  state: 'Telangana',
  postalCode: '500013',
  hours: ShopHours(
    daysOpen: 'Monday–Saturday',
    opensAt: '9:00 AM',
    closesAt: '7:00 PM',
    daysClosed: '',
  ),
  areas: ['Ramanthapur', 'Hyderabad'],
  brands: ['All brands'],
  yearsExperience: 15,
  doorstepVisits: true,
  layouts: ['front-load', 'top-load', 'microwave oven'],
  claims: ['15 years', 'Doorstep visits', 'Spare parts'],
  intro: 'Sri Sai Durga Enterprises is V. Rama Swamy’s shop in Sri Nagar Colony, Ramanthapur. He repairs washing machines and microwave ovens of all brands, and all types of spare parts are available here.',
  topLoad: _topLoad,
  frontLoad: _frontLoad,
  coverageCopy: 'The shop is in Sri Nagar Colony, Ramanthapur, Hyderabad. All types of spare parts are available here.',
  brandsCopy: 'He services all brands of washing machines and microwave ovens. All types of spare parts are available here.',
  brandsNote: 'All brands of washing machines and microwave ovens. All types of spare parts are available here.',
  commonFaults: [
    CommonFault(
      title: 'Not spinning',
      checks: 'On the visit he checks whether the lid or the door is holding the cycle, and whether the motor tries to turn the tub. If the tub only rocks and then stops, he looks at the belt and the clutch while the machine is still in place.',
    ),
    CommonFault(
      title: 'Not draining',
      checks: 'He listens for the pump and checks the hose at the back for a kink or a dry end. If the tub is still full at the end of the cycle, he opens the pump path and sees what is blocking the water.',
    ),
    CommonFault(
      title: 'Leaking',
      checks: 'He dries the floor and runs a short fill so he can see where the water leaves. The usual places are the door seal, a hose joint, and the seam under the tub.',
    ),
    CommonFault(
      title: 'Not filling',
      checks: 'He checks that the tap is open and that the inlet hose is clear. If the drum stays empty, he tests the valve that should let the water in.',
    ),
    CommonFault(
      title: 'Bad smell',
      checks: 'He looks in the door seal, the drawer, and the filter for water that never left. A smell that hangs on after a hot wash is usually that standing water, and he cleans the path it sits in.',
    ),
    CommonFault(
      title: 'Machine dead',
      checks: 'He checks the plug, the socket, and whether any light on the panel comes on. If the machine stays silent with power at the wall, he follows the supply in as far as the board.',
    ),
  ],
  gallery: _gallery,
  contactCopy: 'The surest way to reach him is the mobile number, on a call or on WhatsApp. Email works too, and he answers it when he is back from a visit.',
);

const List<GalleryItem> _gallery = [
  GalleryItem(
    asset: 'assets/gallery/top_load_drum.png',
    caption: 'A top-load drum, open at the top.',
  ),
  GalleryItem(
    asset: 'assets/gallery/front_load_door_seal.png',
    caption: 'A front-load door seal, the rubber ring around the glass.',
  ),
  GalleryItem(
    asset: 'assets/gallery/pump.png',
    caption: 'A pump from under the tub.',
  ),
  GalleryItem(
    asset: 'assets/gallery/drain_hose.png',
    caption: 'A drain hose, the path the water leaves by.',
  ),
  GalleryItem(
    asset: 'assets/gallery/control_panel.png',
    caption: 'A control panel, the buttons and the display.',
  ),
  GalleryItem(
    asset: 'assets/gallery/finished_repair.png',
    caption: 'A finished repair, the machine closed and ready.',
  ),
];

/// The only source of shop facts. Pages read this; they do not hard-code the business.
final ownerProfileProvider = Provider<OwnerProfile>((ref) => _ownerProfile);
