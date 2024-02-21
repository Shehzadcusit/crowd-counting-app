import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';

class Result extends StatefulWidget {
  final File pickedFile;
  final int crowdCount;

  Result(this.crowdCount, this.pickedFile);

  @override
  _ResultState createState() => _ResultState();
}

class _ResultState extends State<Result> {
  final GlobalKey _stackKey = GlobalKey();

  late final File pickedFile;
  late final int crowdCount;

  Future<void> saveImageToGallery() async {
    try {
      RenderRepaintBoundary? boundary = _stackKey.currentContext
          ?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary != null) {
        ui.Image image = await boundary.toImage(pixelRatio: 3.0);
        ByteData? byteData =
            await image.toByteData(format: ui.ImageByteFormat.png);
        Uint8List? uint8List = byteData?.buffer.asUint8List();

        if (uint8List != null) {
          final directory = await getTemporaryDirectory();
          final path = '${directory.path}/result_image.png';

          File(path).writeAsBytesSync(uint8List);

          final result = await ImageGallerySaver.saveFile(path);

          if (result != null && result.isNotEmpty) {
            showToast("Image saved successfully");
          } else {
            print("Error: Failed to save image");
          }
        } else {
          print("Error: ByteData is null");
        }
      } else {
        print("Error: RenderRepaintBoundary is null");
      }
    } catch (e) {
      print("Error saving image to gallery: $e");
    }
  }

  Future<void> shareImage() async {
    try {
      RenderRepaintBoundary? boundary = _stackKey.currentContext
          ?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary != null) {
        ui.Image image = await boundary.toImage(pixelRatio: 3.0);
        ByteData? byteData =
            await image.toByteData(format: ui.ImageByteFormat.png);
        Uint8List? uint8List = byteData?.buffer.asUint8List();

        if (uint8List != null) {
          final directory = await getTemporaryDirectory();
          final path = '${directory.path}/result_image.png';

          File(path).writeAsBytesSync(uint8List);

          Share.shareFiles([path], text: 'Check out this image!');
        } else {
          print("Error: ByteData is null");
        }
      } else {
        print("Error: RenderRepaintBoundary is null");
      }
    } catch (e) {
      print("Error sharing image: $e");
    }
  }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: Colors.white,
      textColor: Colors.black,
    );
  }

  @override
  void initState() {
    super.initState();
    pickedFile = widget.pickedFile;
    crowdCount = widget.crowdCount;
  }

  Future<ui.Image> getImageDimensions(File imageFile) async {
    final data = await imageFile.readAsBytes();
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(Uint8List.fromList(data), (ui.Image img) {
      completer.complete(img);
    });
    return completer.future;
  }

  String getImageDimensionMessage(ui.Image image) {
    if (image.width > 1000 && image.height > 1000) {
      return 'High resolution image';
    } else {
      return 'Standard resolution image';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Result',
          style: GoogleFonts.aBeeZee(
            color: Colors.white,
            letterSpacing: 1,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: HexColor('#D4246F'),
        elevation: 0.3,
        centerTitle: true,
        leadingWidth: 60,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.save,
              color: Colors.white,
            ),
            onPressed: () {
              saveImageToGallery();
            },
          ),
          IconButton(
            icon: Icon(
              Icons.share,
              color: Colors.white,
            ),
            onPressed: () {
              shareImage();
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: RepaintBoundary(
        key: _stackKey,
        child: Container(
          child: Stack(
            children: [
              if (pickedFile != null && pickedFile.existsSync()) ...[
                FutureBuilder<ui.Image>(
                  future: getImageDimensions(pickedFile),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.hasData) {
                      ui.Image image = snapshot.data!;
                      String dimensionMessage = getImageDimensionMessage(image);
                      // Display different content based on image dimensions
                      if (image.width > 2 && image.height > 4) {
                        return Stack(
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height *0.9, // Full screen height
                              child: Align(
                                alignment: Alignment.center,
                                child: Image.file(
                                  pickedFile,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            if (crowdCount != null)
                              Positioned(
                                bottom: 40.0,
                                left: 85.0,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10.0,
                                    vertical: 5.0,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black45,
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Text(
                                    'Crowd count: $crowdCount',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 20.0,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        );
                      } /*else if (image.width > 64400 && image.height > 62000) {
                        return Stack(
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height *
                                  0.7, // Full screen height
                              child: Align(
                                alignment: Alignment.center,
                                child: Image.file(
                                  pickedFile,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            if (crowdCount != null)
                              Positioned(
                                bottom: 200.0,
                                left: 120.0,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10.0,
                                    vertical: 5.0,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black45,
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Text(
                                    'Crowd count: $crowdCount',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        );
                      } else if (image.width > 61200 && image.height > 6900) {
                        return Stack(
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height *
                                  0.7, // Full screen height
                              child: Align(
                                alignment: Alignment.center,
                                child: Image.file(
                                  pickedFile,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            if (crowdCount != null)
                              Positioned(
                                bottom: 145.0,
                                left: 115.0,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10.0,
                                    vertical: 5.0,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black45,
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Text(
                                    'Crowd count: $crowdCount',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        );
                      } else if (image.width > 6000 && image.height > 6000) {
                        return Stack(
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height *
                                  0.7, // Full screen height
                              child: Align(
                                alignment: Alignment.center,
                                child: Image.file(
                                  pickedFile,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            if (crowdCount != null)
                              Positioned(
                                bottom: 100.0,
                                left: 120.0,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10.0,
                                    vertical: 5.0,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black45,
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Text(
                                    'Crowd count: $crowdCount',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        );*/
                       else {
                        return Container(
                          height: MediaQuery.of(context)
                              .size
                              .height, // Full screen height
                          child: Center(
                            child: Text(
                              'Image dimensions do not meet the criteria for display',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        );
                      }
                    } else {
                      return Container();
                    }
                  },
                ),
              ] else ...[
                Center(
                  child: Text(
                    'Invalid or missing image file',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
