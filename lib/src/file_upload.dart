// Copyright (c) 2023 Yang,Zhong
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

import 'file_manager.dart';
import 'fileinfo.dart';

class FileUploader {
  FileManager fileManager;
  FileUploader({required this.fileManager});
  Future<List<FileInfo?>> upload(
    List<XFile> files, {
    Function(XFile file, int sent, int total)? onSent,
    Function(XFile file, int code, String info)? onFail,
  }) async {
    List<Future> fs = [];
    List<FileInfo?> infos = [];
    locate(XFile file) async {
      var id = await fileManager.createFileId();
      if (id == null) {
        if (onFail != null) onFail(file, 1, "can't create file id");
        return;
      }
      var info = await _upload(id, file, onSent, (err) {
        if (onFail == null) {
          if (kDebugMode) {
            print(err);
          }
        }
        if (err is DioException) {
          if (err.response == null) {
            onFail!(file, 2, err.message ?? "unkwon error");
            return;
          }
          onFail!(file, err.response!.statusCode ?? 500,
              err.response!.data ?? "unkown error");
          return;
        }
        onFail!(file, 3, "$err");
      });
      if (info != null) {
        infos.add(info);
      }
    }

    for (var file in files) {
      fs.add(locate(file));
    }
    await Future.wait(fs);
    return infos;
  }

  Future<FileInfo?> _upload(String id, XFile file, onSent, onFail) async {
    var data = await file.readAsBytes();
    FormData formData = FormData.fromMap({
      "file": MultipartFile.fromBytes(
        data,
        filename: _getFileName(file),
      ),
    });
    return await fileManager.upload(
      id,
      formData,
      onSent: (int sent, int total) {
        if (onSent != null) {
          onSent(file, sent, total);
        }
      },
      onFail: onFail,
    );
  }

  _getFileName(XFile file) {
    if (file.name != "") {
      return file.name;
    }
    return "unnamed file";
  }
}
