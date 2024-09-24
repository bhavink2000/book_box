import 'dart:convert';
import 'package:book_box/network/api_constant.dart';
import 'package:book_box/styles/colors.dart';
import 'package:book_box/styles/fonts.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';
import 'package:http/http.dart' as http;
import '../controller/checkout_controller.dart';
import '../controller/slot_booking_controller.dart';

class BookingDetailPage extends StatefulWidget {
  BookingDetailPage(
      {this.name,
      this.city,
      this.address,
      this.boxId,
      this.date,
      this.idList,
      this.detail,
      this.slotPricee,
      this.selectedSlotInfoList,
      super.key});

  String? name;
  String? city;
  String? address;
  String? boxId;
  String? date;
  List<String>? idList = [];
  String? detail;
  String? slotPricee;
  List<Map<String, String>>? selectedSlotInfoList = [];

  @override
  State<BookingDetailPage> createState() => _BookingDetailPageState();
}

class _BookingDetailPageState extends State<BookingDetailPage> {
  int? slotPrice;
  List<String> selectedSlotId = [];

  String environment = 'PRODUCTION';
  String appId = '';

  bool enableLogging = true;
  String checkSum = '';

  String saltIndex = '1';

  String callBackUrl = 'https://webhook.site/callback-url';
  String body = '';
  String apiEndPoint = '/pg/v1/pay';
  Object? result;
  String transactionId = DateTime.now().millisecondsSinceEpoch.toString();

  SlotBookingController slotBookingController = SlotBookingController();
  CheckoutController checkoutController = CheckoutController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('name : ${widget.name}');
    print('city : ${widget.city}');
    print('address : ${widget.address}');
    print('boxId : ${widget.boxId}');
    print('date : ${widget.date}');
    print('Id : ${widget.idList.toString()}');
    print('Id : ${widget.selectedSlotInfoList.toString()}');

    print('Id : ${widget.slotPricee.toString()}');

    slotPrice =
        int.parse(widget.slotPricee!) * widget.selectedSlotInfoList!.length;

    for (var map in widget.selectedSlotInfoList!) {
      String id = map['id'] ?? ''; // Replace '' with a default value if needed
      selectedSlotId.add(id);
    }

    try {
      phonePayInit();
    } on Exception catch (error) {
      // handle error
    }

    body = getCheckSum().toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: const Text(
          'My Booking',
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontFamily: AppFonts.sofiaSans,
          ),
        ),
        centerTitle: false,
      ),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Total Pay',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontFamily: AppFonts.sofiaSans,
                          ),
                        ),
                        Text(
                          '₹ ${slotPrice}',
                          style: const TextStyle(
                            fontSize: 28,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontFamily: AppFonts.sofiaSans,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 10),
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        _buildRowItem(
                            title: 'Booking Date', value: widget.date!),
                        _buildRowItem(title: 'Ground', value: widget.name!),
                        _buildRowItem(title: 'City', value: widget.city!),
                        _buildRowItem(title: 'Details', value: widget.detail!),
                        _buildRowItem(
                          title: 'Address',
                          value: widget.address!,
                        ),
                        const SizedBox(height: 6),
                        const MySeparator(color: AppColors.lightText),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    'Selected Slot',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.primaryText,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: AppFonts.sofiaSans,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount:
                                      widget.selectedSlotInfoList!.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    var data =
                                        widget.selectedSlotInfoList![index];

                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8.0, bottom: 8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            data['time'] ?? '',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: AppColors.primaryText,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: AppFonts.sofiaSans,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                if (widget.selectedSlotInfoList!
                                                        .length >
                                                    2) {
                                                  widget.selectedSlotInfoList!
                                                      .removeAt(index);
                                                  slotPrice = int.parse(
                                                          widget.slotPricee!) *
                                                      widget
                                                          .selectedSlotInfoList!
                                                          .length;
                                                  selectedSlotId
                                                      .removeAt(index);
                                                } else {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                          'Minimum select 2 slot'),
                                                      duration:
                                                          Duration(seconds: 2),
                                                    ),
                                                  );
                                                }
                                              });
                                            },
                                            child: const Icon(
                                              Icons.clear,
                                              size: 20,
                                              // Adjust the size of the icon
                                              color: Colors.red,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        _buildRowItem(
                            title: 'Total Slot',
                            value:
                                widget.selectedSlotInfoList!.length.toString()),
                        _buildRowItem(
                            title: 'Total Slot Price', value: '₹ ${slotPrice}'),
                        const SizedBox(height: 6),
                        const MySeparator(color: AppColors.lightText),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Grand Total',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.primaryText,
                                fontWeight: FontWeight.w700,
                                // fontFamily: AppFonts.sofiaSans,
                              ),
                            ),
                            Text(
                              '₹ ${slotPrice}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.primaryText,
                                fontWeight: FontWeight.w700,
                                // fontFamily: AppFonts.sofiaSans,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      // Move to root page
                      print(selectedSlotId.toString());

                      startPgTransaction();

                      print('result :: $result');
                      // Navigator.of(context).push(
                      //   MaterialPageRoute(
                      //     builder: (context) => const PaymentPage(),
                      //   ),
                      // );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: AppColors.primary,
                    ),
                    child: Text(
                      'Pay    ${slotPrice!}',
                      style: const TextStyle(
                        fontSize: 18,
                        color: AppColors.secondary,
                        fontWeight: FontWeight.w600,
                        fontFamily: AppFonts.sofiaSans,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRowItem({required String title, required String value}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.primaryText,
                fontWeight: FontWeight.w600,
                fontFamily: AppFonts.sofiaSans,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.primaryText,
                fontWeight: FontWeight.w600,
                fontFamily: AppFonts.sofiaSans,
              ),
            ),
          ),
        ],
      ),
    );
  }

  getCheckSum() {
    final requestData = {
      "merchantId": ApiConstant.merchantId,
      "merchantTransactionId": transactionId,
      "merchantUserId": "MUID123",
      "amount": slotPrice! * 100,
      "mobileNumber": "9016306565",
      "callbackUrl": callBackUrl,
      "paymentInstrument": {
        "type": "PAY_PAGE",
      },
    };

    String base64Body = base64.encode(utf8.encode(json.encode(requestData)));
    checkSum =
        '${sha256.convert(utf8.encode(base64Body + apiEndPoint + ApiConstant.saltKey)).toString()}###$saltIndex';

    print("checkSum:- " + checkSum);
    return base64Body;
  }

  void phonePayInit() {
    PhonePePaymentSdk.init(
            environment, appId, ApiConstant.merchantId, enableLogging)
        .then((val) => {
              setState(() {
                result = 'PhonePe SDK Initialized - $val';
              })
            })
        .catchError((error) {
      handleError(error);
    });
  }

  void startPgTransaction() async {
    PhonePePaymentSdk.startTransaction(body, callBackUrl, checkSum, '')
        .then((response) => {
              setState(() {
                if (response != null) {
                  String status = response['status'].toString();
                  String error = response['error'].toString();
                  if (status == 'SUCCESS') {
                    result = "Flow Complete  - status  : SUCCESS";
                    checkStatusForSuccess();
                  } else {
                    result =
                        "Flow Complete  - status  : $status  and error $error";

                    slotBookingController
                        .slotBook(
                            context,
                            ApiConstant.userToken!,
                            widget.boxId!,
                            widget.date!,
                            selectedSlotId,
                            transactionId,
                            "2",
                            slotPrice.toString())
                        .then((value) {
                      checkoutController.checkout(context);
                    });
                  }
                } else {
                  // "Flow Incomplete";
                }
              })
            })
        .catchError((error) {
      // handleError(error)
      return <dynamic>{};
    });
  }

  void handleError(error) {
    setState(() {
      result = {'error': error};
    });
  }

  void checkStatusForSuccess() async {
    String url =
        'https://api.phonepe.com/apis/hermes/pg/v1/status/${ApiConstant.merchantId}/$transactionId';

    String concatString =
        "/pg/v1/status/${ApiConstant.merchantId}/$transactionId${ApiConstant.saltKey}";

    var bytes = utf8.encode(concatString);
    var digest = sha256.convert(bytes).toString();
    String xVerify = "$digest###$saltIndex";

    Map<String, String> headers = {
      "Content-Type": "application/json",
      "X-VERIFY": xVerify,
      "X-MERCHANT-ID": ApiConstant.merchantId
    };

    await http.get(Uri.parse(url), headers: headers).then((value) {
      Map<String, dynamic> res = jsonDecode(value.body);

      print(res);

      if (res['success'].toString() == 'true') {
        print(' success:::: ${res['message']}');

        print(' success');

        slotBookingController
            .slotBook(
                context,
                ApiConstant.userToken!,
                widget.boxId!,
                widget.date!,
                selectedSlotId,
                transactionId,
                "1",
                slotPrice.toString())
            .then((value) {
          checkoutController.checkout(context);
        });
      } else {
        print('success  :: ${res['message']}');
      }
    });
  }
}

class MySeparator extends StatelessWidget {
  const MySeparator({super.key, this.height = 1, this.color = Colors.black});

  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 5.0;
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
        );
      },
    );
  }
}
