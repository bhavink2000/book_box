import 'package:book_box/controller/box_controller.dart';
import 'package:book_box/controller/city_controller.dart';
import 'package:book_box/models/box_model.dart';
import 'package:book_box/models/city_model.dart';
import 'package:book_box/screens/book_detail_page.dart';
import 'package:book_box/styles/colors.dart';
import 'package:book_box/styles/fonts.dart';
import 'package:book_box/styles/icons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // RangeValues _currentRangeValues = const RangeValues(120, 1400);
  // double _start = 500.0;
  // double _end = 1400.0;

  bool loading = false;

  CityController cityController = CityController();
  CityModel? cityModel;

  BoxController boxController = BoxController();
  BoxModel? boxModel;
  List<ListElement> boxList = [];

  SfRangeValues _currentRangeValues = SfRangeValues(
    DateTime(2023, 01, 01, 07, 00, 00),
    DateTime(2023, 01, 01, 17, 00, 00),
  );
  final dateFormatter = DateFormat('h:mm a');
  List<Datum> cityList = [];
  List<String> cityName = [];

  String? _currentAddress;
  Position? _currentPosition;

  String? city;

  // Example suggestion list
  Future<void> _getCityNameFromCoordinates(double lat, double long) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);
      if (placemarks.isNotEmpty) {
        setState(() {
          city = placemarks[0].locality ?? '';
          print(city);
        });
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  String getRangeValue() {
    final start = dateFormatter.format(_currentRangeValues.start);
    final end = dateFormatter.format(_currentRangeValues.end);

    return '$start - $end';
  }

  Future getCity(BuildContext context) async {
    await cityController.getCity(context).then((value) {
      setState(() {
        if (value != null) {
          cityModel = value;
          cityList = cityModel!.data;

          print(value.toString());
          print(cityList.length);
          cityName = cityList.map((datum) => datum.name).toList();

          print(cityName);
        } else {
          cityList.clear();
        }
      });
    });
  }

  Future getCricketBox(BuildContext context, String cityName) async {
    setState(() {
      loading = true;
    });
    await boxController.getAllBox(context, cityName).then((value) {
      print(value.toString());
      setState(() {
        if (value != null) {
          boxModel = value;
          boxList = boxModel!.data.data;

          print('boxsize ${boxList.length}');
          loading = false;
        } else {
          boxList.clear();
          loading = false;
        }
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCity(context);
    getCricketBox(context, '');
    _getCurrentPosition();
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Autocomplete<String>(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text == '') {
                    return const Iterable<String>.empty();
                  }
                  return cityName.where((String item) {
                    return item.contains(textEditingValue.text);
                  });
                },
                fieldViewBuilder: (BuildContext context,
                    TextEditingController textEditingController,
                    FocusNode focusNode,
                    VoidCallback onFieldSubmitted) {
                  return TextFormField(
                    textInputAction: TextInputAction.search,
                    controller: textEditingController,
                    focusNode: focusNode,
                    onFieldSubmitted: (String value) {
                      onFieldSubmitted();
                      print(value);
                      getCricketBox(context, value);
                    },
                    onChanged: (String value) {
                      // Perform actions when text changes
                      getCricketBox(context, value);
                      // You can call any function or perform any action here based on the changed text
                    },
                    decoration: InputDecoration(
                      hintText: 'Search',
                      hintStyle: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF49454F),
                        fontFamily: AppFonts.sofiaSans,
                        fontWeight: FontWeight.w600,
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Color(0xFF49454F),
                      ),
                      suffixIcon: GestureDetector(
                        onTap: () async {
                          print('LAT: ${_currentPosition?.latitude ?? ""}');
                          print('LNG: ${_currentPosition?.longitude ?? ""}');
                          print('ADDRESS: ${_currentAddress ?? ""}');

                          // _getCityNameFromCoordinates(_currentPosition!.latitude,_currentPosition!.longitude);
                          try {
                            List<Placemark> placemarks =
                                await placemarkFromCoordinates(
                                    _currentPosition!.latitude,
                                    _currentPosition!.longitude);
                            if (placemarks.isNotEmpty) {
                              setState(() {
                                city = placemarks[0].locality ?? '';
                                print(city);
                                textEditingController.text = city!;
                                getCricketBox(
                                    context, textEditingController.text);
                              });
                            }
                          } catch (e) {
                            print('Error: $e');
                          }
                        },
                        child: const Icon(
                          Icons.location_searching,
                          color: Color(0xFF49454F),
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(28),
                        borderSide: BorderSide(
                          width: 0,
                          color: AppColors.primary.withOpacity(0.10),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(28),
                        borderSide: BorderSide(
                          width: 0,
                          color: AppColors.primary.withOpacity(0.10),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(28),
                        borderSide: BorderSide(
                          width: 0,
                          color: AppColors.primary.withOpacity(0.10),
                        ),
                      ),
                      filled: true,
                      fillColor: AppColors.primary.withOpacity(0.10),
                    ),
                  );
                },
                onSelected: (String item) async {
                  print(item);
                  getCricketBox(context, item);
                },
              ),
            ),
            const SizedBox(height: 8),
            loading
                ? Center(child: CircularProgressIndicator())
                : Expanded(
                    child: ListView.builder(
                      padding:
                          const EdgeInsets.only(left: 16, right: 16, bottom: 8),
                      shrinkWrap: true,
                      itemCount: boxList.length,
                      itemBuilder: (context, index) {
                        var data = boxList[index];
                        final imageWidth =
                            MediaQuery.of(context).size.width / 2.6;

                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => BookDetailPage(
                                boxId: data.id.toString(),
                                image: data.image,
                                name: data.name,
                                detail: data.details,
                                city: data.city,
                                address: data.address,
                                slotPrice: data.price,
                                latitude: data.latitude,
                                longitude: data.longitude,
                              ),
                            ));
                          },
                          child: Container(
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
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        data.name!,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          color: AppColors.primaryText,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: AppFonts.sofiaSans,
                                        ),
                                      ),
                                      Text(
                                        data.city!,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: AppColors.lightText,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: AppFonts.sofiaSans,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4),
                                        child: Text(
                                          'Timing: ${data.time}${'To'}${data.time1}',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: AppFonts.sofiaSans,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '₹ ${data.price}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: AppColors.primaryText,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: AppFonts.sofiaSans,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                SizedBox(
                                  width: imageWidth,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 96,
                                        width: imageWidth,
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            child: CachedNetworkImage(
                                              imageUrl: data.image!,
                                              fit: BoxFit.cover,
                                            )),
                                      ),
                                      const SizedBox(height: 1),
                                      SizedBox(
                                        width: imageWidth,
                                        child: ElevatedButton(
                                          onPressed: () =>
                                              Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  BookDetailPage(
                                                boxId: data.id.toString(),
                                                image: data.image,
                                                name: data.name,
                                                detail: data.details,
                                                city: data.city,
                                                address: data.address,
                                                slotPrice: data.price,
                                                latitude: data.latitude,
                                                longitude: data.longitude,
                                              ),
                                            ),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            backgroundColor: AppColors.primary,
                                          ),
                                          child: const Text(
                                            'Book',
                                            style: TextStyle(
                                              fontSize: 14,
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
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSheet() {
    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Container(
              height: 4,
              width: 75,
              color: const Color(0xFFD9D9D9),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Text(
                    'Select Booking Option',
                    style: TextStyle(
                      fontSize: 20,
                      color: AppColors.primaryText,
                      fontWeight: FontWeight.w600,
                      fontFamily: AppFonts.sofiaSans,
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    child: Image.asset(AppIcons.close, height: 16),
                  )
                ],
              ),
            ),
            // Range filter view
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Preferred Time',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.primaryText,
                      fontWeight: FontWeight.w600,
                      fontFamily: AppFonts.sofiaSans,
                    ),
                  ),
                  Text(
                    getRangeValue(),
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.primaryText,
                      fontWeight: FontWeight.w600,
                      fontFamily: AppFonts.sofiaSans,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: SfRangeSlider(
                values: _currentRangeValues,
                min: DateTime(2023, 01, 01, 00, 30, 00),
                max: DateTime(2023, 01, 01, 23, 30, 00),
                stepDuration: const SliderStepDuration(minutes: 30),
                dateFormat: dateFormatter,
                dateIntervalType: DateIntervalType.minutes,
                onChanged: (value) {
                  setState(() {
                    _currentRangeValues = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 10),
            _buildBottomRow(title: 'Morning'),
            _buildBottomRow(title: 'Afternoon'),
            _buildBottomRow(title: 'Evening'),
            _buildBottomRow(title: 'Night'),
            const SafeArea(child: SizedBox(height: 20)),
          ],
        );
      },
    );
  }

  Padding _buildBottomRow({required String title}) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 10, top: 10),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              color: AppColors.primaryText,
              fontWeight: FontWeight.w400,
              fontFamily: AppFonts.sofiaSans,
            ),
          ),
          const Spacer(),
          Image.asset(AppIcons.angleRight, height: 20),
        ],
      ),
    );
  }
}

class BookRowWidget extends StatelessWidget {
  const BookRowWidget({
    super.key,
    required this.bookModel,
    required this.imageWidth,
    this.onBookTap,
  });

  final BookModel bookModel;
  final double imageWidth;
  final VoidCallback? onBookTap;

  @override
  Widget build(BuildContext context) {
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bookModel.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 20,
                    color: AppColors.primaryText,
                    fontWeight: FontWeight.w600,
                    fontFamily: AppFonts.sofiaSans,
                  ),
                ),
                Text(
                  bookModel.city,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.lightText,
                    fontWeight: FontWeight.w600,
                    fontFamily: AppFonts.sofiaSans,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    'Timing: ${bookModel.timing}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                      fontFamily: AppFonts.sofiaSans,
                    ),
                  ),
                ),
                Text(
                  '₹ ${bookModel.price.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.primaryText,
                    fontWeight: FontWeight.w600,
                    fontFamily: AppFonts.sofiaSans,
                  ),
                ),
                const SizedBox(height: 5),
              ],
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: imageWidth,
            child: Column(
              children: [
                SizedBox(
                  height: 96,
                  width: imageWidth,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: CachedNetworkImage(
                      imageUrl: bookModel.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 1),
                SizedBox(
                  width: imageWidth,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: AppColors.primary,
                    ),
                    child: const Text(
                      'Book',
                      style: TextStyle(
                        fontSize: 14,
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
        ],
      ),
    );
  }
}

class BookModel {
  const BookModel({
    required this.title,
    required this.city,
    required this.imageUrl,
    required this.timing,
    required this.price,
    required this.rating,
  });

  final String title;
  final String city;
  final String imageUrl;
  final String timing;
  final double price;
  final double rating;
}

const bookModels = <BookModel>[
  BookModel(
    title: 'Box Cricket',
    city: 'Gandhinagar',
    imageUrl: 'https://impliestech.site/book/public/uploads/1689487480.jpg',
    timing: '7:00Am to 9:00Pm',
    price: 200,
    rating: 4.5,
  ),
  BookModel(
    title: 'Decathlon Motera Box Cricket',
    city: 'Ahmedabad',
    imageUrl: 'https://impliestech.site/book/public/uploads/1689492866.jpg',
    timing: '7:00Am to 9:00Pm',
    price: 344,
    rating: 4.5,
  ),
  BookModel(
    title: 'Pro 7 cricket center',
    city: 'Nadiyad',
    imageUrl: 'https://impliestech.site/book/public/uploads/1689492922.jpeg',
    timing: '7:00Am to 10:00Pm',
    price: 400,
    rating: 4.5,
  ),
  BookModel(
    title: 'The Eclipse Sports',
    city: 'Vadodara',
    imageUrl: 'https://impliestech.site/book/public/uploads/1689492973.jpeg',
    timing: '7:00Am to 10:00Pm',
    price: 200,
    rating: 4.0,
  ),
  BookModel(
    title: 'Pavilion Box Cricket',
    city: 'Rajkot',
    imageUrl: 'https://impliestech.site/book/public/uploads/1689493029.jpeg',
    timing: '7:00Am to 12:10Pm',
    price: 344,
    rating: 3.5,
  ),
  BookModel(
    title: 'Keshav sports complex',
    city: 'Jamnagar',
    imageUrl: 'https://impliestech.site/book/public/uploads/1689493086.webp',
    timing: '7:00Am to 12:00Pm',
    price: 750,
    rating: 4.5,
  ),
];
