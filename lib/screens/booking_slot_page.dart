import 'package:book_box/screens/booking_detail_page.dart';
import 'package:book_box/styles/colors.dart';
import 'package:book_box/styles/fonts.dart';
import 'package:flutter/material.dart';
import 'package:horizontal_calendar/horizontal_calendar.dart';
import 'package:table_calendar/table_calendar.dart';

class BookingSlotPage extends StatefulWidget {
  const BookingSlotPage({super.key});

  @override
  State<BookingSlotPage> createState() => _BookingSlotPageState();
}

class _BookingSlotPageState extends State<BookingSlotPage> {
  String _currentSelectedValue = 'Morning';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        centerTitle: false,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Eden Garden',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                fontFamily: AppFonts.sofiaSans,
              ),
            ),
            Text(
              'Kolkata, India',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.lightText,
                fontWeight: FontWeight.w600,
                fontFamily: AppFonts.sofiaSans,
              ),
            ),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(top: 8, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '₹ 25,000',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: AppFonts.sofiaSans,
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: AppColors.secondary,
                    ),
                    SizedBox(width: 4),
                    Text(
                      '[4.5]',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.primaryText,
                        fontWeight: FontWeight.w600,
                        fontFamily: AppFonts.sofiaSans,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: HorizontalCalendar(
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 14)),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  height: 70,
                  spacingBetweenDates: 12,
                  monthTextStyle: const TextStyle(
                    fontSize: 13,
                    color: AppColors.primaryText,
                    fontWeight: FontWeight.w600,
                    fontFamily: AppFonts.sofiaSans,
                  ),
                  selectedMonthTextStyle: const TextStyle(
                    fontSize: 13,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontFamily: AppFonts.sofiaSans,
                  ),
                  dateTextStyle: const TextStyle(
                    fontSize: 13,
                    color: AppColors.primaryText,
                    fontWeight: FontWeight.w600,
                    fontFamily: AppFonts.sofiaSans,
                  ),
                  selectedDateTextStyle: const TextStyle(
                    fontSize: 13,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontFamily: AppFonts.sofiaSans,
                  ),
                  weekDayTextStyle: const TextStyle(
                    fontSize: 13,
                    color: AppColors.primaryText,
                    fontWeight: FontWeight.w600,
                    fontFamily: AppFonts.sofiaSans,
                  ),
                  selectedWeekDayTextStyle: const TextStyle(
                    fontSize: 13,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontFamily: AppFonts.sofiaSans,
                  ),
                  isLabelUppercase: true,
                  selectedDecoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Text(
                        'Select Booking Option',
                        style: TextStyle(
                          fontSize: 18,
                          color: AppColors.primaryText,
                          fontFamily: AppFonts.sofiaSans,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  FormField<String>(
                    builder: (FormFieldState<String> state) {
                      return InputDecorator(
                        decoration: InputDecoration(
                          errorStyle: const TextStyle(
                            color: Colors.redAccent,
                            fontSize: 16.0,
                          ),
                          hintText: 'Please select expense',
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _currentSelectedValue,
                            isDense: true,
                            onChanged: (newValue) {
                              setState(() {
                                _currentSelectedValue = newValue ?? 'Morning';
                                state.didChange(newValue);
                              });
                            },
                            items: [
                              "Morning",
                              "Afternoon",
                              "Evening",
                              "Night",
                            ].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 4,
                  childAspectRatio: 1 / 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 16,
                  shrinkWrap: true,
                  children: <String>[
                    '150',
                    '160',
                    '170',
                    '100',
                    '200',
                    '150',
                    '150',
                    '190',
                    '150',
                    '250',
                  ].map((String price) {
                    return Column(
                      children: [
                        Flexible(
                          child: Container(
                            // Default
                            decoration: BoxDecoration(
                              color: AppColors.cardBackground,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            // Selected
                            // decoration: BoxDecoration(
                            //   color: Colors.white,
                            //   borderRadius: BorderRadius.circular(10),
                            //   border: Border.all(
                            //     color: AppColors.primary,
                            //     width: 2,
                            //   ),
                            // ),
                            // Booked
                            // decoration: BoxDecoration(
                            //   color: AppColors.primary.withOpacity(0.5),
                            //   borderRadius: BorderRadius.circular(10),
                            // ),
                            child: Center(
                                child: Text(
                              '₹ $price',
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.primaryText,
                                fontWeight: FontWeight.w600,
                                fontFamily: AppFonts.sofiaSans,
                              ),
                            )),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 6, right: 6, top: 4),
                          child: Text(
                            '08:00am - 09:00am',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.primaryText,
                              fontWeight: FontWeight.w600,
                              fontFamily: AppFonts.sofiaSans,
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 5),


              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    FocusManager.instance.primaryFocus?.unfocus();

                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (context) => const BookingDetailPage(),
                    //   ),
                    // );
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: AppColors.primary,
                  ),
                  child: const Text(
                    'Next',
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

