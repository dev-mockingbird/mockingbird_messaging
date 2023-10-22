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

  File? cachedFile(String id) {
    if (_cachedFiles[id] != null) {
      return File(_cachedFiles[id]!);
    }
    return null;
  }

  Future<File?> cacheFile(
    String id,
    void Function(int, int)? receiveCallback,
  ) async {
    FileInfo? info = await cacheFileInfo(id);
    if (info == null) {
      return null;
    }
    Directory dir = await getApplicationCacheDirectory();
    var pathfile = "${dir.path}/${info.md5sum ?? info.id}";
    final file = File(pathfile);
    if (await file.exists()) {
      _cachedFiles[id] = pathfile;
      return file;
    }
    try {
      await fileManager.download(
        info.accessUrl!,
        pathfile,
        receiveCallback: receiveCallback,
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
    _cachedFiles[id] = pathfile;
    return file;
  }

  FileInfo? cachedFileInfo(String id) {
    return _cachedFileInfos[id];
  }

  Future<FileInfo?> cacheFileInfo(String id) async {
    var info = cachedFileInfo(id);
    if (info != null) {
      return info;
    }
    String data = await KV.get<String>(id);
    if (data != "") {
      FileInfo info = FileInfo.fromJson(jsonDecode(data));
      _cachedFileInfos[id] = info;
      return info;
    }
    try {
      FileInfo info = await fileManager.getFileInfo(id);
      _cachedFileInfos[id] = info;
      await KV.save(id, jsonEncode(info));
      return info;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }
}
