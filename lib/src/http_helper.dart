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

  Future<Dio> getDio() async {
    _dio ??= Dio(
      BaseOptions(
        baseUrl: domain,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );
    try {
      if (token != null) {
        _dio!.options.headers['authorization'] = 'Bearer $token';
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return _dio!;
  }

  Future<Dio> dioUpload({
    Duration? receiveTimeout,
    Duration? connectTimeout,
    Duration? sendTimeout,
  }) async {
    _dioUpload ??= Dio(
      BaseOptions(
          baseUrl: domain,
          // If you want to receive the response data with String, use `plain`.
          responseType: ResponseType.plain,
          contentType: Headers.formUrlEncodedContentType,
          connectTimeout: connectTimeout,
          receiveTimeout: receiveTimeout,
          sendTimeout: sendTimeout),
    );
    try {
      if (token != null) {
        _dioUpload!.options.headers['authorization'] = 'Bearer $token';
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
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
    try {
      return _handleData(() async {
        var dio = await getDio();
        return await dio.get(path, queryParameters: data, options: options);
      });
    } catch (e) {
      _errorHandler(e, onError);
    }
  }

  // post
  Future post(
    String path, {
    Object? data,
    Options? options,
    HandleError? showError,
  }) async {
    try {
      return await _handleData(() async {
        var dio = await getDio();
        return await dio.post(path, data: data, options: options);
      });
    } catch (e) {
      _errorHandler(e, showError);
    }
  }

  _handleData(Future<Response> Function() d) async {
    var res = await d();
    return res.data;
  }

  _do(Future Function() d, {HandleError? showError}) async {
    try {
      return await d();
    } on DioException catch (e) {
      _errorHandler(e, showError);
    }
  }

  // put
  Future<dynamic> put(
    String path, {
    Map<String, dynamic>? data,
    Options? options,
    HandleError? showError,
  }) async {
    try {
      return _handleData(() async {
        var dio = await getDio();
        return await dio.put(path, data: data, options: options);
      });
    } catch (e) {
      _errorHandler(e, showError);
    }
  }

  // delete
  Future<dynamic> delete(
    String path, {
    Map<String, dynamic>? data,
    Options? options,
    HandleError? showError,
  }) async {
    try {
      return _handleData(() async {
        var dio = await getDio();
        return await dio.delete(path, data: data, options: options);
      });
    } catch (e) {
      _errorHandler(e, showError);
    }
  }

  // upload
  Future<dynamic> upload(String path, data,
      {Function(int sent, int total)? onSent,
      String method = "post",
      HandleError? showError}) async {
    return await _do(() async {
      var uploader = await dioUpload();
      if (method == "post") {
        Response res =
            await uploader.post(path, data: data, onSendProgress: onSent);
        return jsonDecode(res.data);
      }
      Response res =
          await uploader.put(path, data: data, onSendProgress: onSent);
      return jsonDecode(res.data);
    }, showError: showError);
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
    var dio = await getDio();
    try {
      Response response = await dio.download(
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
      return response.data;
    } on DioException catch (e) {
      _errorHandler(e, showError);
    }
  }

  // 错误处理
  void _errorHandler(Object error, HandleError? showError) async {
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
