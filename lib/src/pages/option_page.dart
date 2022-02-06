import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/all_the_models.dart';
import '../widgets/cards_widget.dart';


class OptionPage extends StatelessWidget {
  const OptionPage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final infoCardModel = Provider.of<InfoCardModel>(context);

    final _orientation = MediaQuery.of(context).orientation;

    bool isLarge = _orientation == Orientation.portrait;

    return Scaffold(
      
      appBar: AppBar(
        toolbarHeight: (isLarge)?75:null,
        title: Text(
          infoCardModel.title,
          style: TextStyle(
            fontFamily: "Roboto Light",
            color: Theme.of(context).canvasColor,
            fontSize: 28.0,
          ),
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: _leading(),
        ),
        backgroundColor: infoCardModel.color,
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              child: GenerateCards(cardsInfo: infoCardModel.optionsMap, ),
            ),
            
          ],
        ),
      )
      
    );
  }

  Builder _leading() {
    return Builder(
      builder: (BuildContext context) {
        return ClipOval(
          child: RawMaterialButton(
            splashColor: Colors.white.withOpacity(0.1),
            highlightColor: Colors.white.withOpacity(0.1),
            shape: const CircleBorder(
              
            ),
            onPressed: (){
              Navigator.pop(context);
            },
            child: Icon(
            Icons.arrow_back_rounded,
              size: 32,
              color: Theme.of(context).canvasColor,
            )
          ),
        );
      }
    );
  }

  


}