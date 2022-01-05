import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:payments/Helpers/constants.dart';


class BackGround extends StatelessWidget {
  final Widget child;
  final String title;
  const BackGround({ required this.child, required this.title});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AnimatedContainer(
      duration: Duration(milliseconds: 0),
      width: size.width,
      height: size.height,
      child: Stack(
        children: [
          Positioned(
            left: size.width * 0.1,
            bottom:size.height * 0.85,
            child: Text(
              title,
              style: TxtStls.titlestl,
            ),
          ),
          Positioned(
            child: Image.asset(
              "assets/images/top1.png",
              fit: BoxFit.fill,
            ),
            top: 0,
            right: 0,
          ),
          Positioned(
            child: Image.asset("assets/images/top2.png", fit: BoxFit.fill),
            top: 0,
            right: 0,
          ),
          Positioned(
            child: Image.asset("assets/images/bottom1.png", fit: BoxFit.fill),
            bottom: 0,
            right: 0,
          ),
          Positioned(
            child: Image.asset("assets/images/bottom2.png", fit: BoxFit.fill),
            bottom: 0,
            right: 0,
          ),
          child
        ],
      ),
    );
  }
}