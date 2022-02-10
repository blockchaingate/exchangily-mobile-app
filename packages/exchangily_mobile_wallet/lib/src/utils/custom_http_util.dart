import 'dart:convert';
import 'dart:io';
import 'package:exchangilymobileapp/constants/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';

import 'package:http/io_client.dart';

/*----------------------------------------------------------------------
                          Custom HTTP client
----------------------------------------------------------------------*/
class CustomHttpUtil {
  static HttpClient customHttpClient({String cert}) {
    SecurityContext securityContext = SecurityContext.defaultContext;
    try {
      if (cert != null) {
        Uint8List bytes = utf8.encode(cert);
        securityContext.setTrustedCertificatesBytes(bytes);
      }
      debugPrint('certicate added');
    } on TlsException catch (e) {
      if (e?.osError?.message != null &&
          e.osError.message.contains('CERT_ALREADY_IN_HASH_TABLE')) {
        debugPrint('createHttpClient() - cert already trusted! Skipping.');
      } else {
        debugPrint(
            'createHttpClient().setTrustedCertificateBytes EXCEPTION: $e');
        rethrow;
      }
    } finally {}

    HttpClient httpClient = HttpClient(context: securityContext);

    return httpClient;
  }

  /// Use package:http Client with our custom dart:io HttpClient with added
  /// LetsEncrypt trusted certificate
  static http.Client createLetsEncryptUpdatedCertClient() {
    IOClient ioClient;
    ioClient = IOClient(customHttpClient(cert: Constants.ISRG_X1));
    return ioClient;
  }
}
