import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class KinematicsAnimation extends StatefulWidget {

  final Function(bool isDisposed)? update;
  final double velocityX;
  final double velocityY;
  final double height;
  final double factor;

  const KinematicsAnimation({
    Key? key,
    this.velocityX = 0.0,
    this.velocityY = 0.0,
    this.height = 0.0,
    this.factor = 100, 
    this.update,
  }) : super(key: key);


  @override
  KinematicsAnimationState createState() => KinematicsAnimationState();


}

class KinematicsAnimationState extends State<KinematicsAnimation>
    with SingleTickerProviderStateMixin {

  late AnimationController controller;
  double animationPercent = 0.0;

  final bolitaFileName = "assets/Bolita.svg";

  late double positionX;
  late double positionY;
  double gravity = -9.81;
  double time = 0;
  double magVelocity = 0.0;
  
   
  // double _round(double value, int decimals) {
  //   num fac = pow(10, decimals);
  //   return (value * fac).round() / fac;
  // }

  @override
  void initState() {
    super.initState();
    double velocityX = widget.velocityX;
    double velocityY = widget.velocityY;
    double height = widget.height;
    positionX = 0;
    positionY = 0;

    controller = AnimationController(
        duration: Duration(
            microseconds:
                (_getTotalTime(velocityY, height, gravity) * 1000000).toInt()),
        vsync: this
    );
    
    controller.addListener(() {
      setState(() {
        widget.update!(false);
        
      });

      time = controller.duration!.inMicroseconds * controller.value * (1 / 1000000);
      positionX = widget.factor * velocityX * time;
      positionY = widget.factor * ((velocityY * time) + ((1 / 2) * gravity * pow(time, 2)));

      // magVelocity = _round(
      //  sqrt(pow(velocityX, 2) + pow(velocityY + (gravity * time), 2)), 2);

    });
  }



  @override
  Widget build(BuildContext context) {
    print("build");
    return AnimatedBuilder(
      animation: controller,
      child: Stack(
        children: [
          SizedBox(
            width: 0.25 * widget.factor + 2,
            height: 0.25 * widget.factor + 2,
          ),
          Positioned(
            top: 2,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(
                tileMode:  TileMode.decal,
                sigmaX: 1.0,
                sigmaY: 1.0,
              
              ),
              child: SvgPicture.asset(
                bolitaFileName,
                width: 0.25 * widget.factor,
                color: Colors.black.withOpacity(0.25)
              ),
            ),
          ),
          Positioned(
            left: 2,
            child: SvgPicture.asset(
              bolitaFileName,
              width: 0.25 * widget.factor,
            ),
          ),
        ],
      ),
      builder: (BuildContext context, Widget? child)  {
        return Transform.translate(
          offset: Offset(positionX, -positionY),
          child: child,
        );
      }
    );
  }


  double _getTotalTime(double velocityY, double height, double gravity) =>
      (-sqrt(pow(velocityY, 2) + (2 * gravity * -height)) - velocityY) /
      gravity;



  @override
  void dispose() {
    if (!(widget.velocityX == 0.0 && widget.velocityY == 0.0)) {
      widget.update!(true);
      
    }
    controller.dispose();
    super.dispose();
  }
}
