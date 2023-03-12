import 'package:agent/generated/json/base/json_convert_content.dart';
import 'package:agent/model/conversation_info.dart';

ConversationInfo $ConversationInfoFromJson(Map<String, dynamic> json) {
  final ConversationInfo conversationInfo = ConversationInfo();
  final int? currentPage = jsonConvert.convert<int>(json['current_page']);
  if (currentPage != null) {
    conversationInfo.currentPage = currentPage;
  }
  final List<ConversationData>? data =
      jsonConvert.convertListNotNull<ConversationData>(json['data']);
  if (data != null) {
    conversationInfo.data = data;
  }
  final String? firstPageUrl =
      jsonConvert.convert<String>(json['first_page_url']);
  if (firstPageUrl != null) {
    conversationInfo.firstPageUrl = firstPageUrl;
  }
  final int? from = jsonConvert.convert<int>(json['from']);
  if (from != null) {
    conversationInfo.from = from;
  }
  final int? lastPage = jsonConvert.convert<int>(json['last_page']);
  if (lastPage != null) {
    conversationInfo.lastPage = lastPage;
  }
  final String? lastPageUrl =
      jsonConvert.convert<String>(json['last_page_url']);
  if (lastPageUrl != null) {
    conversationInfo.lastPageUrl = lastPageUrl;
  }
  final dynamic? nextPageUrl =
      jsonConvert.convert<dynamic>(json['next_page_url']);
  if (nextPageUrl != null) {
    conversationInfo.nextPageUrl = nextPageUrl;
  }
  final String? path = jsonConvert.convert<String>(json['path']);
  if (path != null) {
    conversationInfo.path = path;
  }
  final int? perPage = jsonConvert.convert<int>(json['per_page']);
  if (perPage != null) {
    conversationInfo.perPage = perPage;
  }
  final dynamic? prevPageUrl =
      jsonConvert.convert<dynamic>(json['prev_page_url']);
  if (prevPageUrl != null) {
    conversationInfo.prevPageUrl = prevPageUrl;
  }
  final int? to = jsonConvert.convert<int>(json['to']);
  if (to != null) {
    conversationInfo.to = to;
  }
  final int? total = jsonConvert.convert<int>(json['total']);
  if (total != null) {
    conversationInfo.total = total;
  }
  return conversationInfo;
}

Map<String, dynamic> $ConversationInfoToJson(ConversationInfo entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['current_page'] = entity.currentPage;
  data['data'] = entity.data?.map((v) => v.toJson()).toList();
  data['first_page_url'] = entity.firstPageUrl;
  data['from'] = entity.from;
  data['last_page'] = entity.lastPage;
  data['last_page_url'] = entity.lastPageUrl;
  data['next_page_url'] = entity.nextPageUrl;
  data['path'] = entity.path;
  data['per_page'] = entity.perPage;
  data['prev_page_url'] = entity.prevPageUrl;
  data['to'] = entity.to;
  data['total'] = entity.total;
  return data;
}

ConversationData $ConversationDataFromJson(Map<String, dynamic> json) {
  final ConversationData conversationData = ConversationData();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    conversationData.id = id;
  }
  final int? fromid = jsonConvert.convert<int>(json['fromid']);
  if (fromid != null) {
    conversationData.fromid = fromid;
  }
  final int? parentId = jsonConvert.convert<int>(json['parent_id']);
  if (parentId != null) {
    conversationData.parentId = parentId;
  }
  final String? fromname = jsonConvert.convert<String>(json['fromname']);
  if (fromname != null) {
    conversationData.fromname = fromname;
  }
  final String? fromusername =
      jsonConvert.convert<String>(json['fromusername']);
  if (fromusername != null) {
    conversationData.fromusername = fromusername;
  }
  final int? toid = jsonConvert.convert<int>(json['toid']);
  if (toid != null) {
    conversationData.toid = toid;
  }
  final int? isRead = jsonConvert.convert<int>(json['is_read']);
  if (isRead != null) {
    conversationData.isRead = isRead;
  }
  final String? toname = jsonConvert.convert<String>(json['toname']);
  if (toname != null) {
    conversationData.toname = toname;
  }
  final String? tousername = jsonConvert.convert<String>(json['tousername']);
  if (tousername != null) {
    conversationData.tousername = tousername;
  }
  final String? tag = jsonConvert.convert<String>(json['tag']);
  if (tag != null) {
    conversationData.tag = tag;
  }
  final String? img = jsonConvert.convert<String>(json['img']);
  if (img != null) {
    conversationData.img = img;
  }
  final dynamic? content = jsonConvert.convert<dynamic>(json['content']);
  if (content != null) {
    conversationData.content = content;
  }
  final String? createdAt = jsonConvert.convert<String>(json['createdAt']);
  if (createdAt != null) {
    conversationData.createdAt = createdAt;
  }
  final int? photo = jsonConvert.convert<int>(json['photo']);
  if (photo != null) {
    conversationData.photo = photo;
  }
  final int? tophoto = jsonConvert.convert<int>(json['tophoto']);
  if (tophoto != null) {
    conversationData.tophoto = tophoto;
  }
  return conversationData;
}

Map<String, dynamic> $ConversationDataToJson(ConversationData entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['fromid'] = entity.fromid;
  data['parent_id'] = entity.parentId;
  data['fromname'] = entity.fromname;
  data['fromusername'] = entity.fromusername;
  data['toid'] = entity.toid;
  data['is_read'] = entity.isRead;
  data['toname'] = entity.toname;
  data['tousername'] = entity.tousername;
  data['tag'] = entity.tag;
  data['img'] = entity.img;
  data['content'] = entity.content;
  data['createdAt'] = entity.createdAt;
  data['photo'] = entity.photo;
  data['tophoto'] = entity.tophoto;
  return data;
}
