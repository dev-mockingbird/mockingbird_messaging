// Copyright (c) 2023 Yang,Zhong
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'package:json_annotation/json_annotation.dart';
import 'package:mockingbird_messaging/src/storage/sqlite.dart';
part 'model_sync.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ModelSync implements SqliteModel {
  static String stableName = 'model_syncs';

  @JsonKey(disallowNullValue: false)
  String model;
  String lastUpdatedAt;
  String userId;
  ModelSync({
    required this.model,
    required this.lastUpdatedAt,
    required this.userId,
  });

  static List<String> get fields {
    return [
      "model TEXT",
      "user_id TEXT",
      "last_updated_at TEXT",
      "UNIQUE(model, user_id)",
    ];
  }

  @override
  String get idKey {
    return "model";
  }

  @override
  String tableName() {
    return stableName;
  }

  @override
  Map<String, dynamic> toSqliteMap() {
    return toJson();
  }

  static List<ModelSync> fromSqlite(List<Map<String, Object?>> list) {
    List<ModelSync> ret = [];
    for (var data in list) {
      ret.add(ModelSync.fromJson(data));
    }
    return ret;
  }

  // 反序列化
  factory ModelSync.fromJson(Map<String, dynamic> json) =>
      _$ModelSyncFromJson(json);
  // 序列化
  Map<String, dynamic> toJson() => _$ModelSyncToJson(this);
}
