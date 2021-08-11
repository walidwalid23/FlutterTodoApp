import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todoappwithriverpod/RiverPodProviders.dart';
import "home.dart";


void main() async{

  runApp(ProviderScope(child: MyApp()));

}

class MyApp extends StatelessWidget {
 final Color scaffoldBGColor= Color.fromRGBO(71, 183, 239,1);
  @override
  Widget build(BuildContext context) {
    print("MATERIALAPP PAGE REBUILT");
    return MaterialApp(
        home:Home(),
        title: "TODOAPP",
        theme: ThemeData(scaffoldBackgroundColor:scaffoldBGColor),
        debugShowCheckedModeBanner:false
    );
  }
}

