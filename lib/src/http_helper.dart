// Copyright (c) 2023 Yang,Zhong
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

typedef HandleError = void Function(dynamic);

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
    HandleError? showError,
  }) async {
    return await _do(() async {
      return await dio.put(path, data: data, options: options);
    }, showError);
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
      if (res.data is String) {
        return jsonDecode(res.data);
      }
      return res.data;
    } catch (e) {
      _errorHandler(e, handleError);
    }
  }

  // 错误处理
  void _errorHandler(Object error, HandleError? showError) {
    if (error is! DioException) {
      if (kDebugMode) {
        print(error);
      }
      return;
    }
    if (showError != null) {
      showError(error);
      return;
    }
    if (onError != null) {
      onError!(error);
      return;
    }
    throw error;
  }
}
