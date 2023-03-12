import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/http_controller.dart';
import '../constants/api_keys.dart';
import '../generated/json/base/json_convert_content.dart';
import '../model/user_info.dart';
import 'socket_controller.dart';

class UserController {
  ///
  factory UserController() => _getInstance();

  // 静态私有成员，没有初始化
  static UserController? _instance;

  // 静态、同步、私有访问点
  static UserController _getInstance() {
    _instance ??= UserController._internal();
    return _instance!;
  }

  // 私有构造函数
  UserController._internal() {
    getCacheToken();
  }

  /// 令牌
  String? token;

  /// 刷新令牌
  String? refreshToken;

  /// 是否正在登录
  bool isLogin = false;

  /// 是否显示公告
  bool isShowNotice = false;

  bool get isAgent => (user.isAgent ?? 0) == 1 || (user.isAgent ?? 0) == 3;

  final _userInfo = UserInfo().obs;

  UserInfo get user => _userInfo.value;

  set user(UserInfo info) => _userInfo(info);

  final levelName = "".obs;

  final unApplyList = [].obs;

  String noticeTitle = "";
  String noticeContent = "";
  final noticeList = [].obs;

  /// 获取缓存token
  void getCacheToken() async {
    final share = await SharedPreferences.getInstance();
    if (share.getString(UserCacheKey.tokenCache) != null) {
      token = share.getString(UserCacheKey.tokenCache);
    }
    if (share.getString(UserCacheKey.refreshTokenCache) != null) {
      refreshToken = share.getString(UserCacheKey.refreshTokenCache);
    }
    getUserInfo(
        check: false,
        success: (res) {
          if (user.isAgent == 1) {
            SocketController().connect();
          }
        });
  }

  /// 清除缓存token
  void clearTokenCache() async {
    final share = await SharedPreferences.getInstance();
    share.setString(UserCacheKey.tokenCache, "");
    share.setString(UserCacheKey.refreshTokenCache, "");
  }

  /// 缓存token
  Future<void> cacheToken() async {
    final share = await SharedPreferences.getInstance();
    share.setString(UserCacheKey.tokenCache, token ?? "");
    share.setString(UserCacheKey.refreshTokenCache, refreshToken ?? "");
  }

  /// 登出
  void loginOut() {
    user = UserInfo();
    token = null;
    clearTokenCache();
    SocketController().dispose();
  }

  void login({
    required String userName,
    required String password,
    Function? success,
    Function? fail,
  }) {
    HttpController().post<Map<String, dynamic>>(UserApi.login,
        query: {"username": userName, "password": password},
        showLoading: false, success: (value) {
      token = value["token_type"] + " " + value["token"];
      cacheToken();
      getUserInfo(success: success);
    }, fail: fail);
  }

  /// 获取用户信息
  void getUserInfo({bool check = true, Function? success}) {
    HttpController().get<Map<String, dynamic>>(UserApi.userInfo,
        success: (value) {
      final map = value["list"] as Map;
      user = JsonConvert.fromJsonAsT<UserInfo>(map) ?? UserInfo();

      if (success != null) {
        success(user);
      }
    }, showLoading: false, check: check, showErrorToast: check);
  }

  /// 注册
  void register({
    required String userName,
    required String password,
    Function? success,
  }) {
    HttpController().post(UserApi.register,
        query: {
          "username": userName,
          "new_pass": password,
          "new_passconfirm": password
        },
        success: success,
        showLoading: true);
  }

  /// 分享
  void getShare({Function? success}) {
    HttpController().get(UserApi.share, success: success, showLoading: true);
  }

  /// 修改密码
  void editPassword({String? old, String? newStr, Function? success}) {
    HttpController().post(UserApi.editPassword,
        query: {"oldPass": old, "newPass": newStr},
        success: success,
        showLoading: true);
  }

  void search({String? username, Function? success}) {
    HttpController().get<Map<String, dynamic>>(UserApi.searchAgent,
        query: {"username": username}, success: success, showLoading: true);
  }

  void getOrderList() {}

  void getRechargeList({int? page, Function? success}) {
    HttpController().get<Map<String, dynamic>>(UserApi.rechargeList,
        query: {"page": page}, success: success, showLoading: false);
  }

  void getCode({Function? success}) {
    HttpController().get<Map<String, dynamic>>(UserApi.code,
        query: {}, success: success, showLoading: true);
  }

  void getInviteList({int? page, Function? success}) {
    HttpController().get<Map<String, dynamic>>(UserApi.inviteList,
        query: {"page": page}, success: success, showLoading: false);
  }

  void getCodeList({int? page, Function? success}) {
    HttpController().get<Map<String, dynamic>>(UserApi.codeList,
        query: {"page": page}, success: success, showLoading: false);
  }

  void createCode({Function? success}) {
    HttpController().get<Map<String, dynamic>>(UserApi.createCode,
        query: {}, success: success, showLoading: true);
  }

  void getChildrenRecharge(
      {int? id, String? start, String? end, Function? success}) {
    HttpController().get<Map<String, dynamic>>(UserApi.childrenRecharge,
        query: {"pid": id, 'start_time': start, 'end_time': end},
        success: success,
        showLoading: true);
  }

  void getUserList({int? pid, int? page, String? username, Function? success}) {
    HttpController().get<Map<String, dynamic>>(UserApi.userList,
        query: {"pid": pid, 'page': page, 'username': username},
        success: success,
        showLoading: false);
  }

  void editUser(
      {int? id,
      String? username,
      String? password,
      String? cnname,
      int? state,
      Function? success}) {
    if (id != null) {
      HttpController().post(UserApi.editUser,
          query: {
            "status": state,
            'password': password,
            'cnname': cnname,
            'id': id
          },
          success: success,
          showLoading: true,
          showErrorToast: true);
    } else {
      HttpController().post(UserApi.addUser,
          query: {
            "cnname": cnname,
            'password': password,
            'username': username,
          },
          success: success,
          showLoading: true,
          showErrorToast: true);
    }
  }

  void getAgentDetails({int? id, Function? success}) {
    HttpController().get<Map<String, dynamic>>(UserApi.editUser,
        query: {'id': id}, success: success, showLoading: true);
  }

  void setZhan({int? id, String? zhan, Function? success}) {
    HttpController().post(UserApi.setZhan,
        query: {
          "id": id,
          'zhan': zhan,
        },
        success: success,
        showLoading: true,
        showErrorToast: true);
  }

  void setMoney({int? id, String? money, Function? success}) {
    HttpController().post(UserApi.setMoney,
        query: {
          "id": id,
          'money': money,
        },
        success: success,
        showLoading: true,
        showErrorToast: true);
  }

  void getRegisterList(
      {String? startTime, String? endTime, Function? success}) {
    HttpController().get(UserApi.registerList,
        query: {'start_time': startTime, 'end_time': endTime},
        success: success,
        showLoading: false,
        showErrorToast: true);
  }

  void getRegisterDetails(
      {int? parentId, String? startTime, String? endTime, Function? success}) {
    HttpController().get(UserApi.registerDetails,
        query: {
          'parent_id': parentId,
          'start_time': startTime,
          'end_time': endTime
        },
        success: success,
        showLoading: false,
        showErrorToast: true);
  }

  void rechargeConfirm({String? orderId}) {
    HttpController().post(UserApi.rechargeConfirm, query: {'id': orderId});
  }

  void getAgentRecord(
      {int? parentId, String? startTime, String? endTime, Function? success}) {
    HttpController().get(UserApi.agentReport,
        query: {
          'parent_id': parentId,
          'start_time': startTime,
          'end_time': endTime
        },
        success: success,
        showLoading: false,
        showErrorToast: true);
  }

  void getUserRecord(
      {int? parentId, String? startTime, String? endTime, Function? success}) {
    HttpController().get(UserApi.userReport,
        query: {
          'parent_id': parentId,
          'start_time': startTime,
          'end_time': endTime
        },
        success: success,
        showLoading: false,
        showErrorToast: true);
  }

  void getRechargeRecord(
      {String? startTime, String? endTime, Function? success}) {
    HttpController().get(UserApi.rechargeRecord,
        query: {'start_time': startTime, 'end_time': endTime},
        success: success,
        showLoading: false,
        showErrorToast: true);
  }

  void getMemberTime({Function? success, Function? fails}) {
    HttpController().get(UserApi.memberTime,
        success: success, fail: fails, showLoading: true);
  }

  void getPlan({Function? success}) {
    HttpController().get(UserApi.plan,
        success: success, showLoading: true, showErrorToast: true);
  }

  void recharge({double? money, int? type, Function? success}) {
    HttpController().post(UserApi.recharge,
        query: {'money': money, 'type': type}, success: success);
  }

  void useCode({String? code, Function? success}) {
    HttpController().get(UserApi.useCode,
        query: {'code': code}, success: success, showLoading: true);
  }
}
