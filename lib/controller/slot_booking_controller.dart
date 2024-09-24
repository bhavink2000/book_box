import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/slot_booking_model.dart';
import '../network/api_client.dart';
import '../network/api_constant.dart';

class SlotBookingController {
  SlotBookingModel? slotBookingModel;

  Future slotBook(
      BuildContext context,
      String token,
      String boxId,
      String date,
      List<String> slotIdList,
      String transactionId,
      String status,
      String fee) async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        });

    Map<String, dynamic> params = {
      'token': token,
      'box_id': boxId,
      'booking_date': date,
      'merchantTransactionId': transactionId,
      'status': status,
      'fee': fee,
    };

    // Add the slot_id parameters dynamically based on the elements of slotIdList
    for (int i = 0; i < slotIdList.length; i++) {
      params['slot_id[$i]'] = slotIdList[i];
      print(slotIdList[i]);
    }

    var response = await postData(
      paramUri: ApiConstant.slotBooking,
      params: params,
    );

    print("krunal vegad ====  $params");

    debugPrint("companyLogin response :- ${response.toString()}");
    print('Response status: ${response["status"]}'); // Print the status value

    if (response["status"].toString() == 'true') {
      var res = SlotBookingModel.fromJson(response);
      slotBookingModel = res;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(res.msg),
          duration: const Duration(seconds: 2),
        ),
      );
    } else {
      Navigator.pop(context);
      print(response["status"]);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response["msg"]),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}
