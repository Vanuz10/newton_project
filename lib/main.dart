import 'package:flutter/material.dart';


import 'package:provider/provider.dart';


import 'package:newton_project/src/models/all_the_models.dart';
import 'package:newton_project/src/pages/loading_page.dart';
import 'package:newton_project/src/pages/menu_page.dart';
import 'package:newton_project/src/pages/multi_page.dart';
import 'package:newton_project/src/pages/option_page.dart';



void main() => runApp(
  MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => InfoCardModel()),
      ChangeNotifierProvider(create: (_) => ThemeModel(1)),
      ChangeNotifierProvider(create: (_) => CursorOffsetModel()),
    ], 
    child: const MyApp()));

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeModel>(context).currentTheme;

    return MaterialApp(
      theme: currentTheme,
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: 'loading',
      routes: {
        'loading':(BuildContext context) => const LoadingPage(),
        'menu': (BuildContext context) => const MenuPage(),
        'option': (BuildContext context) => const OptionPage(),
        'multi': (BuildContext context) => const MultiFunctionPage(),
      },
    );
  }
}
