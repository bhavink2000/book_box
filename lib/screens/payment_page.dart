import 'package:book_box/styles/colors.dart';
import 'package:book_box/styles/fonts.dart';
import 'package:book_box/styles/icons.dart';
import 'package:flutter/material.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String _radioValue = 'GooglePay';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: const Text(
          'Payment',
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontFamily: AppFonts.sofiaSans,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select Payment Method you want use.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.primaryText,
                  fontWeight: FontWeight.w600,
                  fontFamily: AppFonts.sofiaSans,
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Card Payment',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.primaryText,
                  fontWeight: FontWeight.w700,
                  fontFamily: AppFonts.sofiaSans,
                ),
              ),
              RadioPaymentTile(
                icon: AppIcons.card,
                title: 'Debit/Credit Card',
                isSelected: _radioValue == 'card',
                onTap: () {
                  setState(() {
                    _radioValue = 'card';
                  });
                },
              ),
              const SizedBox(height: 14),
              const Text(
                'UPI Payment',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.primaryText,
                  fontWeight: FontWeight.w700,
                  fontFamily: AppFonts.sofiaSans,
                ),
              ),
              RadioPaymentTile(
                icon: AppIcons.googlePay,
                title: 'Google Pay',
                isSelected: _radioValue == 'GooglePay',
                onTap: () {
                  setState(() {
                    _radioValue = 'GooglePay';
                  });
                },
              ),
              RadioPaymentTile(
                icon: AppIcons.phonePay,
                title: 'Phone Pay',
                isSelected: _radioValue == 'PhonePay',
                onTap: () {
                  setState(() {
                    _radioValue = 'PhonePay';
                  });
                },
              ),
              RadioPaymentTile(
                icon: AppIcons.paytm,
                title: 'Paytm',
                isSelected: _radioValue == 'Paytm',
                onTap: () {
                  setState(() {
                    _radioValue = 'Paytm';
                  });
                },
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    // Move to root page
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: AppColors.primary,
                  ),
                  child: const Text(
                    'Pay    ₹ 5577.00',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.secondary,
                      fontWeight: FontWeight.w600,
                      fontFamily: AppFonts.sofiaSans,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RadioPaymentTile extends StatelessWidget {
  const RadioPaymentTile({
    super.key,
    required this.icon,
    required this.title,
    required this.isSelected,
    this.onTap,
  });

  final String icon;
  final String title;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 14),
      child: InkWell(
        onTap: () => onTap?.call(),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.cardBackground,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            children: [
              Image.asset(icon, width: 23),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w600,
                  fontFamily: AppFonts.sofiaSans,
                ),
              ),
              const Spacer(),
              Image.asset(
                isSelected ? AppIcons.fillRadio : AppIcons.radio,
                height: 14,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
