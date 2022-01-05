import 'dart:io';

import 'package:dio/dio.dart';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as sysPath;
import 'package:permission_handler/permission_handler.dart';

@JsonSerializable()
class MFile {
  FirebaseStorage storage = FirebaseStorage.instance;

  /// Upload a file from fireStore
  uploadFile(
    String bucketName,
    String fileName,
    File _file,
  ) async {
    //returns an upload task
    String url;
    UploadTask task = upload(bucketName, fileName, _file);

    TaskSnapshot taskSnapshot = await task;
    if (taskSnapshot.state == TaskState.success)
      url = await taskSnapshot.ref.getDownloadURL();

    return url;
  }

  /// Get the storage directory
  Future<Directory> _getDownloadDirectory() async {
    var dir = await sysPath.getExternalStorageDirectory();
    print(dir.path);
    if (Platform.isAndroid) {
      return await DownloadsPathProvider.downloadsDirectory;
    }
    return await sysPath.getApplicationDocumentsDirectory();
  }

  /// Get the permission
  Future<bool> _requestPermissions() async {
    var permission = await Permission.storage.status;
    if (permission.isDenied) {
      permission = await Permission.storage.request();
      permission = await Permission.storage.status;
    }
    return permission.isGranted;
  }

  /// Start downloading
  Future<bool> _startDownloading(
      String url, String savePath, Function func) async {
    final Dio _dio = Dio();

    try {
      final response = await _dio.download(
        url,
        savePath,
        onReceiveProgress: func,
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  /// Load file from firebase
  Future<bool> loadFileFromNetwork(String url, Function func) async {
    var file = await storage.refFromURL(url).getMetadata();
    // print(url);
    //
    // print(file.name);
    var success = false;
    var dir = await _getDownloadDirectory();
    var isPermissionGranted = await _requestPermissions();

    if (isPermissionGranted) {
      var savePath = path.join(dir.path, file.name);
      success = await _startDownloading(url, savePath, func);
    }

    return success;
    // print('${dir.path}/$fileName my path ***');
    // var req = await http.Client().get(Uri.parse(url));
    // File file = File('${dir.path}/${dat.name}');
    //
    // return file.writeAsBytes(req.bodyBytes);
  }

  Future<void> openMedia(String url) async {
    var file = await downloadFile(url);
    if (file == null) return;

    print(file.path);

    OpenFile.open(file.path);
  }

  Future<File> downloadFile(String url) async {
    var fileName = await storage.refFromURL(url).getMetadata();
    var dir = await sysPath.getApplicationDocumentsDirectory();
    var file = File(path.join(dir.path, fileName.name));

    try {
      if (file.existsSync()) return file;
      var response = await Dio().get(url,
          options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            receiveTimeout: 0,
          ));

      var ref = file.openSync(mode: FileMode.write);
      ref.writeFromSync(response.data);
      await ref.close();

      return file;
    } catch (e) {
      return null;
    }
  }

  delete(String fileURL) async {
    await storage.refFromURL(fileURL).delete();
  }

  UploadTask upload(
    String bucketName,
    String fileName,
    File _file,
  ) {
    Reference storageReference = storage.ref().child("$bucketName/$fileName");

    UploadTask uploadTask = storageReference.putFile(_file);
    return uploadTask;
  }
}
