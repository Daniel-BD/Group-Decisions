import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:page_transition/page_transition.dart';

import 'main.dart';
import 'result_screen.dart';
import 'voting_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case StartScreen.routeName:
      return PageTransition(child: StartScreen(), type: PageTransitionType.fade);

    case VotingScreen.routeName:
      var argument = settings.arguments;
      return PageTransition(child: VotingScreen(args: argument), type: PageTransitionType.fade);

    case ResultScreen.routeName:
      var argument = settings.arguments;
      return PageTransition(child: ResultScreen(args: argument), type: PageTransitionType.fade);

    default:
      return PageTransition(child: StartScreen(), type: PageTransitionType.fade);
  }
}
