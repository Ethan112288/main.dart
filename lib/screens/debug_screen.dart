import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';

import '../firebase_options.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import '../config/palette.dart';
import '../config/globals.dart' as globals;

import '../widgets/app_drawer.dart';
//import '../screens/players_screen.dart';
//import '../screens/matches_screen.dart';
import '../screens/point_edit_screen.dart';
import '../screens/match_edit_screen.dart';
import '../screens/stat_screen.dart';

final pctWidth_DebugItem = 0.288;

Map<String, dynamic> _mapPointData =
new Map<String, dynamic>.from(mapPointData_INIT);
Map<String, dynamic> _mapMatchData =
new Map<String, dynamic>.from(mapMatchData_INIT);

class DebugScreenArgs {

  Map<String, dynamic> mapPointData = {};
  Map<String, dynamic> mapMatchData = {};

  DebugScreenArgs(this.mapPointData, this.mapMatchData);
}

class DebugScreen extends StatefulWidget with ChangeNotifier {
  static const routeName = '/debug_screen';

  @override
  DebugScreenState createState() => DebugScreenState();
}

class DebugScreenState extends State<DebugScreen> with ChangeNotifier {
  var _isInit = true;

  @override
  void didChangeDependencies() {

    if (_isInit) {
      final _args =
      ModalRoute
          .of(context)!
          .settings
          .arguments as DebugScreenArgs;
      _mapPointData = _args.mapPointData;
      _mapMatchData = _args.mapMatchData;

      _isInit = false;
      super.didChangeDependencies();
    }
  }

  @override
  Widget build(BuildContext context) {
    // print('ScoreEditScreen ' + _mapMatchData['matchID']);

    return Scaffold(
      appBar: AppBar(
      title: const Text('Debug - System Snapshot..'),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    ),
    drawer: AppDrawer(),
      body: ListView(
        padding: const EdgeInsets.only(top: 5.0),
        children: <Widget>[
        // SCORE BOARD
        Container(
        color: color_ScoreBoard_Bkgrd,
        height: MediaQuery.of(context).size.height * pctHeight_ScoreBoard,
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height *
                  pctHeight_ScoreBoard *
                  0.05,
            ),
            Container(
              height: MediaQuery.of(context).size.height *
                  pctHeight_ScoreBoard *
                  0.4,
              child: Row(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.05,
                  ),
                  Container(
                    // height: MediaQuery.of(context).size.height * pctHeight_ScoreBoard * 0.4 * 0.4,
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: <Widget>[
                            Text(
                              '${_mapMatchData['matchPlayer1FirstName']} ${_mapMatchData['matchPlayer1LastName'].toUpperCase()}',
                              style: TextStyle(
                                fontWeight: fontWeight_ScoreBoard_Name,
                                color: color_ScoreBoard_Text,
                                fontSize: fontSize_ScoreBoard,
                              ),
                            ),
                            (_mapPointData['pointService_PlayerNum'] ==
                                '1')
                                ? Icon(Icons.sports_baseball)
                                : SizedBox()
                          ],
                        )),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.05,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.15,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        // '0 0 0 0',
                        _mapMatchData['matchPriorSetGames_Player1']
                            .join(' '),
                        style: TextStyle(
                          fontWeight: fontWeight_ScoreBoard_PrevSets,
                          color: color_ScoreBoard_Text,
                          fontSize: fontSize_ScoreBoard,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.05,
                  ),
                  Expanded(
                    // width: MediaQuery.of(context).size.width * 0.25,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        // '0  0',
                        '${_mapMatchData['matchCurrSetGames_Player1']}  ${(_mapMatchData['matchCurrGameFormat'] == 'Regular' || _mapMatchData['matchIsMatchOver']) ? _mapMatchData['matchCurrGameScores_Player1'] : _mapMatchData['matchCurrGamePts_Player1']}',
                        style: TextStyle(
                          fontWeight: fontWeight_ScoreBoard_CurrSet,
                          color: color_ScoreBoard_Text,
                          fontSize: fontSize_ScoreBoard,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.05,
                  ),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height *
                  pctHeight_ScoreBoard *
                  0.1,
            ),
            Container(
              height: MediaQuery.of(context).size.height *
                  pctHeight_ScoreBoard *
                  0.4,
              child: Row(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.05,
                  ),
                  Container(
                    // height: MediaQuery.of(context).size.height * pctHeight_ScoreBoard * 0.4 * 0.4,
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: <Widget>[
                            Text(
                              '${_mapMatchData['matchPlayer2FirstName']} ${_mapMatchData['matchPlayer2LastName'].toUpperCase()}',
                              style: TextStyle(
                                fontWeight: fontWeight_ScoreBoard_Name,
                                color: color_ScoreBoard_Text,
                                fontSize: fontSize_ScoreBoard,
                              ),
                            ),
                            (_mapPointData['pointService_PlayerNum'] ==
                                '2')
                                ? Icon(Icons.sports_baseball)
                                : SizedBox()
                          ],
                        )),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.05,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.15,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        // '0 0 0 0',
                        _mapMatchData['matchPriorSetGames_Player2']
                            .join(' '),
                        style: TextStyle(
                          fontWeight: fontWeight_ScoreBoard_PrevSets,
                          color: color_ScoreBoard_Text,
                          fontSize: fontSize_ScoreBoard,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.05,
                  ),
                  Expanded(
                    // width: MediaQuery.of(context).size.width * 0.25,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        // '0  0',
                        '${_mapMatchData['matchCurrSetGames_Player2']}  ${(_mapMatchData['matchCurrGameFormat'] == 'Regular' || _mapMatchData['matchIsMatchOver']) ? _mapMatchData['matchCurrGameScores_Player2'] : _mapMatchData['matchCurrGamePts_Player2']}',
                        style: TextStyle(
                          fontWeight: fontWeight_ScoreBoard_CurrSet,
                          color: color_ScoreBoard_Text,
                          fontSize: fontSize_ScoreBoard,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.05,
                  ),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height *
                  pctHeight_ScoreBoard *
                  0.05,
            ),
          ],
        ),
      ),
      Container(
        width: double.infinity,
        height: height_StatSpace,
      ),

          Container(
            width: double.infinity,
            height: 5.0,
            // MediaQuery.of(context).size.height * pctHeight_PtAttrib / pctHeight_PtAttrib_DenomAdj,
          ),

          // General >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
          Row(children: <Widget>[
            Expanded(
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: <Widget>[
                      Text(
                        'Game Format',
                        style: TextStyle(
                          fontWeight: fontWeight_StatName,
                          color: color_StatName,
                          fontSize: fontSize_StatName,
                        ),
                      ),
                    ],
                  )),
            ),
            Container(
              width: MediaQuery.of(context).size.width *
                  pctWidth_DebugItem,
              height: MediaQuery.of(context).size.height *
                  pctHeight_StatItem,
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: <Widget>[
                      Text(
                        '${_mapMatchData['matchCurrGameFormat']}',
                        style: TextStyle(
                          fontWeight: fontWeight_StatItem,
                          color: color_StatItem,
                          fontSize: fontSize_StatItem,
                        ),
                      ),
                    ],
                  )),
            ),
          ]),

          Row(children: <Widget>[
            Expanded(
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: <Widget>[
                      Text(
                        'matchIsMatchOver',
                        style: TextStyle(
                          fontWeight: fontWeight_StatName,
                          color: color_StatName,
                          fontSize: fontSize_StatName,
                        ),
                      ),
                    ],
                  )),
            ),
            Container(
              width: MediaQuery.of(context).size.width *
                  pctWidth_DebugItem,
              height: MediaQuery.of(context).size.height *
                  pctHeight_StatItem,
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: <Widget>[
                      Text(
                        '${_mapMatchData['matchIsMatchOver']}',
                        style: TextStyle(
                          fontWeight: fontWeight_StatItem,
                          color: color_StatItem,
                          fontSize: fontSize_StatItem,
                        ),
                      ),
                    ],
                  )),
            ),
          ]),

          Row(children: <Widget>[
            Expanded(
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: <Widget>[
                      Text(
                        'matchIsMatchPt',
                        style: TextStyle(
                          fontWeight: fontWeight_StatName,
                          color: color_StatName,
                          fontSize: fontSize_StatName,
                        ),
                      ),
                    ],
                  )),
            ),
            Container(
              width: MediaQuery.of(context).size.width *
                  pctWidth_DebugItem,
              height: MediaQuery.of(context).size.height *
                  pctHeight_StatItem,
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: <Widget>[
                      Text(
                        '${_mapMatchData['matchIsMatchPt']}',
                        style: TextStyle(
                          fontWeight: fontWeight_StatItem,
                          color: color_StatItem,
                          fontSize: fontSize_StatItem,
                        ),
                      ),
                    ],
                  )),
            ),
          ]),

          Row(children: <Widget>[
            Expanded(
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: <Widget>[
                      Text(
                        'matchIsSetPt',
                        style: TextStyle(
                          fontWeight: fontWeight_StatName,
                          color: color_StatName,
                          fontSize: fontSize_StatName,
                        ),
                      ),
                    ],
                  )),
            ),
            Container(
              width: MediaQuery.of(context).size.width *
                  pctWidth_DebugItem,
              height: MediaQuery.of(context).size.height *
                  pctHeight_StatItem,
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: <Widget>[
                      Text(
                        '${_mapMatchData['matchIsSetPt']}',
                        style: TextStyle(
                          fontWeight: fontWeight_StatItem,
                          color: color_StatItem,
                          fontSize: fontSize_StatItem,
                        ),
                      ),
                    ],
                  )),
            ),
          ]),

          Row(children: <Widget>[
            Expanded(
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: <Widget>[
                      Text(
                        'matchIsGamePt',
                        style: TextStyle(
                          fontWeight: fontWeight_StatName,
                          color: color_StatName,
                          fontSize: fontSize_StatName,
                        ),
                      ),
                    ],
                  )),
            ),
            Container(
              width: MediaQuery.of(context).size.width *
                  pctWidth_DebugItem,
              height: MediaQuery.of(context).size.height *
                  pctHeight_StatItem,
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: <Widget>[
                      Text(
                        '${_mapMatchData['matchIsGamePt']}',
                        style: TextStyle(
                          fontWeight: fontWeight_StatItem,
                          color: color_StatItem,
                          fontSize: fontSize_StatItem,
                        ),
                      ),
                    ],
                  )),
            ),
          ]),

          Container(
            width: double.infinity,
            height: 5.0,
            // MediaQuery.of(context).size.height * pctHeight_PtAttrib / pctHeight_PtAttrib_DenomAdj,
          ),

      const Divider(
        height: 2,
        thickness: 1,
        indent: 8,
        endIndent: 8,
        color: Colors.grey,
      ),
      const Divider(
        height: 2,
        thickness: 1,
        indent: 8,
        endIndent: 8,
        color: Colors.grey,
      ),


          // LeadingPlayer >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
          Row(children: <Widget>[
            Expanded(
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: <Widget>[
                      Text(
                        'stringGameLeadingPlayer',
                        style: TextStyle(
                          fontWeight: fontWeight_StatName,
                          color: color_StatName,
                          fontSize: fontSize_StatName,
                        ),
                      ),
                    ],
                  )),
            ),
            Container(
              width: MediaQuery.of(context).size.width *
                  pctWidth_DebugItem,
              height: MediaQuery.of(context).size.height *
                  pctHeight_StatItem,
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: <Widget>[
                      Text(
                        '${globals.stringGameLeadingPlayer}',
                        style: TextStyle(
                          fontWeight: fontWeight_StatItem,
                          color: color_StatItem,
                          fontSize: fontSize_StatItem,
                        ),
                      ),
                    ],
                  )),
            ),
          ]),

          Row(children: <Widget>[
            Expanded(
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: <Widget>[
                      Text(
                        'boolGameLeadingPlayerWon',
                        style: TextStyle(
                          fontWeight: fontWeight_StatName,
                          color: color_StatName,
                          fontSize: fontSize_StatName,
                        ),
                      ),
                    ],
                  )),
            ),
            Container(
              width: MediaQuery.of(context).size.width *
                  pctWidth_DebugItem,
              height: MediaQuery.of(context).size.height *
                  pctHeight_StatItem,
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: <Widget>[
                      Text(
                        '${globals.boolGameLeadingPlayerWon}',
                        style: TextStyle(
                          fontWeight: fontWeight_StatItem,
                          color: color_StatItem,
                          fontSize: fontSize_StatItem,
                        ),
                      ),
                    ],
                  )),
            ),
          ]),

          Row(children: <Widget>[
            Expanded(
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: <Widget>[
                      Text(
                        'stringSetLeadingPlayer',
                        style: TextStyle(
                          fontWeight: fontWeight_StatName,
                          color: color_StatName,
                          fontSize: fontSize_StatName,
                        ),
                      ),
                    ],
                  )),
            ),
            Container(
              width: MediaQuery.of(context).size.width *
                  pctWidth_DebugItem,
              height: MediaQuery.of(context).size.height *
                  pctHeight_StatItem,
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: <Widget>[
                      Text(
                        '${globals.stringSetLeadingPlayer}',
                        style: TextStyle(
                          fontWeight: fontWeight_StatItem,
                          color: color_StatItem,
                          fontSize: fontSize_StatItem,
                        ),
                      ),
                    ],
                  )),
            ),
          ]),

          Row(children: <Widget>[
            Expanded(
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: <Widget>[
                      Text(
                        'boolSetLeadingPlayerWon',
                        style: TextStyle(
                          fontWeight: fontWeight_StatName,
                          color: color_StatName,
                          fontSize: fontSize_StatName,
                        ),
                      ),
                    ],
                  )),
            ),
            Container(
              width: MediaQuery.of(context).size.width *
                  pctWidth_DebugItem,
              height: MediaQuery.of(context).size.height *
                  pctHeight_StatItem,
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: <Widget>[
                      Text(
                        '${globals.boolSetLeadingPlayerWon}',
                        style: TextStyle(
                          fontWeight: fontWeight_StatItem,
                          color: color_StatItem,
                          fontSize: fontSize_StatItem,
                        ),
                      ),
                    ],
                  )),
            ),
          ]),

          Row(children: <Widget>[
            Expanded(
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: <Widget>[
                      Text(
                        'stringMatchLeadingPlayer',
                        style: TextStyle(
                          fontWeight: fontWeight_StatName,
                          color: color_StatName,
                          fontSize: fontSize_StatName,
                        ),
                      ),
                    ],
                  )),
            ),
            Container(
              width: MediaQuery.of(context).size.width *
                  pctWidth_DebugItem,
              height: MediaQuery.of(context).size.height *
                  pctHeight_StatItem,
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: <Widget>[
                      Text(
                        '${globals.stringMatchLeadingPlayer}',
                        style: TextStyle(
                          fontWeight: fontWeight_StatItem,
                          color: color_StatItem,
                          fontSize: fontSize_StatItem,
                        ),
                      ),
                    ],
                  )),
            ),
          ]),

          Row(children: <Widget>[
            Expanded(
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: <Widget>[
                      Text(
                        'boolMatchLeadingPlayerWon',
                        style: TextStyle(
                          fontWeight: fontWeight_StatName,
                          color: color_StatName,
                          fontSize: fontSize_StatName,
                        ),
                      ),
                    ],
                  )),
            ),
            Container(
              width: MediaQuery.of(context).size.width *
                  pctWidth_DebugItem,
              height: MediaQuery.of(context).size.height *
                  pctHeight_StatItem,
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: <Widget>[
                      Text(
                        '${globals.boolMatchLeadingPlayerWon}',
                        style: TextStyle(
                          fontWeight: fontWeight_StatItem,
                          color: color_StatItem,
                          fontSize: fontSize_StatItem,
                        ),
                      ),
                    ],
                  )),
            ),
          ]),

          Container(
            width: double.infinity,
            height: 5.0,
            // MediaQuery.of(context).size.height * pctHeight_PtAttrib / pctHeight_PtAttrib_DenomAdj,
          ),

          const Divider(
            height: 2,
            thickness: 1,
            indent: 8,
            endIndent: 8,
            color: Colors.grey,
          ),
          const Divider(
            height: 2,
            thickness: 1,
            indent: 8,
            endIndent: 8,
            color: Colors.grey,
          ),


          // matchPtMAX >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
          Row(children: <Widget>[
            Expanded(
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: <Widget>[
                      Text(
                        'matchPtMAX',
                        style: TextStyle(
                          fontWeight: fontWeight_StatName,
                          color: color_StatName,
                          fontSize: fontSize_StatName,
                        ),
                      ),
                    ],
                  )),
            ),
            Container(
              width: MediaQuery.of(context).size.width *
                  pctWidth_DebugItem,
              height: MediaQuery.of(context).size.height *
                  pctHeight_StatItem,
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: <Widget>[
                      Text(
                        '${_mapMatchData['matchPtMAX']}',
                        style: TextStyle(
                          fontWeight: fontWeight_StatItem,
                          color: color_StatItem,
                          fontSize: fontSize_StatItem,
                        ),
                      ),
                    ],
                  )),
            ),
          ]),

          Row(children: <Widget>[
            Expanded(
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: <Widget>[
                      Text(
                        'matchCurrGamePts_PlayerMAX',
                        style: TextStyle(
                          fontWeight: fontWeight_StatName,
                          color: color_StatName,
                          fontSize: fontSize_StatName,
                        ),
                      ),
                    ],
                  )),
            ),
            Container(
              width: MediaQuery.of(context).size.width *
                  pctWidth_DebugItem,
              height: MediaQuery.of(context).size.height *
                  pctHeight_StatItem,
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: <Widget>[
                      Text(
                        '${_mapMatchData['matchCurrGamePts_PlayerMAX']}',
                        style: TextStyle(
                          fontWeight: fontWeight_StatItem,
                          color: color_StatItem,
                          fontSize: fontSize_StatItem,
                        ),
                      ),
                    ],
                  )),
            ),
          ]),


          Row(children: <Widget>[
            Expanded(
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: <Widget>[
                      Text(
                        'matchCurrGamePts_Player1',
                        style: TextStyle(
                          fontWeight: fontWeight_StatName,
                          color: color_StatName,
                          fontSize: fontSize_StatName,
                        ),
                      ),
                    ],
                  )),
            ),
            Container(
              width: MediaQuery.of(context).size.width *
                  pctWidth_DebugItem,
              height: MediaQuery.of(context).size.height *
                  pctHeight_StatItem,
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: <Widget>[
                      Text(
                        '${_mapMatchData['matchCurrGamePts_Player1']}',
                        style: TextStyle(
                          fontWeight: fontWeight_StatItem,
                          color: color_StatItem,
                          fontSize: fontSize_StatItem,
                        ),
                      ),
                    ],
                  )),
            ),
          ]),


          Row(children: <Widget>[
            Expanded(
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: <Widget>[
                      Text(
                        'matchCurrGamePts_Player2',
                        style: TextStyle(
                          fontWeight: fontWeight_StatName,
                          color: color_StatName,
                          fontSize: fontSize_StatName,
                        ),
                      ),
                    ],
                  )),
            ),
            Container(
              width: MediaQuery.of(context).size.width *
                  pctWidth_DebugItem,
              height: MediaQuery.of(context).size.height *
                  pctHeight_StatItem,
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: <Widget>[
                      Text(
                        '${_mapMatchData['matchCurrGamePts_Player2']}',
                        style: TextStyle(
                          fontWeight: fontWeight_StatItem,
                          color: color_StatItem,
                          fontSize: fontSize_StatItem,
                        ),
                      ),
                    ],
                  )),
            ),
          ]),

          Container(
            width: double.infinity,
            height: 5.0,
            // MediaQuery.of(context).size.height * pctHeight_PtAttrib / pctHeight_PtAttrib_DenomAdj,
          ),

          const Divider(
            height: 2,
            thickness: 1,
            indent: 8,
            endIndent: 8,
            color: Colors.grey,
          ),
          const Divider(
            height: 2,
            thickness: 1,
            indent: 8,
            endIndent: 8,
            color: Colors.grey,
          ),


          // matchGameMAX >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
          Row(children: <Widget>[
            Expanded(
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: <Widget>[
                      Text(
                        'matchGameMAX',
                        style: TextStyle(
                          fontWeight: fontWeight_StatName,
                          color: color_StatName,
                          fontSize: fontSize_StatName,
                        ),
                      ),
                    ],
                  )),
            ),
            Container(
              width: MediaQuery.of(context).size.width *
                  pctWidth_DebugItem,
              height: MediaQuery.of(context).size.height *
                  pctHeight_StatItem,
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: <Widget>[
                      Text(
                        '${_mapMatchData['matchGameMAX']}',
                        style: TextStyle(
                          fontWeight: fontWeight_StatItem,
                          color: color_StatItem,
                          fontSize: fontSize_StatItem,
                        ),
                      ),
                    ],
                  )),
            ),
          ]),

          Row(children: <Widget>[
            Expanded(
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: <Widget>[
                      Text(
                        'matchCurrSetGames_PlayerMAX',
                        style: TextStyle(
                          fontWeight: fontWeight_StatName,
                          color: color_StatName,
                          fontSize: fontSize_StatName,
                        ),
                      ),
                    ],
                  )),
            ),
            Container(
              width: MediaQuery.of(context).size.width *
                  pctWidth_DebugItem,
              height: MediaQuery.of(context).size.height *
                  pctHeight_StatItem,
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: <Widget>[
                      Text(
                        '${_mapMatchData['matchCurrSetGames_PlayerMAX']}',
                        style: TextStyle(
                          fontWeight: fontWeight_StatItem,
                          color: color_StatItem,
                          fontSize: fontSize_StatItem,
                        ),
                      ),
                    ],
                  )),
            ),
          ]),


          Row(children: <Widget>[
            Expanded(
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: <Widget>[
                      Text(
                        'matchCurrSetGames_Player1',
                        style: TextStyle(
                          fontWeight: fontWeight_StatName,
                          color: color_StatName,
                          fontSize: fontSize_StatName,
                        ),
                      ),
                    ],
                  )),
            ),
            Container(
              width: MediaQuery.of(context).size.width *
                  pctWidth_DebugItem,
              height: MediaQuery.of(context).size.height *
                  pctHeight_StatItem,
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: <Widget>[
                      Text(
                        '${_mapMatchData['matchCurrSetGames_Player1']}',
                        style: TextStyle(
                          fontWeight: fontWeight_StatItem,
                          color: color_StatItem,
                          fontSize: fontSize_StatItem,
                        ),
                      ),
                    ],
                  )),
            ),
          ]),


          Row(children: <Widget>[
            Expanded(
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: <Widget>[
                      Text(
                        'matchCurrSetGames_Player2',
                        style: TextStyle(
                          fontWeight: fontWeight_StatName,
                          color: color_StatName,
                          fontSize: fontSize_StatName,
                        ),
                      ),
                    ],
                  )),
            ),
            Container(
              width: MediaQuery.of(context).size.width *
                  pctWidth_DebugItem,
              height: MediaQuery.of(context).size.height *
                  pctHeight_StatItem,
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: <Widget>[
                      Text(
                        '${_mapMatchData['matchCurrSetGames_Player2']}',
                        style: TextStyle(
                          fontWeight: fontWeight_StatItem,
                          color: color_StatItem,
                          fontSize: fontSize_StatItem,
                        ),
                      ),
                    ],
                  )),
            ),
          ]),

          Container(
            width: double.infinity,
            height: 5.0,
            // MediaQuery.of(context).size.height * pctHeight_PtAttrib / pctHeight_PtAttrib_DenomAdj,
          ),

          const Divider(
            height: 2,
            thickness: 1,
            indent: 8,
            endIndent: 8,
            color: Colors.grey,
          ),
          const Divider(
            height: 2,
            thickness: 1,
            indent: 8,
            endIndent: 8,
            color: Colors.grey,
          ),



          // matchSetMMAX >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
          Row(children: <Widget>[
            Expanded(
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: <Widget>[
                      Text(
                        'matchSetMMAX',
                        style: TextStyle(
                          fontWeight: fontWeight_StatName,
                          color: color_StatName,
                          fontSize: fontSize_StatName,
                        ),
                      ),
                    ],
                  )),
            ),
            Container(
              width: MediaQuery.of(context).size.width *
                  pctWidth_DebugItem,
              height: MediaQuery.of(context).size.height *
                  pctHeight_StatItem,
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: <Widget>[
                      Text(
                        '${_mapMatchData['matchSetMMAX']}',
                        style: TextStyle(
                          fontWeight: fontWeight_StatItem,
                          color: color_StatItem,
                          fontSize: fontSize_StatItem,
                        ),
                      ),
                    ],
                  )),
            ),
          ]),

          Row(children: <Widget>[
            Expanded(
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: <Widget>[
                      Text(
                        'matchCurrSet',
                        style: TextStyle(
                          fontWeight: fontWeight_StatName,
                          color: color_StatName,
                          fontSize: fontSize_StatName,
                        ),
                      ),
                    ],
                  )),
            ),
            Container(
              width: MediaQuery.of(context).size.width *
                  pctWidth_DebugItem,
              height: MediaQuery.of(context).size.height *
                  pctHeight_StatItem,
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: <Widget>[
                      Text(
                        '${_mapMatchData['matchCurrSet']}',
                        style: TextStyle(
                          fontWeight: fontWeight_StatItem,
                          color: color_StatItem,
                          fontSize: fontSize_StatItem,
                        ),
                      ),
                    ],
                  )),
            ),
          ]),

          Row(children: <Widget>[
            Expanded(
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: <Widget>[
                      Text(
                        'matchSetMAX',
                        style: TextStyle(
                          fontWeight: fontWeight_StatName,
                          color: color_StatName,
                          fontSize: fontSize_StatName,
                        ),
                      ),
                    ],
                  )),
            ),
            Container(
              width: MediaQuery.of(context).size.width *
                  pctWidth_DebugItem,
              height: MediaQuery.of(context).size.height *
                  pctHeight_StatItem,
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: <Widget>[
                      Text(
                        '${_mapMatchData['matchSetMAX']}',
                        style: TextStyle(
                          fontWeight: fontWeight_StatItem,
                          color: color_StatItem,
                          fontSize: fontSize_StatItem,
                        ),
                      ),
                    ],
                  )),
            ),
          ]),

          Row(children: <Widget>[
            Expanded(
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: <Widget>[
                      Text(
                        'matchSetsWon_PlayerMAX',
                        style: TextStyle(
                          fontWeight: fontWeight_StatName,
                          color: color_StatName,
                          fontSize: fontSize_StatName,
                        ),
                      ),
                    ],
                  )),
            ),
            Container(
              width: MediaQuery.of(context).size.width *
                  pctWidth_DebugItem,
              height: MediaQuery.of(context).size.height *
                  pctHeight_StatItem,
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: <Widget>[
                      Text(
                        '${_mapMatchData['matchSetsWon_PlayerMAX']}',
                        style: TextStyle(
                          fontWeight: fontWeight_StatItem,
                          color: color_StatItem,
                          fontSize: fontSize_StatItem,
                        ),
                      ),
                    ],
                  )),
            ),
          ]),


          Row(children: <Widget>[
            Expanded(
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: <Widget>[
                      Text(
                        'matchSetsWon_Player1',
                        style: TextStyle(
                          fontWeight: fontWeight_StatName,
                          color: color_StatName,
                          fontSize: fontSize_StatName,
                        ),
                      ),
                    ],
                  )),
            ),
            Container(
              width: MediaQuery.of(context).size.width *
                  pctWidth_DebugItem,
              height: MediaQuery.of(context).size.height *
                  pctHeight_StatItem,
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: <Widget>[
                      Text(
                        '${_mapMatchData['matchSetsWon_Player1']}',
                        style: TextStyle(
                          fontWeight: fontWeight_StatItem,
                          color: color_StatItem,
                          fontSize: fontSize_StatItem,
                        ),
                      ),
                    ],
                  )),
            ),
          ]),


          Row(children: <Widget>[
            Expanded(
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: <Widget>[
                      Text(
                        'matchSetsWon_Player2',
                        style: TextStyle(
                          fontWeight: fontWeight_StatName,
                          color: color_StatName,
                          fontSize: fontSize_StatName,
                        ),
                      ),
                    ],
                  )),
            ),
            Container(
              width: MediaQuery.of(context).size.width *
                  pctWidth_DebugItem,
              height: MediaQuery.of(context).size.height *
                  pctHeight_StatItem,
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: <Widget>[
                      Text(
                        '${_mapMatchData['matchSetsWon_Player2']}',
                        style: TextStyle(
                          fontWeight: fontWeight_StatItem,
                          color: color_StatItem,
                          fontSize: fontSize_StatItem,
                        ),
                      ),
                    ],
                  )),
            ),
          ]),

          Container(
            width: double.infinity,
            height: 5.0,
            // MediaQuery.of(context).size.height * pctHeight_PtAttrib / pctHeight_PtAttrib_DenomAdj,
          ),

          const Divider(
            height: 2,
            thickness: 1,
            indent: 8,
            endIndent: 8,
            color: Colors.grey,
          ),
          const Divider(
            height: 2,
            thickness: 1,
            indent: 8,
            endIndent: 8,
            color: Colors.grey,
          ),

        ],
      ),
    );
  }
}
