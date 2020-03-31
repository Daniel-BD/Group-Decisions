import 'package:flutter/material.dart';

import 'start_screen.dart';
import 'router.dart' as router;
import 'theming.dart';

/// TODO: Om två eller flera resultat är lika, ha en knapp som väljer en på random
/// TODO: Funktion att kunna spara vanliga röstningar? T.ex. så man kan välja ett sparat val för "pizza, thai, sushi", så man slipper skriva om dom

void main() {
  runApp(GroupRankingApp());
}

class GroupRankingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: MaterialApp(
        theme: ThemeData(accentColor: contrastMainColor, textSelectionHandleColor: secondaryColor),
        debugShowCheckedModeBanner: false,
        title: 'Group Decider',
        initialRoute: StartScreen.routeName,
        onGenerateRoute: router.generateRoute,
      ),
    );
  }
}

class ScreenArguments {
  final List<Option> options;
  ScreenArguments(this.options);
}

class Option {
  String text;
  TextEditingController controller;
  FocusNode focusNode;
  bool readOnly = true;
  List<double> ratings = [];

  Option({@required controller, @required text, @required focusNode}) {
    this.controller = controller;
    this.text = text;
    this.focusNode = focusNode;
  }
}
