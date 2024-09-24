import 'package:book_box/controller/profile_controller.dart';
import 'package:book_box/models/profile_model.dart';
import 'package:book_box/network/api_constant.dart';
import 'package:book_box/screens/login_page.dart';
import 'package:book_box/styles/colors.dart';
import 'package:book_box/styles/fonts.dart';
import 'package:book_box/styles/icons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ProfileController profileController = ProfileController();
  ProfileModel? profileModel;
  List<Datum> profileList = [];
  bool loading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProfile(context);
  }

  Future getProfile(BuildContext context) async {
    setState(() {
      loading = true;
    });
    await profileController.getProfile(context).then((value) {
      print(value.toString());
      setState(() {
        if (value != null) {
          profileModel = value;
          profileList = profileModel!.data;

          print(profileModel!.data.toString());
          print('size ${profileList.length}');
          loading = false;
        } else {
          profileList.clear();
          loading = false;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('No Box found'),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      });
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const SizedBox(
              height: 110,
              width: 110,
              child: Stack(
                clipBehavior: Clip.none,
                fit: StackFit.expand,
                children: [
                  CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 53,
                      backgroundImage: CachedNetworkImageProvider(
                          'https://impliestech.site/book/public/uploads/1689492973.jpeg'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // Edit text
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                    topLeft: Radius.circular(30),
                  ),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      loading
                          ? const CircularProgressIndicator()
                          : ListView.builder(
                              padding: const EdgeInsets.only(
                                  left: 16, right: 16, bottom: 8),
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(), // Disable scrolling
                              itemCount: profileList.length,
                              itemBuilder: (BuildContext context, int index) {
                                var data = profileList[index];
                                return Container(
                                  margin: const EdgeInsets.symmetric(vertical: 8),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        spreadRadius: 0,
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Expanded(
                                            child: Text(
                                              'Name',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: AppColors.primaryText,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: AppFonts.sofiaSans,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              data.name,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: AppColors.primaryText,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: AppFonts.sofiaSans,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Expanded(
                                            child: Text(
                                              'Price',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: AppColors.primaryText,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: AppFonts.sofiaSans,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              data.price,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: AppColors.primaryText,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: AppFonts.sofiaSans,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Expanded(
                                            child: Text(
                                              'Status',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: AppColors.primaryText,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: AppFonts.sofiaSans,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              data.status,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: AppColors.primaryText,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: AppFonts.sofiaSans,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              bool logoutConfirmed = await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                      'Logout Confirmation',
                                      style: TextStyle(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: AppFonts.sofiaSans,
                                      ),
                                    ),
                                    content: Text(
                                      'Are you sure you want to logout?',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontFamily: AppFonts.sofiaSans,
                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(
                                              false); // Dismiss the dialog and return false
                                        },
                                        child: Text(
                                          'Cancel',
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(
                                              true); // Dismiss the dialog and return true
                                        },
                                        child: Text('Logout'),
                                      ),
                                    ],
                                  );
                                },
                              );

                              if (logoutConfirmed != null && logoutConfirmed) {
                                // Perform logout actions here
                                print('User confirmed logout');
                                FocusManager.instance.primaryFocus?.unfocus();
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                await prefs.clear();

                                print(ApiConstant.userToken);

                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const LoginPage()),
                                    (route) => false);
                              } else {
                                print('User canceled logout');
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              backgroundColor: AppColors.primary,
                            ),
                            child: const Text(
                              'Logout',
                              style: TextStyle(
                                fontSize: 18,
                                color: AppColors.secondary,
                                fontWeight: FontWeight.w600,
                                fontFamily: AppFonts.sofiaSans,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: 16.0, left: 16.0, right: 16.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              bool logoutConfirmed = await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                      'Account deletion Confirmation',
                                      style: TextStyle(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: AppFonts.sofiaSans,
                                      ),
                                    ),
                                    content: Text(
                                      'Are you sure you want to delete your account ?',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontFamily: AppFonts.sofiaSans,
                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(
                                              false); // Dismiss the dialog and return false
                                        },
                                        child: Text(
                                          'Cancel',
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(
                                              true); // Dismiss the dialog and return true
                                        },
                                        child: Text('Delete'),
                                      ),
                                    ],
                                  );
                                },
                              );

                              if (logoutConfirmed != null && logoutConfirmed) {
                                // Perform logout actions here
                                FocusManager.instance.primaryFocus?.unfocus();
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                await prefs.clear();

                                print(ApiConstant.userToken);

                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const LoginPage()),
                                    (route) => false);
                              } else {}
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              backgroundColor: AppColors.primary,
                            ),
                            child: const Text(
                              'Delete Account',
                              style: TextStyle(
                                fontSize: 18,
                                color: AppColors.secondary,
                                fontWeight: FontWeight.w600,
                                fontFamily: AppFonts.sofiaSans,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
