import 'dart:convert';
import 'package:agent/generated/json/base/json_field.dart';
import 'package:agent/generated/json/user_info.g.dart';

@JsonSerializable()
class UserInfo {
  int? id;
  String? username;
  String? cnname;
  @JSONField(name: "son_status")
  int? sonStatus;
  @JSONField(name: "agent_money")
  int? agentMoney;
  @JSONField(name: "parent_id")
  int? parentId;
  @JSONField(name: "room_id")
  String? roomId;
  @JSONField(name: "room_name")
  String? roomName;
  @JSONField(name: "room_photo")
  String? roomPhoto;
  @JSONField(name: "deleted_at")
  dynamic deletedAt;
  @JSONField(name: "create_time")
  String? createTime;
  int? status;
  @JSONField(name: "register_status")
  int? registerStatus;
  @JSONField(name: "is_agent")
  int? isAgent;
  @JSONField(name: "is_user")
  int? isUser;
  @JSONField(name: "is_agent_web")
  int? isAgentWeb;
  @JSONField(name: "is_class")
  int? isClass;
  @JSONField(name: "qq_chat")
  dynamic qqChat;
  dynamic wechat;
  @JSONField(name: "open_time")
  dynamic openTime;
  @JSONField(name: "lose_time")
  dynamic loseTime;
  @JSONField(name: "agent_notice")
  dynamic agentNotice;
  int? photo;
  @JSONField(name: "min_fen")
  dynamic minFen;
  @JSONField(name: "xia_fen")
  int? xiaFen;
  @JSONField(name: "min_xiazhu")
  dynamic minXiazhu;
  dynamic openid;
  dynamic unionid;
  @JSONField(name: "invite_status")
  String? inviteStatus;
  @JSONField(name: "remember_token")
  dynamic rememberToken;
  @JSONField(name: "switch_pei")
  dynamic switchPei;
  @JSONField(name: "limit_level")
  dynamic limitLevel;
  int? level;
  @JSONField(name: "user_limit")
  dynamic userLimit;
  @JSONField(name: "is_qz")
  dynamic isQz;
  @JSONField(name: "updated_at")
  dynamic updatedAt;
  @JSONField(name: "created_at")
  dynamic createdAt;
  int? robot;
  int? type;
  @JSONField(name: "set_bet")
  int? setBet;
  @JSONField(name: "set_chat")
  int? setChat;
  @JSONField(name: "is_show")
  int? isShow;
  @JSONField(name: "give_money")
  dynamic giveMoney;
  @JSONField(name: "give_set")
  dynamic giveSet;
  @JSONField(name: "set_money")
  int? setMoney;
  @JSONField(name: "give_num")
  dynamic giveNum;
  int? choice;
  @JSONField(name: "send_status")
  int? sendStatus;
  @JSONField(name: "money_ao")
  double? moneyAo;
  @JSONField(name: "money_liu")
  double? moneyLiu;
  @JSONField(name: "money_liu_init")
  double? moneyLiuInit;
  @JSONField(name: "money_ao_init")
  double? moneyAoInit;
  int? money;
  List<dynamic>? phone;
  String? kaiUrl;
  String? levelName;

  String? code;

  UserInfo();

  factory UserInfo.fromJson(Map<String, dynamic> json) =>
      $UserInfoFromJson(json);

  Map<String, dynamic> toJson() => $UserInfoToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
