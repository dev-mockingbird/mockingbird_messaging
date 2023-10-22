// Copyright (c) 2023 Yang,Zhong
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'package:json_annotation/json_annotation.dart';
part 'fileinfo.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class VideoInfo {
  FileInfo? thumbnailInfo;
  String? artist;
  String? title;
  int? duration;
  int width;
  int height;

  VideoInfo({
    this.thumbnailInfo,
    this.artist,
    this.title,
    this.duration,
    required this.width,
    required this.height,
  });

  factory VideoInfo.fromJson(Map<String, dynamic> json) =>
      _$VideoInfoFromJson(json);

  Map<String, dynamic> toJson() => _$VideoInfoToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class ImageInfo {
  int width;
  int height;

  ImageInfo({required this.width, required this.height});

  factory ImageInfo.fromJson(Map<String, dynamic> json) =>
      _$ImageInfoFromJson(json);

  Map<String, dynamic> toJson() => _$ImageInfoToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class FileInfo {
  String id;
  String mimeType;
  int? size;
  String? accessUrl;
  String? filename;
  String? md5sum;
  VideoInfo? videoInfo;
  ImageInfo? imageInfo;

  FileInfo({
    required this.id,
    required this.mimeType,
    this.md5sum,
    this.filename,
    this.size,
    this.imageInfo,
    this.videoInfo,
    this.accessUrl,
  });

  factory FileInfo.fromJson(Map<String, dynamic> json) =>
      _$FileInfoFromJson(json);

  Map<String, dynamic> toJson() => _$FileInfoToJson(this);
}
