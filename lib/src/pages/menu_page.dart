import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../utils/info.dart';
import '../models/all_the_models.dart';
import '../widgets/cards_widget.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({Key? key}) : super(key: key);

  

  @override
  Widget build(BuildContext context) {
    final themeModel = Provider.of<ThemeModel>(context);


    final _size = MediaQuery.of(context).size;
    final _orientation = MediaQuery.of(context).orientation;

    bool isLarge = _orientation == Orientation.portrait;

    final _headerHeight = (isLarge)?_size.width*0.35:_size.height*0.25;

    final _newtLogoFile = (themeModel.darkTheme)?"assets/NewtLogoWhite.svg":"assets/NewTLogo.svg";

    return Scaffold(
      drawer: _getDrawer(context, themeModel),
      body: Column(
        children: <Widget>[
          _getHeader(_headerHeight, themeModel, _newtLogoFile),
          const Divider(height: 1,thickness: 0.5,),
          Expanded(
            child: GenerateCards(cardsInfo: menuCardsInfo, ),
          ),
        ],
      ),
    );
  }

  Widget _getDrawer(BuildContext context, ThemeModel themeModel){
    
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Divider(thickness: 0.5,),
          ListTile(
            title: Text(
              "Dark Mode",
              style: TextStyle(
                fontFamily: "Roboto Light",
                color: themeModel.currentTheme.textTheme.bodyText1?.color,
                fontSize: 16.0,
              ),
            ),
            trailing: Switch.adaptive(
              activeThumbImage: const AssetImage("assets/Moon.png",),
              inactiveThumbImage: const AssetImage("assets/Sun.png",),
              activeColor: const Color(0xff282828),
              activeTrackColor: Colors.black.withOpacity(0.35),
              inactiveTrackColor: Colors.black.withOpacity(0.35),
              inactiveThumbColor: Colors.white,
              value: themeModel.darkTheme,
              onChanged: (value){
                themeModel.darkTheme = value;
              },
            ),
          ),
          const Divider(thickness: 0.5,),
        ],
      ),
    );
  }



  Widget _getHeader(double _headerHeight, ThemeModel themeModel, String _newtLogoFile) {
    return Stack(
      children: <Widget>[
        SizedBox(
          height: _headerHeight,
          child: const SafeArea(
            child: Center(
              child: Text(
                "physics",
                style: TextStyle(
                  fontFamily: "Roboto Light",
                  fontSize: 44.0,
                ),
              ),
            ),
          ),
        ),
        
        Positioned(
          left: -16,
          child: SafeArea(
            child: Builder(
              builder: (BuildContext context) {
                return RawMaterialButton(
                  shape: const CircleBorder(),
                  onPressed: (){
                    Scaffold.of(context).openDrawer();
                  },
                  child: Icon(
                    Icons.menu_rounded,
                    size: 32,
                    color: Colors.black.withOpacity(0.4),
                  )
                );
              }
            ),
          ),
        ),
        Positioned(
          bottom: 12,
          right: 30,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:[
              const Text("By:  ",
                style: TextStyle(
                  fontFamily: "Roboto Light",
                  fontSize: 14.0,
                ),
              ),
              SvgPicture.asset(
                _newtLogoFile,
                height: 30,
              ),
            ]
          ),
        ),
      ],
    );
  }

 
}





