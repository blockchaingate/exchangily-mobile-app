flutter pub run intl_translation:extract_to_arb --output-dir=lib/l10n lib/localizations.dart

flutter pub run intl_translation:generate_from_arb  --output-dir=lib/l10n --no-use-deferred-loading  lib/main.dart lib/l10n/intl_messages.arb

flutter pub run intl_translation:generate_from_arb  --output-dir=lib/l10n --no-use-deferred-loading  lib/main.dart lib/l10n/intl_zh.arb

flutter pub run intl_translation:generate_from_arb  --output-dir=lib/l10n --no-use-deferred-loading  lib/main.dart lib/l10n/intl_en.arb