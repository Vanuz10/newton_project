import 'package:flutter/material.dart';

import '../../models/physics_class.dart';
import '../../widgets/container_format_widget.dart';
import '../../widgets/text_editing_controller_workaroud.dart';


// import 'dart:ui';

// var pixelRatio = window.devicePixelRatio;

//  //Size in physical pixels
// var physicalScreenSize = window.physicalSize;
// var physicalWidth = physicalScreenSize.width;
// var physicalHeight = physicalScreenSize.height;

// //Size in logical pixels
// var logicalScreenSize = window.physicalSize / pixelRatio;
// var logicalWidth = logicalScreenSize.width;
// var logicalHeight = logicalScreenSize.height;

// //Padding in physical pixels
// var padding = window.padding;

// //Safe area paddings in logical pixels
// var paddingLeft = window.padding.left / window.devicePixelRatio;
// var paddingRight = window.padding.right / window.devicePixelRatio;
// var paddingTop = window.padding.top / window.devicePixelRatio;
// var paddingBottom = window.padding.bottom / window.devicePixelRatio;

// //Safe area in logical pixels
// var safeWidth = logicalWidth - paddingLeft - paddingRight;
// var safeHeight = logicalHeight - paddingTop - paddingBottom;



class ParametersPage extends StatefulWidget {
  final PhysicsController controller;
  final Color focusedColor;
  const ParametersPage({Key? key, required this.controller, required this.focusedColor}) : super(key: key);

  @override
  _ParametersPageState createState() => _ParametersPageState();
}

class _ParametersPageState extends State<ParametersPage> {
  
  
  static const labelTextStyle =  TextStyle(fontFamily: "Roboto Light", fontSize: 16);
  static const subLabelTextStyle =  TextStyle(fontFamily: "Roboto Light", fontSize: 12);
  static const unitsTextStyle =  TextStyle(fontFamily: "Roboto Thin", fontSize: 12);

  late PhysicsController physicsCtrl;
  
  late int cursorOffset;


  @override
  void initState() { 
    super.initState();
    cursorOffset = 0;
    physicsCtrl = widget.controller; // Aquí se reemplaza el ParabolicMotionController() por el physicsController que venga según la card selecionada
  }
  // Hacer un apartado para decidir qué mensajes mostrar cuando se escribe un valor que cno cumpla condiciones como que sea 0 o negativo.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        physics: const BouncingScrollPhysics(),
        children: [
          Padding(
            padding:  const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  " Parámetros: ",
                  style: TextStyle(
                    fontFamily: "Roboto Light",
                    fontSize: 20.0,
                  ),
                ),
                Row(
                  children: [
                    TextButton.icon(
                      icon: const Icon(Icons.double_arrow_rounded, size: 20,),
                      style: TextButton.styleFrom(
                        primary: const Color(0xff7DD65D),
                      ),
                      label: const Text("Calcular"),
                      onPressed: (!physicsCtrl.canCalculate)?null:() {
                        setState(() {
                          FocusScope.of(context).unfocus();
                          physicsCtrl.calculate(400.0, 200.0);
                        });
                        
                        
                      },
                    ),
                    
                    TextButton.icon(
                      icon: const Icon(Icons.replay_rounded, size: 20,),
                      style: TextButton.styleFrom(
                        primary: Colors.red,
                      ),
                      label: const Text("Reset"),
                      onPressed: (){
                        setState(() {
                          FocusScope.of(context).unfocus();
                          physicsCtrl.resetAll();
                        });

                      }
                    ),
                  ],
                )
              ],
            ),
          ),
          RectangleContainerFormat(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: Wrap(
                  // runAlignment: WrapAlignment.center,
                  // crossAxisAlignment: WrapCrossAlignment.center,
                  runSpacing: 12,
                  spacing: 24,
                  children: _getInputFields(widget.focusedColor, physicsCtrl),
                ),
              ),
            ),
          ),
          
        ],
      ),
    );
  }


  List<Widget> _getInputFields(Color focusedColor, PhysicsController physicsCtrl){

    List<Widget> inputFields = [];
    physicsCtrl.parameters.forEach((key, value) {
      inputFields.add(
        _inputField(labelText: value["label"], subLabelText: value["subLabel"], units: value["units"], focusedColor: focusedColor, physicsCtrl: physicsCtrl,),
      );
     });
    return inputFields;
  }



  Widget _inputField({required String labelText, required String subLabelText, required String units, Color? focusedColor, required PhysicsController physicsCtrl}){
    final parameter = labelText + subLabelText;
    final valueP = physicsCtrl.parameters[parameter]["value"];
    final readOnly = physicsCtrl.parameters[parameter]["readOnly"];

    TextEditingControllerWorkaroud textEditingController = TextEditingControllerWorkaroud(text: '');
    textEditingController.text = valueP.toString();
    textEditingController.setTextAndPosition(valueP, caretPosition: cursorOffset);

    final size = MediaQuery.of(context).size;    
    final width = (size.width<420.0)?size.width*0.4:160.0;

    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: width*0.75,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      labelText,
                      style: labelTextStyle,
                    ),
                    Text(
                      subLabelText,
                      style: subLabelTextStyle,
                    ),
                    const Text(
                      " :",
                      style: labelTextStyle,
                    ),
                  ],
                ),
                Icon(
                  // Icons.highlight_off_rounded, 
                  Icons.circle,
                  // size: 16,
                  size: 12, 
                  color: focusedColor!.withOpacity((readOnly)?1.0:0.0),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Expanded(
                child: Opacity(
                  opacity: (readOnly)?0.5:1,
                  child: TextField(
                    
                    controller: textEditingController,
                    maxLines: 1,
                    scrollPhysics: const BouncingScrollPhysics(),
                    style: const TextStyle(
                      fontSize: 14
                    ),
                    onTap: (){
                      cursorOffset = textEditingController.selection.base.offset;
                    },
                    onChanged: (value)async{
                      
                      physicsCtrl.onChanged(parameter, value);
                      cursorOffset = textEditingController.selection.base.offset;
                      if (physicsCtrl.canSetState){
                        setState(() {});
                      }
                    },
                    // enabled: !readOnly,
                    readOnly: readOnly,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
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
              ),
              Container(
                alignment: Alignment.center,
                width: 0.25*width,
                child:Text(
                  units,
                  style: unitsTextStyle

                )
              ),
            ],

          ),

        ],
      )
    );
  }


}


 

