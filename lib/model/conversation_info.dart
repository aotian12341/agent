import 'dart:convert';
import 'package:agent/generated/json/base/json_field.dart';
import 'package:agent/generated/json/conversation_info.g.dart';

@JsonSerializable()
class ConversationInfo {
  @JSONField(name: "current_page")
  int? currentPage;
  List<ConversationData>? data;
  @JSONField(name: "first_page_url")
  String? firstPageUrl;
  int? from;
  @JSONField(name: "last_page")
  int? lastPage;
  @JSONField(name: "last_page_url")
  String? lastPageUrl;
  @JSONField(name: "next_page_url")
  dynamic nextPageUrl;
  String? path;
  @JSONField(name: "per_page")
  int? perPage;
  @JSONField(name: "prev_page_url")
  dynamic prevPageUrl;
  int? to;
  int? total;

  ConversationInfo();

  factory ConversationInfo.fromJson(Map<String, dynamic> json) =>
      $ConversationInfoFromJson(json);

  Map<String, dynamic> toJson() => $ConversationInfoToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class ConversationData {
  int? id;
  int? fromid;
  @JSONField(name: "parent_id")
  int? parentId;
  String? fromname;
  String? fromusername;
  int? toid;
  @JSONField(name: "is_read")
  int? isRead;
  String? toname;
  String? tousername;
  String? tag;
  String? img;
  dynamic content;
  String? createdAt;
  int? photo;
  int? tophoto;

  ConversationData();

  factory ConversationData.fromJson(Map<String, dynamic> json) =>
      $ConversationDataFromJson(json);

  Map<String, dynamic> toJson() => $ConversationDataToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
