// Copyright (c) 2023 Yang,Zhong
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'fileinfo.dart';
import 'http_helper.dart';

abstract class FileManager {
  Future<String> createFileId();
  Future<FileInfo> upload(
    String id,
    file, {
    Function(int sent, int total)? onSent,
  });
  Future<FileInfo> getFileInfo(String id);

  Future<dynamic> download(String path, String savePath,
      {void Function(int, int)? receiveCallback,
      Map<String, dynamic>? data,
      HandleError? showError});

  Future<String> getAccessUrl(String id);
}

class HttpFileManager extends FileManager {
  DioHelper helper;
  HttpFileManager({required this.helper});
  @override
  Future<String> createFileId() async {
    final res = await helper.post('/files');
    return res['data']['id'];
  }

  @override
  Future<String> getAccessUrl(String id) async {
    final res = await helper.get('/files/$id');
    return res['data']['access_url'];
  }

  @override
  Future<FileInfo> upload(String id, file,
      {Function(int sent, int total)? onSent}) async {
    var res = await helper.upload('/files/$id', file, onSent: onSent);
    return res['data'];
  }

  @override
  Future download(String path, String savePath,
      {void Function(int, int)? receiveCallback,
      Map<String, dynamic>? data,
      HandleError? showError}) async {
    return await helper.download(path, savePath,
        receiveCallback: receiveCallback, data: data, showError: showError);
  }

  @override
  Future<FileInfo> getFileInfo(String id) async {
    final res = await helper.get('/files/$id');
    var raw = res['data']['info'];
    if (raw != null) {
      var info = FileInfo.fromJson(raw);
      info.accessUrl = res['data']['access_url'];
      return info;
    }
    return FileInfo(
        id: id, mimeType: "unknown", accessUrl: res['data']['access_url']);
  }
}
