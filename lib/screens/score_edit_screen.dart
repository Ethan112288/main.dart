import 'dart:async';
import 'dart:convert';
import 'dart:math';
import '../firebase_options.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import '../config/palette.dart';
import '../config/globals.dart' as globals;

import '../screens/match_edit_screen.dart';
import '../screens/matches_screen.dart';
import '../screens/point_edit_screen.dart';

import '../widgets/app_drawer.dart';

// Map<String, dynamic> mapPointData_scoreEditScreen = {};
// Map<String, dynamic> mapMatchData_scoreEditScreen = {};
Map<String, dynamic> mapPointData_scoreEditScreen =
    new Map<String, dynamic>.from(mapPointData_INIT);
Map<String, dynamic> mapMatchData_scoreEditScreen =
    new Map<String, dynamic>.from(mapMatchData_INIT);

GlobalKey<FormState> keyForm_scoreEdit1 =
    new GlobalKey<FormState>(debugLabel: 'keyForm_scoreEdit1');
GlobalKey<FormState> keyForm_scoreEdit2 =
    new GlobalKey<FormState>(debugLabel: 'keyForm_scoreEdit2');

class scoreEditScreenArgs {
  Map<String, dynamic> mapPointData = {};
  Map<String, dynamic> mapMatchData = {};

  scoreEditScreenArgs(this.mapPointData, this.mapMatchData);
}

class Form_PlayerScore extends StatefulWidget {
  Form_PlayerScore({required this.keyForm, required this.PlayerNum});

  final keyForm;
  final String PlayerNum;

  @override
  Form_PlayerScoreState createState() => Form_PlayerScoreState();
}

class Form_PlayerScoreState extends State<Form_PlayerScore> {
  // final keyForm_scoreEdit1 =
  //     GlobalKey<FormState>(debugLabel: 'ScoreEditScreenState_Player1');
  // final keyForm_scoreEdit2 =
  //     GlobalKey<FormState>(debugLabel: 'ScoreEditScreenState_Player2');

  final _priorSetGamesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _dropdownListScore =
        (mapMatchData_scoreEditScreen['matchCurrGameFormat'] == 'SuperTieBreak')
            ? [
                '0',
                '1',
                '2',
                '3',
                '4',
                '5',
                '6',
                '7',
                '8',
                '9',
                '10',
                '11',
                '12',
                '13',
                '14',
                '15'
              ]
            : (mapMatchData_scoreEditScreen['matchCurrGameFormat'] ==
                    'TieBreak')
                ? [
                    '0',
                    '1',
                    '2',
                    '3',
                    '4',
                    '5',
                    '6',
                    '7',
                    '8',
                    '9',
                    '10',
                    '11',
                    '12',
                    '13',
                    '14',
                    '15'
                  ]
                : (mapMatchData_scoreEditScreen['matchAd'] == 'NoAd')
                    ? ['0', '15', '30', '40']
                    : ['0', '15', '30', '40', 'Ad'];

    String _currGameScore = '';
    if (widget.PlayerNum == '1') {
      _currGameScore =
          mapMatchData_scoreEditScreen['matchCurrGameScores_Player1']
              .toString();
      // _priorSetGamesController.text = mapMatchData_scoreEditScreen['matchPriorSetGames_Player1'];
      // _priorSetGamesController.text = String.fromCharCodes(mapMatchData_scoreEditScreen['matchPriorSetGames_Player1']);
      _priorSetGamesController.text =
          mapMatchData_scoreEditScreen['matchPriorSetGames_Player1'].toString();
    } else {
      _currGameScore =
          mapMatchData_scoreEditScreen['matchCurrGameScores_Player2']
              .toString();
      // _priorSetGamesController.text = mapMatchData_scoreEditScreen['matchPriorSetGames_Player2'];
      // _priorSetGamesController.text = String.fromCharCodes(mapMatchData_scoreEditScreen['matchPriorSetGames_Player2']);
      _priorSetGamesController.text =
          mapMatchData_scoreEditScreen['matchPriorSetGames_Player2'].toString();
    }
    _currGameScore = (mapMatchData_scoreEditScreen['matchAd'] == 'NoAd' &&
            _currGameScore == 'Ad')
        ? '40'
        : _currGameScore;

    var _tmp = [
      for (int i = 0;
          i <= mapMatchData_scoreEditScreen['matchNumOfGamesPerSet'];
          i++)
        i
    ];
    // List<String> _dropdownListGame = _tmp.map((i) => i.toString()).join(",").toList();
    List<String> _dropdownListGame = _tmp.map((i) => i.toString()).toList();

    // print('ScoreEditScreen.Form_PlayerScoreState ' + _dropdownListScore.toString());
    // print('ScoreEditScreen.Form_PlayerScoreState ' + _dropdownListGame.toString());

    return Form(
      // key: (widget.PlayerNum == '1') ? keyForm_scoreEdit1 : keyForm_scoreEdit2,
      key: widget.keyForm,
      child: ListView(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height *
                pctHeight_PtAttrib /
                pctHeight_PtAttrib_DenomAdj,
          ),
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height *
                pctHeight_PtAttrib /
                pctHeight_PtAttrib_DenomAdj,
            child: Text(
              '${(widget.PlayerNum == '1') ? mapMatchData_scoreEditScreen['matchPlayer1FirstName'] : mapMatchData_scoreEditScreen['matchPlayer2FirstName']}',
              style:
                  TextStyle(color: Palette.umBlue, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height *
                pctHeight_PtAttrib /
                pctHeight_PtAttrib_DenomAdj,
          ),
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * pctHeight_PtAttrib,
            child: DropdownButtonFormField<String>(
              value: _currGameScore,
              isExpanded: true,
              decoration: InputDecoration(labelText: 'Points'),
              validator: (value) {
                if (value == null || value == '') {
                  return 'Please provide a value.';
                }
                return null;
              },
              onChanged: (String? value) {
                if (widget.PlayerNum == '1') {
                  mapMatchData_scoreEditScreen['matchCurrGameScores_Player1'] =
                      value!;
                  mapMatchData_scoreEditScreen['matchCurrGamePts_Player1'] =
                      _dropdownListScore.indexOf(value!);
                  // if (mapMatchData_scoreEditScreen['matchCurrGamePts_PlayerMAX'])
                } else {
                  mapMatchData_scoreEditScreen['matchCurrGameScores_Player2'] =
                      value!;
                  mapMatchData_scoreEditScreen['matchCurrGamePts_Player2'] =
                      _dropdownListScore.indexOf(value!);
                }
                List<int> _tmpList = [];
                _tmpList.add(
                    mapMatchData_scoreEditScreen['matchCurrGamePts_Player1']);
                _tmpList.add(
                    mapMatchData_scoreEditScreen['matchCurrGamePts_Player2']);
                mapMatchData_scoreEditScreen['matchCurrGamePts_PlayerMAX'] =
                    _tmpList.reduce(max); // _ptMax

                mapMatchData_scoreEditScreen['matchCurrGamePts_PlayerDIFF'] =
                    (mapMatchData_scoreEditScreen['matchCurrGamePts_Player1'] -
                            mapMatchData_scoreEditScreen[
                                'matchCurrGamePts_Player2'])
                        .abs(); // _ptDiff
              },
              onSaved: (String? value) {
                if (widget.PlayerNum == '1') {
                  mapMatchData_scoreEditScreen['matchCurrGameScores_Player1'] =
                      value!;
                  mapMatchData_scoreEditScreen['matchCurrGamePts_Player1'] =
                      _dropdownListScore.indexOf(value!);
                } else {
                  mapMatchData_scoreEditScreen['matchCurrGameScores_Player2'] =
                      value!;
                  mapMatchData_scoreEditScreen['matchCurrGamePts_Player2'] =
                      _dropdownListScore.indexOf(value!);
                }
              },
              items: _dropdownListScore.map((String value) {
                return DropdownMenuItem<String>(
                    value: value, child: Text(value));
                // child: Text(value.toString()));
              }).toList(),
            ),
          ),
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height *
                pctHeight_PtAttrib /
                pctHeight_PtAttrib_DenomAdj,
          ),
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * pctHeight_PtAttrib,
            child: DropdownButtonFormField<String>(
              value: (widget.PlayerNum == '1')
                  ? mapMatchData_scoreEditScreen['matchCurrSetGames_Player1']
                      .toString()
                  : mapMatchData_scoreEditScreen['matchCurrSetGames_Player2']
                      .toString(),
              isExpanded: true,
              decoration: InputDecoration(labelText: 'Games'),
              validator: (value) {
                if (value == null || value == '') {
                  return 'Please provide a value.';
                }
                return null;
              },
              onChanged: (String? value) {
                if (widget.PlayerNum == '1') {
                  mapMatchData_scoreEditScreen['matchCurrSetGames_Player1'] =
                      int.parse(value!);
                } else {
                  mapMatchData_scoreEditScreen['matchCurrSetGames_Player2'] =
                      int.parse(value!);
                }
                List<int> _tmpList = [];
                _tmpList.add(
                    mapMatchData_scoreEditScreen['matchCurrSetGames_Player1']);
                _tmpList.add(
                    mapMatchData_scoreEditScreen['matchCurrSetGames_Player2']);
                mapMatchData_scoreEditScreen['matchCurrSetGames_PlayerMAX'] =
                    _tmpList.reduce(max); // _gameMax

                mapMatchData_scoreEditScreen['matchCurrSetGames_PlayerDIFF'] =
                    (mapMatchData_scoreEditScreen['matchCurrSetGames_Player1'] -
                            mapMatchData_scoreEditScreen[
                                'matchCurrSetGames_Player2'])
                        .abs(); //_gameDiff
              },
              onSaved: (String? value) {
                if (widget.PlayerNum == '1') {
                  mapMatchData_scoreEditScreen['matchCurrSetGames_Player1'] =
                      int.parse(value!);
                } else {
                  mapMatchData_scoreEditScreen['matchCurrSetGames_Player2'] =
                      int.parse(value!);
                }
              },
              items: _dropdownListGame.map((String value) {
                return DropdownMenuItem<String>(
                    value: value, child: Text(value));
                // child: Text(value.toString()));
              }).toList(),
            ),
          ),
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height *
                pctHeight_PtAttrib /
                pctHeight_PtAttrib_DenomAdj,
          ),
          Container(
            // width: MediaQuery.of(context).size.width * 0.4,
            width: double.infinity,
            height: MediaQuery.of(context).size.height * pctHeight_PtAttrib,
            child: TextFormField(
              controller: _priorSetGamesController,
              decoration: InputDecoration(labelText: 'Prior Set Games'),
              //keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value!.isEmpty) {
                  return 'No data';
                }
                return null;
              },
              onChanged: (value) {
                if (widget.PlayerNum == '1') {
                  // mapMatchData_scoreEditScreen['matchPriorSetGames_Player1'] = value!;
                  mapMatchData_scoreEditScreen['matchPriorSetGames_Player1'] =
                      json.decode(value!)!;
                } else {
                  // mapMatchData_scoreEditScreen['matchPriorSetGames_Player2'] = value!;
                  mapMatchData_scoreEditScreen['matchPriorSetGames_Player2'] =
                      json.decode(value!)!;
                }
              },
              onSaved: (value) {
                if (widget.PlayerNum == '1') {
                  // mapMatchData_scoreEditScreen['matchPriorSetGames_Player1'] = value!;
                  mapMatchData_scoreEditScreen['matchPriorSetGames_Player1'] =
                      json.decode(value!)!;
                } else {
                  // mapMatchData_scoreEditScreen['matchPriorSetGames_Player2'] = value!;
                  mapMatchData_scoreEditScreen['matchPriorSetGames_Player2'] =
                      json.decode(value!)!;
                }
              },
            ),
          ),
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height *
                pctHeight_PtAttrib /
                pctHeight_PtAttrib_DenomAdj,
          ),
        ],
      ),
    );
  }
}

class ScoreEditScreen extends StatefulWidget with ChangeNotifier {
  static const routeName = '/edit-score';

  @override
  ScoreEditScreenState createState() => ScoreEditScreenState();
}

class ScoreEditScreenState extends State<ScoreEditScreen> with ChangeNotifier {
  var _isInit = true;

  final _numOfGamesPerSetController = TextEditingController();
  final _noteController = TextEditingController();
  final _currSetController = TextEditingController();

  var _initValues_matchServicePlayerNum = '1';
  var _initValues_matchSetFormat = MatchFormatSetOptions.TwoOfThree;
  var _initValues_matchAd = MatchAdOptions.NoAd;
  var _initValues_matchFinalSetFormat =
      MatchFormatFinalSetOptions.SuperTieBreak;

  @override
  void didChangeDependencies() {
    //didChangeDependencies is called just a few moments after the state loads its dependencies and context is available at this moment so here you can use context.

    // print('DEBUG.. didChangeDependencies');
    // print('DEBUG.. ' + _isInit.toString());

    if (_isInit) {
      // Load maps
      // mapMatchData_scoreEditScreen =
      final _args =
          ModalRoute.of(context)!.settings.arguments as scoreEditScreenArgs;
      mapPointData_scoreEditScreen = _args.mapPointData;
      mapMatchData_scoreEditScreen = _args.mapMatchData;

      if (mapMatchData_scoreEditScreen.isEmpty) {
        // print('ScoreEditScreenState.. mapMatchData_scoreEditScreen.isEmpty' +
        //     _isInit.toString());
      }
      _numOfGamesPerSetController.text =
          mapMatchData_scoreEditScreen['matchNumOfGamesPerSet'].toString();
      _noteController.text =
          mapMatchData_scoreEditScreen['matchNotes'].toString();
      _currSetController.text =
          mapMatchData_scoreEditScreen['matchCurrSet'].toString();

      _initValues_matchServicePlayerNum =
          mapMatchData_scoreEditScreen['matchService_PlayerNum'];
      _initValues_matchSetFormat = MatchFormatSetOptions.values.firstWhere(
          (e) =>
              e.toString() ==
              'MatchFormatSetOptions.' +
                  mapMatchData_scoreEditScreen['matchSetFormat']);
      _initValues_matchAd = MatchAdOptions.values.firstWhere((e) =>
          e.toString() ==
          'MatchAdOptions.' + mapMatchData_scoreEditScreen['matchAd']);
      _initValues_matchFinalSetFormat = MatchFormatFinalSetOptions.values
          .firstWhere((e) =>
              e.toString() ==
              'MatchFormatFinalSetOptions.' +
                  mapMatchData_scoreEditScreen['matchFinalSetFormat']);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _saveScore2FB(mapMatchData_scoreEditScreen, _matchID) async {
    var _args;

    // commit Form values to variables
    keyForm_scoreEdit1.currentState!.save();
    keyForm_scoreEdit2.currentState!.save();

    // Recalc Match Stats
    if (mapMatchData_scoreEditScreen['matchSetFormat'] == 'ThreeOfFive') {
      mapMatchData_scoreEditScreen['matchSetMMAX'] =
          5; // mapMatchData_scoreEditScreen['matchSetMMAX']
      if (mapMatchData_scoreEditScreen['matchSetsWon_PlayerDIFF'] >= 2) {
        mapMatchData_scoreEditScreen['matchSetMAX'] =
            mapMatchData_scoreEditScreen['matchSetsWon_PlayerMAX'];
      } else {
        mapMatchData_scoreEditScreen['matchSetMAX'] =
            mapMatchData_scoreEditScreen['matchSetsWon_PlayerMIN'] + 2;
        if (mapMatchData_scoreEditScreen['matchSetMAX'] <= 3) {
          mapMatchData_scoreEditScreen['matchSetMAX'] = 3;
        } else if (mapMatchData_scoreEditScreen['matchSetMAX'] >= 5) {
          mapMatchData_scoreEditScreen['matchSetMAX'] = 5;
        }
      }
    } else if (mapMatchData_scoreEditScreen['matchSetFormat'] == 'TwoOfThree') {
      mapMatchData_scoreEditScreen['matchSetMMAX'] = 3; // _maxmaxSet
      // if (mapMatchData_scoreEditScreen['matchSetsWon_PlayerMAX'] == 2 &&
      //     mapMatchData_scoreEditScreen['matchSetsWon_PlayerMIN'] == 0) {
      if (mapMatchData_scoreEditScreen['matchSetsWon_PlayerMIN'] == 0) {
        mapMatchData_scoreEditScreen['matchSetMAX'] = 2; // _maxSet
      } else {
        mapMatchData_scoreEditScreen['matchSetMAX'] = 3; // _maxSet
      }
    } else if (mapMatchData_scoreEditScreen['matchSetFormat'] == 'OneSet' ||
        mapMatchData_scoreEditScreen['matchSetFormat'] == 'ProSet') {
      mapMatchData_scoreEditScreen['matchSetMMAX'] = 1; // _maxmaxSet
      mapMatchData_scoreEditScreen['matchSetMAX'] = 1; // _maxSet
    } else {
      mapMatchData_scoreEditScreen['matchSetMMAX'] =
          1; // not supposed to happen // _maxmaxSet
      mapMatchData_scoreEditScreen['matchSetMAX'] =
          1; // not supposed to happen // _maxSet

      // print('_savePoint2FB.. _maxSet Calc Error: ' +
      //     mapMatchData_scoreEditScreen['matchSetFormat'] +
      //     '.. _setMax: ' +
      //     mapMatchData_scoreEditScreen['matchSetsWon_PlayerMAX'].toString() +
      //     '.. _setMin: ' +
      //     mapMatchData_scoreEditScreen['matchSetsWon_PlayerMIN'].toString());
    }

    // print('_savePoint2FB.. matchCurrSet: ' +
    //     mapMatchData_scoreEditScreen['matchCurrSet'].toString() +
    //     '.. matchSetMMAX: ' +
    //     mapMatchData_scoreEditScreen['matchSetMMAX'].toString() +
    //     '.. matchFinalSetFormat: ' +
    //     mapMatchData_scoreEditScreen['matchFinalSetFormat']);

    // Last Set
    if (mapMatchData_scoreEditScreen['matchCurrSet'] ==
            mapMatchData_scoreEditScreen['matchSetMMAX'] - 0 &&
        mapMatchData_scoreEditScreen['matchCurrSetGames_Player1'] ==
            mapMatchData_scoreEditScreen['matchCurrSetGames_Player2'] &&
        mapMatchData_scoreEditScreen['matchFinalSetFormat'] ==
            'SuperTieBreak') {
      mapMatchData_scoreEditScreen['matchCurrGameFormat'] =
          'SuperTieBreak'; // Final set has 1 Super Tiebreak game
    } else if ((mapMatchData_scoreEditScreen['matchCurrSet'] ==
                mapMatchData_scoreEditScreen['matchSetMMAX'] - 0 ||
            mapMatchData_scoreEditScreen['matchSetsWon_PlayerMAX'] ==
                mapMatchData_scoreEditScreen['matchSetMAX'] - 0) &&
        mapMatchData_scoreEditScreen['matchCurrSetGames_Player1'] ==
            mapMatchData_scoreEditScreen[
                'matchCurrSetGames_Player2'] && // Last Set
        mapMatchData_scoreEditScreen['matchCurrSetGames_PlayerMAX'] >=
            mapMatchData_scoreEditScreen['matchNumOfGamesPerSet'] -
                0 && // Last Game of Set
        mapMatchData_scoreEditScreen['matchFinalSetFormat'] == 'NoTieBreak') {
      mapMatchData_scoreEditScreen['matchCurrGameFormat'] =
          'NoTieBreak'; // Final set has no Tiebreak
    } else if (mapMatchData_scoreEditScreen['matchCurrSetGames_PlayerMAX'] >=
            mapMatchData_scoreEditScreen['matchNumOfGamesPerSet'] &&
        mapMatchData_scoreEditScreen['matchCurrSetGames_Player1'] ==
            mapMatchData_scoreEditScreen['matchCurrSetGames_Player2']) {
      mapMatchData_scoreEditScreen['matchCurrGameFormat'] =
          'TieBreak'; // Final set has Tiebreak
    } else {
      // NOT Last Set
      mapMatchData_scoreEditScreen['matchCurrGameFormat'] = 'Regular';
    }

    mapMatchData_scoreEditScreen['matchGameMAX'] =
        (mapMatchData_scoreEditScreen['matchCurrGameFormat'] == 'SuperTieBreak')
            ? 1
            : (mapMatchData_scoreEditScreen['matchCurrGameFormat'] ==
                    'TieBreak')
                ? mapMatchData_scoreEditScreen['matchNumOfGamesPerSet'] + 1
                : (mapMatchData_scoreEditScreen['matchCurrGameFormat'] ==
                        'NoTieBreak')
                    ? (mapMatchData_scoreEditScreen[
                                'matchCurrSetGames_PlayerDIFF'] >=
                            1)
                        ? mapMatchData_scoreEditScreen[
                                'matchCurrSetGames_PlayerMAX'] +
                            1
                        : 999
                    : mapMatchData_scoreEditScreen[
                        'matchNumOfGamesPerSet']; // _maxGame

    mapMatchData_scoreEditScreen['matchPtMAX'] =
        (mapMatchData_scoreEditScreen['matchCurrGameFormat'] == 'SuperTieBreak')
            ? 10
            : (mapMatchData_scoreEditScreen['matchCurrGameFormat'] ==
                    'TieBreak')
                ? 7
                : 4; // _maxPt
    mapMatchData_scoreEditScreen[
        'matchPtMAX'] = (mapMatchData_scoreEditScreen['matchAd'] == 'NoAd' &&
            (!([
              'SuperTieBreak',
              'TieBreak'
            ].contains(mapMatchData_scoreEditScreen['matchCurrGameFormat']))))
        ? 4
        : (mapMatchData_scoreEditScreen['matchCurrGamePts_PlayerMAX'] <
                    mapMatchData_scoreEditScreen['matchPtMAX'] &&
                mapMatchData_scoreEditScreen['matchCurrGamePts_PlayerDIFF'] >=
                    1)
            ? mapMatchData_scoreEditScreen['matchPtMAX']
            : (mapMatchData_scoreEditScreen['matchCurrGamePts_PlayerMAX'] >=
                        mapMatchData_scoreEditScreen['matchPtMAX'] &&
                    mapMatchData_scoreEditScreen[
                            'matchCurrGamePts_PlayerDIFF'] >=
                        1)
                ? mapMatchData_scoreEditScreen['matchCurrGamePts_PlayerMAX'] + 1
                : 999; // _maxPt

    globals.stringGameLeadingPlayer = (mapMatchData_scoreEditScreen[
                    'matchCurrGamePts_Player1'] ==
                mapMatchData_scoreEditScreen['matchCurrGamePts_PlayerMAX'] &&
            mapMatchData_scoreEditScreen['matchCurrGamePts_Player1'] ==
                mapMatchData_scoreEditScreen['matchCurrGamePts_Player2'])
        ? '9' // Tied and at game point
        : (mapMatchData_scoreEditScreen['matchCurrGamePts_Player1'] ==
                mapMatchData_scoreEditScreen['matchCurrGamePts_PlayerMAX'])
            ? '1'
            : (mapMatchData_scoreEditScreen['matchCurrGamePts_Player2'] ==
                    mapMatchData_scoreEditScreen['matchCurrGamePts_PlayerMAX'])
                ? '2'
                : '0';
    globals.boolGameLeadingPlayerWon = (globals.stringGameLeadingPlayer == '9')
        ? true
        : (mapPointData_scoreEditScreen['pointPtWon_PlayerNum'] ==
                globals.stringGameLeadingPlayer)
            ? true
            : false;

    globals.stringSetLeadingPlayer = (mapMatchData_scoreEditScreen[
                    'matchCurrSetGames_Player1'] ==
                mapMatchData_scoreEditScreen['matchCurrSetGames_PlayerMAX'] &&
            mapMatchData_scoreEditScreen['matchCurrSetGames_Player1'] ==
                mapMatchData_scoreEditScreen['matchCurrSetGames_Player2'])
        ? '9' // Tied and at game point
        : (mapMatchData_scoreEditScreen['matchCurrSetGames_Player1'] ==
                mapMatchData_scoreEditScreen['matchCurrSetGames_PlayerMAX'])
            ? '1'
            : (mapMatchData_scoreEditScreen['matchCurrSetGames_Player2'] ==
                    mapMatchData_scoreEditScreen['matchCurrSetGames_PlayerMAX'])
                ? '2'
                : '0';
    globals.boolSetLeadingPlayerWon = (globals.stringSetLeadingPlayer == '9')
        ? true
        : (mapPointData_scoreEditScreen['pointPtWon_PlayerNum'] ==
                globals.stringSetLeadingPlayer)
            ? true
            : false;

    globals.stringMatchLeadingPlayer =
        (mapMatchData_scoreEditScreen['matchSetsWon_Player1'] ==
                    mapMatchData_scoreEditScreen['matchSetsWon_PlayerMAX'] &&
                mapMatchData_scoreEditScreen['matchSetsWon_Player1'] ==
                    mapMatchData_scoreEditScreen['matchSetsWon_Player2'])
            ? '9' // Tied and at game point
            : (mapMatchData_scoreEditScreen['matchSetsWon_Player1'] ==
                    mapMatchData_scoreEditScreen['matchSetsWon_PlayerMAX'])
                ? '1'
                : (mapMatchData_scoreEditScreen['matchSetsWon_Player2'] ==
                        mapMatchData_scoreEditScreen['matchSetsWon_PlayerMAX'])
                    ? '2'
                    : '0';
    globals.boolMatchLeadingPlayerWon = (globals.stringMatchLeadingPlayer == '9')
        ? true
        : (mapPointData_scoreEditScreen['pointPtWon_PlayerNum'] ==
                globals.stringMatchLeadingPlayer)
            ? true
            : false;

    mapMatchData_scoreEditScreen['matchIsMatchPt'] = false;
    mapMatchData_scoreEditScreen['matchIsSetPt'] = false;
    mapMatchData_scoreEditScreen['matchIsGamePt'] = false;
    // Last Point of Game
    if (mapMatchData_scoreEditScreen['matchCurrGamePts_PlayerMAX'] >=
        mapMatchData_scoreEditScreen['matchPtMAX'] - 1) {
      mapMatchData_scoreEditScreen['matchIsGamePt'] = true;
      // Last Game of Set
      if (mapMatchData_scoreEditScreen['matchCurrSetGames_PlayerMAX'] >=
              mapMatchData_scoreEditScreen['matchGameMAX'] - 1) {
        mapMatchData_scoreEditScreen['matchIsSetPt'] = true;

        // Last Set of Match
        if ((mapMatchData_scoreEditScreen['matchSetsWon_PlayerMAX'] >=
                    mapMatchData_scoreEditScreen['matchSetMAX'] - 1 ||
                mapMatchData_scoreEditScreen['matchCurrSet'] >=
                    mapMatchData_scoreEditScreen['matchSetMMAX'] - 1)) {
          mapMatchData_scoreEditScreen['matchIsMatchPt'] = true;
        }
      }
    }
    // print('ScoreEditScreenState.. matchCurrGamePts_PlayerMAX: ${mapMatchData_scoreEditScreen['matchCurrGamePts_PlayerMAX'].toString()} matchPtMAX: ${mapMatchData_scoreEditScreen['matchPtMAX'].toString()}');
    // print('ScoreEditScreenState.. matchCurrSetGames_PlayerMAX: ${mapMatchData_scoreEditScreen['matchCurrSetGames_PlayerMAX'].toString()} matchGameMAX: ${mapMatchData_scoreEditScreen['matchGameMAX'].toString()}');
    // print('ScoreEditScreenState.. matchSetsWon_PlayerMAX: ${mapMatchData_scoreEditScreen['matchSetsWon_PlayerMAX'].toString()} matchSetMAX: ${mapMatchData_scoreEditScreen['matchSetMAX'].toString()}');
    // print('ScoreEditScreenState.. matchCurrSet: ${mapMatchData_scoreEditScreen['matchCurrSet'].toString()} matchSetMMAX: ${mapMatchData_scoreEditScreen['matchSetMMAX'].toString()}');
    //
    // print('ScoreEditScreenState LeadingPlayer.. Game: ${globals.stringGameLeadingPlayer.toString()} Set: ${globals.stringSetLeadingPlayer.toString()} Match: ${globals.stringMatchLeadingPlayer.toString()}');
    // print('ScoreEditScreenState Flag.. Game: ${mapMatchData_scoreEditScreen['matchIsGamePt'].toString()} Set: ${mapMatchData_scoreEditScreen['matchIsSetPt'].toString()} Match: ${mapMatchData_scoreEditScreen['matchIsMatchPt'].toString()}');

    // Update mapMatchData_ptEditScreen;
    mapMatchData_ptEditScreen = mapMatchData_scoreEditScreen;

    print('ScoreEditScreenState.. CurrSet: ' +
        mapMatchData_ptEditScreen['matchCurrSet'].runtimeType.toString() +
        '.. scoreEdit: ' +
        mapMatchData_scoreEditScreen['matchPriorSetGames_Player1']
            .runtimeType
            .toString());
    print('ScoreEditScreenState.. CurrSet: ' +
        mapMatchData_ptEditScreen['matchCurrSet'].toString() +
        '.. scoreEdit: ' +
        mapMatchData_scoreEditScreen['matchPriorSetGames_Player1'].toString());
    // print('ScoreEditScreenState.. PRE..  ptEdit: ' + mapMatchData_ptEditScreen['matchCurrGameScores_Player1'] + '.. scoreEdit: ' + mapMatchData_scoreEditScreen['matchCurrGameScores_Player1']);
    // print('ScoreEditScreenState.. PRE..  ptEdit: ' + mapMatchData_ptEditScreen['matchCurrGameScores_Player2'] + '.. scoreEdit: ' + mapMatchData_scoreEditScreen['matchCurrGameScores_Player2']);
    // print('ScoreEditScreenState.. POST.. ptEdit: ' + mapMatchData_ptEditScreen['matchCurrGameScores_Player1'] + '.. scoreEdit: ' + mapMatchData_scoreEditScreen['matchCurrGameScores_Player1']);
    // print('ScoreEditScreenState.. POST.. ptEdit: ' + mapMatchData_ptEditScreen['matchCurrGameScores_Player2'] + '.. scoreEdit: ' + mapMatchData_scoreEditScreen['matchCurrGameScores_Player2']);

    // Update mapMatchData_scoreEditScreen on FB >>>>>>>>>>>>>>>>>>>>>
    CollectionReference collectionReference =
        await FirebaseFirestore.instance.collection('Matches');
    // .doc(_matchID)
    // .collection('Points');
    collectionReference.doc(_matchID).set(mapMatchData_scoreEditScreen);

    // _args = matchScreenArgs(
    //     _matchID, mapMatchData_scoreEditScreen as Map<String, dynamic>);
    // // index, doc.data() as Map<String, dynamic>);
    // Navigator.of(context).pushNamed(
    //   MatchEditScreen.routeName,
    //   arguments: _args,
    // );

    //Navigator.of(context).pop();
    Navigator.of(context).pushNamed(
        MatchesScreen.routeName);

        // Navigator.of(context).pushNamed(PointEditScreen.routeName,
    //     arguments: mapMatchData_scoreEditScreen);
    // await Future.delayed(Duration(seconds: 1));

    // print('ScoreEditScreen _saveScore2FB: ' +
    //     mapMatchData_scoreEditScreen['matchID']);

    // reset Forms
    // keyForm_scoreEdit1.currentState!.reset();
    // keyForm_scoreEdit2.currentState!.reset();
  } // _saveScore2FB

  @override
  Widget build(BuildContext context) {
    // print('ScoreEditScreen ' + mapMatchData_scoreEditScreen['matchID']);

    return Scaffold(
        //resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text('Edit Scores'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: () {
                setState(() {
                  _saveScore2FB(mapMatchData_scoreEditScreen,
                      mapMatchData_scoreEditScreen['matchID']);
                });
              },
            ),
          ],
        ),
        drawer: AppDrawer(),
        floatingActionButton: new FloatingActionButton.extended(
          label: const Text(
            'NEXT',
            style: TextStyle(
                color: color_ScoreBoard_Icon, fontWeight: FontWeight.normal),
          ),
          onPressed: () {
            setState(() {
              _saveScore2FB(mapMatchData_scoreEditScreen,
                  mapMatchData_scoreEditScreen['matchID']);
              // Navigator.of(context)
              //     .pushNamed(ScoreEditScreen.routeName, arguments: '');
            });
          },
          backgroundColor: Palette.umMaize,
          icon: const Icon(
            // Icons.arrow_forward_ios_rounded,
            Icons.send,
            color: color_ScoreBoard_Icon,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        // floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
        //body: SingleChildScrollView(
        //  reverse: true,
        body: Padding(
          padding: const EdgeInsets.only(top: 5.0),
            child: ListView(
              //child: Column(
            children: <Widget>[
              Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    // height: 200,
                    height: MediaQuery.of(context).size.height *
                        pctHeight_PtAttrib *
                        4, // was 3
                    child: Form_PlayerScore(
                      keyForm: keyForm_scoreEdit1,
                      PlayerNum: '1',
                    ),
                  ), // const SizedBox(width: 8),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    // height: 200,
                    height: MediaQuery.of(context).size.height *
                        pctHeight_PtAttrib *
                        4, // was 3
                    child: Form_PlayerScore(
                      keyForm: keyForm_scoreEdit2,
                      PlayerNum: '2',
                    ),
                  ),
                ],
              ),
              // const Divider(
              //   height: 8,
              //   thickness: 1,
              //   indent: 8,
              //   endIndent: 8,
              //   color: Colors.grey,
              // ),
              const SizedBox(width: 10),
              Row(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: TextFormField(
                      controller: _currSetController,
                      decoration: InputDecoration(labelText: 'Current Set'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value!.isEmpty) {
                          return 'Please enter a number.';
                        }
                        if (int.tryParse(value!) == null) {
                          return 'Please enter a valid number.';
                        }
                        if (int.parse(value!) <= 0) {
                          return 'Please enter a number greater than zero.';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        mapMatchData_scoreEditScreen['matchCurrSet'] =
                            int.parse(value!);
                      },
                      onSaved: (value) {
                        mapMatchData_scoreEditScreen['matchCurrSet'] =
                            int.parse(value!);
                      },
                    ),
                  ),
                  // const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: TextFormField(
                        controller: _numOfGamesPerSetController,
                        decoration:
                            InputDecoration(labelText: 'Num Of Games Per Set'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value!.isEmpty) {
                            return 'Please enter a number.';
                          }
                          if (int.tryParse(value!) == null) {
                            return 'Please enter a valid number.';
                          }
                          if (int.parse(value!) <= 0) {
                            return 'Please enter a number greater than zero.';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          mapMatchData_scoreEditScreen[
                              'matchNumOfGamesPerSet'] = int.parse(value!);
                        },
                        onSaved: (value) {
                          mapMatchData_scoreEditScreen[
                              'matchNumOfGamesPerSet'] = int.parse(value!);
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: DropdownButtonFormField<String>(
                      value: _initValues_matchServicePlayerNum,
                      isExpanded: true,
                      decoration:
                          InputDecoration(labelText: 'Player to Serve: 1 or 2'),
                      onChanged: (String? value) {
                        setState(() {
                          mapMatchData_scoreEditScreen[
                              'matchService_PlayerNum'] = value!;
                        });
                      },
                      onSaved: (String? value) {
                        setState(() {
                          mapMatchData_scoreEditScreen[
                              'matchService_PlayerNum'] = value!;
                        });
                      },
                      items: ['1', '2'].map((String value) {
                        return DropdownMenuItem<String>(
                            value: value, child: Text(value));
                        // child: Text(value.toString()));
                      }).toList(),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: DropdownButtonFormField<MatchFormatSetOptions>(
                      value: _initValues_matchSetFormat,
                      isExpanded: true,
                      decoration: InputDecoration(labelText: 'Set Format'),
                      onChanged: (MatchFormatSetOptions? value) {
                        setState(() {
                          mapMatchData_scoreEditScreen['matchSetFormat'] =
                              describeEnum(value!).toString();
                        });
                      },
                      onSaved: (MatchFormatSetOptions? value) {
                        setState(() {
                          mapMatchData_scoreEditScreen['matchSetFormat'] =
                              describeEnum(value!).toString();
                        });
                      },
                      items: MatchFormatSetOptions.values
                          .map((MatchFormatSetOptions value) {
                        return DropdownMenuItem<MatchFormatSetOptions>(
                            value: value, child: Text(describeEnum(value)));
                        // child: Text(value.toString()));
                      }).toList(),
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: DropdownButtonFormField<MatchAdOptions>(
                        value: _initValues_matchAd,
                        isExpanded: true,
                        decoration: InputDecoration(labelText: 'Ad / No Ad'),
                        onChanged: (MatchAdOptions? value) {
                          setState(() {
                            mapMatchData_scoreEditScreen['matchAd'] =
                                describeEnum(value!).toString();
                          });
                        },
                        onSaved: (MatchAdOptions? value) {
                          setState(() {
                            mapMatchData_scoreEditScreen['matchAd'] =
                                describeEnum(value!).toString();
                          });
                        },
                        items:
                            MatchAdOptions.values.map((MatchAdOptions value) {
                          return DropdownMenuItem<MatchAdOptions>(
                              value: value, child: Text(describeEnum(value)));
                          // child: Text(value.toString()));
                        }).toList(),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child:
                          DropdownButtonFormField<MatchFormatFinalSetOptions>(
                        value: _initValues_matchFinalSetFormat,
                        isExpanded: true,
                        decoration:
                            InputDecoration(labelText: 'Final Set Format'),
                        onChanged: (MatchFormatFinalSetOptions? value) {
                          setState(() {
                            mapMatchData_scoreEditScreen[
                                    'matchFinalSetFormat'] =
                                describeEnum(value!).toString();
                          });
                        },
                        onSaved: (MatchFormatFinalSetOptions? value) {
                          setState(() {
                            mapMatchData_scoreEditScreen[
                                    'matchFinalSetFormat'] =
                                describeEnum(value!).toString();
                          });
                        },
                        items: MatchFormatFinalSetOptions.values
                            .map((MatchFormatFinalSetOptions value) {
                          return DropdownMenuItem<MatchFormatFinalSetOptions>(
                              value: value, child: Text(describeEnum(value)));
                          // child: Text(value.toString()));
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
              //Expanded(
              Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 1,
                    // height: 200,
                    height: MediaQuery.of(context).size.height *
                        pctHeight_PtAttrib *
                        2, // was 4
                    child: TextFormField(
                      controller: _noteController,
                      decoration: InputDecoration(
                        labelText: 'Notes',
                      ),
                      maxLines: 5,
                      keyboardType: TextInputType.multiline,
                      onChanged: (value) {
                        mapMatchData_scoreEditScreen['matchNotes'] = value;
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
