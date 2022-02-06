import 'package:flutter/material.dart';





class RectangleContainerFormat extends StatelessWidget {

  final double? width;
  final double? height;
  final Widget child;

  const RectangleContainerFormat({Key? key,  this.width,  required this.child,  this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
            color: Colors.black.withOpacity(0.2), width: 2),
      ),
      child: child
    );
     
  }
}


class CircleContainerFormat extends StatelessWidget {

  final double width;
  final Widget child;

  const CircleContainerFormat({Key? key, required this.width, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: width,
      width: width,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
            color: Colors.black.withOpacity(0.2), width: 2),
      ),
      child: child
    );
     
  }
}




class TitleRectangleContainerFormat extends StatelessWidget {

  final double width;
  final double height;
  final String containerTitle;
  final Widget child;

  const TitleRectangleContainerFormat({Key? key, required this.width, required this.child, required this.height, required this.containerTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width:width,
      height:height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: Colors.black.withOpacity(0.2),
          width: 2),
        // color: color
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              containerTitle,
              style: const TextStyle(
                fontFamily: "Roboto Light",
                fontSize: 18.0,
              ),
            ),
            const Divider(height: 1,thickness: 0.5,),
            const SizedBox(height:16),
            child,
            const SizedBox(height:16),
          ],
        ),
      ),
    );
  }
}