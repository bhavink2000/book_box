import 'package:book_box/screens/booking_history_page.dart';
import 'package:book_box/screens/home_page.dart';
import 'package:book_box/screens/profile_page.dart';
import 'package:book_box/styles/colors.dart';
import 'package:book_box/styles/fonts.dart';
import 'package:book_box/styles/icons.dart';
import 'package:flutter/material.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const [
        HomePage(),
        BookingHistoryPage(),
        ProfilePage(),
      ].elementAt(_currentIndex),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30),
            topLeft: Radius.circular(30),
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
          child: BottomNavigationBar(
            backgroundColor: AppColors.primary,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white,
            selectedLabelStyle: const TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontFamily: AppFonts.sofiaSans,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontFamily: AppFonts.sofiaSans,
            ),
            items: [
              BottomNavigationBarItem(
                icon: Image.asset(AppIcons.home, height: 22),
                activeIcon: Image.asset(AppIcons.fillHome, height: 22),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(AppIcons.booking, height: 22),
                activeIcon: Image.asset(AppIcons.fillBooking, height: 22),
                label: 'Tournament',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(AppIcons.profile, height: 22),
                activeIcon: Image.asset(AppIcons.profile, height: 22),
                label: 'Profile',
              ),
            ],
            currentIndex: _currentIndex,
            onTap: (value) {
              setState(() {
                _currentIndex = value;
              });
            },
          ),
        ),
      ),
    );
  }
}
