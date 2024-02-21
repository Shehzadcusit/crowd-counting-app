import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/bindings/home_bindings.dart';
import '../home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({required Key key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(seconds: 2), () {
        Get.off(() => HomeScreen(), binding: HomeBindings());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly, // <-- SEE HERE
          children: [
            Image.asset('assets/images/crowdlogo.png',),
            CircularProgressIndicator(color: Color.fromRGBO(0, 77, 64,1)),
          ],
    ),


    /*Center(
              child: Image.asset('assets/images/crowdlogo.png',),
              //Lottie.asset('assets/animations/animation_lm3r0kos.json'),
            ),*/
    //CircularProgressIndicator(color: Colors.yellow),
    );
  }
}






