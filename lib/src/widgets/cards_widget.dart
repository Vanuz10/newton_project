import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../models/all_the_models.dart';
import '../pages/multi_page.dart';
import 'card_animation_widget.dart';


class GenerateCards extends StatelessWidget {
  final Map cardsInfo;
  const GenerateCards({Key? key, required this.cardsInfo}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    final _orientation = MediaQuery.of(context).orientation;

    bool isLarge = _orientation == Orientation.portrait; // Esta variable verifica si el dispositivo está en formato vertical (Sólo para smartphones -- no tablets).
    // bool isTablet = (isLarge)?_size.width/_size.height > 0.625:_size.height/_size.width > 0.625;
    

    return Container(
      alignment: (isLarge)?null:Alignment.center,
      child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: (isLarge)?4.0:16.0, vertical: 16.0),
          scrollDirection: (isLarge)?Axis.vertical:Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 16,
            runSpacing: 16,
            children: _createCards(cardsInfo,_size,isLarge,context),
          )
        ),
    );
      
    
  }


  List<Widget>_createCards(Map map, Size size, bool isLarge, BuildContext context){
    
    final currentTheme = Provider.of<ThemeModel>(context).currentTheme; // Información del tema seleccionado.
    
    final isMenu = map.values.toList()[0].containsKey("options"); // Verifica si el contenido del map pertenece a las cards del menú (Pertenece si contiene la key "options" en uno de sus elementos).

    // Estilos de texto para el título y contenido de la carta.
    TextStyle titleStyle = TextStyle(
      fontFamily: "Roboto Light",
      color: currentTheme.textTheme.bodyText1?.color,
      fontSize: 22.0,
    );
    TextStyle bodyStyle = TextStyle(
      fontFamily: "Roboto Thin",
      color: currentTheme.textTheme.bodyText1?.color,
      fontSize: 12.0,
    );

    // El ancho y alto de la card será proporcional al ancho del dispositivo, a menos que este pase de los 500 pixeles de ancho, en este caso tendrá un ancho y alto fijo.
    double widthCard= (size.width<500)?size.width*0.4375:180.0;
    double heightCard= (size.width<500)?size.width*0.5590:230.0;

    List<Widget> cardsList =[];
    
    map.forEach((key,value){
      cardsList.add(
        RawMaterialButton(
          elevation: 4.5,
          fillColor: currentTheme.canvasColor,
          shape: RoundedRectangleBorder(
            side: BorderSide(color:Colors.black.withOpacity(0.2), width: 3),
            borderRadius: BorderRadius.circular(16)
          ),
          splashColor: Colors.white.withOpacity(0.1),
          highlightColor: Colors.white.withOpacity(0.1),
          onPressed: (){
            final infoCardModel = Provider.of<InfoCardModel>(context, listen: false);

            if(isMenu){

              infoCardModel.color = Color(int.parse("0xff" + value["color"]));
              infoCardModel.title = value["title"];
              infoCardModel.optionsMap = value["options"];

              Navigator.pushNamed(context, "option");

            }else{
              
              infoCardModel.subTitle = value["title"];
              Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (context) => const MultiFunctionPage(),
                )
              );
            
            }

          },
          child: Container(
            width: widthCard,
            height: heightCard,
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 100.0,
                  width: 170.0,
                  child: (isMenu)
                    ?CardAnimation(
                      riveFileName: "assets/MenuCardsAnimations/" + value["animation"] + ".riv",
                      animationName: value["animation"],
                    )
                    
                    // :(value["animation"]!=" ")
                    //   ?SvgPicture.asset("assets/MenuCardsAnimations/KinematicsAnimations/"+ value["animation"]+".svg", fit: BoxFit.contain,)
                      : null
                ),

                Text(value["title"], textAlign: TextAlign.center, style: titleStyle),
                const SizedBox(height:10),
                Text(value["body"], textAlign: TextAlign.center, style: bodyStyle),
              ],
            )
          ),
        )
      );
    }
    );
    return cardsList;
  }



}