import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';

class PdfViewerService {
  String? path;
  final String guideEnglishPdf = 'assets/pdf/campaign/guide-en.pdf';
  final String guideChinesePdf = 'assets/pdf/campaign/guide-cn.pdf';

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    debugPrint('$path/assets/pdf/campaign/guide-en.pdf');
    return File('$path/assets/pdf/campaign/guide-en.pdf');
  }

  Future<File> writeCounter(Uint8List stream) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsBytes(stream);
  }

  Future<bool> existsFile() async {
    final file = await _localFile;
    return file.exists();
  }

  void loadPdf() async {
    debugPrint('in load');
    //await writeCounter(await fetchPost());
    await existsFile();
    path = (await _localFile).path;

    //if (!mounted) return;

    // setState(() {});
  }
}
