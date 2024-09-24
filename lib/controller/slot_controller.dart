import 'dart:math';

import 'package:book_box/models/slot_model.dart';
import 'package:flutter/cupertino.dart';

import '../network/api_client.dart';
import '../network/api_constant.dart';

class SlotController {
  Future getAllSlot(
      BuildContext context, String slotTime, String boxId, String date) async {
    var response = await postData(
        paramUri: ApiConstant.slot,
        params: {'slottime': slotTime, 'box_id': boxId, 'date': date});
    if (response["status"].toString() == "true" && response["data"] != null) {
      return SlotModel.fromJson(
        response,
      );
    } else {
      return null;
    }
  }
}
