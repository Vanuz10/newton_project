import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



import '../models/all_the_models.dart';
import '../models/physics_class.dart';
import '../widgets/physics_app_icons.dart';
import 'multifunction_pages/charts_page.dart';
import 'multifunction_pages/parameters_page.dart';
import 'multifunction_pages/process_page.dart';
import 'multifunction_pages/simulation_page.dart';



class MultiFunctionPage extends StatefulWidget {
  const MultiFunctionPage({Key? key}) : super(key: key);



  @override
  _MultiFunctionPageState createState() => _MultiFunctionPageState();
}

class _MultiFunctionPageState extends State<MultiFunctionPage> {
  late PhysicsController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = ParabolicMotionController(context: context);
  }


  @override
  Widget build(BuildContext context) {
    final infoCardModel = Provider.of<InfoCardModel>(context);
    final _orientation = MediaQuery.of(context).orientation;
    // final physicsModel = Provider.of<KinematicsModel>(context);
    

    bool isLarge = _orientation == Orientation.portrait;
    // print(MediaQuery.of(context).size);

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          toolbarHeight: (isLarge)?75:null,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: _leading(),
          ),
          elevation: 0,
          title: Text(
            infoCardModel.subTitle,
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyText1?.color,
              fontFamily: "Roboto Light",
              fontSize: 24.0,
            ),),
          backgroundColor: Theme.of(context).canvasColor,
        ),
        body: DefaultTabController(
          length: 4,
          child: MultiPage(
            isLarge: isLarge,
            children: [
                _tabBar(context, infoCardModel.color ,isLarge),
                (isLarge)?const Divider(height: 1, thickness: 0.5,):const VerticalDivider(width: 1, thickness: 0.5,),
                Expanded(
                  child: TabBarView(

                    physics: const BouncingScrollPhysics(),
                    children:[
                      ParametersPage(controller: controller, focusedColor: infoCardModel.color,),
                      SimulationPage(controller: controller, focusedColor: infoCardModel.color,),
                      const ProcessPage(),
                      const ChartsPage(),

                    ]
                    ,
                  ),
                )
            ],
          ),
        
      ),
    );
  }

  Builder _leading() {
    return Builder(
      builder: (BuildContext context) {
        return ClipOval(
          child: RawMaterialButton(
            // splashColor: Colors.white.withOpacity(0.1),
            // highlightColor: Colors.white.withOpacity(0.1),
            shape: const CircleBorder(

            ),
            onPressed: (){
              Navigator.pop(context);
            },
            child: Icon(
            Icons.arrow_back_rounded,
              size: 32,
              color: Colors.black.withOpacity(0.4),
            )
          ),
        );
      }
    );
  }

  Container _tabBar(BuildContext context, Color color, bool isLarge) {
    return Container(
      color: Theme.of(context).canvasColor,
      child: TabBar(
        // indicator: BoxDecoration(),
        // indicatorWeight: 1,
        unselectedLabelColor: Colors.black.withOpacity(0.4),
        labelColor: color,
        physics: const BouncingScrollPhysics(),
        indicatorColor: color,
        tabs: [
          _tab( PhysicsAppIcons.parameters, isLarge),
          _tab( PhysicsAppIcons.simulation, isLarge),
          _tab( PhysicsAppIcons.process, isLarge),
          _tab( PhysicsAppIcons.charts, isLarge),
        ]
      ),
    );
  }

  Widget _tab(IconData icon, bool isLarge) {
    return Tab(
      icon: Transform(
        alignment: Alignment.center,
        transform: Matrix4.rotationY((isLarge)?0:pi),
        child: RotatedBox(
          quarterTurns: (isLarge)?0:1,
          child: Icon(icon,
            size: 28,
          )
        ),
      ),

    );
  }
}



class MultiPage extends StatelessWidget {
  final bool isLarge;
  final List<Widget> children;

  const MultiPage({Key? key, required this.isLarge, required this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
    (isLarge)
      ?
      Column(
        children: children
      )
      :  Row(
        children: [
          Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(pi),
            child: RotatedBox(
            quarterTurns: 1,
            child: SizedBox(
              height: 60,
              child: children[0],
            ),
          ),
          ), ...children.sublist(1)


        ]
      );

  }
}