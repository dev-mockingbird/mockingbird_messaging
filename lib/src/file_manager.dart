// Copyright (c) 2023 Yang,Zhong
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'fileinfo.dart';
import 'http_helper.dart';

enum ImageSize {
  xs,
  sm,
  md,
  lg,
  origin,
}

getImageSizeName(ImageSize size) {
  switch (size) {
    case ImageSize.xs:
      return "xs";
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

ImageSize? getImageSize(double? width) {
  if (width == null) {
    return null;
  } else if (width <= 192) {
    return ImageSize.xs;
  } else if (width <= 480) {
    return ImageSize.sm;
  } else if (width <= 720) {
    return ImageSize.md;
  } else if (width <= 1080) {
    return ImageSize.lg;
  }
  return ImageSize.origin;
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
  Future<String?> createFileId() async {
    final res = await helper.post('/files');
    if (res != false) {
      return res['data']['id'];
    }
    return null;
  }

  @override
  Future<String?> getAccessUrl(String id) async {
    final res = await helper.get('/files/$id');
    if (res != false) {
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
    var res = await helper.upload(
      '/files/$id',
      file,
      method: 'put',
      onSent: onSent,
      handleError: onFail,
    );
    if (res != false) {
      return FileInfo.fromJson(res['data']);
    }
    return null;
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
      "$path?size=${getImageSizeName(imageSize)}",
      savePath,
      receiveCallback: receiveCallback,
      data: data,
      showError: handleError,
    );
  }

  @override
  Future<FileInfo?> getFileInfo(String id) async {
    final res = await helper.get('/files/$id');
    if (res == false) {
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
  }
}
