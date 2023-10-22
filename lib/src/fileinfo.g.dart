// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fileinfo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideoInfo _$VideoInfoFromJson(Map<String, dynamic> json) => VideoInfo(
      thumbnailInfo: json['thumbnail_info'] == null
          ? null
          : FileInfo.fromJson(json['thumbnail_info'] as Map<String, dynamic>),
      artist: json['artist'] as String?,
      title: json['title'] as String?,
      duration: json['duration'] as int?,
      width: json['width'] as int,
      height: json['height'] as int,
    );

Map<String, dynamic> _$VideoInfoToJson(VideoInfo instance) => <String, dynamic>{
      'thumbnail_info': instance.thumbnailInfo,
      'artist': instance.artist,
      'title': instance.title,
      'duration': instance.duration,
      'width': instance.width,
      'height': instance.height,
    };

ImageInfo _$ImageInfoFromJson(Map<String, dynamic> json) => ImageInfo(
      width: json['width'] as int,
      height: json['height'] as int,
    );

Map<String, dynamic> _$ImageInfoToJson(ImageInfo instance) => <String, dynamic>{
      'width': instance.width,
      'height': instance.height,
    };

FileInfo _$FileInfoFromJson(Map<String, dynamic> json) => FileInfo(
      id: json['id'] as String,
      mimeType: json['mime_type'] as String,
      md5sum: json['md5sum'] as String?,
      filename: json['filename'] as String?,
      size: json['size'] as int?,
      imageInfo: json['image_info'] == null
          ? null
          : ImageInfo.fromJson(json['image_info'] as Map<String, dynamic>),
      videoInfo: json['video_info'] == null
          ? null
          : VideoInfo.fromJson(json['video_info'] as Map<String, dynamic>),
      accessUrl: json['access_url'] as String?,
    );

Map<String, dynamic> _$FileInfoToJson(FileInfo instance) => <String, dynamic>{
      'id': instance.id,
      'mime_type': instance.mimeType,
      'size': instance.size,
      'access_url': instance.accessUrl,
      'filename': instance.filename,
      'md5sum': instance.md5sum,
      'video_info': instance.videoInfo,
      'image_info': instance.imageInfo,
    };
