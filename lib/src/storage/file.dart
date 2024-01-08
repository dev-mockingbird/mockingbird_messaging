// Copyright (c) 2023 Yang,Zhong
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import '../file_manager.dart';
import '../fileinfo.dart';
import 'kv.dart';
import 'package:path_provider/path_provider.dart';

class FileCacher {
  FileManager fileManager;
  final Map<String, String> _cachedFiles = {};
  final Map<String, FileInfo> _cachedFileInfos = {};

  FileCacher({required this.fileManager});

  Future<File?> cachedFile(
    String id, {
    ImageSize size = ImageSize.md,
  }) async {
    if (kIsWeb) {
      return null;
    }
    FileInfo? info = await cacheFileInfo(id);
    if (info == null) {
      return null;
    }
    Directory dir = await getApplicationCacheDirectory();
    var pathfile = "${dir.path}/${_id(id, size)}";
    final file = File(pathfile);
    if (await file.exists() && await file.length() > 0) {
      _cachedFiles[_id(id, size)] = pathfile;
      return file;
    }
    return null;
  }

  File? syncedFile(String id, {ImageSize size = ImageSize.md}) {
    var pathfile = _cachedFiles[_id(id, size)];
    if (pathfile != null) {
      return File(pathfile);
    }
    return null;
  }

  FileInfo? syncedFileInfo(String id) {
    return _cachedFileInfos[id];
  }

  Future<File?> cacheFile(
    String id, {
    ImageSize size = ImageSize.md,
    void Function(int, int)? receiveCallback,
  }) async {
    if (kIsWeb) {
      throw Exception("not support cache file in web");
    }
    FileInfo? info = await cacheFileInfo(id);
    if (info == null) {
      return null;
    }
    Directory dir = await getApplicationCacheDirectory();
    var pathfile = "${dir.path}/${_id(id, size)}";
    final file = File(pathfile);
    if (await file.exists() && await file.length() > 0) {
      _cachedFiles[_id(id, size)] = pathfile;
      return file;
    }
    var tmpFile = "$pathfile.tmp";
    try {
      await fileManager.download(
        info.accessUrl!,
        tmpFile,
        receiveCallback: receiveCallback,
        imageSize: size,
      );
      var r = File(tmpFile).renameSync(pathfile);
      _cachedFiles[_id(id, size)] = r.path;
      return r;
    } catch (e) {
      await uncacheFileInfo(id);
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }

  Future<FileInfo?> cachedFileInfo(String id) async {
    var info = _cachedFileInfos[id];
    if (info != null) {
      return info;
    }
    String data = await KV.get<String>(id);
    if (data != "") {
      FileInfo info = FileInfo.fromJson(jsonDecode(data));
      _cachedFileInfos[id] = info;
      return info;
    }
    return null;
  }

  Future<FileInfo?> cacheFileInfo(String id) async {
    var info = await cachedFileInfo(id);
    if (info != null) {
      return info;
    }
    info = await fileManager.getFileInfo(id);
    if (info == null) {
      return null;
    }
    _cachedFileInfos[id] = info;
    await KV.save(id, jsonEncode(info));
    return info;
  }

  Future<bool> uncacheFileInfo(String id) async {
    try {
      _cachedFileInfos.remove(id);
      await KV.remove(id);
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  String _id(String id, ImageSize size) {
    return "$id-$size";
  }
}
