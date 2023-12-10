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
    FileInfo? info = await cacheFileInfo(id);
    if (info == null) {
      return null;
    }
    Directory dir = await getApplicationCacheDirectory();
    var pathfile = "${dir.path}/${_id(id, size)}";
    final file = File(pathfile);
    if (await file.exists() && await file.length() > 0) {
      _cachedFiles[id] = pathfile;
      return file;
    }
    return null;
  }

  Future<File?> cacheFile(
    String id, {
    ImageSize size = ImageSize.md,
    void Function(int, int)? receiveCallback,
  }) async {
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
    try {
      await fileManager.download(
        info.accessUrl!,
        pathfile,
        receiveCallback: receiveCallback,
        imageSize: size,
      );
      _cachedFiles[_id(id, size)] = pathfile;
      return file;
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
