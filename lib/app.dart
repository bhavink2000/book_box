import 'package:book_box/screens/login_page.dart';
import 'package:book_box/styles/colors.dart';
import 'package:flutter/material.dart';

class BookBoxApp extends StatelessWidget {
  BookBoxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book My Box',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          surfaceTint: Colors.white,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.scaffoldBackgroundColor,
      ),
      home: const LoginPage(),
    );
  }
}
