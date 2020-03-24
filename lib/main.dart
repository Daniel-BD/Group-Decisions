import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:page_transition/page_transition.dart';

import 'theming.dart';
import 'package:google_fonts/google_fonts.dart';
import 'voting_screen.dart';
import 'result_screen.dart';
import 'router.dart' as router;

// TODO: Ordna de populäraste valen först i "results"
// TODO: Om två eller flera resultat är lika, ha en knapp som väljer en på random


void main() {
  runApp(GroupRankingApp());
}

class GroupRankingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Group Decider',
      initialRoute: StartScreen.routeName,
      onGenerateRoute: router.generateRoute,
    );
  }
}

class StartScreen extends StatefulWidget {
  static const routeName = '/startScreen';

  StartScreen({Key key}) : super(key: key);

  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  void initState() {
    super.initState();

    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        if (_addOptionFocus.hasFocus) {
          setState(() {
            showOptionsTextField = visible;
          });
        }
      },
    );
  }

  bool showOptionsTextField = false;
  TextEditingController _addOptionController = TextEditingController();
  FocusNode _addOptionFocus = FocusNode();
  List<Option> _options = [];
  int optionMaxLength = 60;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      resizeToAvoidBottomInset: true,
      body: SafeArea(child: _body()),
      bottomNavigationBar: SafeArea(
        child: _bottomButtons(),
      ),
    );
  }

  Widget hintWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("Tap ", style: textStyle1),
        Icon(
          Icons.add,
          color: contrastMainColor,
          size: 40,
        ),
        Text(" to add an option", style: textStyle1),
      ],
    );
  }

  Widget _body() {
    Widget bodyWidget = Container();

    if (_options.isEmpty && !_addOptionFocus.hasFocus) {
      bodyWidget = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          hintWidget(),
        ],
      );
    } else if (_options.isNotEmpty) {
      bodyWidget = FadingEdgeScrollView.fromScrollView(
        child: ListView(
          controller: ScrollController(),
          physics: AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          shrinkWrap: false,
          children: <Widget>[
            Container(height: 80),
            _optionsTiles(),
          ],
        ),
      );
    }

    return Stack(
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: bodyWidget,
            ),
            //_bottomButtons(),
          ],
        ),
        _addOptionTextField(),
      ],
    );
  }

  Widget _optionsTiles() {
    List<Widget> tiles = [];
    tiles.add(Container());

    for (int i = 0; i < _options.length; i++) {
      tiles.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Row(
                    children: <Widget>[
                      Container(width: 12),
                      Text(
                        (i + 1).toString() + '.',
                        style: GoogleFonts.pTSans(
                          color: contrastMainColor,
                          fontSize: 24,
                        ),
                      ),
                      Container(width: 12),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 0),
                          child: TextField(
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(optionMaxLength),
                            ],
                            textCapitalization: TextCapitalization.sentences,
                            textInputAction: TextInputAction.done,
                            readOnly: _options[i].readOnly,
                            controller: _options[i].controller,
                            focusNode: _options[i].focusNode,
                            style: GoogleFonts.pTSans(
                              color: contrastMainColor,
                              fontSize: 22,
                            ),
                            decoration: InputDecoration(border: InputBorder.none),
                            maxLines: 10,
                            minLines: 1,
                            onSubmitted: (text) {
                              setState(() {
                                _options[i].controller.text = text;
                                _options[i].text = text;
                                _options[i].readOnly = true;
                              });
                            },
                          ),
                        ),
                      ),
                      Container(width: 12),
                    ],
                  ),
                ),
                Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.edit,
                        color: secondaryColor,
                        size: 32,
                      ),
                      onPressed: () {
                        setState(() {
                          _options[i].readOnly = false;
                        });
                        _options[i].focusNode.requestFocus();
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: secondaryColor,
                        size: 32,
                      ),
                      onPressed: () {
                        setState(() {
                          _options.removeAt(i);
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        children: tiles,
      ),
    );
  }

  Widget _bottomButtons() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Row(
        children: <Widget>[
          ButtonTheme(
            minWidth: 160,
            height: 50,
            child: FlatButton(
              child: Text("START VOTE", style: bigButtonText),
              onPressed: _options.isEmpty
                  ? null
                  : () {
                      Navigator.pushReplacementNamed(
                        context,
                        VotingScreen.routeName,
                        arguments: ScreenArguments(_options),
                      );
                    },
              disabledColor: disabledButtonColor,
              disabledTextColor: disabledButtonTextColor,
              color: secondaryColor,
              textColor: enabledButtonTextColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
            ),
          ),
          Spacer(),
          FloatingActionButton(
            onPressed: () {
              setState(() {
                FocusScope.of(context).requestFocus(_addOptionFocus);
              });
            },
            tooltip: 'Add an option',
            child: Icon(
              Icons.add,
              color: enabledButtonTextColor,
              size: 40,
            ),
            backgroundColor: secondaryColor,
          ),
        ],
      ),
    );
  }

  Widget _addOptionTextField() {
    return AnimatedPositioned(
      duration: Duration(milliseconds: 150),
      bottom: 0,
      left: 0,
      right: 0,
      child: Visibility(
        visible: showOptionsTextField,
        maintainSize: true,
        maintainAnimation: true,
        maintainState: true,
        child: Container(
          color: newOptionTextFieldColor,
          child: TextField(
            controller: _addOptionController,
            focusNode: _addOptionFocus,
            textCapitalization: TextCapitalization.sentences,
            onSubmitted: (option) {
              setState(() {
                if (option.isNotEmpty) {
                  _options.add(
                    Option(
                      text: option,
                      controller: TextEditingController(text: option),
                      focusNode: FocusNode(),
                    ),
                  );
                }
                showOptionsTextField = false;
                _addOptionController.clear();
              });
            },
            cursorColor: mainColor,
            style: GoogleFonts.pTSans(
              color: newOptionTextColor,
              fontSize: 20,
            ),
            decoration: InputDecoration(
              hintText: "Add option",
              hintStyle: TextStyle(
                color: newOptionHintColor,
              ),
              contentPadding: const EdgeInsets.only(left: 10),
              border: InputBorder.none,
            ),
            inputFormatters: [
              LengthLimitingTextInputFormatter(optionMaxLength),
            ],
          ),
        ),
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
