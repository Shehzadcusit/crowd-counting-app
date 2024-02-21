import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LiveDetectionPreview extends StatefulWidget {
  @override
  _LiveDetectionPreviewState createState() => _LiveDetectionPreviewState();
}

class _LiveDetectionPreviewState extends State<LiveDetectionPreview>
    with WidgetsBindingObserver {
  /// List of available cameras
  late List<CameraDescription> cameras;

  /// Controller
  late CameraController cameraController;

  /// true when inference is ongoing
  late bool predicting;

  bool isCameraControllerInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await initializeCamera();
    });
  }

  /// Initializes the camera by setting [cameraController]
  Future<void> initializeCamera() async {
    cameras = await availableCameras();

    // cameras[0] for rear-camera
    cameraController =
        CameraController(cameras[0], ResolutionPreset.low, enableAudio: false);

    cameraController.initialize();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    log('CAMERA CONTROLLER :: ${cameraController}');
    // Return empty container while the camera is not initialized

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF0C0908),
          title: Text('Live Detection'),
          centerTitle: true,
        ),
        body:
            (cameraController == null || !cameraController.value.isInitialized)
                ? Center(
                    child: LoadingAnimationWidget.flickr(
                        leftDotColor: Color(0xFF0C0908),
                        rightDotColor: Colors.grey,
                        size: 70.0),
                  )
                : Stack(
                    children: [
                      AspectRatio(
                        aspectRatio: 1 / cameraController.value.aspectRatio,
                        child: CameraPreview(cameraController),
                      ),
                      // Stats
                      _statsWidget(),
                    ],
                  ));
  }

  Widget _statsWidget() => Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          color: Colors.white.withAlpha(150),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Conversion Time:'),
                  Text('80'),
                  // Text(controller.conversionTime.toString()),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Inference Time:'),
                  Text('49'),
                  // Text(controller.inferenceTime.toString()),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total Prediction Time:'),
                  Text('195'),
                  // Text(
                  //     controller.totalPredictTime.toString()),
                ],
              ),
              const SizedBox(height: 12.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Classification Result: ',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'vhigh'.toUpperCase(),
                    style: GoogleFonts.poppins(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ]),
          ),
        ),
      );

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.paused:
        cameraController.stopImageStream();
        break;
      case AppLifecycleState.resumed:
        if (!cameraController.value.isStreamingImages) {
          //TODO: Frame by Frame image logic
        }
        break;
      default:
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    cameraController.dispose();
    super.dispose();
  }
}
