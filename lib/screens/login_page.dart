import 'package:book_box/network/api_constant.dart';
import 'package:book_box/screens/privacy_policy_page.dart';
import 'package:book_box/screens/root_page.dart';
import 'package:book_box/styles/colors.dart';
import 'package:book_box/styles/fonts.dart';
import 'package:book_box/styles/icons.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controller/login_controller.dart';
import 'enter_opt_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginController loginController = LoginController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getToken();
  }

  void getToken() async {
    SharedPreferences prefsToken = await SharedPreferences.getInstance();
    // prefsToken.clear();
    String? token = prefsToken.getString('token');
    print(prefsToken.getString('token'));

    if (token == null) {
      print('token null');
      // Navigator.of(context).pushReplacement(
      //   MaterialPageRoute(
      //     builder: (context) => const RootPage(),
      //   ),
      // );
    } else {
      ApiConstant.userToken = token;
      print(ApiConstant.userToken);

      Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => RootPage()),
          (route) => false);

      /*Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const RootPage(),
        ),
      );*/
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          SingleChildScrollView(
            reverse: true,
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 130),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Image.asset(
                    AppIcons.phone,
                    width: 32,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Phone Number',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontFamily: AppFonts.sofiaSans,
                    ),
                  ),
                  const Text(
                    'Please enter your phone number to proceed',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.primaryText,
                      fontWeight: FontWeight.w600,
                      fontFamily: AppFonts.sofiaSans,
                    ),
                  ),
                  const SizedBox(height: 40),
                  TextField(
                    controller: loginController.mobileNumber,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    style: const TextStyle(
                      fontSize: 20,
                      color: AppColors.primaryText,
                      fontWeight: FontWeight.w600,
                      fontFamily: AppFonts.sofiaSans,
                    ),
                    decoration: const InputDecoration(
                      isDense: true,
                      counterText: '',
                      hintText: 'Enter your phone number',
                      hintStyle: TextStyle(
                        fontSize: 17,
                        color: AppColors.lightText,
                        fontWeight: FontWeight.w600,
                        fontFamily: AppFonts.sofiaSans,
                      ),
                      prefixIcon: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          '+91',
                          style: TextStyle(
                            fontSize: 20,
                            color: AppColors.primaryText,
                            fontWeight: FontWeight.w600,
                            fontFamily: AppFonts.sofiaSans,
                          ),
                        ),
                      ),
                      prefixIconConstraints:
                          BoxConstraints(minWidth: 0, minHeight: 0),
                    ),
                  ),
                  const SizedBox(height: 40),
                  _buildGetOTPButton(() {
                    FocusManager.instance.primaryFocus?.unfocus();
                    // Move to root page

                    if (loginController.mobileNumber.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please enter mobile number"),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    } else if (loginController.mobileNumber.text.length != 10) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please enter valid mobile number"),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    } else {
                      loginController.userLogin(context);
                      // Navigator.of(context).pushReplacement(
                      //   MaterialPageRoute(
                      //     builder: (context) =>  OtpPage(mobileNumber: '8849938881',),
                      //   ),
                      // );
                    }
                  }),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildPrivacyText(context),
        ],
      ),
    );
  }

  Widget _buildGetOTPButton(VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => onPressed.call(),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: AppColors.primary,
        ),
        child: const Text(
          'Get OTP',
          style: TextStyle(
            fontSize: 18,
            color: AppColors.secondary,
            fontWeight: FontWeight.w600,
            fontFamily: AppFonts.sofiaSans,
          ),
        ),
      ),
    );
  }

  Align _buildPrivacyText(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: 20,
            left: 20,
            right: 20,
          ),
          child: GestureDetector(
            onTap: () {
              // Handle tap on the whole text
              print('Tap on entire text');
              // Add your action when the entire text is tapped
            },
            child: RichText(
              text: TextSpan(
                text:
                    'Copyright ©2023 All Rights Reserved By\nVeerjeet Technology Private Limited.\n\nBy continuing you agree to the ',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black, // Update color as needed
                  fontWeight: FontWeight.w600,
                  fontFamily: AppFonts.sofiaSans,
                ),
                children: [
                  TextSpan(
                    text: 'Terms of services',
                    style: TextStyle(
                      color: AppColors.primary, // Change color as desired
                      fontWeight: FontWeight.w600,
                      fontFamily: AppFonts.sofiaSans,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => PrivacyPolicyPage(
                              url: 'https://bookmybox.online/terms.php',
                              title: 'Terms of services',
                            ),
                          ),
                        ); // Call function to navigate to Terms of Service page
                      },
                  ),
                  TextSpan(text: '   and  '),
                  TextSpan(
                    text: 'privacy policy',
                    style: TextStyle(
                      color: AppColors.primary, // Change color as desired
                      fontWeight: FontWeight.w600,
                      fontFamily: AppFonts.sofiaSans,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => PrivacyPolicyPage(
                              url: 'https://bookmybox.online/privacypolicy.php',
                              title: 'Privacy Policy',
                            ),
                          ),
                        ); // Call function to navigate to Privacy Policy page
                      },
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
