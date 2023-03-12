import 'package:agent/common/http_controller.dart';
import 'package:agent/constants/api_keys.dart';

class VideoController {
  factory VideoController() => _getInstance();

  // 静态私有成员，没有初始化
  static VideoController? _instance;

  // 静态、同步、私有访问点
  static VideoController _getInstance() {
    _instance ??= VideoController._internal();
    return _instance!;
  }

  // 私有构造函数
  VideoController._internal();

  void getHomeData({int? page, int? classId, Function? success}) {
    HttpController().get(VideoApi.homeData,
        query: {'page': page, 'class_id': classId},
        showErrorToast: true,
        showLoading: false,
        success: success);
  }

  void getVideoDetails({int? id, Function? success}) {
    HttpController().get(VideoApi.videoDetails,
        query: {"id": id},
        success: success,
        showLoading: true,
        showErrorToast: true);
  }
}
