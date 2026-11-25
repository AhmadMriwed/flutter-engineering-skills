# Repository discovery

One customer Flutter application has a single Dart entry point, shared platform startup, and 39 immediate feature roots. Authentication and onboarding contain nested flows. The source inventory spans app bootstrap, shared infrastructure, modules, translations, native Android and iOS configuration, asset declarations, and debug tooling.

The review used a whole-tree Dart content scan followed by targeted call tracing across startup, FAQ, search, orders, session, and platform services. The inventory counts files in each root and does not imply a line-by-line review. Generated builds, binaries, signing material, and project credentials were excluded from deep inspection.

| Feature root under `lib/features` | Dart files | Immediate directories |
| --- | ---: | --- |
| `about_app` | 9 | binding, controller, pages, widgets |
| `all_categories` | 12 | binding, controller, data, domain, pages, widgets |
| `all_products` | 10 | binding, controller, mappers, models, pages, widgets |
| `api_configuration` | 5 | data, domain |
| `auth` | 83 | create_account, location_picker, login, services, sign_up, success, verification_code, widgets |
| `categories` | 21 | binding, controller, data, domain, pages, widgets |
| `checkout` | 12 | binding, controller, pages, widgets |
| `checkout_preview` | 20 | binding, controller, data, domain, models, pages, widgets |
| `create_ticket` | 13 | binding, controller, models, pages, widgets |
| `custom_request` | 80 | binding, controller, data, domain, models, pages, widgets |
| `delivery_address` | 24 | binding, controller, data, domain, models, pages, widgets |
| `delivery_schedule` | 1 | pages |
| `faq` | 21 | binding, controller, data, domain, models, pages, widgets |
| `guest_mode` | 11 | binding, controller, pages, services, widgets |
| `help_and_support` | 52 | binding, controller, data, domain, formatters, pages, services, widgets |
| `home` | 69 | binding, controller, data, domain, mappers, models, pages, widgets |
| `legal_content` | 10 | data, domain, models, widgets |
| `location_zone` | 5 | data, domain, widgets |
| `main_shell` | 5 | binding, controller, pages, widgets |
| `my_cart` | 35 | binding, controller, data, domain, mappers, models, pages, services, widgets |
| `my_tickets` | 19 | binding, controller, models, pages, widgets |
| `notifications` | 20 | binding, controller, data, domain, pages, services, widgets |
| `order_details` | 39 | binding, controller, models, pages, widgets |
| `order_tracking` | 13 | binding, controller, data, pages, services, widgets |
| `orders` | 39 | binding, controller, data, domain, models, pages, widgets |
| `payment_methods` | 23 | binding, controller, data, domain, pages, widgets |
| `privacy_policy` | 4 | binding, controller, pages, widgets |
| `product_details` | 32 | binding, controller, mappers, models, pages, widgets |
| `products` | 23 | binding, controller, data, domain, models, widgets |
| `profile` | 32 | binding, controller, data, domain, models, pages, widgets |
| `rating` | 33 | binding, controller, data, domain, models, pages, widgets |
| `search` | 23 | binding, controller, data, domain, pages, widgets |
| `seasonal_campaigns_details` | 39 | binding, controller, mappers, models, pages, widgets |
| `special_offers` | 9 | binding, controller, models, pages, widgets |
| `splash` | 6 | binding, controller, pages, widgets |
| `stores` | 33 | binding, controller, data, domain, pages, widgets |
| `ticket_conversation` | 7 | binding, controller, pages, widgets |
| `update_profile` | 17 | binding, controller, models, pages, widgets |
| `welcome` | 48 | language_selection, onboarding |

## Dependency evidence

`pubspec.yaml` requires Dart ^3.11.1. Core constraints observed were Get ^4.7.3, GetIt ^9.2.1, Dio ^5.9.2, GetStorage ^2.1.1, ScreenUtil ^5.9.3, and intl ^0.20.2. Flutter localization and testing come from the SDK. Feature packages cover maps/location, images/SVG/video, Firebase messaging and local notifications, sockets, phone input, carousel, shimmer, app info, and launching URLs. Flutter lints, launcher icons, and native splash generation are development dependencies. Select plugins only when the destination app calls their APIs.

[Architecture](../../architecture/profiles/feature-first/ARCHITECTURE.md) follows the runtime composition. [Coverage](../../validation/COVERAGE_MATRIX.md) maps reviewed behaviors to evidence.

## Version baseline

Resolved versions come from the source lockfile. Flutter, Flutter localizations, and Flutter test use the SDK. This table is a source snapshot.

| Package | Declared | Resolved |
| --- | --- | --- |
| `cached_network_image` | `^3.4.1` | `3.4.1` |
| `dio` | `^5.9.2` | `5.9.2` |
| `flutter_screenutil` | `^5.9.3` | `5.9.3` |
| `flutter_svg` | `^2.2.1` | `2.3.0` |
| `get` | `^4.7.3` | `4.7.3` |
| `get_it` | `^9.2.1` | `9.2.1` |
| `get_storage` | `^2.1.1` | `2.1.1` |
| `intl` | `^0.20.2` | `0.20.2` |
| `country_flags` | `^4.1.2` | `4.1.2` |
| `pinput` | `^6.0.2` | `6.0.2` |
| `image_picker` | `^1.2.2` | `1.2.2` |
| `google_maps_flutter` | `2.14.2` | `2.14.2` |
| `google_maps_flutter_android` | `^2.19.10` | `2.19.10` |
| `google_maps_flutter_ios_sdk9` | `^2.18.10` | `2.18.10` |
| `geolocator` | `14.0.2` | `14.0.2` |
| `package_info_plus` | `8.3.1` | `8.3.1` |
| `url_launcher` | `^6.3.2` | `6.3.2` |
| `shimmer` | `^3.0.0` | `3.0.0` |
| `firebase_core` | `4.15.0` | `4.15.0` |
| `firebase_messaging` | `16.7.0` | `16.7.0` |
| `flutter_local_notifications` | `^22.0.1` | `22.1.0` |
| `socket_io_client` | `^3.1.6` | `3.1.6` |
| `pusher_client_socket` | `^0.0.8` | `0.0.8` |
| `carousel_slider` | `^5.1.2` | `5.1.2` |
| `marquee` | `^2.3.0` | `2.3.0` |
| `video_player` | `^2.11.1` | `2.11.1` |
| `flutter_native_splash` | `^2.4.7` | `2.4.7` |
| `flutter_launcher_icons` | `^0.14.4` | `0.14.4` |
| `flutter_lints` | `^6.0.0` | `6.0.0` |
