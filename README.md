# Sri Sai Durga Enterprises

A Flutter web site for Sri Sai Durga Enterprises, a washing-machine and microwave-oven repair shop in Ramanthapur, Hyderabad. Shop facts live in `lib/content/owner_profile.dart`.

Flutter 3.47.1 (Dart 3.13.1).

## Run on Chrome

```bash
flutter run -d chrome
```

## Build web

```bash
flutter build web
```

The output is `build/web`.

## Change the shop details

Edit only `lib/content/owner_profile.dart`. The pages read that file.

- **Name.** `ownerName`
- **Shop.** `shopName`
- **Phone.** `phoneDisplay` and `phoneE164`. The dialer uses `phoneE164`.
- **WhatsApp.** `whatsappDisplay`. The `wa.me` link uses `phoneE164`, so that number has to be the WhatsApp number.
- **Email.** `email`
- **Address.** `street`, `locality`, `city`, `state`, and `postalCode`
- **Maps query.** No separate field. The Google Maps search uses the address built from those five fields.
- **Hours.** `hours`: `daysOpen`, `opensAt`, `closesAt`, and `daysClosed`
- **Areas.** `areas`
- **Bio.** `intro`, `ownerRole`, `yearsExperience`, `claims`, `coverageCopy`, and `contactCopy`. The about text is built from the name, role, years, areas, and hours.
- **Brands.** `brands`, `brandsCopy`, and `brandsNote`
