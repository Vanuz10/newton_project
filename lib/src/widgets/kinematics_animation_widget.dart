import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class KinematicsAnimation extends StatefulWidget {
  // final String playerControl;
  // final double animationPercent;
  final Function(bool isDisposed)? update;
  final double velocityX;
  final double velocityY;
  final double height;
  final double factor;

  const KinematicsAnimation({
    Key? key,
    // this.playerControl,
    // this.animationPercent,
    this.velocityX = 0.0,
    this.velocityY = 0.0,
    this.height = 0.0,
    this.factor = 100, 
    this.update,
  }) : super(key: key);


  // double _animationPercentListeneable;
  // set animationPercentListeneable(double animationPercentListeneable){
  //   this._animationPercentListeneable = animationPercentListeneable;
  // }
  // double get animationPercentListeneable => this._animationPercentListeneable;

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


  // @override
  // void deactivate(){
  //   super.deactivate();
  //   controller.stop();

  // }


  


  // woo() {

  //   switch (widget.playerControl) {
  //     case "play":
  //       controller.forward();
  //       break;
  //     case "pause":
  //       // controller.value = widget.valuePercent;
  //       controller.stop();
  //       break;
  //     case "reset":
  //       controller.animateTo(0.0, duration: Duration(milliseconds: 1));
  //       break;
  //     default:
  //   }
  
  // }

  @override
  Widget build(BuildContext context) {
    

    // woo();

    return AnimatedBuilder(
      animation: controller,
      child: 
      // Row(
      //   children: <Widget>[
          Stack(
            children: [
              SizedBox(
                // color:Colors.yellow,
                width: 0.25 * widget.factor + 2,
                height: 0.25 * widget.factor + 2,
              ),
              Positioned(
                left: 2,
                top: 2,
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(
                    sigmaX: 4, sigmaY: 4
                  ),
                  child: SvgPicture.asset(
                    bolitaFileName,
                    width: 0.25 * widget.factor,
                    color: Colors.black.withOpacity(0.25)
                  ),
                ),
              ),
              SvgPicture.asset(
                bolitaFileName,
                width: 0.25 * widget.factor,
              ),
            ],
          ),
          // Text(
          //   "v= $magVelocity m/s",
          //   style: TextStyle(
          //     fontFamily: "Roboto Light",
          //   ),
          // ),
      //   ],
      // ),
      builder: (BuildContext context, Widget? child)  {

        // Get.put(PruebasModel2() ).animationPercent.value = controller.value;
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

  // double _round(double value, int decimals) {
  //   int fac = pow(10, decimals);
  //   return (value * fac).round() / fac;
  // }

  @override
  void dispose() {
    if (!(widget.velocityX == 0.0 && widget.velocityY == 0.0)) {
      widget.update!(true);
      
    }
    controller.dispose();
    super.dispose();
  }
}
