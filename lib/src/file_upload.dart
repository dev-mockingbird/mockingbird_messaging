// Copyright (c) 2023 Yang,Zhong
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

import 'file_manager.dart';
import 'fileinfo.dart';

class FileUploader {
  FileManager fileManager;
  FileUploader({required this.fileManager});
  Future<List<FileInfo?>> upload(List<XFile> files,
      {Function(XFile file, int sent, int total)? onSent}) async {
    List<Future> fs = [];
    List<FileInfo?> infos = [];
    locate(XFile file) async {
      var id = await fileManager.createFileId();
      infos.add(await _upload(id, file, onSent));
    }

    for (var file in files) {
      fs.add(locate(file));
    }
    await Future.wait(fs);
    return infos;
  }

  Future<FileInfo?> _upload(String id, XFile file, onSent) async {
    var data = await file.readAsBytes();
    FormData formData = FormData.fromMap(
        {"file": MultipartFile.fromBytes(data, filename: _getFileName(file))});
    try {
      return await fileManager.upload(id, formData,
          onSent: (int sent, int total) {
        if (onSent != null) {
          onSent(file, sent, total);
        }
      });
    } catch (e) {
      return null;
    }
  }

  _getFileName(XFile file) {
    if (file.name != "") {
      return file.name;
    }
    return "unnamed file";
  }
}
