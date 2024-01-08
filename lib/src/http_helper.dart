// Copyright (c) 2023 Yang,Zhong
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ResponseError {
  int statusCode;
  String code;
  String message;
  ResponseError({
    required this.statusCode,
    required this.code,
    required this.message,
  });
}

typedef HandleError = void Function(ResponseError);

class DioHelper {
  Function(dynamic)? onError;
  String? token;
  String domain;
  DioHelper({required this.domain, this.onError, this.token});
  Dio? _dio;
  Dio? _dioUpload;

  Dio get dio {
    _dio ??= Dio(
      BaseOptions(
        baseUrl: domain,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        validateStatus: (int? status) {
          return true;
        },
      ),
    );
    if (token != null) {
      _dio!.options.headers['authorization'] = 'Bearer $token';
    }
    return _dio!;
  }

  Dio dioUpload({
    Duration? receiveTimeout,
    Duration? connectTimeout,
    Duration? sendTimeout,
  }) {
    _dioUpload ??= Dio(
      BaseOptions(
        baseUrl: domain,
        // If you want to receive the response data with String, use `plain`.
        responseType: ResponseType.plain,
        contentType: Headers.formUrlEncodedContentType,
        connectTimeout: connectTimeout,
        receiveTimeout: receiveTimeout,
        validateStatus: (int? status) {
          return true;
        },
        sendTimeout: sendTimeout,
      ),
    );
    if (token != null) {
      _dioUpload!.options.headers['authorization'] = 'Bearer $token';
    }
    return _dioUpload!;
  }

  // get
  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? data,
    Options? options,
    HandleError? onError,
  }) async {
    return await _do(() async {
      return await dio.get(path, queryParameters: data, options: options);
    }, onError);
  }

  // post
  Future post(
    String path, {
    Object? data,
    Options? options,
    HandleError? showError,
  }) async {
    return await _do(() async {
      return await dio.post(path, data: data, options: options);
    }, showError);
  }

  // put
  Future<dynamic> put(
    String path, {
    Map<String, dynamic>? data,
    Options? options,
    HandleError? handleError,
  }) async {
    return await _do(() async {
      return await dio.put(path, data: data, options: options);
    }, handleError);
  }

  // delete
  Future<dynamic> delete(
    String path, {
    Map<String, dynamic>? data,
    Options? options,
    HandleError? showError,
  }) async {
    return await _do(() async {
      return await dio.delete(path, data: data, options: options);
    }, showError);
  }

  // upload
  Future<dynamic> upload(
    String path,
    data, {
    Function(int sent, int total)? onSent,
    String method = "post",
    HandleError? handleError,
  }) async {
    return await _do(() async {
      var uploader = dioUpload();
      if (method == "post") {
        return await uploader.post(path, data: data, onSendProgress: onSent);
      }
      return await uploader.put(path, data: data, onSendProgress: onSent);
    }, handleError);
  }

  // download
  Future<dynamic> download(
    String path,
    String savePath, {
    void Function(int, int)? receiveCallback,
    Map<String, dynamic>? data,
    Options? options,
    HandleError? showError,
  }) async {
    return await _do(() async {
      var dio = dioUpload();
      return await dio.download(
        path,
        savePath,
        data: data,
        options: options,
        onReceiveProgress: (int receive, int total) {
          if (receiveCallback != null) {
            receiveCallback(receive, total);
          }
        },
      );
    }, showError);
  }

  Future<dynamic> _do(
    Future<Response> Function() d,
    HandleError? handleError,
  ) async {
    try {
      Response res = await d();
      if (res.statusCode == null || (res.statusCode ?? 200) >= 300) {
        _handleError(handleError, _parseBody(res));
        return;
      }
      if (res.data is String) {
        return jsonDecode(res.data);
      }
      return res.data;
    } catch (e) {
      if (e is! DioException) {
        if (kDebugMode) {
          print(e);
        }
        return;
      }
      if (onError != null) {
        onError!(e);
        return;
      }
      rethrow;
    }
  }

  _parseBody(Response res) {
    var err = ResponseError(
      statusCode: res.statusCode ?? 0,
      code: "unknown-error",
      message: "unknown error",
    );
    if (res.data is Map) {
      err.code = res.data["code"] ?? err.code;
      err.message = res.data["data"]["msg"] ?? err.message;
      return err;
    }
    if (res.data is String) {
      // var contentType = res.headers["Content-Type"];
      // if (contentType != null &&
      //     contentType.isNotEmpty &&
      //     contentType.first == "application/json") {
      var body = jsonDecode(res.data);
      err.code = body["code"] ?? err.code;
      err.message = body["data"]["msg"] ?? err.message;
      return err;
      // }
      // err.message = res.data;
    }
    return err;
  }

  _handleError(HandleError? handle, ResponseError err) {
    if (handle == null) {
      throw err;
    }
    handle(err);
  }
}
