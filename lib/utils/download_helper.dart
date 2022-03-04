import 'dart:io';

import 'lib.dart';

Future<bool> downloadFile(String url) async {
  try {
    Dio dio = Dio();
    String savePath = "";

    String fileName = url.substring(url.lastIndexOf("/") + 1);

    savePath = await getFilePath(fileName);
    Response response =
        await dio.download(url, savePath, onReceiveProgress: (rec, total) {});

    if (response.statusCode == 200) {
      return true;
    }

    return false;
  } catch (e) {
    print(e.toString());
    return false;
  }
}

Future<String> getFilePath(uniqueFileName) async {
  Directory _path = await getApplicationDocumentsDirectory();
  String _localPath = _path.path + Platform.pathSeparator + 'Downloads';

  return _localPath;
}
