# exchangily-mobile-app
eXchangily DEX mobile App


Note:
### Error: Try correcting the name to the name of an existing method, or defining a method named 'setMockMessageHandler'.
          <channel.setMockMessageHandler((dynamic message) async {}>

### Solution: After upgrade to Flutter 2.5.0. You may need to add 
<void setMockMessageHandler(Future<T> Function(T? message)? handler) {}>
into /Users/USER_NAME/PATH_TO_FLTTER/packages/flutter/lib/src/services/platform_channel.dart. 

This is a temporary way to fix the following bug: "Error: The method 'setMockMessageHandler' isn't defined for the class 'BinaryMessenger'.
 - 'BinaryMessenger' is from 'package:flutter/src/services/binary_messenger.dart'".