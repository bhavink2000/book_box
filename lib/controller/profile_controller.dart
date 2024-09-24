import 'package:book_box/models/profile_model.dart';
import 'package:flutter/cupertino.dart';

import '../network/api_client.dart';
import '../network/api_constant.dart';

class ProfileController{

  Future getProfile(BuildContext context) async {
    var response = await postData(
        paramUri: ApiConstant.profile,
        params: {'token': ApiConstant.userToken});
    if (response["status"].toString() == "true" && response["data"] != null) {
      return ProfileModel.fromJson(
        response,
      );
    } else {
      return null;
    }
  }




}