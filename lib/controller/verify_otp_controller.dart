import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/otp_model.dart';
import '../network/api_client.dart';
import '../network/api_constant.dart';
import '../screens/root_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpController {
  OtpModel? otpModel;

  TextEditingController mobileNumber = TextEditingController();
  TextEditingController otp = TextEditingController();

  Future verifyOtp(BuildContext context) async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        });
    var response = await postData(
      paramUri: ApiConstant.otpVerify,
      params: {'mobile_number': mobileNumber.text, 'otp': otp.text},
    );
    debugPrint("otp response :- ${response.toString()}");
    print('Response status: ${response["status"]}'); // Print the status value

    if (response["status"].toString() == 'true') {
      var res = OtpModel.fromJson(response);
      otpModel = res;

      SharedPreferences prefsToken = await SharedPreferences.getInstance();
      prefsToken.setString('token', res.data.token.toString());
      ApiConstant.userToken = res.data.token.toString();
      print(ApiConstant.userToken);

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(res.msg),
          duration: const Duration(seconds: 2),
        ),
      );

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const RootPage(),
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
