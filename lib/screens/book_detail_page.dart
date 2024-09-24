import 'package:book_box/controller/MapUtils.dart';
import 'package:book_box/controller/deeplinking_controller.dart';
import 'package:book_box/controller/slot_controller.dart';
import 'package:book_box/styles/colors.dart';
import 'package:book_box/styles/fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../controller/QRImage.dart';
import '../models/slot_model.dart';
import 'booking_detail_page.dart';
import 'package:intl/intl.dart';

String getCurrentTime() {
  DateTime now = DateTime.now();
  int currentHour = now.hour;
  if (currentHour >= 6 && currentHour < 12) {
    return 'Morning';
  } else if (currentHour >= 12 && currentHour < 18) {
    return 'Afternoon';
  } else if (currentHour >= 18 && currentHour < 24) {
    return 'Evening';
  } else {
    return 'Night';
  }
}

class BookDetailPage extends StatefulWidget {
  BookDetailPage(
      {this.boxId,
      this.image,
      this.name,
      this.detail,
      this.city,
      this.address,
      this.slotPrice,
      this.latitude,
      this.longitude,
      super.key});

  String? boxId;
  String? image;
  String? name;
  String? detail;
  String? city;
  String? address;
  String? slotPrice;
  String? latitude;
  String? longitude;

  @override
  State<BookDetailPage> createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  final CarouselController _controller = CarouselController();
  String _currentSelectedValue = getCurrentTime();

  late CalendarFormat _calendarFormat;
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  String? selectedDate;
  String? selectedTime = getCurrentTime();
  List<bool> isCheckedList = List.generate(12, (index) => false);

  SlotController slotController = SlotController();
  SlotModel? slotModel;

  List<SlotElement> slotList = [];
  Map<int, bool> selectedSlots = {};
  List<String> selectedSlotId = [];
  bool loading = false;

  Map<String, bool> checkedValues = {};
  List<Map<String, String>> selectedSlotInfoList = [];

  Future getSlot(
      BuildContext context, String slotTime, String boxId, String date) async {
    setState(() {
      loading = true;
    });
    await slotController
        .getAllSlot(context, slotTime, boxId, date)
        .then((value) {
      if (this.mounted) {
        setState(() {
          if (value != null) {
            slotModel = value;
            slotList = slotModel!.data.slots;
            print('boxsize ${slotList.length}');

            var cityName = slotList.map((datum) => datum.isBooked).toList();

            print('krunal =====  $cityName');

            loading = false;
          } else {
            slotList.clear();
            loading = false;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('No slot found'),
                duration: Duration(seconds: 2),
              ),
            );
          }
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _calendarFormat = CalendarFormat.month;
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();

    selectedDate = DateFormat('dd-MM-yyyy').format(_selectedDay);
    print(selectedDate);

    getSlot(context, getCurrentTime(), widget.boxId!, selectedDate!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SafeArea(
              top: false,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        SizedBox(
                          height: 200,
                          width: double.infinity,
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(8),
                                bottomRight: Radius.circular(8)),
                            child: CachedNetworkImage(
                              imageUrl: widget.image!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          child: SafeArea(
                            child: IconButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  widget.name!,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: AppColors.primaryText,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: AppFonts.sofiaSans,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              widget.detail!,
                              textAlign: TextAlign.start,
                              // Align text to start (left)
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                fontFamily: AppFonts.sofiaSans,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            decoration: BoxDecoration(
                              color: AppColors.cardBackground,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.city!,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: AppColors.lightText,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: AppFonts.sofiaSans,
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(right: 40, bottom: 8),
                                  child: Column(
                                    children: [
                                      Text(
                                        widget.address!,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: AppFonts.sofiaSans,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          if (widget.latitude != null &&
                                              widget.longitude != null) {
                                            MapUtils.openMap(widget.latitude!,
                                                widget.longitude!);
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content:
                                                    Text('Location Not Found'),
                                                duration: Duration(seconds: 2),
                                              ),
                                            );
                                          }
                                        },
                                        child: const Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Get Direction',
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: AppColors.primary,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: AppFonts.sofiaSans,
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          GestureDetector(
                            onTap: () async {
                              /*Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: ((context) {
                                    */ /*var boxid = widget.boxId;
                                    var image = widget.image;
                                    var name = widget.name;
                                    var details = widget.detail;
                                    var city = widget.city;
                                    var address = widget.address;
                                    var price = widget.slotPrice;
                                    return QRImage(
                                        "$boxid/$image/$name/$details/$city/$address/$price");*/ /*
                                  }),
                                ),
                              );*/
                              DeeplinkingController deepLinkinCOntroller =
                                  DeeplinkingController();
                              deepLinkinCOntroller.deepLinking(
                                  context, widget.boxId!, selectedDate!);
                            },
                            child: const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Generate QR Code',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: AppFonts.sofiaSans,
                                ),
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
                                      fontSize: 14,
                                      color: AppColors.primaryText,
                                      fontWeight: FontWeight.w600,
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
                                      contentPadding:
                                          const EdgeInsets.symmetric(
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
                                            _currentSelectedValue =
                                                newValue ?? 'Morning';
                                            state.didChange(newValue);

                                            selectedTime =
                                                _currentSelectedValue;

                                            print(selectedDate);

                                            getSlot(context, selectedTime!,
                                                widget.boxId!, selectedDate!);

                                            selectedSlots.clear();
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
                          const SizedBox(height: 20),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppColors.cardBackground,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: TableCalendar(
                              firstDay: DateTime.now(),
                              lastDay: DateTime.utc(2050, 12, 31),
                              focusedDay: DateTime.now(),
                              calendarFormat: _calendarFormat,
                              selectedDayPredicate: (day) {
                                return isSameDay(_selectedDay, day);
                              },
                              onDaySelected: (selectedDay, focusedDay) {
                                setState(() {
                                  _selectedDay = selectedDay;
                                  _focusedDay =
                                      focusedDay; // update `_focusedDay` as well
                                  print('Selected date: $_selectedDay');

                                  selectedDate = DateFormat('dd-MM-yyyy')
                                      .format(_selectedDay);

                                  DateTime date = DateTime.now();
                                  String d =
                                      DateFormat('dd-MM-yyyy').format(date);

                                  if (d == selectedDate) {
                                    _currentSelectedValue = getCurrentTime();

                                    getSlot(context, selectedTime!,
                                        widget.boxId!, selectedDate!);
                                    selectedSlots.clear();
                                  } else {
                                    _currentSelectedValue = 'Morning';
                                    getSlot(context, 'Morning', widget.boxId!,
                                        selectedDate!);
                                    selectedSlots.clear();
                                  }
                                });
                              },
                              onFormatChanged: (format) {
                                setState(() {
                                  _calendarFormat = format;
                                });
                              },
                              onPageChanged: (focusedDay) {
                                _focusedDay =
                                    focusedDay; // update `_focusedDay` when page changes
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                    GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio:
                            3.0, // Adjust this value to control item height
                      ),
                      itemCount: slotList.length,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        final item = slotList[index];
                        Color itemColor = item.slotDisabled == 'disable' ||
                                item.isBooked == true
                            ? Color(0xFFF2F2F2)
                            : Colors.white;

                        Color borderColor = item.slotDisabled == 'disable'
                            ? Color(0xFFFF0000)
                            : Colors.white;

                        if (selectedSlots.containsKey(index) &&
                            selectedSlots[index] == true) {
                          itemColor =
                              AppColors.primary; // Change color when selected
                        }
                        return Center(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                if (item.slotDisabled != 'disable' &&
                                    item.isBooked == false) {
                                  if (selectedSlots.containsKey(index)) {
                                    // Deselect the slot and remove from the list
                                    selectedSlots.remove(index);
                                    selectedSlotId
                                        .remove(slotList[index].id.toString());

                                    // Remove the deselected slot information from selectedSlotInfoList
                                    selectedSlotInfoList.removeWhere(
                                        (element) =>
                                            element['id'] ==
                                            slotList[index].id.toString());
                                  } else {
                                    if (selectedSlots.isEmpty) {
                                      // Select the slot and add to the list
                                      selectedSlots[index] = true;
                                      selectedSlots[index + 1] = true;
                                      selectedSlotId
                                          .add(slotList[index].id.toString());
                                      selectedSlotId.add(
                                          slotList[index + 1].id.toString());

                                      // Add the selected slot information to selectedSlotInfoList
                                      selectedSlotInfoList.add({
                                        'id': slotList[index].id.toString(),
                                        'time':
                                            "${slotList[index].startTime.toString()} ${slotList[index].startTimeFormate.toString()} to ${slotList[index].endTime!} ${slotList[index].endTimeFormate.toString()}"
                                      });
                                      selectedSlotInfoList.add({
                                        'id': slotList[index + 1].id.toString(),
                                        'time':
                                            "${slotList[index + 1].startTime.toString()} ${slotList[index + 1].startTimeFormate.toString()} to ${slotList[index + 1].endTime!} ${slotList[index + 1].endTimeFormate.toString()}"
                                      });
                                    } else {
                                      // Select the slot and add to the list
                                      selectedSlots[index] = true;
                                      selectedSlotId
                                          .add(slotList[index].id.toString());

                                      // Add the selected slot information to selectedSlotInfoList
                                      selectedSlotInfoList.add({
                                        'id': slotList[index].id.toString(),
                                        'time':
                                            "${slotList[index].startTime.toString()} ${slotList[index].startTimeFormate.toString()} to ${slotList[index].endTime!} ${slotList[index].endTimeFormate.toString()}"
                                      });
                                    }
                                  }
                                }
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: itemColor,
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: borderColor),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    spreadRadius: 0,
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              child: Text(
                                "${item.startTime.toString()} ${item.startTimeFormate.toString()} to ${item.endTime!} ${item.endTimeFormate.toString()}",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: AppFonts.sofiaSans,
                                  color: selectedSlots.containsKey(index) &&
                                          selectedSlots[index] == true
                                      ? Colors
                                          .white // Change to the selected color
                                      : Colors
                                          .black, // Default color when not selected
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            FocusManager.instance.primaryFocus?.unfocus();

                            print('name : ${widget.name}');
                            print('city : ${widget.city}');
                            print('address : ${widget.address}');
                            print('boxId : ${widget.boxId}');
                            print('date : ${selectedDate.toString()}');
                            print('Id : ${selectedSlotId.toString()}');
                            print('Id : ${widget.slotPrice.toString()}');
                            print('Info : ${selectedSlotInfoList.toString()}');

                            if (selectedSlotId.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please select slots.'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            } else if (selectedSlotId.length < 2) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('Please select minimum 2 slots.'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            } else {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => BookingDetailPage(
                                    name: widget.name,
                                    city: widget.city,
                                    address: widget.address,
                                    boxId: widget.boxId,
                                    date: selectedDate.toString(),
                                    idList: selectedSlotId,
                                    detail: widget.detail,
                                    slotPricee: widget.slotPrice.toString(),
                                    selectedSlotInfoList: selectedSlotInfoList,
                                  ),
                                ),
                              );
                            }
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
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
