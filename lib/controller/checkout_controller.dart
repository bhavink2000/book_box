import 'package:book_box/models/checkout_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../network/api_client.dart';
import '../network/api_constant.dart';

class CheckoutController {
  CheckoutModel? checkoutModel;

  Future checkout(BuildContext context) async {
    var response = await postData(
      paramUri: ApiConstant.checkout,
      params: {'token': ApiConstant.userToken},
    );
    debugPrint("companyLogin response :- ${response.toString()}");
    print('Response status: ${response["status"]}'); // Print the status value

    if (response["status"].toString() == 'true') {
      var res = CheckoutModel.fromJson(response);
      checkoutModel = res;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("payment successful"),
          duration: Duration(seconds: 2),
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
