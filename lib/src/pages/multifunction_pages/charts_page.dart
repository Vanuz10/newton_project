import 'package:flutter/material.dart';

import '../../widgets/container_format_widget.dart';


class ChartsPage extends StatelessWidget {
  const ChartsPage({Key? key, }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final kinematicsModel = Provider.of<KinematicsModel>(context);
    // final infoCardModel = Provider.of<InfoCardModel>(context);


    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        physics: const BouncingScrollPhysics(),
        children: [
          const Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text(
            " Charts: ",
            style: TextStyle(
              fontFamily: "Roboto Light",
              fontSize: 20.0,
            ),
          ),
        ),
          RectangleContainerFormat(
            child: Container(
              height: 200,
            )
          ),
        ],
      ),
    );
  }
}
