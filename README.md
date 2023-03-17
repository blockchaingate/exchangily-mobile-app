# exchangily-mobile-app
eXchangily DEX mobile App


Note:
### Error: Try correcting the name to the name of an existing method, or defining a method named 'setMockMessageHandler'.
          <channel.setMockMessageHandler((dynamic message) async {}>

### Solution: After upgrade to Flutter 2.5.0. You may need to add 
<void setMockMessageHandler(Future<T> Function(T? message)? handler) {}>
into /Users/USER_NAME/PATH_TO_FLUTTER/packages/flutter/lib/src/services/platform_channel.dart. 

This is a temporary way to fix the following bug: "Error: The method 'setMockMessageHandler' isn't defined for the class 'BinaryMessenger'.
 - 'BinaryMessenger' is from 'package:flutter/src/services/binary_messenger.dart'".



### flutter pub run intl_translation:extract_to_arb --output-dir=lib/l10n lib/localizations.dart

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

### To use different version of flutter use FVM
Reference: 

- https://github.com/fluttertools/fvm#vscode 

- In VS code terminal type : <flutter pub global activate fvm>
- fvm install 2.10.0
- export PATH="$PATH":"$HOME/.pub-cache/bin" (if terminal gives path error)
- Add below to .vscode/settings.json
{
  "dart.flutterSdkPath": ".fvm/flutter_sdk",
  // Remove .fvm files from search
  "search.exclude": {
    "**/.fvm": true
  },
  // Remove from file watching
  "files.watcherExclude": {
    "**/.fvm": true
  }
}
  - If debug with breakpoint does not work then add "dart.flutterSdkPath": ".fvm/flutter_sdk", in vscode settings by searching for flutter sdk path in settings
- fvm use <version>

