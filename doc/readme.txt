flutter pub run intl_translation:extract_to_arb --output-dir=lib/l10n lib/localizations.dart

flutter pub run intl_translation:generate_from_arb  --output-dir=lib/l10n --no-use-deferred-loading  lib/localizations.dart lib/l10n/intl_en.arb lib/l10n/intl_messages.arb lib/l10n/intl_zh.arb

flutter pub run intl_translation:generate_from_arb  --output-dir=lib/l10n --no-use-deferred-loading  lib/localizations.dart lib/l10n/intl_en.arb

If you get any error then save the pubspec.yaml file and try again


localizations process

1. Add getter in the localization.dart file
2. Update the AppLocalizations.of(context).
3. Run readme.txt commands for localization at least
4. Copy and paste the new entry from intl_messages to intl_en
5. Push the code and merge to master
6. After translation to another lang, pull the code
7. Run the readme.txt commands one by one or all together
