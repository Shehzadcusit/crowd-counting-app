/*
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 100, // Adjust the top position as needed
      left: (MediaQuery.of(context).size.width - 250) / 2, // Center the widget
      child: Container(
        height: 150, // Set the desired height
        width: 250,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min, // Set to minimize the size of the Column
            children: [
              SpinKitCircle(
                color: HexColor('#D4246F'),
                size: 40.0,
              ),
              const SizedBox(height: 12.0),
              Text(
                'Processing...',
                style: GoogleFonts.amiko(
                  color: HexColor('#D4246F'),
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*//*


import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () {
          debugPrint('Card tapped.');
        },
        child: const SizedBox(
          width: 300,
          height: 100,
          child: Text('Political Campaigns',
              style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
    );

    */
/*Positioned(
      top: 100, // Adjust the top position as needed
      left: (MediaQuery.of(context).size.width - 250) / 2, // Center the widget
      child: Card(
        elevation: 5.0, // Adjust the elevation as needed
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          height: 150, // Set the desired height
          width: 250,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min, // Set to minimize the size of the Column
              children: [
                SpinKitCircle(
                  color: HexColor('#D4246F'),
                  size: 40.0,
                ),
                const SizedBox(height: 12.0),
                Text(
                  'Processing...',
                  style: GoogleFonts.amiko(
                    color: HexColor('#D4246F'),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );*//*

  }
}
*/
