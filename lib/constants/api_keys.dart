/// 用户

class UserApi {
  static String login = "auth/login";

  static String userInfo = "user/info";

  static String register = "user/register";

  static String share = "pan/invite_code";

  static String androidVersion = "user/appUpdate";
  static String editPassword = "user/resetPassword";

  static String searchAgent = "user/searchAgent";

  static String rechargeList = "user/recharge_record";

  static String code = "user/invite_code";

  static String inviteList = "user/invite_list";

  static String codeList = "user/listOrderCommand";

  static String createCode = "user/createOrderCommand";

  static String childrenRecharge = "user/report";

  static String userList = "user/user_list";

  static String addUser = "user/addAgent";

  static String editUser = "user/editAgent";

  static String setZhan = "user/editAgentZhan";

  static String setMoney = "user/editAgentMoney";

  static String registerList = "user/registerReport";

  static String registerDetails = "user/registerReportInfo";

  static String rechargeConfirm = "user/testPlay";

  static String agentReport = "user/agentReport";

  static String userReport = "user/userReport";

  static String rechargeRecord = "user/moneyReport";

  static String memberTime = "user/judgment";

  static String plan = "user/plan";

  static String recharge = "user/rechargeMoney";

  static String useCode = "user/useOrderCommand";
}

class VideoApi {
  static String homeData = "user/videoList";

  static String videoDetails = "user/videoInfo";
}

class UserCacheKey {
  /// 用户信息
  static const String userProfileCache = "agent_user";

  /// token
  static const String tokenCache = "agent_token";

  /// 刷新token
  static const String refreshTokenCache = "agent_token_refresh";
}
