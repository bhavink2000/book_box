import 'package:book_box/controller/QRImage.dart';
import 'package:book_box/models/deeplinking_model.dart';
import 'package:flutter/material.dart';

import '../network/api_client.dart';
import '../network/api_constant.dart';

class DeeplinkingController {
  DeeplinkingModel? deeplinkingModel;

  Future deepLinking(BuildContext context, String box_id, String date) async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        });
    var response = await postData(
      paramUri: ApiConstant.deeplinking,
      params: {'box_id': box_id, 'date': date},
    );
    debugPrint("companyLogin response :- ${response.toString()}");
    print('Response status: ${response["status"]}'); // Print the status value

    if (response["status"].toString() == 'true') {
      var res = DeeplinkingModel.fromJson(response);
      deeplinkingModel = res;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => QRImage(
            deeplinkingModel!.deep_link,
          ),
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
