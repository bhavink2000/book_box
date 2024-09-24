import 'package:flutter/cupertino.dart';

import '../models/box_model.dart';
import '../network/api_client.dart';
import '../network/api_constant.dart';

class BoxController {
  BoxModel? boxModel;
  // TextEditingController cityName = TextEditingController();

  Future getAllBox(BuildContext context, String cityName) async {
    var response = await postData(
        paramUri: ApiConstant.box,
        params: {'pagesize': '16', 'city': cityName});
    if (response["status"].toString() == "true" && response["data"] != null) {
      return BoxModel.fromJson(
        response,
      );
    } else {
      return null;
    }
  }
}
