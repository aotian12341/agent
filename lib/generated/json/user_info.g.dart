import 'package:agent/generated/json/base/json_convert_content.dart';
import 'package:agent/model/user_info.dart';

UserInfo $UserInfoFromJson(Map<String, dynamic> json) {
  final UserInfo userInfo = UserInfo();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    userInfo.id = id;
  }
  final String? username = jsonConvert.convert<String>(json['username']);
  if (username != null) {
    userInfo.username = username;
  }
  final String? cnname = jsonConvert.convert<String>(json['cnname']);
  if (cnname != null) {
    userInfo.cnname = cnname;
  }
  final int? sonStatus = jsonConvert.convert<int>(json['son_status']);
  if (sonStatus != null) {
    userInfo.sonStatus = sonStatus;
  }
  final int? agentMoney = jsonConvert.convert<int>(json['agent_money']);
  if (agentMoney != null) {
    userInfo.agentMoney = agentMoney;
  }
  final int? parentId = jsonConvert.convert<int>(json['parent_id']);
  if (parentId != null) {
    userInfo.parentId = parentId;
  }
  final String? roomId = jsonConvert.convert<String>(json['room_id']);
  if (roomId != null) {
    userInfo.roomId = roomId;
  }
  final String? roomName = jsonConvert.convert<String>(json['room_name']);
  if (roomName != null) {
    userInfo.roomName = roomName;
  }
  final String? roomPhoto = jsonConvert.convert<String>(json['room_photo']);
  if (roomPhoto != null) {
    userInfo.roomPhoto = roomPhoto;
  }
  final dynamic? deletedAt = jsonConvert.convert<dynamic>(json['deleted_at']);
  if (deletedAt != null) {
    userInfo.deletedAt = deletedAt;
  }
  final String? createTime = jsonConvert.convert<String>(json['create_time']);
  if (createTime != null) {
    userInfo.createTime = createTime;
  }
  final int? status = jsonConvert.convert<int>(json['status']);
  if (status != null) {
    userInfo.status = status;
  }
  final int? registerStatus = jsonConvert.convert<int>(json['register_status']);
  if (registerStatus != null) {
    userInfo.registerStatus = registerStatus;
  }
  final int? isAgent = jsonConvert.convert<int>(json['is_agent']);
  if (isAgent != null) {
    userInfo.isAgent = isAgent;
  }
  final int? isUser = jsonConvert.convert<int>(json['is_user']);
  if (isUser != null) {
    userInfo.isUser = isUser;
  }
  final int? isAgentWeb = jsonConvert.convert<int>(json['is_agent_web']);
  if (isAgentWeb != null) {
    userInfo.isAgentWeb = isAgentWeb;
  }
  final int? isClass = jsonConvert.convert<int>(json['is_class']);
  if (isClass != null) {
    userInfo.isClass = isClass;
  }
  final dynamic? qqChat = jsonConvert.convert<dynamic>(json['qq_chat']);
  if (qqChat != null) {
    userInfo.qqChat = qqChat;
  }
  final dynamic? wechat = jsonConvert.convert<dynamic>(json['wechat']);
  if (wechat != null) {
    userInfo.wechat = wechat;
  }
  final dynamic? openTime = jsonConvert.convert<dynamic>(json['open_time']);
  if (openTime != null) {
    userInfo.openTime = openTime;
  }
  final dynamic? loseTime = jsonConvert.convert<dynamic>(json['lose_time']);
  if (loseTime != null) {
    userInfo.loseTime = loseTime;
  }
  final dynamic? agentNotice =
      jsonConvert.convert<dynamic>(json['agent_notice']);
  if (agentNotice != null) {
    userInfo.agentNotice = agentNotice;
  }
  final int? photo = jsonConvert.convert<int>(json['photo']);
  if (photo != null) {
    userInfo.photo = photo;
  }
  final dynamic? minFen = jsonConvert.convert<dynamic>(json['min_fen']);
  if (minFen != null) {
    userInfo.minFen = minFen;
  }
  final int? xiaFen = jsonConvert.convert<int>(json['xia_fen']);
  if (xiaFen != null) {
    userInfo.xiaFen = xiaFen;
  }
  final dynamic? minXiazhu = jsonConvert.convert<dynamic>(json['min_xiazhu']);
  if (minXiazhu != null) {
    userInfo.minXiazhu = minXiazhu;
  }
  final dynamic? openid = jsonConvert.convert<dynamic>(json['openid']);
  if (openid != null) {
    userInfo.openid = openid;
  }
  final dynamic? unionid = jsonConvert.convert<dynamic>(json['unionid']);
  if (unionid != null) {
    userInfo.unionid = unionid;
  }
  final String? inviteStatus =
      jsonConvert.convert<String>(json['invite_status']);
  if (inviteStatus != null) {
    userInfo.inviteStatus = inviteStatus;
  }
  final dynamic? rememberToken =
      jsonConvert.convert<dynamic>(json['remember_token']);
  if (rememberToken != null) {
    userInfo.rememberToken = rememberToken;
  }
  final dynamic? switchPei = jsonConvert.convert<dynamic>(json['switch_pei']);
  if (switchPei != null) {
    userInfo.switchPei = switchPei;
  }
  final dynamic? limitLevel = jsonConvert.convert<dynamic>(json['limit_level']);
  if (limitLevel != null) {
    userInfo.limitLevel = limitLevel;
  }
  final int? level = jsonConvert.convert<int>(json['level']);
  if (level != null) {
    userInfo.level = level;
  }
  final dynamic? userLimit = jsonConvert.convert<dynamic>(json['user_limit']);
  if (userLimit != null) {
    userInfo.userLimit = userLimit;
  }
  final dynamic? isQz = jsonConvert.convert<dynamic>(json['is_qz']);
  if (isQz != null) {
    userInfo.isQz = isQz;
  }
  final dynamic? updatedAt = jsonConvert.convert<dynamic>(json['updated_at']);
  if (updatedAt != null) {
    userInfo.updatedAt = updatedAt;
  }
  final dynamic? createdAt = jsonConvert.convert<dynamic>(json['created_at']);
  if (createdAt != null) {
    userInfo.createdAt = createdAt;
  }
  final int? robot = jsonConvert.convert<int>(json['robot']);
  if (robot != null) {
    userInfo.robot = robot;
  }
  final int? type = jsonConvert.convert<int>(json['type']);
  if (type != null) {
    userInfo.type = type;
  }
  final int? setBet = jsonConvert.convert<int>(json['set_bet']);
  if (setBet != null) {
    userInfo.setBet = setBet;
  }
  final int? setChat = jsonConvert.convert<int>(json['set_chat']);
  if (setChat != null) {
    userInfo.setChat = setChat;
  }
  final int? isShow = jsonConvert.convert<int>(json['is_show']);
  if (isShow != null) {
    userInfo.isShow = isShow;
  }
  final dynamic? giveMoney = jsonConvert.convert<dynamic>(json['give_money']);
  if (giveMoney != null) {
    userInfo.giveMoney = giveMoney;
  }
  final dynamic? giveSet = jsonConvert.convert<dynamic>(json['give_set']);
  if (giveSet != null) {
    userInfo.giveSet = giveSet;
  }
  final int? setMoney = jsonConvert.convert<int>(json['set_money']);
  if (setMoney != null) {
    userInfo.setMoney = setMoney;
  }
  final dynamic? giveNum = jsonConvert.convert<dynamic>(json['give_num']);
  if (giveNum != null) {
    userInfo.giveNum = giveNum;
  }
  final int? choice = jsonConvert.convert<int>(json['choice']);
  if (choice != null) {
    userInfo.choice = choice;
  }
  final int? sendStatus = jsonConvert.convert<int>(json['send_status']);
  if (sendStatus != null) {
    userInfo.sendStatus = sendStatus;
  }
  final double? moneyAo = jsonConvert.convert<double>(json['money_ao']);
  if (moneyAo != null) {
    userInfo.moneyAo = moneyAo;
  }
  final double? moneyLiu = jsonConvert.convert<double>(json['money_liu']);
  if (moneyLiu != null) {
    userInfo.moneyLiu = moneyLiu;
  }
  final double? moneyLiuInit =
      jsonConvert.convert<double>(json['money_liu_init']);
  if (moneyLiuInit != null) {
    userInfo.moneyLiuInit = moneyLiuInit;
  }
  final double? moneyAoInit =
      jsonConvert.convert<double>(json['money_ao_init']);
  if (moneyAoInit != null) {
    userInfo.moneyAoInit = moneyAoInit;
  }
  final int? money = jsonConvert.convert<int>(json['money']);
  if (money != null) {
    userInfo.money = money;
  }
  final List<dynamic>? phone =
      jsonConvert.convertListNotNull<dynamic>(json['phone']);
  if (phone != null) {
    userInfo.phone = phone;
  }
  final String? kaiUrl = jsonConvert.convert<String>(json['kaiUrl']);
  if (kaiUrl != null) {
    userInfo.kaiUrl = kaiUrl;
  }
  final String? levelName = jsonConvert.convert<String>(json['levelName']);
  if (levelName != null) {
    userInfo.levelName = levelName;
  }
  final String? code = jsonConvert.convert<String>(json['code']);
  if (code != null) {
    userInfo.code = code;
  }
  return userInfo;
}

Map<String, dynamic> $UserInfoToJson(UserInfo entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['username'] = entity.username;
  data['cnname'] = entity.cnname;
  data['son_status'] = entity.sonStatus;
  data['agent_money'] = entity.agentMoney;
  data['parent_id'] = entity.parentId;
  data['room_id'] = entity.roomId;
  data['room_name'] = entity.roomName;
  data['room_photo'] = entity.roomPhoto;
  data['deleted_at'] = entity.deletedAt;
  data['create_time'] = entity.createTime;
  data['status'] = entity.status;
  data['register_status'] = entity.registerStatus;
  data['is_agent'] = entity.isAgent;
  data['is_user'] = entity.isUser;
  data['is_agent_web'] = entity.isAgentWeb;
  data['is_class'] = entity.isClass;
  data['qq_chat'] = entity.qqChat;
  data['wechat'] = entity.wechat;
  data['open_time'] = entity.openTime;
  data['lose_time'] = entity.loseTime;
  data['agent_notice'] = entity.agentNotice;
  data['photo'] = entity.photo;
  data['min_fen'] = entity.minFen;
  data['xia_fen'] = entity.xiaFen;
  data['min_xiazhu'] = entity.minXiazhu;
  data['openid'] = entity.openid;
  data['unionid'] = entity.unionid;
  data['invite_status'] = entity.inviteStatus;
  data['remember_token'] = entity.rememberToken;
  data['switch_pei'] = entity.switchPei;
  data['limit_level'] = entity.limitLevel;
  data['level'] = entity.level;
  data['user_limit'] = entity.userLimit;
  data['is_qz'] = entity.isQz;
  data['updated_at'] = entity.updatedAt;
  data['created_at'] = entity.createdAt;
  data['robot'] = entity.robot;
  data['type'] = entity.type;
  data['set_bet'] = entity.setBet;
  data['set_chat'] = entity.setChat;
  data['is_show'] = entity.isShow;
  data['give_money'] = entity.giveMoney;
  data['give_set'] = entity.giveSet;
  data['set_money'] = entity.setMoney;
  data['give_num'] = entity.giveNum;
  data['choice'] = entity.choice;
  data['send_status'] = entity.sendStatus;
  data['money_ao'] = entity.moneyAo;
  data['money_liu'] = entity.moneyLiu;
  data['money_liu_init'] = entity.moneyLiuInit;
  data['money_ao_init'] = entity.moneyAoInit;
  data['money'] = entity.money;
  data['phone'] = entity.phone;
  data['kaiUrl'] = entity.kaiUrl;
  data['levelName'] = entity.levelName;
  data['code'] = entity.code;
  return data;
}
