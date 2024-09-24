import 'package:flutter/material.dart';
import 'package:book_box/screens/root_page.dart';
import 'package:book_box/styles/colors.dart';
import 'package:book_box/styles/fonts.dart';
import 'package:book_box/styles/icons.dart';

import '../controller/verify_otp_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpPage extends StatefulWidget {
  OtpPage({this.mobileNumber, super.key});

  String? mobileNumber;

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  OtpController otpController = OtpController();

  String getOtpValue(List<String> otpList) {
    return otpList.join(); // Concatenates the list of OTP values
  }

// Inside your Stateful/Stateless widget
  List<String> otpValues =
      List.filled(6, ''); // Initialize a list to store OTP values

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    otpController.mobileNumber.text = widget.mobileNumber.toString();
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
                    'OTP',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontFamily: AppFonts.sofiaSans,
                    ),
                  ),
                  const Text(
                    'Please enter the otp sent to your mobile number',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.primaryText,
                      fontWeight: FontWeight.w600,
                      fontFamily: AppFonts.sofiaSans,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      6,
                      // Change this number to the required number of digit boxes (e.g., 6 for OTP)
                      (index) => Container(
                        width: 40,
                        // Adjust the width of each box as needed
                        height: 40,
                        // Set the height to match the width for a square shape
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        // Adjust the spacing between boxes
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.primary,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(
                              8), // Adjust the border radius for a rounded look
                        ),
                        child: Center(
                          child: TextFormField(
                            maxLength: 1,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'SofiaSans',
                            ),
                            decoration: const InputDecoration(
                              counterText: '',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                              isDense: true,
                              hintText: '',
                              hintStyle: TextStyle(
                                fontSize: 17,
                                color: Colors.grey,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'SofiaSans',
                              ),
                            ),
                            onChanged: (String value) {
                              // Implement any logic for handling input changes here
                              // For example, moving focus to the next box
                              if (value.isNotEmpty) {
                                otpValues[index] =
                                    value; // Store the value in the list
                                if (index < 5) {
                                  FocusScope.of(context).nextFocus();
                                } else {
                                  String otp = getOtpValue(
                                      otpValues); // Retrieve OTP when all fields are filled
                                  print('Entered OTP: $otp');
                                  otpController.otp.text = otp.toString();
                                  // Perform further actions with the OTP (e.g., verify, submit)
                                }
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  _buildGetOTPButton(() {
                    FocusManager.instance.primaryFocus?.unfocus();

                    if (otpValues.length > 6) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please enter valid otp"),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    } else {
                      otpController.verifyOtp(context);
                    }

                    // Move to root page
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
          'Verify',
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
}
