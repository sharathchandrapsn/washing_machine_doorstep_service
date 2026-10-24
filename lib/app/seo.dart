import 'package:washing_machine_doorstep_service/content/owner_profile.dart';

/// Canonical origin for SEO links until the site has a public host.
const siteBaseUrl = 'http://localhost';

/// Schema.org LocalBusiness built only from the owner profile.
Map<String, dynamic> localBusinessJsonLd(OwnerProfile profile) {
  return {
    '@type': 'LocalBusiness',
    'name': profile.shopName,
    'description': profile.intro,
    'url': siteBaseUrl,
    'telephone': profile.phoneE164,
    'email': profile.email,
    'address': {
      '@type': 'PostalAddress',
      'streetAddress': '${profile.street}, ${profile.locality}',
      'addressLocality': profile.city,
      'addressRegion': profile.state,
      'postalCode': profile.postalCode,
    },
    'areaServed': profile.areas,
    'openingHours': profile.hours.label,
    'founder': {'@type': 'Person', 'name': profile.ownerName},
  };
}
