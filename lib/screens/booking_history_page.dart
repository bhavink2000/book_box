import 'package:book_box/controller/tournamenr_controller.dart';
import 'package:book_box/models/tournament_model.dart';
import 'package:book_box/styles/colors.dart';
import 'package:book_box/styles/fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BookingHistoryPage extends StatefulWidget {
  const BookingHistoryPage({super.key});

  @override
  State<BookingHistoryPage> createState() => _BookingHistoryPageState();
}

class _BookingHistoryPageState extends State<BookingHistoryPage> {
  bool loading = false;
  TournamentController tournamentController = TournamentController();
  TournamentModel? tournamentModel;

  List<Datum> tournamentList = [];

  Future getTournament(BuildContext context) async {
    loading = true;
    await tournamentController.getTournament(context).then((value) {
      setState(() {
        if (value != null) {
          tournamentModel = value;
          tournamentList = tournamentModel!.data;

          print(value.toString());
          print(tournamentList.length);

          loading = false;
        } else {
          tournamentList.clear();
          loading = false;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('No data found'),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();

    getTournament(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: const Text(
          'Upcoming tournament',
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontFamily: AppFonts.sofiaSans,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: loading
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: tournamentList.length,
                      itemBuilder: (context, index) {
                        var data = tournamentList[index];
                        final imageWidth =
                            MediaQuery.of(context).size.width / 2.6;

                        return GestureDetector(
                          onTap: () {
                            // Navigator.of(context).push(
                            // MaterialPageRoute(
                            //   builder: (context) => const BookDetailPage(),
                            // ),
                            // );
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
                                        data.name,
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
                                        'Location: ${data.location}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: AppColors.primaryText,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: AppFonts.sofiaSans,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4),
                                        child: Text(
                                          'Registration Number: ${data.registrationNumber}',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: AppColors.primaryText,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: AppFonts.sofiaSans,
                                          ),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          const Text(
                                            'Detail: ',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: AppColors.primaryText,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: AppFonts.sofiaSans,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              viewTournamentDetail(
                                                  context,
                                                  data.name,
                                                  data.location,
                                                  data.registrationNumber,
                                                  data.details);
                                            },
                                            child: const Text(
                                              'Read more...',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: AppColors.primary,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: AppFonts.sofiaSans,
                                              ),
                                            ),
                                          ),

                                        ],
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
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          child: CachedNetworkImage(
                                            imageUrl: data.image,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 1),
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
}

Future viewTournamentDetail(BuildContext context, String name, String location,
    String number, String description) async {
  return showDialog(
    context: context,
    builder: (context) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: AlertDialog(
            insetPadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.zero,
            titlePadding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            title: Container(
              child: Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8.0),
                          topRight: Radius.circular(8.0)),
                      color: AppColors.primary,
                    ),
                    height: 50,
                    child: Padding(
                      padding: EdgeInsets.only(right: 8.0, left: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Tournament',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 18.0, left: 8, right: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 20,
                            color: AppColors.primaryText,
                            fontWeight: FontWeight.w600,
                            fontFamily: AppFonts.sofiaSans,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Text(
                              'Location: ',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                                fontFamily: AppFonts.sofiaSans,
                              ),
                            ),
                            Text(
                              location,
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.primaryText,
                                fontWeight: FontWeight.w600,
                                fontFamily: AppFonts.sofiaSans,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Text(
                              'Registration Number: ',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                                fontFamily: AppFonts.sofiaSans,
                              ),
                            ),
                            Text(
                              number,
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.primaryText,
                                fontWeight: FontWeight.w600,
                                fontFamily: AppFonts.sofiaSans,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Text(
                          description,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.primaryText,
                            fontWeight: FontWeight.w600,
                            fontFamily: AppFonts.sofiaSans,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                // Action to perform when the button is pressed
                                Navigator.pop(context);
                                print('ElevatedButton pressed!');
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                backgroundColor: AppColors.primary,
                              ),
                              child: const Text(
                                'Close',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: AppColors.secondary,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: AppFonts.sofiaSans,
                                ),
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
        ),
      );
    },
  );
}
