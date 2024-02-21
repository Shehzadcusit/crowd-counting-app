import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:hexcolor/hexcolor.dart';

class MyCarouselSlider extends StatefulWidget {
  @override
  _MyCarouselSliderState createState() => _MyCarouselSliderState();
}

class _MyCarouselSliderState extends State<MyCarouselSlider> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          items: [
            Card(
              color: Colors.white,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: InkWell(
                splashColor: Colors.pink.withAlpha(50),
                onTap: () {
                  debugPrint('Card tapped.');
                },
                child: ClipPath(
                  clipper: CardClipper(),
                  child: Container(
                    width: 330,
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFFD4246F),
                          Color(0xFF922D50),
                          Color(0xFF511327),
                        ],
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Image.asset(
                            'assets/images/design_home.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            // Darker overlay
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome to',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Crowd Counting App',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 28,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Click One Shot to Find Crowd Count',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                    size: 40,
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
            ),
            /*Container(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.asset('assets/images/hbd_banner.png',
                    width: 330, fit: BoxFit.fill),
              ),
            ),
            Container(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.asset('assets/images/hbd_banner.png',
                    width: 330, fit: BoxFit.fill),
              ),
            ),
            Container(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.asset('assets/images/hbd_banner.png',
                    width: 330, fit: BoxFit.fill),
              ),
            ),*/
          ],
          options: CarouselOptions(
            height: 210.0,
            autoPlay: false,
            autoPlayInterval: Duration(seconds: 4),
            autoPlayAnimationDuration: Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            aspectRatio: double.infinity,
            viewportFraction: 0.99,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
                print('Page changed to index $index, reason: $reason');
              });
            },
          ),
        ),
        /*DotsIndicator(
          dotsCount: 1,
          position: _currentIndex,
          decorator: DotsDecorator(
            color: Colors.black12,
            activeColor: Color.fromRGBO(0, 77, 64, 6),
            spacing: EdgeInsets.all(2.0),
            size: Size.square(5.0),
            activeSize: Size.square(5.0),
          ),*/
      ],
    );
  }
}

class CardClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final radius = 15.0;

    path.moveTo(radius, 0);
    path.lineTo(size.width - radius, 0);
    path.quadraticBezierTo(size.width, 0, size.width, radius);
    path.lineTo(size.width, size.height - radius);
    path.quadraticBezierTo(
        size.width, size.height, size.width - radius, size.height);
    path.lineTo(radius, size.height);
    path.quadraticBezierTo(0, size.height, 0, size.height - radius);
    path.lineTo(0, radius);
    path.quadraticBezierTo(0, 0, radius, 0);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
