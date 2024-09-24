import 'package:book_box/models/login_model.dart';
import 'package:book_box/screens/enter_opt_page.dart';
import 'package:flutter/material.dart';

import '../network/api_client.dart';
import '../network/api_constant.dart';

class LoginController {
  LoginModel? loginModel;

  TextEditingController mobileNumber = TextEditingController();

  Future userLogin(BuildContext context) async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        });
    var response = await postData(
      paramUri: ApiConstant.userLogin,
      params: {'mobile_number': mobileNumber.text},
    );
    debugPrint("companyLogin response :- ${response.toString()}");
    print('Response status: ${response["status"]}'); // Print the status value

    if (response["status"].toString() == 'true') {
      var res = LoginModel.fromJson(response);
      loginModel = res;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(res.msg),
          duration: const Duration(seconds: 2),
        ),
      );

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => OtpPage(
            mobileNumber: loginModel!.data,
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
