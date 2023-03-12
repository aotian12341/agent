import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'dart:ui' as ui show instantiateImageCodec, Codec;

class MImage {
  static Widget network(
    String src, {
    Key? key,
    double scale = 1.0,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BoxFit? fit,
    Alignment alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    FilterQuality filterQuality = FilterQuality.low,
    Map<String, String>? headers,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image(
      image: NetworkImageSSL(src),
      loadingBuilder: (
        BuildContext context,
        Widget child,
        ImageChunkEvent? loadingProgress,
      ) {
        if (loadingProgress == null) {
          return child;
        }

        return Image.asset(
          "assets/images/icon_loading.png",
          width: width ?? MediaQuery.of(context).size.width,
          height: height ?? 200,
        );
      },
      errorBuilder: (
        BuildContext context,
        Object error,
        StackTrace? stackTrace,
      ) {
        return Image.asset(
          "assets/images/icon_no_data.png",
          width: width,
          height: height,
        );
      },
      key: key,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      filterQuality: filterQuality,
    );
  }

  static Future<Widget> file(
    String src, {
    String? path,
    Key? key,
    double scale = 1.0,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BoxFit? fit,
    Alignment alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    FilterQuality filterQuality = FilterQuality.low,
    Map<String, String>? headers,
    int? cacheWidth,
    int? cacheHeight,
  }) async {
    try {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.camera,
        Permission.storage,
      ].request();

      if (statuses[Permission.camera] == PermissionStatus.granted &&
          statuses[Permission.storage] == PermissionStatus.granted) {
        File text = File(path ?? '');
        final textBool = await text.exists();
        if (textBool) {
          return Image.file(
            text,
            errorBuilder: (
              BuildContext context,
              Object error,
              StackTrace? stackTrace,
            ) {
              return Image.asset(
                "assets/images/icon_no_data.png",
                width: width,
                height: height,
              );
            },
            key: key,
            scale: scale,
            width: width,
            height: height,
            color: color,
            opacity: opacity,
            fit: fit,
            alignment: alignment,
            repeat: repeat,
            filterQuality: filterQuality,
            cacheHeight: cacheHeight,
            cacheWidth: cacheWidth,
          );
        } else {
          return Image.network(
            src,
            loadingBuilder: (
              BuildContext context,
              Widget child,
              ImageChunkEvent? loadingProgress,
            ) {
              if (loadingProgress == null) {
                return child;
              }

              return Image.asset(
                "assets/images/icon_loading.png",
                width: width,
                height: height,
              );
            },
            errorBuilder: (
              BuildContext context,
              Object error,
              StackTrace? stackTrace,
            ) {
              return Image.asset(
                "assets/images/icon_no_data.png",
                width: width,
                height: height,
              );
            },
            key: key,
            scale: scale,
            width: width,
            headers: headers,
            height: height,
            color: color,
            opacity: opacity,
            fit: fit,
            alignment: alignment,
            repeat: repeat,
            filterQuality: filterQuality,
            cacheHeight: cacheHeight,
            cacheWidth: cacheWidth,
          );
        }
      }
    } catch (e) {}

    return Container();
  }
}

class NetworkImageSSL extends ImageProvider<NetworkImageSSL> {
  const NetworkImageSSL(this.url, {this.scale = 1.0, this.headers});

  final String url;

  final double scale;

  final Map<String, String>? headers;

  @override
  Future<NetworkImageSSL> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<NetworkImageSSL>(this);
  }

  @override
  ImageStreamCompleter load(NetworkImageSSL key, DecoderCallback decode) {
    return MultiFrameImageStreamCompleter(
        codec: _loadAsync(key), scale: key.scale);
  }

  static final HttpClient _httpClient = HttpClient()
    ..badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);

  Future<ui.Codec> _loadAsync(NetworkImageSSL key) async {
    assert(key == this);

    final Uri resolved = Uri.base.resolve(key.url);
    final HttpClientRequest request = await _httpClient.getUrl(resolved);
    headers?.forEach((String name, String value) {
      request.headers.add(name, value);
    });
    final HttpClientResponse response = await request.close();
    if (response.statusCode != HttpStatus.ok) {
      throw Exception('HTTP请求失败，状态码: ${response.statusCode}, $resolved');
    }

    final Uint8List bytes = await consolidateHttpClientResponseBytes(response);
    if (bytes.lengthInBytes == 0) {
      throw Exception('NetworkImageSSL是一个空文件: $resolved');
    }

    return await ui.instantiateImageCodec(bytes);
  }

  @override
  bool operator ==(dynamic other) {
    if (other.runtimeType != runtimeType) return false;
    final NetworkImageSSL typedOther = other;
    return url == typedOther.url && scale == typedOther.scale;
  }

  @override
  int get hashCode => hashValues(url, scale);

  @override
  String toString() => '$runtimeType("$url", scale: $scale)';
}
