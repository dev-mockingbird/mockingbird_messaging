// Copyright (c) 2023 Yang,Zhong
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'package:flutter/foundation.dart';

import 'fileinfo.dart';
import 'http_helper.dart';

enum ImageSize {
  sm,
  md,
  lg,
  origin,
}

getImageSize(ImageSize size) {
  switch (size) {
    case ImageSize.sm:
      return "sm";
    case ImageSize.md:
      return "md";
    case ImageSize.lg:
      return "lg";
    default:
      return "origin";
  }
}

abstract class FileManager {
  Future<String?> createFileId();
  Future<FileInfo?> upload(
    String id,
    file, {
    Function(int sent, int total)? onSent,
    Function(dynamic)? onFail,
  });
  Future<FileInfo?> getFileInfo(String id);

  Future<dynamic> download(
    String path,
    String savePath, {
    void Function(int, int)? receiveCallback,
    Map<String, dynamic>? data,
    HandleError? handleError,
    ImageSize imageSize = ImageSize.md,
  });

  Future<String?> getAccessUrl(String id);
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
  Future<String?> getAccessUrl(String id) async {
    final res = await helper.get('/files/$id');
    if (res != null) {
      return res['data']['access_url'];
    }
    return null;
  }

  @override
  Future<FileInfo?> upload(
    String id,
    file, {
    Function(int sent, int total)? onSent,
    Function(dynamic)? onFail,
  }) async {
    try {
      var res = await helper.upload(
        '/files/$id',
        file,
        method: 'put',
        onSent: onSent,
        handleError: onFail,
      );
      if (res != null) {
        return FileInfo.fromJson(res['data']);
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }

  @override
  Future download(
    String path,
    String savePath, {
    void Function(int, int)? receiveCallback,
    Map<String, dynamic>? data,
    HandleError? handleError,
    ImageSize imageSize = ImageSize.md,
  }) async {
    return await helper.download(
      "$path?size=${getImageSize(imageSize)}",
      savePath,
      receiveCallback: receiveCallback,
      data: data,
      showError: handleError,
    );
  }

  @override
  Future<FileInfo?> getFileInfo(String id) async {
    try {
      final res = await helper.get('/files/$id');
      if (res == null) {
        return null;
      }
      var raw = res['data']['info'];
      if (raw != null) {
        var info = FileInfo.fromJson(raw);
        info.accessUrl = res['data']['access_url'];
        return info;
      }
      return FileInfo(
        id: id,
        mimeType: "unknown",
        accessUrl: res['data']['access_url'],
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }
}
