import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;

import 'package:agent/common/plugin_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as gx;
import 'package:permission_handler/permission_handler.dart';

import '../constants/app_config.dart';
import '../controller/user_controller.dart';
import '../generated/json/base/json_convert_content.dart';
import '../routes/Routes.dart';
import '../widget/loading.dart';
import '../widget/m_toast.dart';
import 'aes_util.dart';
import 'plugin_utils.dart';

/// 请求类型
enum HttpMethod {
  ///
  get,

  ///
  post,

  ///
  patch,

  ///
  delete,
}

/// 网络请求
class HttpController {
  static final HttpController _instance = HttpController._internal();

  ///
  late Dio dio;

  bool isFirstOverdue = true;

  final String tokenRefreshApi = "auth/refresh";

  ///
  Options? options;

  ///
  Loading? loading;

  /// 请求任务栈
  List<String> taskList = [];

  /// 提供了一个工厂方法来获取该类的实例
  factory HttpController() {
    return _instance;
  }

  /// 通过私有方法_internal()隐藏了构造方法，防止被误创建
  HttpController._internal() {
    // 初始化
    init();
  }
  // Singleton._internal(); // 不需要初始化

  /// 初始化
  void init() {
    dio = Dio();
    dio.options.connectTimeout = 50000;
    dio.options.receiveTimeout = 20000;
    httpLog();
  }

  ///
  Future<T?> get<T>(
    String action, {
    Map<String, Object?>? query,
    Map<dynamic, dynamic>? model,
    bool? showLoading,
    bool? showErrorToast,
    bool? special = false,
    bool check = true,
    Function? success,
    Function? fail,
  }) async {
    return call<T>(
      action,
      data: query,
      model: model,
      special: special,
      method: HttpMethod.get,
      loading: showLoading,
      showTips: showErrorToast,
      check: check,
      success: success,
      fail: fail,
    );
  }

  /// post
  Future<T?> post<T>(
    String action, {
    Map<String, Object?>? query,
    Map<dynamic, dynamic>? model,
    bool? showLoading,
    bool? showErrorToast,
    bool? special = false,
    bool check = true,
    Function? success,
    Function? fail,
  }) async {
    return call<T>(
      action,
      data: query,
      model: model,
      special: special,
      method: HttpMethod.post,
      loading: showLoading,
      showTips: showErrorToast,
      check: check,
      success: success,
      fail: fail,
    );
  }

  /// delete
  Future<T?> delete<T>(
    String action, {
    Map<String, Object?>? query,
    Map<dynamic, dynamic>? model,
    bool? showLoading,
    bool? showErrorToast,
    bool check = true,
    Function? success,
    Function? fail,
  }) async {
    return call<T>(
      action,
      data: query,
      model: model,
      method: HttpMethod.delete,
      loading: showLoading,
      showTips: showErrorToast,
      check: check,
      success: success,
      fail: fail,
    );
  }

  /// 网络请求
  Future<T?> call<T>(
    String action, {
    Map<String, dynamic>? data,
    Map<dynamic, dynamic>? model,
    HttpMethod method = HttpMethod.get,
    bool? loading,
    bool? showTips,
    bool? special = false,
    bool check = true,
    Function? success,
    Function? fail,
  }) async {
    showTips ??= true;
    String taskId = DateTime.now().millisecondsSinceEpoch.toString() +
        math.Random().nextInt(1000).toString();
    final extra = <String, dynamic>{};
    extra["taskId"] = taskId;
    Options callOptions = Options(extra: extra);

    /// 是否显示loading
    if (loading ?? false) {
      taskList.add(taskId);
      showLoading();
    }

    // await PluginUtils().getRealServiceAddress();

    /// 基础api   2082
    String url = AppConfig.baseUrl;
    // String url = "${AppConfig.baseUrl}:${AppConfig.basePort}/";

    /// 若action为方法，则是正常调用，若action为完整url，则认为是访问第三方网站，直接把返回值回调
    bool isNormal = true;

    /// action.startsWith 检测字符串是否为"http"开头
    if (action.startsWith("http")) {
      url = action;
      isNormal = false;
    } else {
      url += action;
    }

    data ??= <String, dynamic>{};

    data = initHeadParams(data);
    if (UserController().token != null) {
      dio.options.headers["Authorization"] = UserController().token;
    }
    dio.options.headers
        .removeWhere((key, dynamic value) => value == null || value == "");
    data.removeWhere((key, dynamic value) => value == null || value == "");

    late Response<dynamic> response;

    try {
      if (method == HttpMethod.get) {
        response = await dio.get<dynamic>(url,
            queryParameters: data, options: callOptions);
      } else if (method == HttpMethod.post) {
        response = await dio.post<dynamic>(url,
            queryParameters: data, options: callOptions);
      } else if (method == HttpMethod.delete) {
        response = await dio.delete<dynamic>(url,
            queryParameters: data, options: callOptions);
      }
    } on DioError catch (error) {
      if (taskList.contains(error.requestOptions.extra["taskId"].toString())) {
        taskList.remove(error.requestOptions.extra["taskId"].toString());
      }

      String errorStr = "";
      hideLoading();
      var routePath = ModalRoute.of(gx.Get.context!)?.settings.name;
      debugPrint("current route: $routePath");
      if (error.toString().contains("400001") ||
          error.toString().contains("403111")) {
        errorStr = "请先登录";
      } else if (error.response?.statusCode == 401) {
        /// token过期
        ///
      } else if (error.type == DioErrorType.other) {
        errorStr = "无网络";
      } else if (error.type == DioErrorType.connectTimeout) {
        errorStr = "网络请求超时，请稍后重试";
      } else if (error.type == DioErrorType.receiveTimeout) {
        // await PluginUtils().restartService();
        // PluginUtils().getConnectPort();
        // PluginUtils().getRealServiceAddress();
        call(action,
            data: data,
            method: method,
            loading: loading,
            success: success,
            fail: fail);
        // errorStr = "网络连接超时，请稍后重试";
      } else if (error.type == DioErrorType.response) {
        errorStr = "服务器繁忙，请稍后重试";
        if (error.message.contains("500")) {
          errorStr = error.response?.data["message"];
        }
        debugPrint(error.response?.data.toString());
      } else {
        errorStr = error.toString();
      }
      onError(msg: errorStr, fail: fail, showTips: showTips);

      hideLoading();

      return null;
    }

    if (action != tokenRefreshApi) {
      isFirstOverdue = true;
    }

    if (taskList.contains(response.requestOptions.extra["taskId"].toString())) {
      taskList.remove(response.requestOptions.extra["taskId"].toString());
    }

    hideLoading();

    if (response.data is DioError) {
      onError(
          msg: response.data['message'] as String,
          fail: fail,
          showTips: showTips);
      return null;
    }

    /// 如果不是咱配置的域名，因为格式不合适，所以不解析，直接就返回了
    if (!isNormal) {
      final map = Map<String, dynamic>.from(response.data as Map);
      return map as T;
    }

    // final base64Str = response.data["data"].toString();
    //
    // final cipherData = json.decode(utf8.decode(base64Decode(base64Str)));
    //
    // final iv = cipherData["iv"].toString();
    // final cipherStr = cipherData["result"].toString();
    //
    // final plaintext = AesUtil.aesDecrypt(cipherStr, iv);
    //
    // log("iv:$iv");
    // log("密文:$cipherStr");
    //
    // final res = json.decode(plaintext);
    // log("明文:${json.encode(res)}");

    final res = response.data;

    try {
      log("message:${utf8.decode(res["message"])}");
    } catch (e) {}

    // final res = response.data;
    if (res is String) {
      onSuccess<T>(success, res);
      return null;
    }
    final result = res["state"] as int;
    if (result == 200) {
      dynamic temp;
      try {
        if (res["data"] == null) {
          if (T.toString() == (ResultInfo).toString()) {
            ResultInfo info = ResultInfo();
            info.state = res["state"] as int;
            info.message = res['message'] as String;
            temp = info as T;
          } else {
            temp = null;
          }
        } else if (special ?? false) {
          temp = res["data"];
        } else if (<T>[] is List<int>) {
          temp = res["data"] as int;
        } else if (<T>[] is double) {
          temp = res["data"] as double;
        } else if (<T>[] is List<String>) {
          temp = res["data"] as String;
        } else if (<T>[] is List<bool>) {
          temp = res["data"] as bool;
        } else if (<T>[] is List<Map>) {
          temp = Map<String, dynamic>.from(res["data"] as Map);
        } else if (T.toString() == (ResultInfo).toString()) {
          ResultInfo info = ResultInfo();
          info.data = res["data"];
          info.state = res["state"] as int;
          info.message = res['message'] as String;
          temp = info as T;
        } else if (T.toString().contains("List") &&
            T.toString().contains("Map")) {
          temp = res["data"];
        } else {
          temp = JsonConvert.fromJsonAsT<T>(res["data"]);
        }
        onSuccess<T>(success, temp);
      } catch (error) {
        onError(msg: "数据解析失败", fail: fail, showTips: showTips);
        return null;
      }
      return temp;
    } else if (result == 401) {
      if (!UserController().isLogin && check) {
        UserController().isLogin = true;
        MToast.show("无效登录信息,请重新登录!");
        gx.Get.offAllNamed(Routes.login);
      } else {
        onError(msg: res['message'] as String, fail: fail, showTips: showTips);
      }
    } else if (result == 251) {
    } else {
      onError(msg: res['message'] as String, fail: fail, showTips: showTips);
      return null;
    }
  }

  Map<String, dynamic> initHeadParams(Map<String, dynamic> data) {
    return data;
  }

  ///
  void onSuccess<T>(Function? success, dynamic t) {
    if (success != null) {
      if (t == null) {
        success(t);
      } else {
        success(t);
      }
    }
  }

  ///
  void onError({required String msg, Function? fail, bool? showTips}) {
    if ((showTips ?? false) && fail == null) {
      MToast.show(msg);
    }
    if (fail != null) {
      fail(msg);
    }
  }

  /// 显示loading
  void showLoading() {
    if (gx.Get.context != null) {
      if (loading == null) {
        loading = Loading();
        showDialog<dynamic>(
          context: gx.Get.context!,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return loading!;
          },
        );
      }
    }
  }

  /// 隐藏loading
  void hideLoading() {
    if (gx.Get.context != null && loading != null && taskList.isEmpty) {
      loading!.hide();
      loading = null;
    }
  }

  /// 拦截器
  void httpLog() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
          log("\n================================= 请求数据 =================================");
          log("method = ${options.method.toString()}");
          log("url = ${options.uri.toString()}");
          log("headers = ${options.headers}");
          log("requestTime = ${DateTime.now()}");
          if (options.method.toString() == "GET") {
            log("data = ${options.queryParameters}");
          } else {
            log("data = ${options.queryParameters}");
          }
          return handler.next(options);
        },
        onResponse: (
          Response response,
          ResponseInterceptorHandler handler,
        ) {
          log("================================= 响应数据开始 =================================");
          log("code = ${response.statusCode}");
          log("responseTime = ${DateTime.now()}");
          log("url = ${response.requestOptions.path}");
          log("header = ${response.requestOptions.headers}");
          log("params = ${response.requestOptions.queryParameters}");
          log("data = ${json.encode(response.data)}");
          log("================================= 响应数据结束 =================================\n");

          return handler.next(response);
        },
        onError: (DioError e, ErrorInterceptorHandler handler) {
          log("\n=================================错误响应数据 =================================");
          log("type = ${e.type}");
          log("url = ${e.requestOptions.path}");
          log("header = ${e.requestOptions.headers}");
          log("params = ${e.requestOptions.queryParameters}");
          log("message = ${e.message}");
          log("data = ${e.response?.data.toString()}");
          log("stackTrace = ${e.error}");
          log("\n");

          return handler.next(e);
        },
      ),
    );
  }

  /// 单纯的Json格式输出打印
  void printJson(Object object) {
    const encoder = JsonEncoder.withIndent('  ');
    try {
      final encoderString = encoder.convert(object);
      debugPrint(encoderString);
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> download({
    required String url,
    required String path,
    CancelToken? token,
    DownloadListener? listener,
  }) async {
    try {
      File file = File(path);
      if (!file.existsSync()) {
        file.createSync();
      }

      final permission = await checkPermissionFunction();

      if (permission) {
        if (listener != null) {
          listener.onStart();
        }
        Response response = await Dio().download(url, path,
            onReceiveProgress: (received, total) {
          if (total != -1) {
            ///当前下载的百分比例
            debugPrint("${(received / total * 100).toStringAsFixed(0)}%");
            if (listener != null) {
              listener.onProgress(total, received / total);
            }
          }
        }, cancelToken: token);
        if (response.statusCode == 200) {
          debugPrint('下载请求成功');
          if (listener != null) {
            listener.onFinish();
          }
        }
      }
    } catch (e) {
      if (listener != null) {
        listener.onError(e.toString());
      }
    }
  }

  Future<bool> checkPermissionFunction() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();

    if (statuses[Permission.storage] == PermissionStatus.granted) {
      return true;
    } else {
      return false;
    }
  }

  String getRandom(int num) {
    String alphabet = 'qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM';
    String left = '';
    for (var i = 0; i < num; i++) {
      left = left + alphabet[math.Random().nextInt(alphabet.length)];
    }
    return left;
  }

  String getFileType(String path) {
    debugPrint(path);
    List<String> array = path.split('.');
    return array[array.length - 1];
  }

  Future<String> upload(
      {required String path, UploadListener? listener}) async {
    final uuid = getRandom(30);

    final uploadCancelToken = CancelToken();

    listener?.onCreate(uuid, uploadCancelToken);

    String pathName = '${getRandom(12)}.${getFileType(path)}';
    final formData = FormData.fromMap(
        {"img": await MultipartFile.fromFile(path, filename: pathName)});
    Response res = await dio.post(
        //此处更换为自己的上传文件接口
        "${AppConfig.baseUrl}user/uploadImg",
        data: formData, onSendProgress: (send, total) {
      debugPrint('已发送：$send  总大小：$total');
      if (listener != null) {
        listener.onProgress(uuid, send, total);
      }
    });

    // final base64Str = res.data["data"].toString();
    //
    // final cipherData = json.decode(utf8.decode(base64Decode(base64Str)));
    //
    // final iv = cipherData["iv"].toString();
    // final cipherStr = cipherData["result"].toString();
    //
    // final plaintext = AesUtil.aesDecrypt(cipherStr, iv);
    //
    // log("iv:$iv");
    // log("密文:$cipherStr");
    //
    // final temp = json.decode(plaintext);
    // log("明文:${json.encode(temp)}");
    final temp = res.data;
    if (listener != null) {
      listener.onSuccess(uuid, temp["data"]["path"]);
    }
    return temp["data"]["path"];
  }
}

class DownloadListener {
  DownloadListener({
    required this.onStart,
    required this.onProgress,
    required this.onFinish,
    required this.onError,
  });

  final Function onStart;

  final Function(int total, double progress) onProgress;

  final Function onFinish;

  final Function(String error) onError;
}

class ResultInfo {
  int? state;
  String? message;
  Object? data;
}

/// 上传回调
class UploadListener {
  /// 创建
  Function(String uploadId, CancelToken token) onCreate;

  /// 成功
  Function(String uploadId, String url) onSuccess;

  /// 失败
  Function(String uploadId, String error) onError;

  /// 进度
  Function(String uploadId, int done, int total) onProgress;

  ///
  UploadListener(
      {required this.onCreate,
      required this.onSuccess,
      required this.onError,
      required this.onProgress});
}
