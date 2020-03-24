flutter pub run intl_translation:extract_to_arb --output-dir=lib/l10n lib/localizations.dart

flutter pub run intl_translation:generate_from_arb  --output-dir=lib/l10n --no-use-deferred-loading  lib/localizations.dart lib/l10n/intl_en.arb lib/l10n/intl_messages.arb lib/l10n/intl_zh.arb

flutter pub run intl_translation:generate_from_arb  --output-dir=lib/l10n --no-use-deferred-loading  lib/localizations.dart lib/l10n/intl_en.arb

:Generate Launcher icons:
flutter pub run flutter_launcher_icons:main