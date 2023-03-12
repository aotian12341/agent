import 'package:agent/pages/conversation.dart';
import 'package:agent/pages/edit_password.dart';
import 'package:agent/pages/recharge_list.dart';
import 'package:agent/pages/register_record.dart';
import 'package:agent/pages/search.dart';
import 'package:agent/pages/user_edit.dart';
import 'package:agent/pages/video_detailss.dart';
import 'package:get/get.dart';

import '../pages/code.dart';
import '../pages/code_list.dart';
import '../pages/home.dart';
import '../pages/invite_list.dart';
import '../pages/login.dart';
import '../pages/recharge_record.dart';
import '../pages/register.dart';
import '../pages/video_details.dart';
import '../pages/video_list.dart';

class Routes {
  static const login = "/login";
  static const home = "/home";
  static const search = "/search";
  static const conversation = "/conversation";
  static const rechargeList = "/rechargeList";
  static const editPassword = "/editPassword";
  static const inviteList = "/inviteList";
  static const codeList = "/codeList";
  static const code = "/Code";
  static const userEdit = "/userEdit";
  static const registerList = "/registerList";
  static const rechargeRecord = "/rechargeRecord";
  static const videoList = "/videoList";
  static const videoDetails = "/VideoDetails";
  static const videoDetailss = "/videoDetailss";
  static const register = "/Register";
}

final List<GetPage> appRoutes = [
  GetPage(name: Routes.login, page: () => const Login()),
  GetPage(name: Routes.register, page: () => const Register()),
  GetPage(name: Routes.home, page: () => const Home()),
  GetPage(name: Routes.search, page: () => const Search()),
  GetPage(name: Routes.conversation, page: () => const Conversation()),
  GetPage(name: Routes.rechargeList, page: () => const RechargeList()),
  GetPage(name: Routes.editPassword, page: () => const EditPassword()),
  GetPage(name: Routes.inviteList, page: () => const InviteList()),
  GetPage(name: Routes.codeList, page: () => const CodeList()),
  GetPage(name: Routes.userEdit, page: () => const UserEdit()),
  GetPage(name: Routes.code, page: () => const Code()),
  GetPage(name: Routes.registerList, page: () => const RegisterRecord()),
  GetPage(name: Routes.rechargeRecord, page: () => const RechargeRecord()),
  GetPage(name: Routes.videoList, page: () => const VideoList()),
  GetPage(name: Routes.videoDetails, page: () => const VideoDetails()),
  GetPage(name: Routes.videoDetailss, page: () => const VideoDetailss()),
];
