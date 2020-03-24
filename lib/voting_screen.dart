import 'package:flutter/material.dart';
import 'package:group_ranking/result_screen.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';

import 'theming.dart';
import 'package:google_fonts/google_fonts.dart';
import 'main.dart';

class VotingScreen extends StatefulWidget {
  static const routeName = '/votingScreen';
  final ScreenArguments args;

  VotingScreen({Key key, this.args}) : super(key: key);

  @override
  _VotingScreenState createState() => _VotingScreenState();
}

class _VotingScreenState extends State<VotingScreen> {
  int _votingIndex = 0;
  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: _body(),
      ),
      bottomNavigationBar: SafeArea(
        child: _bottomButtons(),
      ),
    );
  }

  Widget _body() {
    return Flex(
      direction: Axis.vertical,
      children: <Widget>[
        Container(
          height: 80,
          child: Center(
            child: Text(
              "Person " + (_votingIndex + 1).toString(),
              style: GoogleFonts.pTSans(
                color: contrastMainColor,
                fontSize: 26,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
        Expanded(
          child: FadingEdgeScrollView.fromScrollView(
            child: ListView(
              controller: _scrollController,
              physics: AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              shrinkWrap: false,
              children: <Widget>[
                for (var option in widget.args.options) _optionRow(option),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _optionRow(Option option) {
    if (option.ratings.length < (_votingIndex + 1)) {
      option.ratings.add(0);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(height: 10),
          Text(
            option.text,
            style: GoogleFonts.pTSans(
              color: contrastMainColor,
              fontSize: 24,
            ),
          ),
          Container(height: 8),
          SmoothStarRating(
              allowHalfRating: false,
              onRatingChanged: (v) {
                option.ratings[_votingIndex] = v;
                setState(() {});
              },
              starCount: 5,
              rating: option.ratings[_votingIndex],
              size: 40.0,
              color: secondaryColor,
              borderColor: secondaryColor,
              spacing: 0.0),
          Container(height: 10),
          Divider(
            thickness: 1.5,
            color: Colors.black.withOpacity(0.25),
            indent: 20,
            endIndent: 20,
          ),
        ],
      ),
    );
  }

  Widget _bottomButtons() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Row(
        children: <Widget>[
          ButtonTheme(
            height: 50,
            child: OutlineButton(
              child: Text("SHOW RESULTS", style: mediumButtonText),
              onPressed: () {
                Navigator.pushReplacementNamed(
                  context,
                  ResultScreen.routeName,
                  arguments: widget.args,
                );
              },
              disabledBorderColor: disabledButtonColor,
              disabledTextColor: disabledButtonTextColor,
              highlightedBorderColor: secondaryColor,
              borderSide: BorderSide(
                color: secondaryColor,
                width: 1.5,
              ),
              textColor: secondaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
          ),
          Spacer(),
          ButtonTheme(
            padding: EdgeInsets.only(left: 16, right: 6),
            height: 50,
            child: FlatButton(
              child: Row(
                children: <Widget>[
                  Text("NEXT PERSON", style: mediumButtonText),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 30,
                  ),
                ],
              ),
              onPressed: () {
                setState(() {
                  _votingIndex++;
                  _scrollController.animateTo(0.0, duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
                });
              },
              disabledColor: disabledButtonColor,
              disabledTextColor: disabledButtonTextColor,
              color: secondaryColor,
              textColor: enabledButtonTextColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
