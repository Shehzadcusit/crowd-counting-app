import 'dart:html';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

import '../controllers/home_builds_ids.dart';
import '../controllers/home_controller.dart';

class ResultScreen extends StatefulWidget {
  ResultScreen({Key? key}) : super(key: key);
  late File pickedFile;
  late int crowdCount;

  @override
  State<ResultScreen> createState() =>
      _ResultScreenState(this.pickedFile, this.crowdCount);
}

class _ResultScreenState extends State<ResultScreen> {
  final File pickedFile;
  final int crowdCount;

  _ResultScreenState(this.pickedFile, this.crowdCount);

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
      child: GetBuilder<HomeController>(
        id: kConversionTime,
        builder: (HomeController controller) => Column(
          children: [
            const SizedBox(height: 12.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Crowd count: ',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 26.0,
                  ),
                ),
                crowdCount != null
                    ? const SizedBox()
                    : Text(
                        crowdCount.toString(),
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                          fontSize: 26.0,
                        ),
                      ),
                TextButton(
                  onPressed: () {
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Saved',
                        style: TextStyle(
                            fontSize: 16.0, color: Colors.white, height: 1),
                      ),
                      SizedBox(width: 17.0),
                      Icon(
                        Icons.save_alt,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: HexColor('#D4246F'),
                    padding: EdgeInsets.all(16.0), // Set the padding
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}









// Future<void> processImage({String? imagePath}) async {
//   try {
//     if (imagePath == null) {
//       EasyLoading.showError('Invalid image path.');
//       return;
//     }
//     EasyLoading.show(status: 'Processing...');
//     print('image path:: ${imagePath}');
//
//     final File imageFile = File(imagePath);
//     final List<int> imageBytes = await imageFile.readAsBytes();
//
//     final compressedImageBytes = await compressImage(Uint8List.fromList(imageBytes));
//     final base64CompressedImage = base64Encode(compressedImageBytes);
//     final compressedBody = {'image': base64CompressedImage};
//
//     final List<Future<http.Response>> futures = [];
//     int numberOfRequests = 1;
//
//     for (int i = 0; i < numberOfRequests; i++) {
//       futures.add(_makeApiRequest(Uri.parse('http://192.168.109.177:5000/process_image'), compressedBody));
//     }*//*44.204.156.228:5000*//*
//
//   EasyLoading.dismiss();
//   selectResult(context);
//   } catch (e) {
//   print('AN ERROR OCCURRED WHILE PROCESSING IMAGE:: $e');
//   setState(() {
//   predicting = false;
//   });
//   EasyLoading.showError('Please check your internet connection and try again.');
//   }
// }
//
//
// Future<http.Response> _makeApiRequest(Uri uri, Map<String, dynamic> body) async {
//   final response = await http.post(
//     uri,
//     body: jsonEncode(body),
//     headers: {'Content-Type': 'application/json'},
//   );
//   return response;
// }
//
