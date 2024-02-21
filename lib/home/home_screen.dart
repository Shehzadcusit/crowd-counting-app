/*
import 'dart:convert';
import 'dart:developer' as console;
import 'dart:io';
import 'dart:typed_data';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:object_detection/home/loading.dart';
import 'package:object_detection/home/process_image.dart';
import 'package:object_detection/home/slider.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final imagePicker = ImagePicker();

  Uint8List? image;

  File? pickedFile;

  bool predicting = false;

  int? crowdCount;

  void awes(BuildContext context) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.bottomSlide,
      isDense: false,
      //title: 'Error',
      desc: 'Oops! Cannot Shown Result!',
      btnOkOnPress: () {
        selectHome(context);
      },
      btnOkColor: Colors.blue,
    )..show();
  }



  void selectHome(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return HomeScreen();
        },
      ),
    );
  }

  selectResult(BuildContext context) {
    Future.delayed(Duration.zero, () {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) {
            return Result(crowdCount!, pickedFile!);
          },
        ),
      );
    });
  }

  Future<void> processImage({String? imagePath}) async {
    try {
      EasyLoading.show(status: 'Processing...');
      console.log('image path:: ${imagePath}');
      final imageBytes = File(imagePath!).readAsBytesSync();
      final base64Image = base64Encode(imageBytes);
      // Compress the image
      final compressedImageBytes = await compressImage(imageBytes);
      final base64CompressedImage = base64Encode(compressedImageBytes);
      final compressedBody = {
        'image': base64CompressedImage,
      };
      // final body = {
      //   'image': base64Image,
      // };
      final response = await http.post(
        Uri.parse(
          'http://44.204.156.228:5000/process_image',
        ),
        body: jsonEncode(compressedBody),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      print('RESPONSE:: ${response.body}');
      crowdCount = jsonDecode(response.body)['count'];
      setState(() {});
      EasyLoading.dismiss();
      selectResult(context);
    } catch (e) {
      console.log('AN ERROR OCCURED WHILE PROCESSING IMAGE:: $e');
      setState(() {
        predicting = false;
      });
      EasyLoading.showError('Please check your internet connection and try again.');

    }
  }

  Future<Uint8List> compressImage(Uint8List imageBytes) async {
    img.Image? image = img.decodeImage(imageBytes);
    // Resize the image to a smaller size
    image = img.copyResize(image!,
        width: 800, height: 600, interpolation: img.Interpolation.linear);
    // Compress the image with a specific quality (adjust as needed)
    Uint8List compressedBytes =
        Uint8List.fromList(img.encodeJpg(image, quality: 70));
    return compressedBytes;
  }



  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: HexColor('#D4246F'),
      */
/*appBar: AppBar(
        title: Center(
          child: Text(
            'crowd counting',
            style: GoogleFonts.aBeeZee(
              color: Colors.blue,
              letterSpacing: 1,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.3,
      ),
*/ /*

      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              color: HexColor('#D4246F'),
              child: Row(
                children: [
                  SizedBox(
                    width: 3,
                  ),
                  Icon(Icons.menu, color: HexColor('#ffffff')),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Crowd Counting',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              height: 60,
              width: 400,
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: */
/*predicting
                  ? LoadingPage()
                  : (pickedFile != null)
                      ? GestureDetector(
                          onTap: () {
                            if (crowdCount != null)
                              selectResult(context);
                            else
                              awes(context);
                          },
                          child: Container(
                            // Your styling and content for the Container
                            color: Colors
                                .white, // Placeholder color, adjust as needed
                            child: Center(
                              child: Icon(Icons.ads_click_outlined),
                            ),
                          ),
                        )*/ /*
 //selectResult(context) //this is edited
                       Container(
                         height: MediaQuery.of(context).size.height * 0.2,
                         color: Color(0xFF0C0908),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              MyCarouselSlider(),
                              SizedBox(
                                height: 80,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    children: [
                                      TextButton(
                                        onPressed: predicting
                                            ? null
                                            : () async {
                                                pickedFile = null;
                                                final result =
                                                    await imagePicker.pickImage(
                                                  source: ImageSource.camera,
                                                  imageQuality: 25,
                                                );
                                                if (result != null) {
                                                  pickedFile =
                                                      File(result.path);
                                                  setState(() {
                                                    predicting = true;
                                                  });
                                                  final bytes = await result
                                                      .readAsBytes()
                                                      .then((value) => value);
                                                  print(
                                                      'image path::::: ${(bytes.lengthInBytes / 1024) / 1024}');
                                                  await processImage(
                                                      imagePath: result.path);
                                                  setState(() {
                                                    predicting = false;
                                                  });
                                                }
                                              },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '  Camera',
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  color: Colors.white,
                                                  height: 1),
                                            ),
                                            SizedBox(width: 8.0),
                                            Icon(
                                              Icons.add_a_photo_outlined,
                                              color: Colors.white,
                                            ), // Add some spacing between icon and text
                                          ],
                                        ),
                                        style: TextButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(12),
                                          ),
                                          backgroundColor: HexColor('#D4246F'),
                                          // Set the button background color
                                          padding: EdgeInsets.all(
                                              16.0), // Set the padding
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      TextButton(
                                        onPressed: predicting
                                            ? null
                                            : () async {
                                                pickedFile = null;

                                                final result =
                                                    await imagePicker.pickImage(
                                                  source: ImageSource.gallery,
                                                );
                                                if (result != null) {
                                                  pickedFile =
                                                      File(result.path);
                                                  setState(() {
                                                    predicting = true;
                                                  });
                                                  await processImage(
                                                      imagePath: result.path);
                                                  setState(() {
                                                    predicting = false;
                                                  });
                                                }
                                              },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Gallery',
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  color: Colors.white,
                                                  height: 1),
                                            ),
                                            SizedBox(width: 17.0),
                                            Icon(
                                              Icons.photo,
                                              color: Colors.white,
                                            ),
                                          ],
                                        ),
                                        style: TextButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          backgroundColor: HexColor('#D4246F'),
                                          padding: EdgeInsets.all(
                                              16.0), // Set the padding
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
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
*/

/*
import 'dart:convert';
import 'dart:developer' as console;
import 'dart:io';
import 'dart:typed_data';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:object_detection/home/loading.dart';
import 'package:object_detection/home/process_image.dart';
import 'package:object_detection/home/slider.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final imagePicker = ImagePicker();

  Uint8List? image;

  File? pickedFile;

  bool predicting = false;

  int? crowdCount;

  void awes(BuildContext context) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.bottomSlide,
      isDense: false,
      //title: 'Error',
      desc: 'Oops! Cannot Shown Result!',
      btnOkOnPress: () {
        selectHome(context);
      },
      btnOkColor: Colors.blue,
    )..show();
  }

  void selectHome(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return HomeScreen();
        },
      ),
    );
  }

  selectResult(BuildContext context) {
    Future.delayed(Duration.zero, () {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) {
            return Result(crowdCount!, pickedFile!);
          },
        ),
      );
    });
  }

  Future<void> processImage({String? imagePath}) async {
    try {
      EasyLoading.show(status: 'Processing...');
      console.log('image path:: ${imagePath}');
      final imageBytes = File(imagePath!).readAsBytesSync();
      final base64Image = base64Encode(imageBytes);
      // Compress the image
      final compressedImageBytes = await compressImage(imageBytes);
      final base64CompressedImage = base64Encode(compressedImageBytes);
      final compressedBody = {
        'image': base64CompressedImage,
      };
      // final body = {
      //   'image': base64Image,
      // };
      final response = await http.post(
        Uri.parse(
          'http://44.204.156.228:5000/process_image',
        ),
        body: jsonEncode(compressedBody),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      print('RESPONSE:: ${response.body}');
      crowdCount = jsonDecode(response.body)['count'];
      setState(() {});
      EasyLoading.dismiss();
      selectResult(context);
    } catch (e) {
      console.log('AN ERROR OCCURED WHILE PROCESSING IMAGE:: $e');
      setState(() {
        predicting = false;
      });
      EasyLoading.showError(
          'Please check your internet connection and try again.');
    }
  }

  Future<Uint8List> compressImage(Uint8List imageBytes) async {
    img.Image? image = img.decodeImage(imageBytes);
    // Resize the image to a smaller size
    image = img.copyResize(image!,
        width: 800, height: 600, interpolation: img.Interpolation.linear);
    // Compress the image with a specific quality (adjust as needed)
    Uint8List compressedBytes =
        Uint8List.fromList(img.encodeJpg(image, quality: 70));
    return compressedBytes;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor('#D4246F'),
      */
/*appBar: AppBar(
        title: Center(
          child: Text(
            'crowd counting',
            style: GoogleFonts.aBeeZee(
              color: Colors.blue,
              letterSpacing: 1,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.3,
      ),
*/ /*

      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.06,
              color: HexColor('#D4246F'),
              child: Row(
                children: [
                  SizedBox(
                    width: 3,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Crowd Counting',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              //height: 60,
              //width: 400,
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: Container(
                color: HexColor('#C0C0C0'),
                //color: Colors.blue,//HexColor('#D4246F'),
                height: MediaQuery.of(context).size.height * 0.12,
                child: Column(
                  children: [
                    MyCarouselSlider(),
                    SizedBox(
                      height: 60,
                    ),
                    Column(
                      children: [
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  ElevatedButton(
                                    onPressed: () {},
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image(
                                          image: AssetImage(
                                              'assets/images/tutorial.png'),
                                          width: 45,
                                          height: 45,
                                        ),
                                        Text(
                                          'Tutorial',
                                          style: TextStyle(
                                              decorationThickness:
                                                  double.infinity,
                                              fontSize: 16.0,
                                              color: HexColor('#D4246F'),
                                              height: 1),
                                        ),
                                      ],
                                    ),
                                    style: TextButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        side: BorderSide(
                                          color: Colors.black38,
                                          // Set the border color
                                          width: 1.0, // Set the border width
                                        ),
                                      ),
                                      backgroundColor: Colors.white,
                                      elevation: 5,
                                      padding: EdgeInsets.all(
                                          18.0), // Set the padding
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Column(
                                children: [
                                  ElevatedButton(
                                    onPressed: () {},
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Image(
                                          image: AssetImage(
                                              'assets/images/about.png'),
                                          width: 40,
                                          height: 45,
                                        ),
                                        SizedBox(width: 26.0),
                                        Text(
                                          ' About ',
                                          style: TextStyle(
                                              decorationThickness:
                                                  double.infinity,
                                              fontSize: 16.0,
                                              color: HexColor('#D4246F'),
                                              height: 1),
                                        ),
                                        SizedBox(width: 8),
                                      ],
                                    ),
                                    style: TextButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        side: BorderSide(
                                          color: Colors.black38,
                                          // Set the border color
                                          width: 1.0, // Set the border width
                                        ),
                                      ),
                                      backgroundColor: Colors.white,
                                      elevation: 5,
                                      padding: EdgeInsets.all(
                                          18.0), // Set the padding
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              //color: Colors.blue,
              height: MediaQuery.of(context).size.height * 0.3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2.0),
                color: HexColor('#FFFFFF'),
                border: Border.all(
                  color: Colors.black,
                  width: 1.0,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 3.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Pick From',
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            ElevatedButton(
                              onPressed: predicting
                                  ? null
                                  : () async {
                                      pickedFile = null;
                                      final result =
                                          await imagePicker.pickImage(
                                        source: ImageSource.camera,
                                        imageQuality: 25,
                                      );
                                      if (result != null) {
                                        pickedFile = File(result.path);
                                        setState(() {
                                          predicting = true;
                                        });
                                        final bytes = await result
                                            .readAsBytes()
                                            .then((value) => value);
                                        print(
                                            'image path::::: ${(bytes.lengthInBytes / 1024) / 1024}');
                                        await processImage(
                                            imagePath: result.path);
                                        setState(() {
                                          predicting = false;
                                        });
                                      }
                                    },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image(
                                    image: AssetImage(
                                        'assets/images/camera_icon.png'),
                                    width: 45,
                                    height: 45,
                                  ),
                                  SizedBox(width: 8.0),
                                  Text(
                                    'Camera',
                                    style: TextStyle(
                                        decorationThickness: double.infinity,
                                        fontSize: 16.0,
                                        color: HexColor('#D4246F'),
                                        height: 1),
                                  ),
                                ],
                              ),
                              style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: BorderSide(
                                    color: Colors.black12,
                                    width: 1.0, // Set the border width
                                  ),
                                ),
                                elevation: 5,
                                backgroundColor: Colors.white,
                                padding: EdgeInsets.all(6.0), // Set the padding
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Column(
                          children: [
                            ElevatedButton(
                              onPressed: predicting
                                  ? null
                                  : () async {
                                      pickedFile = null;

                                      final result =
                                          await imagePicker.pickImage(
                                        source: ImageSource.gallery,
                                      );
                                      if (result != null) {
                                        pickedFile = File(result.path);
                                        setState(() {
                                          predicting = true;
                                        });
                                        await processImage(
                                            imagePath: result.path);
                                        setState(() {
                                          predicting = false;
                                        });
                                      }
                                    },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Image(
                                    image: AssetImage(
                                        'assets/images/gallery_icon.png'),
                                    width: 30,
                                    height: 45,
                                  ),
                                  SizedBox(width: 20.0),
                                  Text(
                                    'Gallery',
                                    style: TextStyle(
                                        decorationThickness: double.infinity,
                                        fontSize: 16.0,
                                        color: HexColor('#D4246F'),
                                        height: 1),
                                  ),
                                  SizedBox(width: 8),
                                ],
                              ),
                              style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: BorderSide(
                                    color: Colors.black12,
                                    width: 1.0, // Set the border width
                                  ),
                                ),
                                elevation: 5,
                                backgroundColor: Colors.white,
                                padding: EdgeInsets.all(6.0), // Set the padding
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 12,
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
*/

//----the above code comment last time for multiple api requests-----//

import 'dart:async';
import 'dart:convert';
import 'dart:developer' as console;
import 'dart:io';
import 'dart:typed_data';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:crowd_counting_app/home/process_image.dart';
import 'package:crowd_counting_app/home/slider.dart';
import 'package:crowd_counting_app/home/tutorial_page.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:path_provider/path_provider.dart';

import 'about.dart';

/*
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final imagePicker = ImagePicker();

  Uint8List? image;

  File? pickedFile;

  bool predicting = false;

  int? crowdCount;

  void awes(BuildContext context) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.bottomSlide,
      isDense: false,
      //title: 'Error',
      desc: 'Oops! Cannot Shown Result!',
      btnOkOnPress: () {
        selectHome(context);
      },
      btnOkColor: Colors.blue,
    )..show();
  }

  void selectHome(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return HomeScreen();
        },
      ),
    );
  }


  selectResult(BuildContext context) {
    if (crowdCount != null && pickedFile != null) {
      print('crowdCount: $crowdCount');
      print('pickedFile: $pickedFile');

      Future.delayed(Duration.zero, () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) {
              print('Navigating to Result widget');
              return Result(crowdCount!, pickedFile!);
            },
          ),
        );
      });
    } else {
      // Handle the case when crowdCount or pickedFile is null
      print('crowdCount or pickedFile is null');
    }
  }


  Future<void> processImage({String? imagePath}) async {
    try {
      if (imagePath == null) {
        EasyLoading.showError('Invalid image path.');
        return;
      }

      EasyLoading.show(status: 'Processing...');
      print('image path:: ${imagePath}');

      final File imageFile = File(imagePath);
      final List<int> imageBytes = await imageFile.readAsBytes();

      final compressedImageBytes = await compressImage(Uint8List.fromList(imageBytes));
      final base64CompressedImage = base64Encode(compressedImageBytes);
      final compressedBody = {'image': base64CompressedImage};

      final List<Future<http.Response>> futures = [];

      final int numberOfRequests = 2;

      for (int i = 0; i < numberOfRequests; i++) {
        final Map<String, dynamic> compressedBody = {'image': base64CompressedImage};
        futures.add(_makeApiRequest(Uri.parse('http://192.168.1.9:5000/process_image'), compressedBody));
      }

      final List<http.Response> responses = [];

      await Future.forEach(futures, (Future<http.Response> future) async {
        try {
          final response = await future;
          responses.add(response);
        } catch (e) {
          print('Error in API request: $e');
          // Handle the error for this specific request if needed
        }
      });

      for (final response in responses) {
        print('RESPONSE:: ${response.body}');
        if (response.statusCode == 200) {
          final jsonResponse = jsonDecode(response.body);
          if (jsonResponse.containsKey('count')) {
            crowdCount = jsonResponse['count'];
            setState(() {});
          } else if (jsonResponse.containsKey('error')) {
            EasyLoading.showError('API error: ${jsonResponse['error']}');
          } else {
            EasyLoading.showError('Unexpected API response format.');
          }
        } else {
          EasyLoading.showError('Failed to process image. Please try again.');
        }
      }

      EasyLoading.dismiss();
      selectResult(context);
    } catch (e) {
      print('AN ERROR OCCURRED WHILE PROCESSING IMAGE:: $e');
      setState(() {
        predicting = false;
      });
      EasyLoading.showError('Please check your internet connection and try again.');
    }
  }

  Future<http.Response> _makeApiRequest(Uri uri, Map<String, dynamic> body) async {
    final response = await http.post(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );
    return response;
  }

  Future<Uint8List> compressImage(Uint8List imageBytes) async {
    img.Image? image = img.decodeImage(imageBytes);
    // Resize the image to a smaller size
    image = img.copyResize(image!,
        width: 800, height: 600, interpolation: img.Interpolation.linear);
    // Compress the image with a specific quality (adjust as needed)
    Uint8List compressedBytes =
    Uint8List.fromList(img.encodeJpg(image, quality: 70));
    return compressedBytes;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: HexColor('#D4246F'),
*/
/*appBar: AppBar(
        title: Center(
          child: Text(
            'crowd counting',
            style: GoogleFonts.aBeeZee(
              color: Colors.blue,
              letterSpacing: 1,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.3,
      ),
*/ /*


      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.06,
              color: HexColor('#D4246F'),
              child: Row(
                children: [
                  SizedBox(
                    width: 3,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Crowd Counting',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              //height: 60,
              //width: 400,
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: Container(
                color: HexColor('#C0C0C0'),
                //color: Colors.blue,//HexColor('#D4246F'),
                height: MediaQuery.of(context).size.height * 0.12,
                child: Column(
                  children: [
                    MyCarouselSlider(),
                    SizedBox(
                      height: 60,
                    ),
                    Column(
                      children: [
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  ElevatedButton(
                                    onPressed: () {},
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image(
                                          image: AssetImage(
                                              'assets/images/tutorial.png'),
                                          width: 45,
                                          height: 45,
                                        ),
                                        Text(
                                          'Tutorial',
                                          style: TextStyle(
                                              decorationThickness:
                                                  double.infinity,
                                              fontSize: 16.0,
                                              color: HexColor('#D4246F'),
                                              height: 1),
                                        ),
                                      ],
                                    ),
                                    style: TextButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        side: BorderSide(
                                          color: Colors.black38,
                                          // Set the border color
                                          width: 1.0, // Set the border width
                                        ),
                                      ),
                                      backgroundColor: Colors.white,
                                      elevation: 5,
                                      padding: EdgeInsets.all(
                                          18.0), // Set the padding
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Column(
                                children: [
                                  ElevatedButton(
                                    onPressed: () {},
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Image(
                                          image: AssetImage(
                                              'assets/images/about.png'),
                                          width: 40,
                                          height: 45,
                                        ),
                                        SizedBox(width: 26.0),
                                        Text(
                                          ' About ',
                                          style: TextStyle(
                                              decorationThickness:
                                                  double.infinity,
                                              fontSize: 16.0,
                                              color: HexColor('#D4246F'),
                                              height: 1),
                                        ),
                                        SizedBox(width: 8),
                                      ],
                                    ),
                                    style: TextButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        side: BorderSide(
                                          color: Colors.black38,
                                          // Set the border color
                                          width: 1.0, // Set the border width
                                        ),
                                      ),
                                      backgroundColor: Colors.white,
                                      elevation: 5,
                                      padding: EdgeInsets.all(
                                          18.0), // Set the padding
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              //color: Colors.blue,
              height: MediaQuery.of(context).size.height * 0.3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2.0),
                color: HexColor('#FFFFFF'),
                border: Border.all(
                  color: Colors.black,
                  width: 1.0,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 3.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Pick From',
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            ElevatedButton(
                              onPressed: predicting
                                  ? null
                                  : () async {
                                      pickedFile = null;
                                      final result =
                                          await imagePicker.pickImage(
                                        source: ImageSource.camera,
                                        imageQuality: 25,
                                      );
                                      if (result != null) {
                                        pickedFile = File(result.path);
                                        setState(() {
                                          predicting = true;
                                        });
                                        final bytes = await result
                                            .readAsBytes()
                                            .then((value) => value);
                                        print(
                                            'image path::::: ${(bytes.lengthInBytes / 1024) / 1024}');
                                        await processImage(
                                            imagePath: result.path);
                                        setState(() {
                                          predicting = false;
                                        });
                                      }
                                    },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image(
                                    image: AssetImage(
                                        'assets/images/camera_icon.png'),
                                    width: 45,
                                    height: 45,
                                  ),
                                  SizedBox(width: 8.0),
                                  Text(
                                    'Camera',
                                    style: TextStyle(
                                        decorationThickness: double.infinity,
                                        fontSize: 16.0,
                                        color: HexColor('#D4246F'),
                                        height: 1),
                                  ),
                                ],
                              ),
                              style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: BorderSide(
                                    color: Colors.black12,
                                    width: 1.0, // Set the border width
                                  ),
                                ),
                                elevation: 5,
                                backgroundColor: Colors.white,
                                padding: EdgeInsets.all(6.0), // Set the padding
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Column(
                          children: [
                            ElevatedButton(
                              onPressed: predicting
                                  ? null
                                  : () async {
                                      pickedFile = null;

                                      final result =
                                          await imagePicker.pickImage(
                                        source: ImageSource.gallery,
                                      );
                                      if (result != null) {
                                        pickedFile = File(result.path);
                                        setState(() {
                                          predicting = true;
                                        });
                                        await processImage(
                                            imagePath: result.path);
                                        setState(() {
                                          predicting = false;
                                        });
                                      }
                                    },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Image(
                                    image: AssetImage(
                                        'assets/images/gallery_icon.png'),
                                    width: 30,
                                    height: 45,
                                  ),
                                  SizedBox(width: 20.0),
                                  Text(
                                    'Gallery',
                                    style: TextStyle(
                                        decorationThickness: double.infinity,
                                        fontSize: 16.0,
                                        color: HexColor('#D4246F'),
                                        height: 1),
                                  ),
                                  SizedBox(width: 8),
                                ],
                              ),
                              style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: BorderSide(
                                    color: Colors.black12,
                                    width: 1.0, // Set the border width
                                  ),
                                ),
                                elevation: 5,
                                backgroundColor: Colors.white,
                                padding: EdgeInsets.all(6.0), // Set the padding
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 12,
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
*/

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final imagePicker = ImagePicker();

  Uint8List? image;

  File? pickedFile;

  bool predicting = false;

  int? crowdCount;

  void selectHome(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return HomeScreen();
        },
      ),
    );
  }

  void aboutScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return About();
        },
      ),
    );
  }

  void tutorialPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return TutorialPage();
        },
      ),
    );
  }

  selectResult(BuildContext context) {
    if (crowdCount != null && pickedFile != null) {
      print('crowdCount: $crowdCount');
      print('pickedFile: $pickedFile');

      Future.delayed(Duration.zero, () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) {
              print('Navigating to Result widget');
              return Result(crowdCount!, pickedFile!);
            },
          ),
        );
      });
    } else {
      // Handle the case when crowdCount or pickedFile is null
      print('crowdCount or pickedFile is null');
    }
  }

  Future<void> processImage({String? imagePath}) async {
    try {
      EasyLoading.show(status: 'Processing...');
      console.log('image path:: ${imagePath}');
      final imageBytes = File(imagePath!).readAsBytesSync();
      final base64Image = base64Encode(imageBytes);
      final compressedImageBytes = await compressImage(imageBytes);
      final base64CompressedImage = base64Encode(compressedImageBytes);
      final compressedBody = {
        'image': base64CompressedImage,
      };
      // final body = {
      //   'image': base64Image,
      // };
      final response = await http.post(
        Uri.parse(
          'http://44.204.156.228:5000/process_image',
          //'http://192.168.109.177:5000/process_image',
        ),
        body: jsonEncode(compressedBody),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      print('RESPONSE:: ${response.body}');
      crowdCount = jsonDecode(response.body)['count'];
      setState(() {});
      EasyLoading.dismiss();
      selectResult(context);
    } catch (e) {
      console.log('AN ERROR OCCURED WHILE PROCESSING IMAGE:: $e');
      setState(() {
        predicting = false;
      });
      EasyLoading.showError(
          'Please check your internet connection and try again.');
    }
  }

  Future<Uint8List> compressImage(Uint8List imageBytes) async {
    img.Image? image = img.decodeImage(imageBytes);
    // Resize the image to a smaller size
    image = img.copyResize(image!,
        width: 800, height: 600, interpolation: img.Interpolation.linear);
    // Compress the image with a specific quality (adjust as needed)
    Uint8List compressedBytes =
        Uint8List.fromList(img.encodeJpg(image, quality: 70));
    return compressedBytes;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Show the confirmation dialog every time the user tries to exit
        return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Do you want to exit the app?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('Yes'),
              ),
            ],
          ),
        ) ?? false;
      },
      child: Scaffold(
        //backgroundColor: HexColor('#D4246F'),
        appBar: AppBar(
          title: Center(
            child: Text(
              'crowd counting',
              style: GoogleFonts.aBeeZee(
                color: Colors.white,
                letterSpacing: 1,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          backgroundColor: HexColor('#D4246F'),
          elevation: 0.3,
        ),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  color: Colors.black12,
                  //color: Colors.blue,//HexColor('#D4246F'),
                  height: MediaQuery.of(context).size.height * 0.12,
                  child: Column(
                    children: [
                      MyCarouselSlider(),
                      SizedBox(
                        height: 62,
                      ),
                      Column(
                        children: [
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        tutorialPage(context);
                                      },
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image(
                                            image: AssetImage(
                                                'assets/images/tutorial.png'),
                                            width: 35,
                                            height: 45,
                                          ),
                                          Text(
                                            ' Usage ',
                                            style: TextStyle(
                                                decorationThickness:
                                                    double.infinity,
                                                fontSize: 16.0,
                                                color: HexColor('#D4246F'),
                                                height: 1),
                                          ),
                                        ],
                                      ),
                                      style: TextButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          side: BorderSide(
                                            color: Colors.black38,
                                            // Set the border color
                                            width: 1.0, // Set the border width
                                          ),
                                        ),
                                        backgroundColor: Colors.white,
                                        elevation: 5,
                                        padding: EdgeInsets.all(
                                            18.0), // Set the padding
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Column(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        aboutScreen(context);
                                      },
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Image(
                                            image: AssetImage(
                                                'assets/images/about.png'),
                                            width: 40,
                                            height: 45,
                                          ),
                                          SizedBox(width: 26.0),
                                          Text(
                                            ' About ',
                                            style: TextStyle(
                                                decorationThickness:
                                                    double.infinity,
                                                fontSize: 16.0,
                                                color: HexColor('#D4246F'),
                                                height: 1),
                                          ),
                                          SizedBox(width: 8),
                                        ],
                                      ),
                                      style: TextButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          side: BorderSide(
                                            color: Colors.black38,
                                            // Set the border color
                                            width: 1.0, // Set the border width
                                          ),
                                        ),
                                        backgroundColor: Colors.white,
                                        elevation: 5,
                                        padding: EdgeInsets.all(
                                            18.0), // Set the padding
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                //color: Colors.blue,
                height: MediaQuery.of(context).size.height * 0.3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: HexColor('#FFFFFF'),
                  border: Border.all(
                    color: Colors.black,
                    width: 1.0,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 3.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Pick From',
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              ElevatedButton(
                                onPressed: predicting
                                    ? null
                                    : () async {
                                        pickedFile = null;
                                        final result =
                                            await imagePicker.pickImage(
                                          source: ImageSource.camera,
                                          imageQuality: 25,
                                        );
                                        if (result != null) {
                                          pickedFile = File(result.path);
                                          setState(() {
                                            predicting = true;
                                          });
                                          final bytes = await result
                                              .readAsBytes()
                                              .then((value) => value);
                                          print(
                                              'image path::::: ${(bytes.lengthInBytes / 1024) / 1024}');
                                          await processImage(
                                              imagePath: result.path);
                                          setState(() {
                                            predicting = false;
                                          });
                                        }
                                      },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image(
                                      image: AssetImage(
                                          'assets/images/camera_icon.png'),
                                      width: 45,
                                      height: 45,
                                    ),
                                    SizedBox(width: 8.0),
                                    Text(
                                      'Camera',
                                      style: TextStyle(
                                          decorationThickness: double.infinity,
                                          fontSize: 16.0,
                                          color: HexColor('#D4246F'),
                                          height: 1),
                                    ),
                                  ],
                                ),
                                style: TextButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: BorderSide(
                                      color: Colors.black12,
                                      width: 1.0, // Set the border width
                                    ),
                                  ),
                                  elevation: 5,
                                  backgroundColor: Colors.white,
                                  padding:
                                      EdgeInsets.all(6.0), // Set the padding
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Column(
                            children: [
                              ElevatedButton(
                                onPressed: predicting
                                    ? null
                                    : () async {
                                        pickedFile = null;

                                        final result =
                                            await imagePicker.pickImage(
                                          source: ImageSource.gallery,
                                        );
                                        if (result != null) {
                                          pickedFile = File(result.path);
                                          setState(() {
                                            predicting = true;
                                          });
                                          await processImage(
                                              imagePath: result.path);
                                          setState(() {
                                            predicting = false;
                                          });
                                        }
                                      },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Image(
                                      image: AssetImage(
                                          'assets/images/gallery_icon.png'),
                                      width: 30,
                                      height: 45,
                                    ),
                                    SizedBox(width: 20.0),
                                    Text(
                                      'Gallery',
                                      style: TextStyle(
                                          decorationThickness: double.infinity,
                                          fontSize: 16.0,
                                          color: HexColor('#D4246F'),
                                          height: 1),
                                    ),
                                    SizedBox(width: 8),
                                  ],
                                ),
                                style: TextButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: BorderSide(
                                      color: Colors.black12,
                                      width: 1.0, // Set the border width
                                    ),
                                  ),
                                  elevation: 5,
                                  backgroundColor: Colors.white,
                                  padding:
                                      EdgeInsets.all(6.0), // Set the padding
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 12,
                      ),
                    ],
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
