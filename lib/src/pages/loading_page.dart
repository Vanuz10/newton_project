import 'dart:async';

import 'package:flutter/material.dart';

import '../widgets/card_animation_widget.dart';
import 'menu_page.dart';


class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    Timer(const Duration(seconds: 3), () {
      // Navigator.push(context, "menu");
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (c, a1, a2) => const MenuPage(),
          transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
          transitionDuration: const Duration(milliseconds: 1000),
        ),
      );
    });
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width*0.33),
          child: const CardAnimation(
            riveFileName: "assets/newt_logo.riv",
            animationName: "NewTLogoAnimation",
          ),
        ),
      ),

    );
  }
}