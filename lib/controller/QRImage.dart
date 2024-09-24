import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import '../styles/colors.dart';
import '../styles/fonts.dart';

class QRImage extends StatefulWidget {
  const QRImage(this.controller, {super.key});

  final String controller;

  @override
  State<QRImage> createState() => _QRImageState();
}

class _QRImageState extends State<QRImage> {
  ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR code'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            QrImageView(
              data: widget.controller,
              version: QrVersions.auto,
              size: 200.0,
            ),
            ButtonBar(
              alignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SizedBox(
                        child: ElevatedButton(
                          onPressed: () {
                            _shareQRImage();
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: AppColors.primary,
                          ),
                          child: const Text(
                            'Share',
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
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future _shareQRImage() async {
    final image = await QrPainter(
      data: widget.controller,
      version: QrVersions.auto,
      gapless: false,
      color: Colors.black,
      emptyColor: Colors.white,
    ).toImageData(200.0); // Generate QR code image data

    final filename = 'qr_code.png';
    final tempDir =
        await getTemporaryDirectory(); // Get temporary directory to store the generated image
    final file = await File('${tempDir.path}/$filename')
        .create(); // Create a file to store the generated image
    var bytes = image!.buffer.asUint8List(); // Get the image bytes
    await file.writeAsBytes(bytes); // Write the image bytes to the file
    final path = await Share.shareFiles([file.path],
        text: 'QR code for ${widget.controller}',
        subject: 'QR Code',
        mimeTypes: [
          'image/png'
        ]); // Share the generated image using the share_plus package
    //print('QR code shared to: $path');
  }
}
