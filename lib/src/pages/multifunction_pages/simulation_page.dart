import 'package:flutter/material.dart';

import '../../models/physics_class.dart';
import '../../widgets/container_format_widget.dart';
import '../../widgets/text_editing_controller_workaroud.dart';



class SimulationPage extends StatefulWidget {
  final PhysicsController controller;
  final Color focusedColor;
  const SimulationPage({ Key? key, required this.controller, required this.focusedColor }) : super(key: key);

  @override
  _SimulationPageState createState() => _SimulationPageState();
}

class _SimulationPageState extends State<SimulationPage> {

  // static const labelTextStyle = TextStyle(fontFamily: "Roboto Light", fontSize: 16);
  // static const subLabelTextStyle = TextStyle(fontFamily: "Roboto Light", fontSize: 12);
  static const unitsTextStyle = TextStyle(fontFamily: "Roboto Thin", fontSize: 12);


  late bool isLarge;

  late PhysicsController physicsCtrl;



  @override
  void initState() {
    super.initState();
    // isLarge = MediaQuery.of(context).orientation == Orientation.portrait;
    isLarge = true;
    physicsCtrl = widget.controller;
    
    


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: ListView(
        
        // scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        physics: const BouncingScrollPhysics(),
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              " Simulación: ",
              style: TextStyle(
                fontFamily: "Roboto Light",
                fontSize: 20.0,
              ),
            ),
          ),
          simulation(),
          const SizedBox(height: 10,),
          RectangleContainerFormat(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0,),
                child: ParameterController(controller: physicsCtrl)
              ),
            ),
          ),
        
        ]
          
    ),
    );
  
  }



  Widget simulation() {
    return RectangleContainerFormat(
        // width: width,
        child: AspectRatio(
          aspectRatio: (isLarge)?160/103.5:210/103.5, // Ratio 16/9 más un 15% de la altura
          child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  flex: 20,
                  child: AspectRatio(
                    aspectRatio: 16/9,
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          bottom: (!physicsCtrl.canSimulate)
                          ? 0.0 
                          : double.parse(physicsCtrl.parameters["ho"]["value"])*physicsCtrl.factor,
                          left: 10,
                          child: physicsCtrl.animation,
                          ),
                      ],
                    )
                  ),
                ),
                const Divider(
                  color: Colors.black,
                  thickness: 2,
                  height: 0.0,
                ),
                Flexible(flex: 4, child: _createControllerBar(widget.focusedColor)),
            ]),
        ),
      );
  }


  Widget _createControllerBar(Color focusedColor) {
    Color iconColor = (!physicsCtrl.canSimulate)?ThemeData.dark().disabledColor: focusedColor;
    return Column(
      children: [
        Flexible( flex: 1, child: Container()),
        Flexible(
          flex: 10,
          child: Row(
            // crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                flex: 1,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      // side: BorderSide(width: 2, color: iconColor),
                        shape: const CircleBorder(),
                        primary: iconColor,
                      ),
                    onPressed: (!physicsCtrl.canSimulate)?null:(){
                      setState(() {
                        // physicsCtrl.playerControl = (physicsCtrl.playerControl == "play")?"pause":"play";
                        physicsCtrl.controlAnimation((physicsCtrl.playerControl == "play")?"pause":"play");
                        
                      });
                    },
                    child: FittedBox(
                      child: Icon(
                        (physicsCtrl.playerControl == "play")?Icons.pause_rounded:Icons.play_arrow_rounded,
                      ),
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: TextButton(
                      style: TextButton.styleFrom(
                        // side: BorderSide(width: 2, color: iconColor),
                        shape: const CircleBorder(),
                        primary: iconColor,
                      ),
                      child: const FittedBox(
                      child: Icon(
                        Icons.stop_rounded,
                        // color: iconColor,
                      ),
                    ),
                      onPressed: (!physicsCtrl.canSimulate)?null:(){
                        setState(() {
                          // physicsCtrl.playerControl = "reset";
                          physicsCtrl.controlAnimation("reset");
                        });
                    },
                    ),
                    
                    
                  ),
                
              ),
              Flexible(
                flex: 5,
                child: Container()
              ),
            ],
          ),
        ),
        Flexible( flex: 1, child: Container()),
      ],
    );
  }




  // _getChildren(BuildContext context, physicsModel, isLarge, size) {
  //   if(isLarge){
  //   return [
  //     Padding(
  //       padding:  EdgeInsets.symmetric(vertical: 10),
  //       child: Text(
  //         " Simulación: ",
  //         style: TextStyle(
  //           fontFamily: "Roboto Light",
  //           fontSize: 20.0,
  //         ),
  //       ),
  //     ),
      
  //     ParabolicMotionSimulation(physicsModel: physicsModel, isLarge: isLarge,),
  //     SizedBox(height: 10,),
  //     RectangleContainerFormat(
  //       height: 300,
  //     ),
    
      
    
  //   ];
  //   }else{
  //     return [
  //       Container(
  //         height: size.height - Scaffold.of(context).appBarMaxHeight,
  //         child: Padding(
  //           padding: const EdgeInsets.symmetric(vertical: 10),
  //           child: Column(
  //             children: [
  //               Flexible(flex: 5, child: ParabolicMotionSimulation(isLarge: isLarge,)),
  //               SizedBox(height: 10,),
  //               RectangleContainerFormat(
  //                 // height: 50,
  //                 child: TextField(),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),

  //     ];
  //   }


  // }
}




class ParameterController extends StatefulWidget {
  final PhysicsController controller;
  const ParameterController({ Key? key, required this.controller }) : super(key: key);

  @override
  State<ParameterController> createState() => _ParameterControllerState();
}

class _ParameterControllerState extends State<ParameterController> {

  late bool isLarge;


  static const unitsTextStyle = TextStyle(fontFamily: "Roboto Thin", fontSize: 12);

  late int cursorOffset;

  late PhysicsController physicsCtrl;

  dynamic dropDownSelection;

  late String text;


  @override
  void initState() {
    physicsCtrl = widget.controller;
    cursorOffset = 0;
    text = "";
    isLarge = true;
    dropDownSelection = physicsCtrl.sliders.keys.first;

    



    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    if (physicsCtrl.canSimulate == true) {
      physicsCtrl.animationController?.addListener(() {
      setState(() {
        
      });
     });
    }
    return Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      // crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text(
              "Parameter:",
              style: TextStyle(
                fontFamily: "Roboto Light",
                fontSize: 18.0,
              ),
            ),
            RectangleContainerFormat(
              // width: 300,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0,),
                child: DropdownButton(
                  underline: const SizedBox(),
                  icon: const Icon(Icons.arrow_drop_down_rounded),
                  iconSize: 30,
                  // menuMaxHeight: 100.0,
                  onChanged: (value){
                    setState(() {
                      dropDownSelection = value;
                      
                    });
                  },
                  value: dropDownSelection,
                  items: physicsCtrl.sliders.keys.map((key) => 
                    DropdownMenuItem(child: Text(key), value: key,),
                  ).toList()
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20,),
        _getSlider(Colors.amber, physicsCtrl),
      ],
    );
  }

  
  Widget _getSlider(Color focusedColor, PhysicsController physicsCtrl) {

    // print(physicsCtrl.animationController.isAnimating);
    // if(physicsCtrl.animationController.isAnimating){
    //   setState(() {
        
    //   });
    // }
    TextEditingControllerWorkaroud textEditingController = TextEditingControllerWorkaroud(text: '');
    textEditingController.text = text;
    // textEditingController.text = physicsCtrl.sliders[dropDownSelection]["value"].toString();
    textEditingController.setTextAndPosition(text, caretPosition: cursorOffset);

    
    Widget slider = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      // mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Flexible(
          flex: 2,
          child: Slider(
            value: physicsCtrl.sliders[dropDownSelection]["value"],
            min: physicsCtrl.sliders[dropDownSelection]["min"], 
            max: physicsCtrl.sliders[dropDownSelection]["max"], 
            onChangeStart: (_){
              // FocusScope.of(context).unfocus();
            },
            onChanged: (!physicsCtrl.canSimulate)?null:(valueSlider){
              
              setState(() {
                physicsCtrl.valueSlider(dropDownSelection, valueSlider);
              });
        
            },
            activeColor: focusedColor,
            inactiveColor: focusedColor.withOpacity(.5)
          ),
        ),
        Flexible(
          flex: 1,
          child: SizedBox(
            width: 120,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    
                    controller: textEditingController,
                    maxLines: 1,
                    scrollPhysics: const BouncingScrollPhysics(),
                    style: const TextStyle(
                      fontSize: 14
        
                    ),
                    onTap: (){
                      cursorOffset = textEditingController.selection.base.offset;
                      // textEditingController.text = "";
                    },
                    onEditingComplete: (){
                      setState(() {
                        text = "";
                        cursorOffset =0;
                      });
                    },
                    onSubmitted: (newValue){
                      physicsCtrl.valueFromText(dropDownSelection, newValue);
                      setState(() {
                        text = "";
                        
                        cursorOffset =0;
                      });
                    },
                    onChanged: (newValue)async{
                      
                      cursorOffset = textEditingController.selection.base.offset;
                      text = newValue;
                      // physicsCtrl.valueText(dropDownSelection, newValue);
                      
                      setState(() {});
                    
                    },
                    readOnly: !physicsCtrl.canSimulate, 
                    // physicsCtrl.animationController.isAnimating,
                    enabled: physicsCtrl.canSimulate,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: physicsCtrl.sliders[dropDownSelection]["value"].toString(),
                      // alignLabelWithHint: true,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: focusedColor, width: 2.0),
                        borderRadius: BorderRadius.circular(16)
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16)
                      ),
        
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  width: 0.25*120,
                  child:Text(
                    physicsCtrl.sliders[dropDownSelection]["units"],
                    style: unitsTextStyle
        
                  )
                ),
              ],
        
            )
            ),
          )
        ],
    );

    return slider;
  }




}