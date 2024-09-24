import 'package:flutter/cupertino.dart';

import '../models/city_model.dart';
import '../network/api_client.dart';
import '../network/api_constant.dart';

class CityController{
  Future getCity(BuildContext context) async {
    var response = await getData(paramUri: ApiConstant.city);
    if (response["status"].toString() == "true" && response["data"] != null) {
      return CityModel.fromJson(response);
    } else {
      return null;
    }
  }

}