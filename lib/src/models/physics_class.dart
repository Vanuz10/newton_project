import 'dart:math';

import 'package:flutter/cupertino.dart';

import '../widgets/kinematics_animation_widget.dart';

abstract class PhysicsController {

  final BuildContext context;
  
  PhysicsController({required this.context,});



  Map get parameters;
  bool get canCalculate;
  bool get canSetState;


  AnimationController? get animationController;
  double get animationPercent;

  double get factor;
  bool get canSimulate;
  get animation;
  String get playerControl;
  Map get sliders;


  double gravity = -9.81;

  


  double _round(double value, int decimals) {
    num fac = pow(10, decimals);
    return (value * fac).round() / fac;
  }

  bool _containsThisElements(List list, List elements){
    bool itContains = true;
    for (var elem in elements) {itContains = itContains && list.contains(elem); }
    return itContains;
  }

  void verifyBlockedItems(){}

  void onChanged(String parameter, String value){}

  void calculate(double maxWidth, double maxHeight){}
  
  void resetAll(){}


  


  // void updateAnimation(){}
  void updateAnimationPercent(bool isDisposed){}

  void controlAnimation(String playerControl){}

  void createSliders(){}

  void valueSlider(String parameter, double newValue){}

  void valueFromText(String parameter, String value){}


}


class ParabolicMotionController extends PhysicsController{
  ParabolicMotionController({required BuildContext context}) : super(context: context);
  
  @override
  Map parameters = {
    "voy": {"label": "v", "subLabel": "oy", "units": "m/s", "value": "", "readOnly": false, },
    "vx": {"label": "v", "subLabel": "x", "units": "m/s", "value": "", "readOnly": false, },
    "ho": {"label": "h", "subLabel": "o", "units": "m", "value": "", "readOnly": false, },
    "hmax": {"label": "h", "subLabel": "max", "units": "m", "value": "", "readOnly": false, }, 
    "thmax": {"label": "t", "subLabel": "hmax", "units": "s", "value": "", "readOnly": false, },
    "ttotal": {"label": "t", "subLabel": "total", "units": "s", "value": "", "readOnly": false, },
    "Xmax": {"label": "X", "subLabel": "max", "units": "m", "value": "", "readOnly": false, },
  };


  @override
  bool canCalculate = false;
  @override
  bool canSimulate = false;
  @override
  bool canSetState = false;
  List inputs = [];
  
  
  
  GlobalKey<KinematicsAnimationState> key = GlobalKey();
  @override
  AnimationController? animationController;
  @override
  double animationPercent = 0.0;
  @override
  double factor = 100;
  @override
  String playerControl = "pause";
  @override
  KinematicsAnimation animation = const KinematicsAnimation(
    // key: GlobalKey(),
    velocityX: 0,
    velocityY: 0,
    height: 0,
    factor: 100,
    //  playerControl: "pause",
  );

  @override
  Map sliders = {
    "t": {"units":"s", "value": 0.0, "min": 0.0, "max": 1.0,},
    "X": {"units":"m", "value": 0.0, "min": 0.0, "max": 1.0,},
    // "vy": {"value": 0.0, "min": 0.0, "max": 1.0,},
    // "h": {"value": 0.0, "min": 0.0, "max": 1.0,},
  };
//TODO: Hacer un Map de specialSliders, donde se encontrará un slider que puede cambiar de sentido, como el trayecto de ho a hmax y de hmax al suelo.

  
  
  int _lastLenght = 0;



  final Map _toBlock = {
    "" : [],
    "voy": ["thmax"],
    "vx": [],
    "ho": [],
    "hmax": [],
    "thmax": ["voy"],
    "ttotal": [],
    "Xmax": [],

    "voy_vx": ["thmax"],
    "ho_voy": ["hmax", "thmax", "ttotal"],
    "hmax_voy": ["ho", "thmax", "ttotal"],
    "ttotal_voy": ["ho", "thmax", "hmax"],
    "Xmax_voy": ["thmax"],


    "ho_vx": [],
    "hmax_vx": [],
    "thmax_vx": ["voy"],
    "ttotal_vx": ["Xmax"],
    "Xmax_vx": ["ttotal"],


    "hmax_ho": ["voy", "thmax", "ttotal"],
    "ho_thmax": ["voy", "hmax", "ttotal"],
    "ho_ttotal": ["voy", "hmax", "thmax"],
    "Xmax_ho": [],
    
    
    "hmax_thmax": ["voy", "ho", "ttotal"],
    "hmax_ttotal": ["voy", "ho", "thmax"],
    "Xmax_hmax": [],


    "thmax_ttotal": ["voy", "ho", "hmax"],
    "Xmax_thmax": [],

    "Xmax_ttotal": ["vx"]


  };
  

  @override
  void resetAll(){
    inputs.clear();
    parameters.forEach((key, value) {
      value["value"] = "";
      value["readOnly"] = false;
    });

    animation = const KinematicsAnimation(
     velocityX: 0,
     velocityY: 0,
     height: 0,
     factor: 100,
    //  playerControl: "pause",
   );
     
    canSimulate = false;
    canCalculate = false;
  }

  @override
  void verifyBlockedItems(){
    canSetState = true;
    List sortedItems = inputs;
    sortedItems.sort();
    List blockedItems = (sortedItems.length == 3)?(parameters.keys.toList().toSet().difference(sortedItems.toSet())).toList():_toBlock[sortedItems.join("_")];
    List notBlockedItems = (parameters.keys.toList().toSet().difference(blockedItems.toSet())).toList();
    
 
    for (var element in notBlockedItems) { 
      parameters[element]["readOnly"] = false;
    }

    for (var element in blockedItems) { 
      parameters[element]["readOnly"] = true;
    }
    
  }
  
  @override
  void onChanged(String parameter, String value){
    canSetState = false;
    canSimulate = false;

    // blockSim = true;

    if(value.isEmpty){
      inputs.remove(parameter);
    }else{
      if(!inputs.contains(parameter) && inputs.length<3){
        inputs.add(parameter);
      }
    }
    parameters[parameter]["value"] = value;


    // canCalculate = false;

    if(inputs.length == 3){
      canCalculate = true;
      canSetState = true;
      parameters.forEach((key, value) {
      if(value["readOnly"] == true){
        value["value"] = "";
      }

      });

    }else{
      canCalculate = false;
    }



    
    if(inputs.length != _lastLenght){
      verifyBlockedItems();
    }

    _lastLenght = inputs.length;
  
  
  }

  void updateAnimation(){
    
    animation = KinematicsAnimation(
      update: updateAnimationPercent,
      key: key,
      velocityX: double.parse(parameters["vx"]["value"]),
      velocityY: double.parse(parameters["voy"]["value"]),
      height: double.parse(parameters["ho"]["value"]),
      factor: factor,
    );
 }


  @override
  void updateAnimationPercent(bool isDisposed){
    if(isDisposed == true){
      animationPercent = 0;
      playerControl = "pause";
    }else{
      animationPercent = animationController!.value;
    }
    updateSliders(false);
  }


  void updateSliders(bool firstTime){
    if(firstTime){
      sliders["t"]["max"] = double.parse(parameters["ttotal"]["value"]);
      sliders["X"]["max"] = double.parse(parameters["Xmax"]["value"]);
    }else{
      sliders["t"]["value"] = animationPercent*sliders["t"]["max"];
      sliders["X"]["value"] = animationPercent*sliders["X"]["max"];

    }



    // sliders["vy"]["max"] = parameters["ttotal"]["value"];
  }


  @override
  void controlAnimation(String playerControl){

    animationController = key.currentState?.controller;

    playerControl = playerControl;
    switch (playerControl) {
      case "play":
        animationController?.forward();
        break;
      case "pause":
        // controller.value = widget.valuePercent;
        animationController?.stop();
        break;
      case "reset":
        animationController?.reset();
        break;
      default:
    }
    // valueSlider("vx", key.currentState.animationPercent);
  //  print(key.currentState.controller.value);

  }

// TODO: Hacer una sección para establecer aquí los valores para los sliders y que se creen en la página, así como pasa con los parámetros.

  @override
  void valueSlider(String parameter, double newValue){
    controlAnimation("pause");
    animationController?.value = newValue/sliders[parameter]["max"];

  }

  @override
  void valueFromText(String parameter, String value){
    controlAnimation("pause");
    if (value.isEmpty) {
      animationController?.value = 0.0;
    }
    else if(double.parse(value) > sliders[parameter]["max"]){
      animationController?.value = 1.0;

    }else{
      animationController?.value = double.parse(value)/sliders[parameter]["max"];
    }

  }

  @override
  void calculate(double maxWidth, double maxHeight){
    canSimulate = true;

    parameters.forEach((key, value) { 
      if(value["value"] == ""){
        value["value"] = 0.0;
      }else{
        value["value"] = double.parse(value["value"]);
      }
    });
    

    double voy = parameters["voy"]["value"];
    double vx = parameters["vx"]["value"];
    double ho = parameters["ho"]["value"];
    double hmax = parameters["hmax"]["value"];
    double thmax = parameters["thmax"]["value"];
    double ttotal = parameters["ttotal"]["value"];
    double xmax = parameters["Xmax"]["value"];


    if(inputs.contains("thmax")){

    voy = -thmax*gravity;

    }
    if(_containsThisElements(inputs, ["ho","hmax"])){
      // print([voy, vx, ho, hmax, thmax, ttotal, xmax]);  
      
      voy = sqrt(-2*gravity*(hmax - ho));

    }else if(_containsThisElements(inputs, ["ho","ttotal"])){

      voy = (-gravity*pow(ttotal, 2)/2 - ho)/ttotal;

    }else if(_containsThisElements(inputs, ["hmax","ttotal"])){

      voy = gravity*ttotal*(-1 + sqrt(-2*hmax/(gravity*pow(ttotal, 2))));
      ho = hmax + pow(voy, 2) / (2 * gravity);

    }else if(_containsThisElements(inputs, ["Xmax", "vx"])) {
      
      ttotal = xmax/vx;
      

      if(inputs.contains("ho")){

        voy = (-gravity*pow(ttotal, 2)/2 - ho)/ttotal;

      }else if(inputs.contains("hmax")){

        voy = gravity*ttotal*(-1 + sqrt(-2*hmax/(gravity*pow(ttotal, 2))));
        ho = hmax + pow(voy, 2) / (2 * gravity);

      }else{
        ho = -gravity*pow(ttotal,2)/2 - ttotal*voy;
      }
    
    
    }else if(inputs.contains("hmax")){

      ho = hmax + pow(voy, 2) / (2 * gravity);

    }else if(inputs.contains("ttotal")){

      ho = -gravity*pow(ttotal,2)/2 - ttotal*voy;
      
    }


    hmax = ho - ((voy < 0) ? 0.0 : pow(voy, 2) / (2 * gravity));
    ttotal = (-sqrt(pow(voy, 2) + (2 * gravity * -ho)) - voy) /gravity;
    thmax = (voy < 0) ? 0.0 : -voy/gravity;



    if(inputs.contains("Xmax")){
      vx = xmax / ttotal;
    }

    xmax = (vx * ttotal);


    // Regresando el valor de las variables a los parámetros
    parameters["voy"]["value"] = voy;
    parameters["vx"]["value"] = vx;
    parameters["ho"]["value"] = ho;
    parameters["hmax"]["value"] = hmax;
    parameters["thmax"]["value"] = thmax;
    parameters["ttotal"]["value"] = ttotal;
    parameters["Xmax"]["value"] = xmax;
    
    

    parameters.forEach((key, value) { 
      
      value["value"] = _round(value["value"], 3).toString();
      
    });
    
    Size size = MediaQuery.of(context).size;
    if(size.width/100 < xmax){
      factor = size.width/xmax;     // factor base multiplicado por el ancho en pixeles permitido dividido para el alcance máximo en metros
      if(factor < 45){
        factor = 45;
      }
    }else{
      factor = 100;
    }
    
    updateAnimation();
    updateSliders(true);



    // blockSim = false;
    
  }

}



// class FreeFallandVerticalThrowController extends PhysicsController{
//   @override
//   Map parameters = {
//     "voy": {"label": "v", "subLabel": "oy", "units": "m/s", "value": "", "readOnly": false, },
//     "ho": {"label": "h", "subLabel": "o", "units": "m", "value": "", "readOnly": false, },
//     "hmax": {"label": "h", "subLabel": "max", "units": "m", "value": "", "readOnly": false, }, 
//     "thmax": {"label": "t", "subLabel": "hmax", "units": "s", "value": "", "readOnly": false, },
//     "ttotal": {"label": "t", "subLabel": "total", "units": "s", "value": "", "readOnly": false, },
//   };


//   @override
//   void calculate(){}
// }



// class MRUMRUVController extends PhysicsController{

//   MRUMRUVController({Map parameters, String playerControl}) : super(parameters: parameters, playerControl: playerControl);

//   @override
//   Map parameters = {};

//   @override
//   void calculate(){}

// }