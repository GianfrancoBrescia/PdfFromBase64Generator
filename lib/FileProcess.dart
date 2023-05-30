import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:android_path_provider/android_path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class FileProcess {
  static Future<void> downloadFile(String base64Str, String fileName) async {
    Uint8List bytes = FileProcess._getDecodedString(base64Str);
    var status = await Permission.storage.status;

    if (!status.isGranted) {
      PermissionStatus permissionStatus = await Permission.storage.request();
      if (permissionStatus.isGranted) {
        await writeFile(bytes, fileName);
      } else {
        await Future.delayed(const Duration(seconds: 5));
      }
    } else {
      await writeFile(bytes, fileName);
    }
  }

  static Uint8List _getDecodedString(String base64Str) {
    switch (base64Str.length % 4) {
      case 1:
        break; // this case can't be handled well, because 3 padding chars is illeagal.
      case 2:
        base64Str = "$base64Str==";
        break;
      case 3:
        base64Str = "$base64Str=";
        break;
    }
    return base64.decode(base64Str);
  }

  static Future<String?> _getDownloadDirectoryPath() async {
    String? downloadDirectoryPath;
    if (Platform.isAndroid) {
      downloadDirectoryPath = await AndroidPathProvider.downloadsPath;
    } else {
      Directory? directory = await getDownloadsDirectory();
      downloadDirectoryPath = directory?.path;
    }
    return downloadDirectoryPath;
  }

  static Future<void> writeFile(Uint8List bytes, String fileName) async {
    String? downloadDirectoryPath = await _getDownloadDirectoryPath();
    File file = File("$downloadDirectoryPath/$fileName.pdf");
    if (!file.existsSync()) file.create();
    await file.writeAsBytes(bytes);
  }

  static void openFile(String fileName) {
    _getDownloadDirectoryPath().then((downloadDirectoryPath) {
      OpenFile.open("$downloadDirectoryPath/$fileName.pdf");
    });
  }
}
