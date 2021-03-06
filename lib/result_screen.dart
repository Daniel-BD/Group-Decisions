import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:tuple/tuple.dart';

import 'theming.dart';
import 'package:google_fonts/google_fonts.dart';
import 'main.dart';
import 'start_screen.dart';

class ResultScreen extends StatefulWidget {
  static const routeName = '/resultScreen';
  final ScreenArguments args;

  ResultScreen({Key key, this.args}) : super(key: key);

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  final List<Tuple2<String, double>> results = [];
  bool hasCalculatedResult = false;
  bool multipleWinners = false;
  int numberOfVoters = 0;

  @override
  Widget build(BuildContext context) {
    if (!hasCalculatedResult) {
      _onFirstBuild();
    }
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: mainColor,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: _body(),
        ),
        bottomNavigationBar: SafeArea(
          child: _bottomButtons(),
        ),
      ),
    );
  }

  _onFirstBuild() {
    bool deleteLastRating = true;

    /// If there's more than one vote, and the last vote is zero on all options, delete the last vote
    widget.args.options.forEach((option) {
      if (option.ratings.last != 0) {
        deleteLastRating = false;
      }
    });

    /// If there's only one vote, we'll leave that vote in even if it's zero
    if (widget.args.options.first.ratings.length > 1) {
      if (deleteLastRating) {
        widget.args.options.forEach((option) {
          option.ratings.removeLast();
        });
      }
    }

    numberOfVoters = widget.args.options.first.ratings.length;

    /// Calculate average ranking for each option
    for (var option in widget.args.options) {
      double averageRating = 0;
      option.ratings.forEach((rating) {
        averageRating += rating;
      });
      averageRating = (averageRating / option.ratings.length);

      results.add(Tuple2(option.text, averageRating));
    }

    /// Sort highest first
    results.sort((a, b) => b.item2.compareTo(a.item2));

    /// See if two or more more options share the highest ranking
    var highestRanked = results.where((result) => result.item2 == results.first.item2);
    if (highestRanked.length > 1) {
      multipleWinners = true;
    }
    print(highestRanked.length);

    hasCalculatedResult = true;
  }

  Widget _body() {
    return Flex(
      direction: Axis.vertical,
      children: <Widget>[
        Container(
          height: 80,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Average Ratings",
                style: GoogleFonts.pTSans(
                  color: contrastMainColor,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                numberOfVoters.toString() + (numberOfVoters == 1 ? ' person voted' : ' people voted'),
                style: GoogleFonts.pTSans(
                  color: contrastMainColor,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: FadingEdgeScrollView.fromScrollView(
            child: ListView(
              controller: ScrollController(),
              shrinkWrap: false,
              children: <Widget>[
                for (var result in results) _optionRow(result),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _optionRow(Tuple2<String, double> result) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(height: 10),
          Text(
            result.item1,
            style: GoogleFonts.pTSans(
              color: contrastMainColor,
              fontSize: 24,
            ),
          ),
          Container(height: 8),
          Stack(
            children: <Widget>[
              RatingBarIndicator(
                rating: result.item2,
                direction: Axis.horizontal,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: secondaryColor,
                ),
                unratedColor: unratedStarColor,
              ),
            ],
          ),
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
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ButtonTheme(
            padding: EdgeInsets.only(left: 30, right: 30),
            height: 50,
            child: FlatButton(
              child: Row(
                children: <Widget>[
                  Text("NEW VOTE", style: bigButtonText),
                ],
              ),
              onPressed: () {
                Navigator.pushReplacementNamed(
                  context,
                  StartScreen.routeName,
                );
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
