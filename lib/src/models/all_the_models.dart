
import 'package:flutter/material.dart';

class InfoCardModel with ChangeNotifier{
  Color _color = Colors.white;
  String _title = "";
  String _subTitle = "";
  Map _optionsMap = {};


  set color(Color color){
    _color=color;
    notifyListeners();
  }Color get color => _color;


  set title(String title){
    _title=title;
    notifyListeners();
  }String get title => _title;


  set subTitle(String subTitle){
    _subTitle=subTitle;
    notifyListeners();
  }String get subTitle => _subTitle;


  set optionsMap(Map optionsMap){
    _optionsMap=optionsMap;
    notifyListeners();
  }Map get optionsMap => _optionsMap;

}


class ThemeModel with ChangeNotifier{
  late bool _darkTheme = false;
  late ThemeData _currentTheme;

  final ThemeData _dark = ThemeData.dark().copyWith(canvasColor: const Color(0xff333333),
    // splashColor: Colors.red,
    // // hoverColor: Colors.red,
    // highlightColor: Colors.green,
    );

  final ThemeData _light = ThemeData.light().copyWith(
    // splashColor: Colors.red,
    // hoverColor: Colors.red,
    // highlightColor: Colors.green,
    // focusColor: Colors.red
    );

  ThemeModel(int theme){
    switch(theme){
      case 1:
        _darkTheme = false;
        _currentTheme = _light;
      break;
      case 2:
        _darkTheme = true;
        _currentTheme = _dark;
      break;
      default:
        _darkTheme = false;
        _currentTheme = _light;
      break;

    }
  }

  set darkTheme(bool darkTheme){
    _darkTheme = darkTheme;
    if(darkTheme){
      _currentTheme = _dark;
    }else{
      _currentTheme = _light;
    }

    notifyListeners();
  }

  bool get darkTheme => _darkTheme;

  set currentTheme(ThemeData currentTheme){
    _currentTheme=currentTheme;
    notifyListeners();
  }

  ThemeData get currentTheme => _currentTheme;


}


class CursorOffsetModel with ChangeNotifier{
  int _cursorOffset = 0;


  set cursorOffset(int cursorOffset){
  // print("THIS IS THE OFFSET: $cursorOffset");
  _cursorOffset = cursorOffset;
  notifyListeners();
  }int get cursorOffset => _cursorOffset;


}

