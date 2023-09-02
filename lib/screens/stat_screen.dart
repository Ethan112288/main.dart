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

import '../screens/players_screen.dart';
import '../screens/matches_screen.dart';
import '../screens/point_edit_screen.dart';

Map<String, dynamic> _mapPointData = {};
Map<String, dynamic> _mapMatchData = {};

final pctWidth_StatItem = 0.288;
final pctHeight_StatItem = 0.03;
final height_StatSpace = 0.5;
const fontSize_StatName = 15.0;
const fontSize_StatItem = 14.0;
// const fontWeight_StatName = FontWeight.normal;
const fontWeight_StatName = FontWeight.bold;
const fontWeight_StatItem = FontWeight.normal;
// const color_StatName = Palette.umMaize;
const color_StatName = Palette.umBlue;
const color_StatItem = Palette.umBlue;

class StatScreenArgs {
  Map<String, dynamic> _mapPointData = {};
  Map<String, dynamic> _mapMatchData = {};

  StatScreenArgs(this._mapPointData, this._mapMatchData);
}

class StatScreen extends StatefulWidget with ChangeNotifier {
  static const routeName = '/statistics';

  @override
  StatScreenState createState() => StatScreenState();
}

class StatScreenState extends State<StatScreen> with ChangeNotifier {
  var _isInit = true;

  @override
  void didChangeDependencies() {
    //didChangeDependencies is called just a few moments after the state loads its dependencies and context is available at this moment so here you can use context.

    // print('StatScreenState.. didChangeDependencies');
    // print('StatScreenState.. _isInit: ' + _isInit.toString());

    if (_isInit) {
      final _args =
      ModalRoute.of(context)!.settings.arguments as StatScreenArgs;
      _mapPointData = _args._mapPointData;
      _mapMatchData = _args._mapMatchData;
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<Map<String, dynamic>> _calcStats() async {
    Map<String, dynamic> _mapStats = {};
    String _Player1 = '1';
    String _Player2 = '2';
    int _tmpInt = 1;

    print('StatScreenState.. BOP.. ');

    // TOTAL >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    QuerySnapshot qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
        .get();
    _mapStats['statTotNum_PtsInMatch'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_PtsInMatch.. ' + _mapStats['statTotNum_PtsInMatch'].toString());

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
    // .where('pointService_PlayerNum', isEqualTo: _Player1)
        .where('pointPtWon_PlayerNum', isEqualTo: _Player1)
        .get();
    _mapStats['statTotNum_PtWon_Player1'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_PtWon_Player1.. ' + _mapStats['statTotNum_PtWon_Player1'].toString());

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
    // .where('pointService_PlayerNum', isEqualTo: _Player2)
        .where('pointPtWon_PlayerNum', isEqualTo: _Player2)
        .get();
    _mapStats['statTotNum_PtWon_Player2'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_PtWon_Player2.. ' + _mapStats['statTotNum_PtWon_Player2'].toString());

    _mapStats['statTotNum_TotPtsInMatch'] =
        _mapStats['statTotNum_PtWon_Player1'] +
            _mapStats['statTotNum_PtWon_Player2'];

    _mapStats['statMsg_PtWon_Player1'] =
    '${(_mapStats['statTotNum_PtWon_Player1'] / _mapStats['statTotNum_TotPtsInMatch'] * 100).round()}% (${_mapStats['statTotNum_PtWon_Player1']}/${_mapStats['statTotNum_TotPtsInMatch']})';
    _mapStats['statMsg_PtWon_Player2'] =
    '${(_mapStats['statTotNum_PtWon_Player2'] / _mapStats['statTotNum_TotPtsInMatch'] * 100).round()}% (${_mapStats['statTotNum_PtWon_Player2']}/${_mapStats['statTotNum_TotPtsInMatch']})';

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
        .where('pointPtWon_PlayerNum', isNotEqualTo: _Player1)
    // .where('pointPtWon_PlayerNum', isNotEqualTo: '0')
        .get();
    _mapStats['statTotNum_PtLost_Player1'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_PtLost_Player1.. ' + _mapStats['statTotNum_PtLost_Player1'].toString());

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
        .where('pointPtWon_PlayerNum', isNotEqualTo: _Player2)
    // .where('pointPtWon_PlayerNum', isNotEqualTo: '0')
        .get();
    _mapStats['statTotNum_PtLost_Player2'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_PtLost_Player2.. ' + _mapStats['statTotNum_PtLost_Player2'].toString());



    // _Player1 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    // Serves
    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
        .where('pointService_PlayerNum', isEqualTo: _Player1)
        .where('pointPtWon_PlayerNum', whereIn: ['1', '2']).get();
    _mapStats['statTotNum_ServiceGame_Player1'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_ServiceGame_Player1.. ' + _mapStats['statTotNum_ServiceGame_Player1'].toString());

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
        .where('pointService_PlayerNum', isEqualTo: _Player1)
        .where('pointPtWon_PlayerNum', isEqualTo: _Player1)
        .get();
    _mapStats['statTotNum_WonServiceGame_Player1'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_WonServiceGame_Player1.. ' + _mapStats['statTotNum_WonServiceGame_Player1'].toString());

    _mapStats['statMsg_WonServiceGame_Player1'] =
    '${(_mapStats['statTotNum_ServiceGame_Player1'] == 0) ? 0 : (_mapStats['statTotNum_WonServiceGame_Player1'] / _mapStats['statTotNum_ServiceGame_Player1'] * 100).round()}% (${_mapStats['statTotNum_WonServiceGame_Player1']}/${_mapStats['statTotNum_ServiceGame_Player1']})';

    // qSnap = await FirebaseFirestore.instance
    //     .collection('Matches')
    //     .doc(_mapMatchData['matchID'])
    //     .collection('Points')
    //     .where('pointService_PlayerNum', isNotEqualTo: _Player1)
    //     .get();
    // _mapStats['statTotNum_RecGame_Player1'] = qSnap.docs.length;
    _mapStats['statTotNum_RecGame_Player1'] =
        _mapStats['statTotNum_TotPtsInMatch'] -
            _mapStats['statTotNum_ServiceGame_Player1'];

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
        .where('pointService_PlayerNum', isNotEqualTo: _Player1)
        .where('pointPtWon_PlayerNum', isEqualTo: _Player1)
        .get();
    _mapStats['statTotNum_WonRecGame_Player1'] = qSnap.docs.length;

    _mapStats['statMsg_WonRecGame_Player1'] =
    '${(_mapStats['statTotNum_RecGame_Player1'] == 0) ? 0 : (_mapStats['statTotNum_WonRecGame_Player1'] / _mapStats['statTotNum_RecGame_Player1'] * 100).round()}% (${_mapStats['statTotNum_WonRecGame_Player1']}/${_mapStats['statTotNum_RecGame_Player1']})';

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
        .where('pointService_PlayerNum', isEqualTo: _Player1)
        .where('pointService_Type', whereIn: ['FirstServe']).get();
    _mapStats['statTotNum_FirstServe_Player1'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_FirstServe_Player1.. ' + _mapStats['statTotNum_FirstServe_Player1'].toString());

    _mapStats['statMsg_FirstServe_Player1'] =
    '${(_mapStats['statTotNum_ServiceGame_Player1'] == 0) ? 0 : (_mapStats['statTotNum_FirstServe_Player1'] / _mapStats['statTotNum_ServiceGame_Player1'] * 100).round()}% (${_mapStats['statTotNum_FirstServe_Player1']}/${_mapStats['statTotNum_ServiceGame_Player1']})';

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
        .where('pointService_PlayerNum', isEqualTo: _Player1)
        .where('pointService_Type', whereIn: ['SecondServe']).get();
    _mapStats['statTotNum_SecondServe_Player1'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_SecondServe_Player1.. ' + _mapStats['statTotNum_SecondServe_Player1'].toString());

    _mapStats['statMsg_SecondServe_Player1'] =
    '${(_mapStats['statTotNum_ServiceGame_Player1'] == 0) ? 0 : (_mapStats['statTotNum_SecondServe_Player1'] / _mapStats['statTotNum_ServiceGame_Player1'] * 100).round()}% (${_mapStats['statTotNum_SecondServe_Player1']}/${_mapStats['statTotNum_ServiceGame_Player1']})';

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
        .where('pointService_PlayerNum', isEqualTo: _Player1)
        .where('pointService_Type', whereIn: ['FirstServeRally']).get();
    _mapStats['statTotNum_FirstServeRally_Player1'] = qSnap.docs.length;

    _mapStats['statMsg_FirstServeRally_Player1'] =
    '${(_mapStats['statTotNum_ServiceGame_Player1'] == 0) ? 0 : (_mapStats['statTotNum_FirstServeRally_Player1'] / _mapStats['statTotNum_ServiceGame_Player1'] * 100).round()}% (${_mapStats['statTotNum_FirstServeRally_Player1']}/${_mapStats['statTotNum_ServiceGame_Player1']})';

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
        .where('pointService_PlayerNum', isEqualTo: _Player1)
        .where('pointService_Type', whereIn: ['SecondServeRally']).get();
    _mapStats['statTotNum_SecondServeRally_Player1'] = qSnap.docs.length;

    _mapStats['statMsg_SecondServeRally_Player1'] =
    '${(_mapStats['statTotNum_ServiceGame_Player1'] == 0) ? 0 : (_mapStats['statTotNum_SecondServeRally_Player1'] / _mapStats['statTotNum_ServiceGame_Player1'] * 100).round()}% (${_mapStats['statTotNum_SecondServeRally_Player1']}/${_mapStats['statTotNum_ServiceGame_Player1']})';
    _mapStats['statTotNum_TotFirstServe_Player1'] =
        _mapStats['statTotNum_FirstServe_Player1'] +
            _mapStats['statTotNum_FirstServeRally_Player1'];

    _mapStats['statMsg_FirstServeCompletion_Player1'] =
    '${(_mapStats['statTotNum_ServiceGame_Player1'] == 0) ? 0 : (_mapStats['statTotNum_TotFirstServe_Player1'] / _mapStats['statTotNum_ServiceGame_Player1'] * 100).round()}% (${_mapStats['statTotNum_TotFirstServe_Player1']}/${_mapStats['statTotNum_ServiceGame_Player1']})';

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
        .where('pointService_PlayerNum', isEqualTo: _Player1)
    // .where('pointPtWon_PlayerNum', isNotEqualTo: _Player1)
    // .where('pointPtWon_PlayerNum', isNotEqualTo: '0')
    // .where('pointService_Type', isEqualTo: 'SecondServe')
        .where('pointService_Type', isEqualTo: 'DoubleFault')
        .get();
    _mapStats['statTotNum_DoubleFault_Player1'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_DoubleFault_Player1.. ' + _mapStats['statTotNum_DoubleFault_Player1'].toString());

    _mapStats['statTotNum_TotSecondServe_Player1'] =
        _mapStats['statTotNum_SecondServe_Player1'] +
            _mapStats['statTotNum_SecondServeRally_Player1'] + _mapStats['statTotNum_DoubleFault_Player1'];

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
        .where('pointService_PlayerNum', isEqualTo: _Player1)
        .where('pointPtWon_PlayerNum', isEqualTo: _Player1)
        .where('pointService_Type', isEqualTo: 'FirstServe')
        .get();
    _mapStats['statTotNum_FirstServeAce_Player1'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_FirstServeAce_Player1.. ' + _mapStats['statTotNum_FirstServeAce_Player1'].toString());

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
        .where('pointService_PlayerNum', isEqualTo: _Player1)
        .where('pointPtWon_PlayerNum', isEqualTo: _Player1)
        .where('pointService_Type', isEqualTo: 'SecondServe')
        .get();
    _mapStats['statTotNum_SecondServeAce_Player1'] = qSnap.docs.length;

    // print('StatScreenState.. statTotNum_SecondServeAce_Player1.. ' + _mapStats['statTotNum_SecondServeAce_Player1'].toString());
    _mapStats['statTotNum_TotalAce_Player1'] =
        _mapStats['statTotNum_FirstServeAce_Player1'] +
            _mapStats['statTotNum_SecondServeAce_Player1'];

    _mapStats['statMsg_TotalAce_Player1'] =
    '${(_mapStats['statTotNum_ServiceGame_Player1'] == 0) ? 0 : (_mapStats['statTotNum_TotalAce_Player1'] / _mapStats['statTotNum_ServiceGame_Player1'] * 100).round()}% (${_mapStats['statTotNum_TotalAce_Player1']}/${_mapStats['statTotNum_ServiceGame_Player1']})';
    _mapStats['statMsg_FirstServeAce_Player1'] =
    '${(_mapStats['statTotNum_TotFirstServe_Player1'] == 0) ? 0 : (_mapStats['statTotNum_FirstServeAce_Player1'] / _mapStats['statTotNum_TotFirstServe_Player1'] * 100).round()}% (${_mapStats['statTotNum_FirstServeAce_Player1']}/${_mapStats['statTotNum_TotFirstServe_Player1']})';
    _mapStats['statMsg_SecondServeAce_Player1'] =
    '${(_mapStats['statTotNum_TotSecondServe_Player1'] == 0) ? 0 : (_mapStats['statTotNum_SecondServeAce_Player1'] / _mapStats['statTotNum_TotSecondServe_Player1'] * 100).round()}% (${_mapStats['statTotNum_SecondServeAce_Player1']}/${_mapStats['statTotNum_TotSecondServe_Player1']})';
    _mapStats['statMsg_DoubleFault_Player1'] =
    '${(_mapStats['statTotNum_TotSecondServe_Player1'] == 0) ? 0 : (_mapStats['statTotNum_DoubleFault_Player1'] / _mapStats['statTotNum_TotSecondServe_Player1'] * 100).round()}% (${_mapStats['statTotNum_DoubleFault_Player1']}/${_mapStats['statTotNum_TotSecondServe_Player1']})';

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
        .where('pointPtWon_PlayerNum', isEqualTo: _Player1)
    // .where('pointPtWon_PlayerNum', isNotEqualTo: _Player1)
    // .where('pointPtWon_PlayerNum', isNotEqualTo: '0')
        .where('pointPlayer1FoulBallLocation', isEqualTo: 'NA')
        .get();
    _mapStats['statTotNum_FoulBallNA_Player1'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_FoulBallNA_Player1.. ' + _mapStats['statTotNum_FoulBallNA_Player1'].toString());

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
    // .where('pointService_PlayerNum', isEqualTo: _Player1)
        .where('pointPtWon_PlayerNum', isNotEqualTo: _Player1)
    // .where('pointPtWon_PlayerNum', isNotEqualTo: '0')
        .where('pointPlayer1FoulBallLocation', isEqualTo: 'NA')
        .get();
    _mapStats['statTotNum_FoulBallNA_Player1'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_FoulBallNA_Player1.. ' + _mapStats['statTotNum_FoulBallNA_Player1'].toString());

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
    // .where('pointService_PlayerNum', isEqualTo: _Player1)
        .where('pointPtWon_PlayerNum', isNotEqualTo: _Player1)
    // .where('pointPtWon_PlayerNum', isNotEqualTo: '0')
        .where('pointPlayer1FoulBallLocation', isEqualTo: 'Net')
        .get();
    _mapStats['statTotNum_FoulBallNet_Player1'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_FoulBallNet_Player1.. ' + _mapStats['statTotNum_FoulBallNet_Player1'].toString());

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
    // .where('pointService_PlayerNum', isEqualTo: _Player1)
        .where('pointPtWon_PlayerNum', isNotEqualTo: _Player1)
    // .where('pointPtWon_PlayerNum', isNotEqualTo: '0')
        .where('pointPlayer1FoulBallLocation', isEqualTo: 'Back')
        .get();
    _mapStats['statTotNum_FoulBallBack_Player1'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_FoulBallBack_Player1.. ' + _mapStats['statTotNum_FoulBallBack_Player1'].toString());

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
    // .where('pointService_PlayerNum', isEqualTo: _Player1)
        .where('pointPtWon_PlayerNum', isNotEqualTo: _Player1)
    // .where('pointPtWon_PlayerNum', isNotEqualTo: '0')
        .where('pointPlayer1FoulBallLocation', isEqualTo: 'Side')
        .get();
    _mapStats['statTotNum_FoulBallSide_Player1'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_FoulBallSide_Player1.. ' + _mapStats['statTotNum_FoulBallSide_Player1'].toString());

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
    // .where('pointService_PlayerNum', isEqualTo: _Player1)
        .where('pointPtWon_PlayerNum', isNotEqualTo: _Player1)
    // .where('pointPtWon_PlayerNum', isNotEqualTo: '0')
        .where('pointPlayer1FoulBallLocation', isEqualTo: 'Shank')
        .get();
    _mapStats['statTotNum_FoulBallShank_Player1'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_FoulBallShank_Player1.. ' + _mapStats['statTotNum_FoulBallShank_Player1'].toString());

    _mapStats['statTotNum_ForcedError_Player1'] =
      _mapStats['statTotNum_FoulBallNA_Player1'] - _mapStats['statTotNum_DoubleFault_Player1'];
    _mapStats['statTotNum_UnforcedError_Player1'] =
        _mapStats['statTotNum_PtLost_Player1'] - _mapStats['statTotNum_ForcedError_Player1'];

    _mapStats['statMsg_UnforcedErrorTotPts_Player1'] =
    '${(_mapStats['statTotNum_TotPtsInMatch'] == 0) ? 0 : (_mapStats['statTotNum_UnforcedError_Player1'] / _mapStats['statTotNum_TotPtsInMatch'] * 100).round()}% (${_mapStats['statTotNum_UnforcedError_Player1']}/${_mapStats['statTotNum_TotPtsInMatch']})';
    _mapStats['statMsg_UnforcedError_Player1'] =
    '${(_mapStats['statTotNum_PtLost_Player1'] == 0) ? 0 : (_mapStats['statTotNum_UnforcedError_Player1'] / _mapStats['statTotNum_PtLost_Player1'] * 100).round()}% (${_mapStats['statTotNum_UnforcedError_Player1']}/${_mapStats['statTotNum_PtLost_Player1']})';
    _mapStats['statMsg_DoubleFaultPtLost_Player1'] =
    '${(_mapStats['statTotNum_PtLost_Player1'] == 0) ? 0 : (_mapStats['statTotNum_DoubleFault_Player1'] / _mapStats['statTotNum_PtLost_Player1'] * 100).round()}% (${_mapStats['statTotNum_DoubleFault_Player1']}/${_mapStats['statTotNum_PtLost_Player1']})';

    _mapStats['statMsg_FoulBallNA_Player1'] =
    '${(_mapStats['statTotNum_PtLost_Player1'] == 0) ? 0 : (_mapStats['statTotNum_FoulBallNA_Player1'] / _mapStats['statTotNum_PtLost_Player1'] * 100).round()}% (${_mapStats['statTotNum_FoulBallNA_Player1']}/${_mapStats['statTotNum_PtLost_Player1']})';
    _mapStats['statMsg_FoulBallNet_Player1'] =
    '${(_mapStats['statTotNum_PtLost_Player1'] == 0) ? 0 : (_mapStats['statTotNum_FoulBallNet_Player1'] / _mapStats['statTotNum_PtLost_Player1'] * 100).round()}% (${_mapStats['statTotNum_FoulBallNet_Player1']}/${_mapStats['statTotNum_PtLost_Player1']})';
    _mapStats['statMsg_FoulBallBack_Player1'] =
    '${(_mapStats['statTotNum_PtLost_Player1'] == 0) ? 0 : (_mapStats['statTotNum_FoulBallBack_Player1'] / _mapStats['statTotNum_PtLost_Player1'] * 100).round()}% (${_mapStats['statTotNum_FoulBallBack_Player1']}/${_mapStats['statTotNum_PtLost_Player1']})';
    _mapStats['statMsg_FoulBallSide_Player1'] =
    '${(_mapStats['statTotNum_PtLost_Player1'] == 0) ? 0 : (_mapStats['statTotNum_FoulBallSide_Player1'] / _mapStats['statTotNum_PtLost_Player1'] * 100).round()}% (${_mapStats['statTotNum_FoulBallSide_Player1']}/${_mapStats['statTotNum_PtLost_Player1']})';
    _mapStats['statMsg_FoulBallShank_Player1'] =
    '${(_mapStats['statTotNum_PtLost_Player1'] == 0) ? 0 : (_mapStats['statTotNum_FoulBallShank_Player1'] / _mapStats['statTotNum_PtLost_Player1'] * 100).round()}% (${_mapStats['statTotNum_FoulBallShank_Player1']}/${_mapStats['statTotNum_PtLost_Player1']})';

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
    // .where('pointService_PlayerNum', isEqualTo: _Player1)
    //     .where('pointPtWon_PlayerNum', isEqualTo: _Player1)
    //     .where('pointPtWon_PlayerNum', whereIn: ['1', '2'])
        .where('pointPlayer1Stroke',
        whereIn: ['Ground', 'Volley', 'Overhead', 'Dropshot', 'Slice', 'Push', 'Lob', 'OnTheRise', 'Deep']).get();
    _mapStats['statTotNum_StrokeALL_Player1'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_StrokeALL_Player1.. ' + _mapStats['statTotNum_StrokeALL_Player1'].toString());

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
    // .where('pointService_PlayerNum', isEqualTo: _Player1)
    //     .where('pointPtWon_PlayerNum', isEqualTo: _Player1)
    //     .where('pointPtWon_PlayerNum', whereIn: ['1', '2'])
        .where('pointPlayer1Stroke', whereIn: ['Ground']).get();
    _mapStats['statTotNum_StrokeGround_Player1'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_StrokeGround_Player1.. ' + _mapStats['statTotNum_StrokeGround_Player1'].toString());

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
    // .where('pointService_PlayerNum', isEqualTo: _Player1)
    //     .where('pointPtWon_PlayerNum', isEqualTo: _Player1)
    //     .where('pointPtWon_PlayerNum', whereIn: ['1', '2'])
        .where('pointPlayer1Stroke', whereIn: ['Volley']).get();
    _mapStats['statTotNum_StrokeVolley_Player1'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_StrokeVolley_Player1.. ' + _mapStats['statTotNum_StrokeVolley_Player1'].toString());

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
    // .where('pointService_PlayerNum', isEqualTo: _Player1)
    //     .where('pointPtWon_PlayerNum', isEqualTo: _Player1)
    //     .where('pointPtWon_PlayerNum', whereIn: ['1', '2'])
        .where('pointPlayer1Stroke', whereIn: ['Overhead']).get();
    _mapStats['statTotNum_StrokeOverhead_Player1'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_StrokeOverhead_Player1.. ' + _mapStats['statTotNum_StrokeOverhead_Player1'].toString());

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
    // .where('pointService_PlayerNum', isEqualTo: _Player1)
    //     .where('pointPtWon_PlayerNum', isEqualTo: _Player1)
    //     .where('pointPtWon_PlayerNum', whereIn: ['1', '2'])
        .where('pointPlayer1Stroke', whereIn: ['Dropshot']).get();
    _mapStats['statTotNum_StrokeDropshot_Player1'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_StrokeDropshot_Player1.. ' + _mapStats['statTotNum_StrokeDropshot_Player1'].toString());

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
    // .where('pointService_PlayerNum', isEqualTo: _Player1)
    //     .where('pointPtWon_PlayerNum', isEqualTo: _Player1)
    //     .where('pointPtWon_PlayerNum', whereIn: ['1', '2'])
        .where('pointPlayer1Stroke', whereIn: ['Slice']).get();
    _mapStats['statTotNum_StrokeSlice_Player1'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_StrokeSlice_Player1.. ' + _mapStats['statTotNum_StrokeSlice_Player1'].toString());

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
    // .where('pointService_PlayerNum', isEqualTo: _Player1)
    //     .where('pointPtWon_PlayerNum', isEqualTo: _Player1)
    //     .where('pointPtWon_PlayerNum', whereIn: ['1', '2'])
        .where('pointPlayer1Stroke', whereIn: ['Push']).get();
    _mapStats['statTotNum_StrokePush_Player1'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_StrokePush_Player1.. ' + _mapStats['statTotNum_StrokePush_Player1'].toString());

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
    // .where('pointService_PlayerNum', isEqualTo: _Player1)
    //     .where('pointPtWon_PlayerNum', isEqualTo: _Player1)
    //     .where('pointPtWon_PlayerNum', whereIn: ['1', '2'])
        .where('pointPlayer1Stroke', whereIn: ['Lob']).get();
    _mapStats['statTotNum_StrokeLob_Player1'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_StrokeLob_Player1.. ' + _mapStats['statTotNum_StrokeLob_Player1'].toString());

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
    // .where('pointService_PlayerNum', isEqualTo: _Player1)
    //     .where('pointPtWon_PlayerNum', isEqualTo: _Player1)
    //     .where('pointPtWon_PlayerNum', whereIn: ['1', '2'])
        .where('pointPlayer1Stroke', whereIn: ['OnTheRise']).get();
    _mapStats['statTotNum_StrokeOnTheRise_Player1'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_StrokeOnTheRise_Player1.. ' + _mapStats['statTotNum_StrokeOnTheRise_Player1'].toString());

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
    // .where('pointService_PlayerNum', isEqualTo: _Player1)
    //     .where('pointPtWon_PlayerNum', isEqualTo: _Player1)
    //     .where('pointPtWon_PlayerNum', whereIn: ['1', '2'])
        .where('pointPlayer1Stroke', whereIn: ['Deep']).get();
    _mapStats['statTotNum_StrokeDeep_Player1'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_StrokeDeep_Player1.. ' + _mapStats['statTotNum_StrokeDeep_Player1'].toString());

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
    // .where('pointService_PlayerNum', isEqualTo: _Player1)
        .where('pointPtWon_PlayerNum', isEqualTo: _Player1)
        .where('pointPlayer1Stroke',
        whereIn: ['Ground', 'Volley', 'Overhead', 'Dropshot', 'Slice', 'Push', 'Lob', 'OnTheRise', 'Deep']).get();
    _mapStats['statTotNum_PtWonStrokeALL_Player1'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_PtWonStrokeALL_Player1.. ' + _mapStats['statTotNum_PtWonStrokeALL_Player1'].toString());

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
    // .where('pointService_PlayerNum', isEqualTo: _Player1)
        .where('pointPtWon_PlayerNum', isEqualTo: _Player1)
        .where('pointPlayer1Stroke', whereIn: ['Ground']).get();
    _mapStats['statTotNum_PtWonStrokeGround_Player1'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_PtWonStrokeGround_Player1.. ' + _mapStats['statTotNum_PtWonStrokeGround_Player1'].toString());

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
    // .where('pointService_PlayerNum', isEqualTo: _Player1)
        .where('pointPtWon_PlayerNum', isEqualTo: _Player1)
        .where('pointPlayer1Stroke', whereIn: ['Volley']).get();
    _mapStats['statTotNum_PtWonStrokeVolley_Player1'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_PtWonStrokeVolley_Player1.. ' + _mapStats['statTotNum_PtWonStrokeVolley_Player1'].toString());

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
    // .where('pointService_PlayerNum', isEqualTo: _Player1)
        .where('pointPtWon_PlayerNum', isEqualTo: _Player1)
        .where('pointPlayer1Stroke', whereIn: ['Overhead']).get();
    _mapStats['statTotNum_PtWonStrokeOverhead_Player1'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_PtWonStrokeOverhead_Player1.. ' + _mapStats['statTotNum_PtWonStrokeOverhead_Player1'].toString());
    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
    // .where('pointService_PlayerNum', isEqualTo: _Player1)
        .where('pointPtWon_PlayerNum', isEqualTo: _Player1)
        .where('pointPlayer1Stroke', whereIn: ['Dropshot']).get();
    _mapStats['statTotNum_PtWonStrokeDropshot_Player1'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_PtWonStrokeDropshot_Player1.. ' + _mapStats['statTotNum_PtWonStrokeDropshot_Player1'].toString());

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
    // .where('pointService_PlayerNum', isEqualTo: _Player1)
        .where('pointPtWon_PlayerNum', isEqualTo: _Player1)
        .where('pointPlayer1Stroke', whereIn: ['Slice']).get();
    _mapStats['statTotNum_PtWonStrokeSlice_Player1'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_PtWonStrokeSlice_Player1.. ' + _mapStats['statTotNum_PtWonStrokeSlice_Player1'].toString());

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
    // .where('pointService_PlayerNum', isEqualTo: _Player1)
        .where('pointPtWon_PlayerNum', isEqualTo: _Player1)
        .where('pointPlayer1Stroke', whereIn: ['Push']).get();
    _mapStats['statTotNum_PtWonStrokePush_Player1'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_PtWonStrokePush_Player1.. ' + _mapStats['statTotNum_PtWonStrokePush_Player1'].toString());

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
    // .where('pointService_PlayerNum', isEqualTo: _Player1)
        .where('pointPtWon_PlayerNum', isEqualTo: _Player1)
        .where('pointPlayer1Stroke', whereIn: ['Lob']).get();
    _mapStats['statTotNum_PtWonStrokeLob_Player1'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_PtWonStrokeLob_Player1.. ' + _mapStats['statTotNum_PtWonStrokeLob_Player1'].toString());
    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
    // .where('pointService_PlayerNum', isEqualTo: _Player1)
        .where('pointPtWon_PlayerNum', isEqualTo: _Player1)
        .where('pointPlayer1Stroke', whereIn: ['OnTheRise']).get();
    _mapStats['statTotNum_PtWonStrokeOnTheRise_Player1'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_PtWonStrokeOnTheRise_Player1.. ' + _mapStats['statTotNum_PtWonStrokeOnTheRise_Player1'].toString());

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
    // .where('pointService_PlayerNum', isEqualTo: _Player1)
        .where('pointPtWon_PlayerNum', isEqualTo: _Player1)
        .where('pointPlayer1Stroke', whereIn: ['Deep']).get();
    _mapStats['statTotNum_PtWonStrokeDeep_Player1'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_PtWonStrokeDeep_Player1.. ' + _mapStats['statTotNum_PtWonStrokeDeep_Player1'].toString());

    _tmpInt = _mapStats['statTotNum_FirstServeRally_Player1'] +
        _mapStats['statTotNum_SecondServeRally_Player1'] +
        _mapStats['statTotNum_RecGame_Player1'];

    _mapStats['statMsg_StrokeALL_Player1'] =
    '${(_tmpInt == 0) ? 0 : (_mapStats['statTotNum_StrokeALL_Player1'] / _tmpInt * 100).round()}% (${_mapStats['statTotNum_StrokeALL_Player1']}/${_tmpInt})';
    _mapStats['statMsg_StrokeGround_Player1'] =
    '${(_mapStats['statTotNum_StrokeALL_Player1'] == 0) ? 0 : (_mapStats['statTotNum_StrokeGround_Player1'] / _mapStats['statTotNum_StrokeALL_Player1'] * 100).round()}% (${_mapStats['statTotNum_StrokeGround_Player1']}/${_mapStats['statTotNum_StrokeALL_Player1']})';
    _mapStats['statMsg_StrokeVolley_Player1'] =
    '${(_mapStats['statTotNum_StrokeALL_Player1'] == 0) ? 0 : (_mapStats['statTotNum_StrokeVolley_Player1'] / _mapStats['statTotNum_StrokeALL_Player1'] * 100).round()}% (${_mapStats['statTotNum_StrokeVolley_Player1']}/${_mapStats['statTotNum_StrokeALL_Player1']})';
    _mapStats['statMsg_StrokeOverhead_Player1'] =
    '${(_mapStats['statTotNum_StrokeALL_Player1'] == 0) ? 0 : (_mapStats['statTotNum_StrokeOverhead_Player1'] / _mapStats['statTotNum_StrokeALL_Player1'] * 100).round()}% (${_mapStats['statTotNum_StrokeOverhead_Player1']}/${_mapStats['statTotNum_StrokeALL_Player1']})';
    _mapStats['statMsg_StrokeDropshot_Player1'] =
    '${(_mapStats['statTotNum_StrokeALL_Player1'] == 0) ? 0 : (_mapStats['statTotNum_StrokeDropshot_Player1'] / _mapStats['statTotNum_StrokeALL_Player1'] * 100).round()}% (${_mapStats['statTotNum_StrokeDropshot_Player1']}/${_mapStats['statTotNum_StrokeALL_Player1']})';
    _mapStats['statMsg_StrokeSlice_Player1'] =
    '${(_mapStats['statTotNum_StrokeALL_Player1'] == 0) ? 0 : (_mapStats['statTotNum_StrokeSlice_Player1'] / _mapStats['statTotNum_StrokeALL_Player1'] * 100).round()}% (${_mapStats['statTotNum_StrokeSlice_Player1']}/${_mapStats['statTotNum_StrokeALL_Player1']})';
    _mapStats['statMsg_StrokePush_Player1'] =
    '${(_mapStats['statTotNum_StrokeALL_Player1'] == 0) ? 0 : (_mapStats['statTotNum_StrokePush_Player1'] / _mapStats['statTotNum_StrokeALL_Player1'] * 100).round()}% (${_mapStats['statTotNum_StrokePush_Player1']}/${_mapStats['statTotNum_StrokeALL_Player1']})';
    _mapStats['statMsg_StrokeLob_Player1'] =
    '${(_mapStats['statTotNum_StrokeALL_Player1'] == 0) ? 0 : (_mapStats['statTotNum_StrokeLob_Player1'] / _mapStats['statTotNum_StrokeALL_Player1'] * 100).round()}% (${_mapStats['statTotNum_StrokeLob_Player1']}/${_mapStats['statTotNum_StrokeALL_Player1']})';
    _mapStats['statMsg_StrokeOnTheRise_Player1'] =
    '${(_mapStats['statTotNum_StrokeALL_Player1'] == 0) ? 0 : (_mapStats['statTotNum_StrokeOnTheRise_Player1'] / _mapStats['statTotNum_StrokeALL_Player1'] * 100).round()}% (${_mapStats['statTotNum_StrokeOnTheRise_Player1']}/${_mapStats['statTotNum_StrokeALL_Player1']})';
    _mapStats['statMsg_StrokeDeep_Player1'] =
    '${(_mapStats['statTotNum_StrokeALL_Player1'] == 0) ? 0 : (_mapStats['statTotNum_StrokeDeep_Player1'] / _mapStats['statTotNum_StrokeALL_Player1'] * 100).round()}% (${_mapStats['statTotNum_StrokeDeep_Player1']}/${_mapStats['statTotNum_StrokeALL_Player1']})';

    _mapStats['statMsg_PtWonStrokeALL_Player1'] =
    '${(_mapStats['statTotNum_StrokeALL_Player1'] == 0) ? 0 : (_mapStats['statTotNum_PtWonStrokeALL_Player1'] / _mapStats['statTotNum_StrokeALL_Player1'] * 100).round()}% (${_mapStats['statTotNum_PtWonStrokeALL_Player1']}/${_mapStats['statTotNum_StrokeALL_Player1']})';
    _mapStats['statMsg_PtWonStrokeGround_Player1'] =
    '${(_mapStats['statTotNum_StrokeGround_Player1'] == 0) ? 0 : (_mapStats['statTotNum_PtWonStrokeGround_Player1'] / _mapStats['statTotNum_StrokeGround_Player1'] * 100).round()}% (${_mapStats['statTotNum_PtWonStrokeGround_Player1']}/${_mapStats['statTotNum_StrokeGround_Player1']})';
    _mapStats['statMsg_PtWonStrokeVolley_Player1'] =
    '${(_mapStats['statTotNum_StrokeVolley_Player1'] == 0) ? 0 : (_mapStats['statTotNum_PtWonStrokeVolley_Player1'] / _mapStats['statTotNum_StrokeVolley_Player1'] * 100).round()}% (${_mapStats['statTotNum_PtWonStrokeVolley_Player1']}/${_mapStats['statTotNum_StrokeVolley_Player1']})';
    _mapStats['statMsg_PtWonStrokeOverhead_Player1'] =
    '${(_mapStats['statTotNum_StrokeOverhead_Player1'] == 0) ? 0 : (_mapStats['statTotNum_PtWonStrokeOverhead_Player1'] / _mapStats['statTotNum_StrokeOverhead_Player1'] * 100).round()}% (${_mapStats['statTotNum_PtWonStrokeOverhead_Player1']}/${_mapStats['statTotNum_StrokeOverhead_Player1']})';
    _mapStats['statMsg_PtWonStrokeDropshot_Player1'] =
    '${(_mapStats['statTotNum_StrokeDropshot_Player1'] == 0) ? 0 : (_mapStats['statTotNum_PtWonStrokeDropshot_Player1'] / _mapStats['statTotNum_StrokeDropshot_Player1'] * 100).round()}% (${_mapStats['statTotNum_PtWonStrokeDropshot_Player1']}/${_mapStats['statTotNum_StrokeDropshot_Player1']})';
    _mapStats['statMsg_PtWonStrokeSlice_Player1'] =
    '${(_mapStats['statTotNum_StrokeSlice_Player1'] == 0) ? 0 : (_mapStats['statTotNum_PtWonStrokeSlice_Player1'] / _mapStats['statTotNum_StrokeSlice_Player1'] * 100).round()}% (${_mapStats['statTotNum_PtWonStrokeSlice_Player1']}/${_mapStats['statTotNum_StrokeSlice_Player1']})';
    _mapStats['statMsg_PtWonStrokePush_Player1'] =
    '${(_mapStats['statTotNum_StrokePush_Player1'] == 0) ? 0 : (_mapStats['statTotNum_PtWonStrokePush_Player1'] / _mapStats['statTotNum_StrokePush_Player1'] * 100).round()}% (${_mapStats['statTotNum_PtWonStrokePush_Player1']}/${_mapStats['statTotNum_StrokePush_Player1']})';
    _mapStats['statMsg_PtWonStrokeLob_Player1'] =
    '${(_mapStats['statTotNum_StrokeLob_Player1'] == 0) ? 0 : (_mapStats['statTotNum_PtWonStrokeLob_Player1'] / _mapStats['statTotNum_StrokeLob_Player1'] * 100).round()}% (${_mapStats['statTotNum_PtWonStrokeLob_Player1']}/${_mapStats['statTotNum_StrokeLob_Player1']})';
    _mapStats['statMsg_PtWonStrokeOnTheRise_Player1'] =
    '${(_mapStats['statTotNum_StrokeOnTheRise_Player1'] == 0) ? 0 : (_mapStats['statTotNum_PtWonStrokeOnTheRise_Player1'] / _mapStats['statTotNum_StrokeOnTheRise_Player1'] * 100).round()}% (${_mapStats['statTotNum_PtWonStrokeOnTheRise_Player1']}/${_mapStats['statTotNum_StrokeOnTheRise_Player1']})';
    _mapStats['statMsg_PtWonStrokeDeep_Player1'] =
    '${(_mapStats['statTotNum_StrokeDeep_Player1'] == 0) ? 0 : (_mapStats['statTotNum_PtWonStrokeDeep_Player1'] / _mapStats['statTotNum_StrokeDeep_Player1'] * 100).round()}% (${_mapStats['statTotNum_PtWonStrokeDeep_Player1']}/${_mapStats['statTotNum_StrokeDeep_Player1']})';

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
    // .where('pointService_PlayerNum', isEqualTo: _Player1)
    //     .where('pointPtWon_PlayerNum', isEqualTo: _Player1)
    //     .where('pointPtWon_PlayerNum', whereIn: ['1', '2'])
        .where('pointPlayer1Location',
        whereIn: ['Baseline', 'Approach', 'Net']).get();
    _mapStats['statTotNum_LocALL_Player1'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_LocALL_Player1.. ' + _mapStats['statTotNum_LocALL_Player1'].toString());

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
    // .where('pointService_PlayerNum', isEqualTo: _Player1)
    //     .where('pointPtWon_PlayerNum', isEqualTo: _Player1)
    //     .where('pointPtWon_PlayerNum', whereIn: ['1', '2'])
        .where('pointPlayer1Location', whereIn: ['Baseline']).get();
    _mapStats['statTotNum_LocBaseline_Player1'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_LocBaseline_Player1.. ' + _mapStats['statTotNum_LocBaseline_Player1'].toString());

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
    // .where('pointService_PlayerNum', isEqualTo: _Player1)
    //     .where('pointPtWon_PlayerNum', isEqualTo: _Player1)
    //     .where('pointPtWon_PlayerNum', whereIn: ['1', '2'])
        .where('pointPlayer1Location', whereIn: ['Approach']).get();
    _mapStats['statTotNum_LocApproach_Player1'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_LocApproach_Player1.. ' + _mapStats['statTotNum_LocApproach_Player1'].toString());

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
    // .where('pointService_PlayerNum', isEqualTo: _Player1)
    //     .where('pointPtWon_PlayerNum', isEqualTo: _Player1)
    //     .where('pointPtWon_PlayerNum', whereIn: ['1', '2'])
        .where('pointPlayer1Location', whereIn: ['Net']).get();
    _mapStats['statTotNum_LocNet_Player1'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_LocNet_Player1.. ' + _mapStats['statTotNum_LocNet_Player1'].toString());

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
    // .where('pointService_PlayerNum', isEqualTo: _Player1)
        .where('pointPtWon_PlayerNum', isEqualTo: _Player1)
        .where('pointPlayer1Location',
        whereIn: ['Baseline', 'Approach', 'Net']).get();
    _mapStats['statTotNum_PtWonLocALL_Player1'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_PtWonLocALL_Player1.. ' + _mapStats['statTotNum_PtWonLocALL_Player1'].toString());

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
    // .where('pointService_PlayerNum', isEqualTo: _Player1)
        .where('pointPtWon_PlayerNum', isEqualTo: _Player1)
        .where('pointPlayer1Location', whereIn: ['Baseline']).get();
    _mapStats['statTotNum_PtWonLocBaseline_Player1'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_PtWonLocBaseline_Player1.. ' + _mapStats['statTotNum_PtWonLocBaseline_Player1'].toString());

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
    // .where('pointService_PlayerNum', isEqualTo: _Player1)
        .where('pointPtWon_PlayerNum', isEqualTo: _Player1)
        .where('pointPlayer1Location', whereIn: ['Approach']).get();
    _mapStats['statTotNum_PtWonLocApproach_Player1'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_PtWonLocApproach_Player1.. ' + _mapStats['statTotNum_PtWonLocApproach_Player1'].toString());

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
    // .where('pointService_PlayerNum', isEqualTo: _Player1)
        .where('pointPtWon_PlayerNum', isEqualTo: _Player1)
        .where('pointPlayer1Location', whereIn: ['Net']).get();
    _mapStats['statTotNum_PtWonLocNet_Player1'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_PtWonLocNet_Player1.. ' + _mapStats['statTotNum_PtWonLocNet_Player1'].toString());

    _tmpInt = _mapStats['statTotNum_FirstServeRally_Player1'] +
        _mapStats['statTotNum_SecondServeRally_Player1'] +
        _mapStats['statTotNum_RecGame_Player1'];

    _mapStats['statMsg_LocALL_Player1'] =
    '${(_tmpInt == 0) ? 0 : (_mapStats['statTotNum_LocALL_Player1'] / _tmpInt * 100).round()}% (${_mapStats['statTotNum_LocALL_Player1']}/${_tmpInt})';
    _mapStats['statMsg_LocBaseline_Player1'] =
    '${(_mapStats['statTotNum_LocALL_Player1'] == 0) ? 0 : (_mapStats['statTotNum_LocBaseline_Player1'] / _mapStats['statTotNum_LocALL_Player1'] * 100).round()}% (${_mapStats['statTotNum_LocBaseline_Player1']}/${_mapStats['statTotNum_LocALL_Player1']})';
    _mapStats['statMsg_LocApproach_Player1'] =
    '${(_mapStats['statTotNum_LocALL_Player1'] == 0) ? 0 : (_mapStats['statTotNum_LocApproach_Player1'] / _mapStats['statTotNum_LocALL_Player1'] * 100).round()}% (${_mapStats['statTotNum_LocApproach_Player1']}/${_mapStats['statTotNum_LocALL_Player1']})';
    _mapStats['statMsg_LocNet_Player1'] =
    '${(_mapStats['statTotNum_LocALL_Player1'] == 0) ? 0 : (_mapStats['statTotNum_LocNet_Player1'] / _mapStats['statTotNum_LocALL_Player1'] * 100).round()}% (${_mapStats['statTotNum_LocNet_Player1']}/${_mapStats['statTotNum_LocALL_Player1']})';

    _mapStats['statMsg_PtWonLocALL_Player1'] =
    '${(_mapStats['statTotNum_LocALL_Player1'] == 0) ? 0 : (_mapStats['statTotNum_PtWonLocALL_Player1'] / _mapStats['statTotNum_LocALL_Player1'] * 100).round()}% (${_mapStats['statTotNum_PtWonLocALL_Player1']}/${_mapStats['statTotNum_LocALL_Player1']})';
    _mapStats['statMsg_PtWonLocBaseline_Player1'] =
    '${(_mapStats['statTotNum_LocBaseline_Player1'] == 0) ? 0 : (_mapStats['statTotNum_PtWonLocBaseline_Player1'] / _mapStats['statTotNum_LocBaseline_Player1'] * 100).round()}% (${_mapStats['statTotNum_PtWonLocBaseline_Player1']}/${_mapStats['statTotNum_LocBaseline_Player1']})';
    _mapStats['statMsg_PtWonLocApproach_Player1'] =
    '${(_mapStats['statTotNum_LocApproach_Player1'] == 0) ? 0 : (_mapStats['statTotNum_PtWonLocApproach_Player1'] / _mapStats['statTotNum_LocApproach_Player1'] * 100).round()}% (${_mapStats['statTotNum_PtWonLocApproach_Player1']}/${_mapStats['statTotNum_LocApproach_Player1']})';
    _mapStats['statMsg_PtWonLocNet_Player1'] =
    '${(_mapStats['statTotNum_LocNet_Player1'] == 0) ? 0 : (_mapStats['statTotNum_PtWonLocNet_Player1'] / _mapStats['statTotNum_LocNet_Player1'] * 100).round()}% (${_mapStats['statTotNum_PtWonLocNet_Player1']}/${_mapStats['statTotNum_LocNet_Player1']})';
    // print('StatScreenState.. DEBUG1.. ');

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
    // .where('pointService_PlayerNum', isEqualTo: _Player1)
    //     .where('pointPtWon_PlayerNum', isEqualTo: _Player1)
    //     .where('pointPtWon_PlayerNum', whereIn: ['1', '2'])
        .where('pointPlayer1Stroke', whereIn: [
      'Ground',
      'Volley',
      'Overhead',
      'Dropshot',
      'Slice',
      'Push',
      'Lob',
      'OnTheRise',
      'Deep'
    ])
    // .where('pointPlayer1Hand', whereIn: ['Fore', 'Back'])
        .get();
    _mapStats['statTotNum_HandALL_Player1'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_HandALL_Player1.. ' + _mapStats['statTotNum_HandALL_Player1'].toString());

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
    // .where('pointService_PlayerNum', isEqualTo: _Player1)
    //     .where('pointPtWon_PlayerNum', isEqualTo: _Player1)
    //     .where('pointPtWon_PlayerNum', whereIn: ['1', '2'])
        .where('pointPlayer1Stroke', whereIn: [
      'Ground',
      'Volley',
      'Overhead',
      'Dropshot',
      'Slice',
      'Push',
      'Lob',
      'OnTheRise',
      'Deep'
    ]).where('pointPlayer1Hand', isEqualTo: 'Fore').get();
    _mapStats['statTotNum_HandFore_Player1'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_HandFore_Player1.. ' + _mapStats['statTotNum_HandFore_Player1'].toString());

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
    // .where('pointService_PlayerNum', isEqualTo: _Player1)
    //     .where('pointPtWon_PlayerNum', isEqualTo: _Player1)
    //     .where('pointPtWon_PlayerNum', whereIn: ['1', '2'])
        .where('pointPlayer1Stroke', whereIn: [
      'Ground',
      'Volley',
      'Overhead',
      'Dropshot',
      'Slice',
      'Push',
      'Lob',
      'OnTheRise',
      'Deep'
    ]).where('pointPlayer1Hand', isEqualTo: 'Back').get();
    _mapStats['statTotNum_HandBack_Player1'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_HandBack_Player1.. ' + _mapStats['statTotNum_HandBack_Player1'].toString());


    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
    // .where('pointService_PlayerNum', isEqualTo: _Player1)
    //     .where('pointPtWon_PlayerNum', isEqualTo: _Player1)
    //     .where('pointPtWon_PlayerNum', whereIn: ['1', '2'])
        .where('pointPlayer1Stroke', whereIn: [
      'Ground',
      'Volley',
      'Overhead',
      'Dropshot',
      'Slice',
      'Push',
      'Lob',
      'OnTheRise',
      'Deep'
    ]).where('pointPlayer1Hand', isEqualTo: 'ForeXCourt').get();
    _mapStats['statTotNum_HandForeXCourt_Player1'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_HandForeXCourt_Player1.. ' + _mapStats['statTotNum_HandForeXCourt_Player1'].toString());

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
    // .where('pointService_PlayerNum', isEqualTo: _Player1)
    //     .where('pointPtWon_PlayerNum', isEqualTo: _Player1)
    //     .where('pointPtWon_PlayerNum', whereIn: ['1', '2'])
        .where('pointPlayer1Stroke', whereIn: [
      'Ground',
      'Volley',
      'Overhead',
      'Dropshot',
      'Slice',
      'Push',
      'Lob',
      'OnTheRise',
      'Deep'
    ]).where('pointPlayer1Hand', isEqualTo: 'BackXCourt').get();
    _mapStats['statTotNum_HandBackXCourt_Player1'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_HandBackXCourt_Player1.. ' + _mapStats['statTotNum_HandBackXCourt_Player1'].toString());

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
    // .where('pointService_PlayerNum', isEqualTo: _Player1)
        .where('pointPtWon_PlayerNum', isEqualTo: _Player1)
        .where('pointPlayer1Stroke', whereIn: [
      'Ground',
      'Volley',
      'Overhead',
      'Dropshot',
      'Slice',
      'Push',
      'Lob',
      'OnTheRise',
      'Deep'
    ])
    // .where('pointPlayer1Hand', whereIn: ['Fore', 'Back'])
        .get();
    _mapStats['statTotNum_PtWonHandALL_Player1'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_PtWonHandALL_Player1.. ' + _mapStats['statTotNum_PtWonHandALL_Player1'].toString());

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
    // .where('pointService_PlayerNum', isEqualTo: _Player1)
        .where('pointPtWon_PlayerNum', isEqualTo: _Player1)
        .where('pointPlayer1Stroke', whereIn: [
      'Ground',
      'Volley',
      'Overhead',
      'Dropshot',
      'Slice',
      'Push',
      'Lob',
      'OnTheRise',
      'Deep'
    ]).where('pointPlayer1Hand', isEqualTo: 'Fore').get();
    _mapStats['statTotNum_PtWonHandFore_Player1'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_PtWonHandFore_Player1.. ' + _mapStats['statTotNum_PtWonHandFore_Player1'].toString());

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
    // .where('pointService_PlayerNum', isEqualTo: _Player1)
        .where('pointPtWon_PlayerNum', isEqualTo: _Player1)
        .where('pointPlayer1Stroke', whereIn: [
      'Ground',
      'Volley',
      'Overhead',
      'Dropshot',
      'Slice',
      'Push',
      'Lob',
      'OnTheRise',
      'Deep'
    ]).where('pointPlayer1Hand', isEqualTo: 'Back').get();
    _mapStats['statTotNum_PtWonHandBack_Player1'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_PtWonHandBack_Player1.. ' + _mapStats['statTotNum_PtWonHandBack_Player1'].toString());

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
    // .where('pointService_PlayerNum', isEqualTo: _Player1)
        .where('pointPtWon_PlayerNum', isEqualTo: _Player1)
        .where('pointPlayer1Stroke', whereIn: [
      'Ground',
      'Volley',
      'Overhead',
      'Dropshot',
      'Slice',
      'Push',
      'Lob',
      'OnTheRise',
      'Deep'
    ]).where('pointPlayer1Hand', isEqualTo: 'ForeXCourt').get();
    _mapStats['statTotNum_PtWonHandForeXCourt_Player1'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_PtWonHandForeXCourt_Player1.. ' + _mapStats['statTotNum_PtWonHandForeXCourt_Player1'].toString());

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
    // .where('pointService_PlayerNum', isEqualTo: _Player1)
        .where('pointPtWon_PlayerNum', isEqualTo: _Player1)
        .where('pointPlayer1Stroke', whereIn: [
      'Ground',
      'Volley',
      'Overhead',
      'Dropshot',
      'Slice',
      'Push',
      'Lob',
      'OnTheRise',
      'Deep'
    ]).where('pointPlayer1Hand', isEqualTo: 'BackXCourt').get();
    _mapStats['statTotNum_PtWonHandBackXCourt_Player1'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_PtWonHandBackXCourt_Player1.. ' + _mapStats['statTotNum_PtWonHandBackXCourt_Player1'].toString());

    _tmpInt = _mapStats['statTotNum_FirstServeRally_Player1'] +
        _mapStats['statTotNum_SecondServeRally_Player1'] +
        _mapStats['statTotNum_RecGame_Player1'];
    _mapStats['statMsg_HandALL_Player1'] =
    '${(_tmpInt == 0) ? 0 : (_mapStats['statTotNum_HandALL_Player1'] / _tmpInt * 100).round()}% (${_mapStats['statTotNum_HandALL_Player1']}/${_tmpInt})';
    _mapStats['statMsg_HandFore_Player1'] =
    '${(_mapStats['statTotNum_HandALL_Player1'] == 0) ? 0 : (_mapStats['statTotNum_HandFore_Player1'] / _mapStats['statTotNum_HandALL_Player1'] * 100).round()}% (${_mapStats['statTotNum_HandFore_Player1']}/${_mapStats['statTotNum_HandALL_Player1']})';
    _mapStats['statMsg_HandBack_Player1'] =
    '${(_mapStats['statTotNum_HandALL_Player1'] == 0) ? 0 : (_mapStats['statTotNum_HandBack_Player1'] / _mapStats['statTotNum_HandALL_Player1'] * 100).round()}% (${_mapStats['statTotNum_HandBack_Player1']}/${_mapStats['statTotNum_HandALL_Player1']})';
    _mapStats['statMsg_HandForeXCourt_Player1'] =
    '${(_mapStats['statTotNum_HandALL_Player1'] == 0) ? 0 : (_mapStats['statTotNum_HandForeXCourt_Player1'] / _mapStats['statTotNum_HandALL_Player1'] * 100).round()}% (${_mapStats['statTotNum_HandForeXCourt_Player1']}/${_mapStats['statTotNum_HandALL_Player1']})';
    _mapStats['statMsg_HandBackXCourt_Player1'] =
    '${(_mapStats['statTotNum_HandALL_Player1'] == 0) ? 0 : (_mapStats['statTotNum_HandBackXCourt_Player1'] / _mapStats['statTotNum_HandALL_Player1'] * 100).round()}% (${_mapStats['statTotNum_HandBackXCourt_Player1']}/${_mapStats['statTotNum_HandALL_Player1']})';

    _mapStats['statMsg_PtWonHandALL_Player1'] =
    '${(_mapStats['statTotNum_HandALL_Player1'] == 0) ? 0 : (_mapStats['statTotNum_PtWonHandALL_Player1'] / _mapStats['statTotNum_HandALL_Player1'] * 100).round()}% (${_mapStats['statTotNum_PtWonHandALL_Player1']}/${_mapStats['statTotNum_HandALL_Player1']})';
    _mapStats['statMsg_PtWonHandFore_Player1'] =
    '${(_mapStats['statTotNum_HandFore_Player1'] == 0) ? 0 : (_mapStats['statTotNum_PtWonHandFore_Player1'] / _mapStats['statTotNum_HandFore_Player1'] * 100).round()}% (${_mapStats['statTotNum_PtWonHandFore_Player1']}/${_mapStats['statTotNum_HandFore_Player1']})';
    _mapStats['statMsg_PtWonHandBack_Player1'] =
    '${(_mapStats['statTotNum_HandBack_Player1'] == 0) ? 0 : (_mapStats['statTotNum_PtWonHandBack_Player1'] / _mapStats['statTotNum_HandBack_Player1'] * 100).round()}% (${_mapStats['statTotNum_PtWonHandBack_Player1']}/${_mapStats['statTotNum_HandBack_Player1']})';
    _mapStats['statMsg_PtWonHandForeXCourt_Player1'] =
    '${(_mapStats['statTotNum_HandForeXCourt_Player1'] == 0) ? 0 : (_mapStats['statTotNum_PtWonHandForeXCourt_Player1'] / _mapStats['statTotNum_HandForeXCourt_Player1'] * 100).round()}% (${_mapStats['statTotNum_PtWonHandForeXCourt_Player1']}/${_mapStats['statTotNum_HandForeXCourt_Player1']})';
    _mapStats['statMsg_PtWonHandBackXCourt_Player1'] =
    '${(_mapStats['statTotNum_HandBackXCourt_Player1'] == 0) ? 0 : (_mapStats['statTotNum_PtWonHandBackXCourt_Player1'] / _mapStats['statTotNum_HandBackXCourt_Player1'] * 100).round()}% (${_mapStats['statTotNum_PtWonHandBackXCourt_Player1']}/${_mapStats['statTotNum_HandBackXCourt_Player1']})';




    // _Player2 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    // Serves
    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
        .where('pointService_PlayerNum', isEqualTo: _Player2)
        .where('pointPtWon_PlayerNum', whereIn: ['1', '2']).get();
    _mapStats['statTotNum_ServiceGame_Player2'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_ServiceGame_Player2.. ' + _mapStats['statTotNum_ServiceGame_Player2'].toString());

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
        .where('pointService_PlayerNum', isEqualTo: _Player2)
        .where('pointPtWon_PlayerNum', isEqualTo: _Player2)
        .get();
    _mapStats['statTotNum_WonServiceGame_Player2'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_WonServiceGame_Player2.. ' + _mapStats['statTotNum_WonServiceGame_Player2'].toString());

    _mapStats['statMsg_WonServiceGame_Player2'] =
    '${(_mapStats['statTotNum_ServiceGame_Player2'] == 0) ? 0 : (_mapStats['statTotNum_WonServiceGame_Player2'] / _mapStats['statTotNum_ServiceGame_Player2'] * 100).round()}% (${_mapStats['statTotNum_WonServiceGame_Player2']}/${_mapStats['statTotNum_ServiceGame_Player2']})';

    // qSnap = await FirebaseFirestore.instance
    //     .collection('Matches')
    //     .doc(_mapMatchData['matchID'])
    //     .collection('Points')
    //     .where('pointService_PlayerNum', isNotEqualTo: _Player2)
    //     .get();
    // _mapStats['statTotNum_RecGame_Player2'] = qSnap.docs.length;
    _mapStats['statTotNum_RecGame_Player2'] =
        _mapStats['statTotNum_TotPtsInMatch'] -
            _mapStats['statTotNum_ServiceGame_Player2'];

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
        .where('pointService_PlayerNum', isNotEqualTo: _Player2)
        .where('pointPtWon_PlayerNum', isEqualTo: _Player2)
        .get();
    _mapStats['statTotNum_WonRecGame_Player2'] = qSnap.docs.length;

    _mapStats['statMsg_WonRecGame_Player2'] =
    '${(_mapStats['statTotNum_RecGame_Player2'] == 0) ? 0 : (_mapStats['statTotNum_WonRecGame_Player2'] / _mapStats['statTotNum_RecGame_Player2'] * 100).round()}% (${_mapStats['statTotNum_WonRecGame_Player2']}/${_mapStats['statTotNum_RecGame_Player2']})';

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
        .where('pointService_PlayerNum', isEqualTo: _Player2)
        .where('pointService_Type', whereIn: ['FirstServe']).get();
    _mapStats['statTotNum_FirstServe_Player2'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_FirstServe_Player2.. ' + _mapStats['statTotNum_FirstServe_Player2'].toString());

    _mapStats['statMsg_FirstServe_Player2'] =
    '${(_mapStats['statTotNum_ServiceGame_Player2'] == 0) ? 0 : (_mapStats['statTotNum_FirstServe_Player2'] / _mapStats['statTotNum_ServiceGame_Player2'] * 100).round()}% (${_mapStats['statTotNum_FirstServe_Player2']}/${_mapStats['statTotNum_ServiceGame_Player2']})';

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
        .where('pointService_PlayerNum', isEqualTo: _Player2)
        .where('pointService_Type', whereIn: ['SecondServe']).get();
    _mapStats['statTotNum_SecondServe_Player2'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_SecondServe_Player2.. ' + _mapStats['statTotNum_SecondServe_Player2'].toString());

    _mapStats['statMsg_SecondServe_Player2'] =
    '${(_mapStats['statTotNum_ServiceGame_Player2'] == 0) ? 0 : (_mapStats['statTotNum_SecondServe_Player2'] / _mapStats['statTotNum_ServiceGame_Player2'] * 100).round()}% (${_mapStats['statTotNum_SecondServe_Player2']}/${_mapStats['statTotNum_ServiceGame_Player2']})';

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
        .where('pointService_PlayerNum', isEqualTo: _Player2)
        .where('pointService_Type', whereIn: ['FirstServeRally']).get();
    _mapStats['statTotNum_FirstServeRally_Player2'] = qSnap.docs.length;

    _mapStats['statMsg_FirstServeRally_Player2'] =
    '${(_mapStats['statTotNum_ServiceGame_Player2'] == 0) ? 0 : (_mapStats['statTotNum_FirstServeRally_Player2'] / _mapStats['statTotNum_ServiceGame_Player2'] * 100).round()}% (${_mapStats['statTotNum_FirstServeRally_Player2']}/${_mapStats['statTotNum_ServiceGame_Player2']})';

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
        .where('pointService_PlayerNum', isEqualTo: _Player2)
        .where('pointService_Type', whereIn: ['SecondServeRally']).get();
    _mapStats['statTotNum_SecondServeRally_Player2'] = qSnap.docs.length;

    _mapStats['statMsg_SecondServeRally_Player2'] =
    '${(_mapStats['statTotNum_ServiceGame_Player2'] == 0) ? 0 : (_mapStats['statTotNum_SecondServeRally_Player2'] / _mapStats['statTotNum_ServiceGame_Player2'] * 100).round()}% (${_mapStats['statTotNum_SecondServeRally_Player2']}/${_mapStats['statTotNum_ServiceGame_Player2']})';
    _mapStats['statTotNum_TotFirstServe_Player2'] =
        _mapStats['statTotNum_FirstServe_Player2'] +
            _mapStats['statTotNum_FirstServeRally_Player2'];

    _mapStats['statMsg_FirstServeCompletion_Player2'] =
    '${(_mapStats['statTotNum_ServiceGame_Player2'] == 0) ? 0 : (_mapStats['statTotNum_TotFirstServe_Player2'] / _mapStats['statTotNum_ServiceGame_Player2'] * 100).round()}% (${_mapStats['statTotNum_TotFirstServe_Player2']}/${_mapStats['statTotNum_ServiceGame_Player2']})';

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
        .where('pointService_PlayerNum', isEqualTo: _Player2)
    // .where('pointPtWon_PlayerNum', isNotEqualTo: _Player2)
    // .where('pointPtWon_PlayerNum', isNotEqualTo: '0')
    // .where('pointService_Type', isEqualTo: 'SecondServe')
        .where('pointService_Type', isEqualTo: 'DoubleFault')
        .get();
    _mapStats['statTotNum_DoubleFault_Player2'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_DoubleFault_Player2.. ' + _mapStats['statTotNum_DoubleFault_Player2'].toString());

    _mapStats['statTotNum_TotSecondServe_Player2'] =
        _mapStats['statTotNum_SecondServe_Player2'] +
            _mapStats['statTotNum_SecondServeRally_Player2'] + _mapStats['statTotNum_DoubleFault_Player2'];

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
        .where('pointService_PlayerNum', isEqualTo: _Player2)
        .where('pointPtWon_PlayerNum', isEqualTo: _Player2)
        .where('pointService_Type', isEqualTo: 'FirstServe')
        .get();
    _mapStats['statTotNum_FirstServeAce_Player2'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_FirstServeAce_Player2.. ' + _mapStats['statTotNum_FirstServeAce_Player2'].toString());

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
        .where('pointService_PlayerNum', isEqualTo: _Player2)
        .where('pointPtWon_PlayerNum', isEqualTo: _Player2)
        .where('pointService_Type', isEqualTo: 'SecondServe')
        .get();
    _mapStats['statTotNum_SecondServeAce_Player2'] = qSnap.docs.length;

    // print('StatScreenState.. statTotNum_SecondServeAce_Player2.. ' + _mapStats['statTotNum_SecondServeAce_Player2'].toString());
    _mapStats['statTotNum_TotalAce_Player2'] =
        _mapStats['statTotNum_FirstServeAce_Player2'] +
            _mapStats['statTotNum_SecondServeAce_Player2'];

    _mapStats['statMsg_TotalAce_Player2'] =
    '${(_mapStats['statTotNum_ServiceGame_Player2'] == 0) ? 0 : (_mapStats['statTotNum_TotalAce_Player2'] / _mapStats['statTotNum_ServiceGame_Player2'] * 100).round()}% (${_mapStats['statTotNum_TotalAce_Player2']}/${_mapStats['statTotNum_ServiceGame_Player2']})';
    _mapStats['statMsg_FirstServeAce_Player2'] =
    '${(_mapStats['statTotNum_TotFirstServe_Player2'] == 0) ? 0 : (_mapStats['statTotNum_FirstServeAce_Player2'] / _mapStats['statTotNum_TotFirstServe_Player2'] * 100).round()}% (${_mapStats['statTotNum_FirstServeAce_Player2']}/${_mapStats['statTotNum_TotFirstServe_Player2']})';
    _mapStats['statMsg_SecondServeAce_Player2'] =
    '${(_mapStats['statTotNum_TotSecondServe_Player2'] == 0) ? 0 : (_mapStats['statTotNum_SecondServeAce_Player2'] / _mapStats['statTotNum_TotSecondServe_Player2'] * 100).round()}% (${_mapStats['statTotNum_SecondServeAce_Player2']}/${_mapStats['statTotNum_TotSecondServe_Player2']})';
    _mapStats['statMsg_DoubleFault_Player2'] =
    '${(_mapStats['statTotNum_TotSecondServe_Player2'] == 0) ? 0 : (_mapStats['statTotNum_DoubleFault_Player2'] / _mapStats['statTotNum_TotSecondServe_Player2'] * 100).round()}% (${_mapStats['statTotNum_DoubleFault_Player2']}/${_mapStats['statTotNum_TotSecondServe_Player2']})';

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
        .where('pointPtWon_PlayerNum', isEqualTo: _Player2)
    // .where('pointPtWon_PlayerNum', isNotEqualTo: _Player2)
    // .where('pointPtWon_PlayerNum', isNotEqualTo: '0')
        .where('pointPlayer2FoulBallLocation', isEqualTo: 'NA')
        .get();
    _mapStats['statTotNum_FoulBallNA_Player2'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_FoulBallNA_Player2.. ' + _mapStats['statTotNum_FoulBallNA_Player2'].toString());

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
    // .where('pointService_PlayerNum', isEqualTo: _Player2)
        .where('pointPtWon_PlayerNum', isNotEqualTo: _Player2)
    // .where('pointPtWon_PlayerNum', isNotEqualTo: '0')
        .where('pointPlayer2FoulBallLocation', isEqualTo: 'NA')
        .get();
    _mapStats['statTotNum_FoulBallNA_Player2'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_FoulBallNA_Player2.. ' + _mapStats['statTotNum_FoulBallNA_Player2'].toString());

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
    // .where('pointService_PlayerNum', isEqualTo: _Player2)
        .where('pointPtWon_PlayerNum', isNotEqualTo: _Player2)
    // .where('pointPtWon_PlayerNum', isNotEqualTo: '0')
        .where('pointPlayer2FoulBallLocation', isEqualTo: 'Net')
        .get();
    _mapStats['statTotNum_FoulBallNet_Player2'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_FoulBallNet_Player2.. ' + _mapStats['statTotNum_FoulBallNet_Player2'].toString());

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
    // .where('pointService_PlayerNum', isEqualTo: _Player2)
        .where('pointPtWon_PlayerNum', isNotEqualTo: _Player2)
    // .where('pointPtWon_PlayerNum', isNotEqualTo: '0')
        .where('pointPlayer2FoulBallLocation', isEqualTo: 'Back')
        .get();
    _mapStats['statTotNum_FoulBallBack_Player2'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_FoulBallBack_Player2.. ' + _mapStats['statTotNum_FoulBallBack_Player2'].toString());

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
    // .where('pointService_PlayerNum', isEqualTo: _Player2)
        .where('pointPtWon_PlayerNum', isNotEqualTo: _Player2)
    // .where('pointPtWon_PlayerNum', isNotEqualTo: '0')
        .where('pointPlayer2FoulBallLocation', isEqualTo: 'Side')
        .get();
    _mapStats['statTotNum_FoulBallSide_Player2'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_FoulBallSide_Player2.. ' + _mapStats['statTotNum_FoulBallSide_Player2'].toString());

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
    // .where('pointService_PlayerNum', isEqualTo: _Player2)
        .where('pointPtWon_PlayerNum', isNotEqualTo: _Player2)
    // .where('pointPtWon_PlayerNum', isNotEqualTo: '0')
        .where('pointPlayer2FoulBallLocation', isEqualTo: 'Shank')
        .get();
    _mapStats['statTotNum_FoulBallShank_Player2'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_FoulBallShank_Player2.. ' + _mapStats['statTotNum_FoulBallShank_Player2'].toString());

    _mapStats['statTotNum_ForcedError_Player2'] =
        _mapStats['statTotNum_FoulBallNA_Player2'] - _mapStats['statTotNum_DoubleFault_Player2'];
    _mapStats['statTotNum_UnforcedError_Player2'] =
        _mapStats['statTotNum_PtLost_Player2'] - _mapStats['statTotNum_ForcedError_Player2'];

    _mapStats['statMsg_UnforcedErrorTotPts_Player2'] =
    '${(_mapStats['statTotNum_TotPtsInMatch'] == 0) ? 0 : (_mapStats['statTotNum_UnforcedError_Player2'] / _mapStats['statTotNum_TotPtsInMatch'] * 100).round()}% (${_mapStats['statTotNum_UnforcedError_Player2']}/${_mapStats['statTotNum_TotPtsInMatch']})';
    _mapStats['statMsg_UnforcedError_Player2'] =
    '${(_mapStats['statTotNum_PtLost_Player2'] == 0) ? 0 : (_mapStats['statTotNum_UnforcedError_Player2'] / _mapStats['statTotNum_PtLost_Player2'] * 100).round()}% (${_mapStats['statTotNum_UnforcedError_Player2']}/${_mapStats['statTotNum_PtLost_Player2']})';
    _mapStats['statMsg_DoubleFaultPtLost_Player2'] =
    '${(_mapStats['statTotNum_PtLost_Player2'] == 0) ? 0 : (_mapStats['statTotNum_DoubleFault_Player2'] / _mapStats['statTotNum_PtLost_Player2'] * 100).round()}% (${_mapStats['statTotNum_DoubleFault_Player2']}/${_mapStats['statTotNum_PtLost_Player2']})';

    _mapStats['statMsg_FoulBallNA_Player2'] =
    '${(_mapStats['statTotNum_PtLost_Player2'] == 0) ? 0 : (_mapStats['statTotNum_FoulBallNA_Player2'] / _mapStats['statTotNum_PtLost_Player2'] * 100).round()}% (${_mapStats['statTotNum_FoulBallNA_Player2']}/${_mapStats['statTotNum_PtLost_Player2']})';
    _mapStats['statMsg_FoulBallNet_Player2'] =
    '${(_mapStats['statTotNum_PtLost_Player2'] == 0) ? 0 : (_mapStats['statTotNum_FoulBallNet_Player2'] / _mapStats['statTotNum_PtLost_Player2'] * 100).round()}% (${_mapStats['statTotNum_FoulBallNet_Player2']}/${_mapStats['statTotNum_PtLost_Player2']})';
    _mapStats['statMsg_FoulBallBack_Player2'] =
    '${(_mapStats['statTotNum_PtLost_Player2'] == 0) ? 0 : (_mapStats['statTotNum_FoulBallBack_Player2'] / _mapStats['statTotNum_PtLost_Player2'] * 100).round()}% (${_mapStats['statTotNum_FoulBallBack_Player2']}/${_mapStats['statTotNum_PtLost_Player2']})';
    _mapStats['statMsg_FoulBallSide_Player2'] =
    '${(_mapStats['statTotNum_PtLost_Player2'] == 0) ? 0 : (_mapStats['statTotNum_FoulBallSide_Player2'] / _mapStats['statTotNum_PtLost_Player2'] * 100).round()}% (${_mapStats['statTotNum_FoulBallSide_Player2']}/${_mapStats['statTotNum_PtLost_Player2']})';
    _mapStats['statMsg_FoulBallShank_Player2'] =
    '${(_mapStats['statTotNum_PtLost_Player2'] == 0) ? 0 : (_mapStats['statTotNum_FoulBallShank_Player2'] / _mapStats['statTotNum_PtLost_Player2'] * 100).round()}% (${_mapStats['statTotNum_FoulBallShank_Player2']}/${_mapStats['statTotNum_PtLost_Player2']})';

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
    // .where('pointService_PlayerNum', isEqualTo: _Player2)
    //     .where('pointPtWon_PlayerNum', isEqualTo: _Player2)
    //     .where('pointPtWon_PlayerNum', whereIn: ['1', '2'])
        .where('pointPlayer2Stroke',
        whereIn: ['Ground', 'Volley', 'Overhead', 'Dropshot', 'Slice', 'Push', 'Lob', 'OnTheRise', 'Deep']).get();
    _mapStats['statTotNum_StrokeALL_Player2'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_StrokeALL_Player2.. ' + _mapStats['statTotNum_StrokeALL_Player2'].toString());

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
    // .where('pointService_PlayerNum', isEqualTo: _Player2)
    //     .where('pointPtWon_PlayerNum', isEqualTo: _Player2)
    //     .where('pointPtWon_PlayerNum', whereIn: ['1', '2'])
        .where('pointPlayer2Stroke', whereIn: ['Ground']).get();
    _mapStats['statTotNum_StrokeGround_Player2'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_StrokeGround_Player2.. ' + _mapStats['statTotNum_StrokeGround_Player2'].toString());

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
    // .where('pointService_PlayerNum', isEqualTo: _Player2)
    //     .where('pointPtWon_PlayerNum', isEqualTo: _Player2)
    //     .where('pointPtWon_PlayerNum', whereIn: ['1', '2'])
        .where('pointPlayer2Stroke', whereIn: ['Volley']).get();
    _mapStats['statTotNum_StrokeVolley_Player2'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_StrokeVolley_Player2.. ' + _mapStats['statTotNum_StrokeVolley_Player2'].toString());

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
    // .where('pointService_PlayerNum', isEqualTo: _Player2)
    //     .where('pointPtWon_PlayerNum', isEqualTo: _Player2)
    //     .where('pointPtWon_PlayerNum', whereIn: ['1', '2'])
        .where('pointPlayer2Stroke', whereIn: ['Overhead']).get();
    _mapStats['statTotNum_StrokeOverhead_Player2'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_StrokeOverhead_Player2.. ' + _mapStats['statTotNum_StrokeOverhead_Player2'].toString());

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
    // .where('pointService_PlayerNum', isEqualTo: _Player2)
    //     .where('pointPtWon_PlayerNum', isEqualTo: _Player2)
    //     .where('pointPtWon_PlayerNum', whereIn: ['1', '2'])
        .where('pointPlayer2Stroke', whereIn: ['Dropshot']).get();
    _mapStats['statTotNum_StrokeDropshot_Player2'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_StrokeDropshot_Player2.. ' + _mapStats['statTotNum_StrokeDropshot_Player2'].toString());

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
    // .where('pointService_PlayerNum', isEqualTo: _Player2)
    //     .where('pointPtWon_PlayerNum', isEqualTo: _Player2)
    //     .where('pointPtWon_PlayerNum', whereIn: ['1', '2'])
        .where('pointPlayer2Stroke', whereIn: ['Slice']).get();
    _mapStats['statTotNum_StrokeSlice_Player2'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_StrokeSlice_Player2.. ' + _mapStats['statTotNum_StrokeSlice_Player2'].toString());

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
    // .where('pointService_PlayerNum', isEqualTo: _Player2)
    //     .where('pointPtWon_PlayerNum', isEqualTo: _Player2)
    //     .where('pointPtWon_PlayerNum', whereIn: ['1', '2'])
        .where('pointPlayer2Stroke', whereIn: ['Push']).get();
    _mapStats['statTotNum_StrokePush_Player2'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_StrokePush_Player2.. ' + _mapStats['statTotNum_StrokePush_Player2'].toString());

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
    // .where('pointService_PlayerNum', isEqualTo: _Player2)
    //     .where('pointPtWon_PlayerNum', isEqualTo: _Player2)
    //     .where('pointPtWon_PlayerNum', whereIn: ['1', '2'])
        .where('pointPlayer2Stroke', whereIn: ['Lob']).get();
    _mapStats['statTotNum_StrokeLob_Player2'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_StrokeLob_Player2.. ' + _mapStats['statTotNum_StrokeLob_Player2'].toString());

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
    // .where('pointService_PlayerNum', isEqualTo: _Player2)
    //     .where('pointPtWon_PlayerNum', isEqualTo: _Player2)
    //     .where('pointPtWon_PlayerNum', whereIn: ['1', '2'])
        .where('pointPlayer2Stroke', whereIn: ['OnTheRise']).get();
    _mapStats['statTotNum_StrokeOnTheRise_Player2'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_StrokeOnTheRise_Player2.. ' + _mapStats['statTotNum_StrokeOnTheRise_Player2'].toString());

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
    // .where('pointService_PlayerNum', isEqualTo: _Player2)
    //     .where('pointPtWon_PlayerNum', isEqualTo: _Player2)
    //     .where('pointPtWon_PlayerNum', whereIn: ['1', '2'])
        .where('pointPlayer2Stroke', whereIn: ['Deep']).get();
    _mapStats['statTotNum_StrokeDeep_Player2'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_StrokeDeep_Player2.. ' + _mapStats['statTotNum_StrokeDeep_Player2'].toString());

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
    // .where('pointService_PlayerNum', isEqualTo: _Player2)
        .where('pointPtWon_PlayerNum', isEqualTo: _Player2)
        .where('pointPlayer2Stroke',
        whereIn: ['Ground', 'Volley', 'Overhead', 'Dropshot', 'Slice', 'Push', 'Lob', 'OnTheRise', 'Deep']).get();
    _mapStats['statTotNum_PtWonStrokeALL_Player2'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_PtWonStrokeALL_Player2.. ' + _mapStats['statTotNum_PtWonStrokeALL_Player2'].toString());

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
    // .where('pointService_PlayerNum', isEqualTo: _Player2)
        .where('pointPtWon_PlayerNum', isEqualTo: _Player2)
        .where('pointPlayer2Stroke', whereIn: ['Ground']).get();
    _mapStats['statTotNum_PtWonStrokeGround_Player2'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_PtWonStrokeGround_Player2.. ' + _mapStats['statTotNum_PtWonStrokeGround_Player2'].toString());

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
    // .where('pointService_PlayerNum', isEqualTo: _Player2)
        .where('pointPtWon_PlayerNum', isEqualTo: _Player2)
        .where('pointPlayer2Stroke', whereIn: ['Volley']).get();
    _mapStats['statTotNum_PtWonStrokeVolley_Player2'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_PtWonStrokeVolley_Player2.. ' + _mapStats['statTotNum_PtWonStrokeVolley_Player2'].toString());

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
    // .where('pointService_PlayerNum', isEqualTo: _Player2)
        .where('pointPtWon_PlayerNum', isEqualTo: _Player2)
        .where('pointPlayer2Stroke', whereIn: ['Overhead']).get();
    _mapStats['statTotNum_PtWonStrokeOverhead_Player2'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_PtWonStrokeOverhead_Player2.. ' + _mapStats['statTotNum_PtWonStrokeOverhead_Player2'].toString());
    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
    // .where('pointService_PlayerNum', isEqualTo: _Player2)
        .where('pointPtWon_PlayerNum', isEqualTo: _Player2)
        .where('pointPlayer2Stroke', whereIn: ['Dropshot']).get();
    _mapStats['statTotNum_PtWonStrokeDropshot_Player2'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_PtWonStrokeDropshot_Player2.. ' + _mapStats['statTotNum_PtWonStrokeDropshot_Player2'].toString());

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
    // .where('pointService_PlayerNum', isEqualTo: _Player2)
        .where('pointPtWon_PlayerNum', isEqualTo: _Player2)
        .where('pointPlayer2Stroke', whereIn: ['Slice']).get();
    _mapStats['statTotNum_PtWonStrokeSlice_Player2'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_PtWonStrokeSlice_Player2.. ' + _mapStats['statTotNum_PtWonStrokeSlice_Player2'].toString());

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
    // .where('pointService_PlayerNum', isEqualTo: _Player2)
        .where('pointPtWon_PlayerNum', isEqualTo: _Player2)
        .where('pointPlayer2Stroke', whereIn: ['Push']).get();
    _mapStats['statTotNum_PtWonStrokePush_Player2'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_PtWonStrokePush_Player2.. ' + _mapStats['statTotNum_PtWonStrokePush_Player2'].toString());

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
    // .where('pointService_PlayerNum', isEqualTo: _Player2)
        .where('pointPtWon_PlayerNum', isEqualTo: _Player2)
        .where('pointPlayer2Stroke', whereIn: ['Lob']).get();
    _mapStats['statTotNum_PtWonStrokeLob_Player2'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_PtWonStrokeLob_Player2.. ' + _mapStats['statTotNum_PtWonStrokeLob_Player2'].toString());
    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
    // .where('pointService_PlayerNum', isEqualTo: _Player2)
        .where('pointPtWon_PlayerNum', isEqualTo: _Player2)
        .where('pointPlayer2Stroke', whereIn: ['OnTheRise']).get();
    _mapStats['statTotNum_PtWonStrokeOnTheRise_Player2'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_PtWonStrokeOnTheRise_Player2.. ' + _mapStats['statTotNum_PtWonStrokeOnTheRise_Player2'].toString());

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
    // .where('pointService_PlayerNum', isEqualTo: _Player2)
        .where('pointPtWon_PlayerNum', isEqualTo: _Player2)
        .where('pointPlayer2Stroke', whereIn: ['Deep']).get();
    _mapStats['statTotNum_PtWonStrokeDeep_Player2'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_PtWonStrokeDeep_Player2.. ' + _mapStats['statTotNum_PtWonStrokeDeep_Player2'].toString());

    _tmpInt = _mapStats['statTotNum_FirstServeRally_Player2'] +
        _mapStats['statTotNum_SecondServeRally_Player2'] +
        _mapStats['statTotNum_RecGame_Player2'];

    _mapStats['statMsg_StrokeALL_Player2'] =
    '${(_tmpInt == 0) ? 0 : (_mapStats['statTotNum_StrokeALL_Player2'] / _tmpInt * 100).round()}% (${_mapStats['statTotNum_StrokeALL_Player2']}/${_tmpInt})';
    _mapStats['statMsg_StrokeGround_Player2'] =
    '${(_mapStats['statTotNum_StrokeALL_Player2'] == 0) ? 0 : (_mapStats['statTotNum_StrokeGround_Player2'] / _mapStats['statTotNum_StrokeALL_Player2'] * 100).round()}% (${_mapStats['statTotNum_StrokeGround_Player2']}/${_mapStats['statTotNum_StrokeALL_Player2']})';
    _mapStats['statMsg_StrokeVolley_Player2'] =
    '${(_mapStats['statTotNum_StrokeALL_Player2'] == 0) ? 0 : (_mapStats['statTotNum_StrokeVolley_Player2'] / _mapStats['statTotNum_StrokeALL_Player2'] * 100).round()}% (${_mapStats['statTotNum_StrokeVolley_Player2']}/${_mapStats['statTotNum_StrokeALL_Player2']})';
    _mapStats['statMsg_StrokeOverhead_Player2'] =
    '${(_mapStats['statTotNum_StrokeALL_Player2'] == 0) ? 0 : (_mapStats['statTotNum_StrokeOverhead_Player2'] / _mapStats['statTotNum_StrokeALL_Player2'] * 100).round()}% (${_mapStats['statTotNum_StrokeOverhead_Player2']}/${_mapStats['statTotNum_StrokeALL_Player2']})';
    _mapStats['statMsg_StrokeDropshot_Player2'] =
    '${(_mapStats['statTotNum_StrokeALL_Player2'] == 0) ? 0 : (_mapStats['statTotNum_StrokeDropshot_Player2'] / _mapStats['statTotNum_StrokeALL_Player2'] * 100).round()}% (${_mapStats['statTotNum_StrokeDropshot_Player2']}/${_mapStats['statTotNum_StrokeALL_Player2']})';
    _mapStats['statMsg_StrokeSlice_Player2'] =
    '${(_mapStats['statTotNum_StrokeALL_Player2'] == 0) ? 0 : (_mapStats['statTotNum_StrokeSlice_Player2'] / _mapStats['statTotNum_StrokeALL_Player2'] * 100).round()}% (${_mapStats['statTotNum_StrokeSlice_Player2']}/${_mapStats['statTotNum_StrokeALL_Player2']})';
    _mapStats['statMsg_StrokePush_Player2'] =
    '${(_mapStats['statTotNum_StrokeALL_Player2'] == 0) ? 0 : (_mapStats['statTotNum_StrokePush_Player2'] / _mapStats['statTotNum_StrokeALL_Player2'] * 100).round()}% (${_mapStats['statTotNum_StrokePush_Player2']}/${_mapStats['statTotNum_StrokeALL_Player2']})';
    _mapStats['statMsg_StrokeLob_Player2'] =
    '${(_mapStats['statTotNum_StrokeALL_Player2'] == 0) ? 0 : (_mapStats['statTotNum_StrokeLob_Player2'] / _mapStats['statTotNum_StrokeALL_Player2'] * 100).round()}% (${_mapStats['statTotNum_StrokeLob_Player2']}/${_mapStats['statTotNum_StrokeALL_Player2']})';
    _mapStats['statMsg_StrokeOnTheRise_Player2'] =
    '${(_mapStats['statTotNum_StrokeALL_Player2'] == 0) ? 0 : (_mapStats['statTotNum_StrokeOnTheRise_Player2'] / _mapStats['statTotNum_StrokeALL_Player2'] * 100).round()}% (${_mapStats['statTotNum_StrokeOnTheRise_Player2']}/${_mapStats['statTotNum_StrokeALL_Player2']})';
    _mapStats['statMsg_StrokeDeep_Player2'] =
    '${(_mapStats['statTotNum_StrokeALL_Player2'] == 0) ? 0 : (_mapStats['statTotNum_StrokeDeep_Player2'] / _mapStats['statTotNum_StrokeALL_Player2'] * 100).round()}% (${_mapStats['statTotNum_StrokeDeep_Player2']}/${_mapStats['statTotNum_StrokeALL_Player2']})';

    _mapStats['statMsg_PtWonStrokeALL_Player2'] =
    '${(_mapStats['statTotNum_StrokeALL_Player2'] == 0) ? 0 : (_mapStats['statTotNum_PtWonStrokeALL_Player2'] / _mapStats['statTotNum_StrokeALL_Player2'] * 100).round()}% (${_mapStats['statTotNum_PtWonStrokeALL_Player2']}/${_mapStats['statTotNum_StrokeALL_Player2']})';
    _mapStats['statMsg_PtWonStrokeGround_Player2'] =
    '${(_mapStats['statTotNum_StrokeGround_Player2'] == 0) ? 0 : (_mapStats['statTotNum_PtWonStrokeGround_Player2'] / _mapStats['statTotNum_StrokeGround_Player2'] * 100).round()}% (${_mapStats['statTotNum_PtWonStrokeGround_Player2']}/${_mapStats['statTotNum_StrokeGround_Player2']})';
    _mapStats['statMsg_PtWonStrokeVolley_Player2'] =
    '${(_mapStats['statTotNum_StrokeVolley_Player2'] == 0) ? 0 : (_mapStats['statTotNum_PtWonStrokeVolley_Player2'] / _mapStats['statTotNum_StrokeVolley_Player2'] * 100).round()}% (${_mapStats['statTotNum_PtWonStrokeVolley_Player2']}/${_mapStats['statTotNum_StrokeVolley_Player2']})';
    _mapStats['statMsg_PtWonStrokeOverhead_Player2'] =
    '${(_mapStats['statTotNum_StrokeOverhead_Player2'] == 0) ? 0 : (_mapStats['statTotNum_PtWonStrokeOverhead_Player2'] / _mapStats['statTotNum_StrokeOverhead_Player2'] * 100).round()}% (${_mapStats['statTotNum_PtWonStrokeOverhead_Player2']}/${_mapStats['statTotNum_StrokeOverhead_Player2']})';
    _mapStats['statMsg_PtWonStrokeDropshot_Player2'] =
    '${(_mapStats['statTotNum_StrokeDropshot_Player2'] == 0) ? 0 : (_mapStats['statTotNum_PtWonStrokeDropshot_Player2'] / _mapStats['statTotNum_StrokeDropshot_Player2'] * 100).round()}% (${_mapStats['statTotNum_PtWonStrokeDropshot_Player2']}/${_mapStats['statTotNum_StrokeDropshot_Player2']})';
    _mapStats['statMsg_PtWonStrokeSlice_Player2'] =
    '${(_mapStats['statTotNum_StrokeSlice_Player2'] == 0) ? 0 : (_mapStats['statTotNum_PtWonStrokeSlice_Player2'] / _mapStats['statTotNum_StrokeSlice_Player2'] * 100).round()}% (${_mapStats['statTotNum_PtWonStrokeSlice_Player2']}/${_mapStats['statTotNum_StrokeSlice_Player2']})';
    _mapStats['statMsg_PtWonStrokePush_Player2'] =
    '${(_mapStats['statTotNum_StrokePush_Player2'] == 0) ? 0 : (_mapStats['statTotNum_PtWonStrokePush_Player2'] / _mapStats['statTotNum_StrokePush_Player2'] * 100).round()}% (${_mapStats['statTotNum_PtWonStrokePush_Player2']}/${_mapStats['statTotNum_StrokePush_Player2']})';
    _mapStats['statMsg_PtWonStrokeLob_Player2'] =
    '${(_mapStats['statTotNum_StrokeLob_Player2'] == 0) ? 0 : (_mapStats['statTotNum_PtWonStrokeLob_Player2'] / _mapStats['statTotNum_StrokeLob_Player2'] * 100).round()}% (${_mapStats['statTotNum_PtWonStrokeLob_Player2']}/${_mapStats['statTotNum_StrokeLob_Player2']})';
    _mapStats['statMsg_PtWonStrokeOnTheRise_Player2'] =
    '${(_mapStats['statTotNum_StrokeOnTheRise_Player2'] == 0) ? 0 : (_mapStats['statTotNum_PtWonStrokeOnTheRise_Player2'] / _mapStats['statTotNum_StrokeOnTheRise_Player2'] * 100).round()}% (${_mapStats['statTotNum_PtWonStrokeOnTheRise_Player2']}/${_mapStats['statTotNum_StrokeOnTheRise_Player2']})';
    _mapStats['statMsg_PtWonStrokeDeep_Player2'] =
    '${(_mapStats['statTotNum_StrokeDeep_Player2'] == 0) ? 0 : (_mapStats['statTotNum_PtWonStrokeDeep_Player2'] / _mapStats['statTotNum_StrokeDeep_Player2'] * 100).round()}% (${_mapStats['statTotNum_PtWonStrokeDeep_Player2']}/${_mapStats['statTotNum_StrokeDeep_Player2']})';

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
    // .where('pointService_PlayerNum', isEqualTo: _Player2)
    //     .where('pointPtWon_PlayerNum', isEqualTo: _Player2)
    //     .where('pointPtWon_PlayerNum', whereIn: ['1', '2'])
        .where('pointPlayer2Location',
        whereIn: ['Baseline', 'Approach', 'Net']).get();
    _mapStats['statTotNum_LocALL_Player2'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_LocALL_Player2.. ' + _mapStats['statTotNum_LocALL_Player2'].toString());

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
    // .where('pointService_PlayerNum', isEqualTo: _Player2)
    //     .where('pointPtWon_PlayerNum', isEqualTo: _Player2)
    //     .where('pointPtWon_PlayerNum', whereIn: ['1', '2'])
        .where('pointPlayer2Location', whereIn: ['Baseline']).get();
    _mapStats['statTotNum_LocBaseline_Player2'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_LocBaseline_Player2.. ' + _mapStats['statTotNum_LocBaseline_Player2'].toString());

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
    // .where('pointService_PlayerNum', isEqualTo: _Player2)
    //     .where('pointPtWon_PlayerNum', isEqualTo: _Player2)
    //     .where('pointPtWon_PlayerNum', whereIn: ['1', '2'])
        .where('pointPlayer2Location', whereIn: ['Approach']).get();
    _mapStats['statTotNum_LocApproach_Player2'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_LocApproach_Player2.. ' + _mapStats['statTotNum_LocApproach_Player2'].toString());

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
    // .where('pointService_PlayerNum', isEqualTo: _Player2)
    //     .where('pointPtWon_PlayerNum', isEqualTo: _Player2)
    //     .where('pointPtWon_PlayerNum', whereIn: ['1', '2'])
        .where('pointPlayer2Location', whereIn: ['Net']).get();
    _mapStats['statTotNum_LocNet_Player2'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_LocNet_Player2.. ' + _mapStats['statTotNum_LocNet_Player2'].toString());

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
    // .where('pointService_PlayerNum', isEqualTo: _Player2)
        .where('pointPtWon_PlayerNum', isEqualTo: _Player2)
        .where('pointPlayer2Location',
        whereIn: ['Baseline', 'Approach', 'Net']).get();
    _mapStats['statTotNum_PtWonLocALL_Player2'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_PtWonLocALL_Player2.. ' + _mapStats['statTotNum_PtWonLocALL_Player2'].toString());

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
    // .where('pointService_PlayerNum', isEqualTo: _Player2)
        .where('pointPtWon_PlayerNum', isEqualTo: _Player2)
        .where('pointPlayer2Location', whereIn: ['Baseline']).get();
    _mapStats['statTotNum_PtWonLocBaseline_Player2'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_PtWonLocBaseline_Player2.. ' + _mapStats['statTotNum_PtWonLocBaseline_Player2'].toString());

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
    // .where('pointService_PlayerNum', isEqualTo: _Player2)
        .where('pointPtWon_PlayerNum', isEqualTo: _Player2)
        .where('pointPlayer2Location', whereIn: ['Approach']).get();
    _mapStats['statTotNum_PtWonLocApproach_Player2'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_PtWonLocApproach_Player2.. ' + _mapStats['statTotNum_PtWonLocApproach_Player2'].toString());

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
    // .where('pointService_PlayerNum', isEqualTo: _Player2)
        .where('pointPtWon_PlayerNum', isEqualTo: _Player2)
        .where('pointPlayer2Location', whereIn: ['Net']).get();
    _mapStats['statTotNum_PtWonLocNet_Player2'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_PtWonLocNet_Player2.. ' + _mapStats['statTotNum_PtWonLocNet_Player2'].toString());

    _tmpInt = _mapStats['statTotNum_FirstServeRally_Player2'] +
        _mapStats['statTotNum_SecondServeRally_Player2'] +
        _mapStats['statTotNum_RecGame_Player2'];

    _mapStats['statMsg_LocALL_Player2'] =
    '${(_tmpInt == 0) ? 0 : (_mapStats['statTotNum_LocALL_Player2'] / _tmpInt * 100).round()}% (${_mapStats['statTotNum_LocALL_Player2']}/${_tmpInt})';
    _mapStats['statMsg_LocBaseline_Player2'] =
    '${(_mapStats['statTotNum_LocALL_Player2'] == 0) ? 0 : (_mapStats['statTotNum_LocBaseline_Player2'] / _mapStats['statTotNum_LocALL_Player2'] * 100).round()}% (${_mapStats['statTotNum_LocBaseline_Player2']}/${_mapStats['statTotNum_LocALL_Player2']})';
    _mapStats['statMsg_LocApproach_Player2'] =
    '${(_mapStats['statTotNum_LocALL_Player2'] == 0) ? 0 : (_mapStats['statTotNum_LocApproach_Player2'] / _mapStats['statTotNum_LocALL_Player2'] * 100).round()}% (${_mapStats['statTotNum_LocApproach_Player2']}/${_mapStats['statTotNum_LocALL_Player2']})';
    _mapStats['statMsg_LocNet_Player2'] =
    '${(_mapStats['statTotNum_LocALL_Player2'] == 0) ? 0 : (_mapStats['statTotNum_LocNet_Player2'] / _mapStats['statTotNum_LocALL_Player2'] * 100).round()}% (${_mapStats['statTotNum_LocNet_Player2']}/${_mapStats['statTotNum_LocALL_Player2']})';

    _mapStats['statMsg_PtWonLocALL_Player2'] =
    '${(_mapStats['statTotNum_LocALL_Player2'] == 0) ? 0 : (_mapStats['statTotNum_PtWonLocALL_Player2'] / _mapStats['statTotNum_LocALL_Player2'] * 100).round()}% (${_mapStats['statTotNum_PtWonLocALL_Player2']}/${_mapStats['statTotNum_LocALL_Player2']})';
    _mapStats['statMsg_PtWonLocBaseline_Player2'] =
    '${(_mapStats['statTotNum_LocBaseline_Player2'] == 0) ? 0 : (_mapStats['statTotNum_PtWonLocBaseline_Player2'] / _mapStats['statTotNum_LocBaseline_Player2'] * 100).round()}% (${_mapStats['statTotNum_PtWonLocBaseline_Player2']}/${_mapStats['statTotNum_LocBaseline_Player2']})';
    _mapStats['statMsg_PtWonLocApproach_Player2'] =
    '${(_mapStats['statTotNum_LocApproach_Player2'] == 0) ? 0 : (_mapStats['statTotNum_PtWonLocApproach_Player2'] / _mapStats['statTotNum_LocApproach_Player2'] * 100).round()}% (${_mapStats['statTotNum_PtWonLocApproach_Player2']}/${_mapStats['statTotNum_LocApproach_Player2']})';
    _mapStats['statMsg_PtWonLocNet_Player2'] =
    '${(_mapStats['statTotNum_LocNet_Player2'] == 0) ? 0 : (_mapStats['statTotNum_PtWonLocNet_Player2'] / _mapStats['statTotNum_LocNet_Player2'] * 100).round()}% (${_mapStats['statTotNum_PtWonLocNet_Player2']}/${_mapStats['statTotNum_LocNet_Player2']})';
    // print('StatScreenState.. DEBUG1.. ');

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
    // .where('pointService_PlayerNum', isEqualTo: _Player2)
    //     .where('pointPtWon_PlayerNum', isEqualTo: _Player2)
    //     .where('pointPtWon_PlayerNum', whereIn: ['1', '2'])
        .where('pointPlayer2Stroke', whereIn: [
      'Ground',
      'Volley',
      'Overhead',
      'Dropshot',
      'Slice',
      'Push',
      'Lob',
      'OnTheRise',
      'Deep'
    ])
    // .where('pointPlayer2Hand', whereIn: ['Fore', 'Back'])
        .get();
    _mapStats['statTotNum_HandALL_Player2'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_HandALL_Player2.. ' + _mapStats['statTotNum_HandALL_Player2'].toString());

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
    // .where('pointService_PlayerNum', isEqualTo: _Player2)
    //     .where('pointPtWon_PlayerNum', isEqualTo: _Player2)
    //     .where('pointPtWon_PlayerNum', whereIn: ['1', '2'])
        .where('pointPlayer2Stroke', whereIn: [
      'Ground',
      'Volley',
      'Overhead',
      'Dropshot',
      'Slice',
      'Push',
      'Lob',
      'OnTheRise',
      'Deep'
    ]).where('pointPlayer2Hand', isEqualTo: 'Fore').get();
    _mapStats['statTotNum_HandFore_Player2'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_HandFore_Player2.. ' + _mapStats['statTotNum_HandFore_Player2'].toString());

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
    // .where('pointService_PlayerNum', isEqualTo: _Player2)
    //     .where('pointPtWon_PlayerNum', isEqualTo: _Player2)
    //     .where('pointPtWon_PlayerNum', whereIn: ['1', '2'])
        .where('pointPlayer2Stroke', whereIn: [
      'Ground',
      'Volley',
      'Overhead',
      'Dropshot',
      'Slice',
      'Push',
      'Lob',
      'OnTheRise',
      'Deep'
    ]).where('pointPlayer2Hand', isEqualTo: 'Back').get();
    _mapStats['statTotNum_HandBack_Player2'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_HandBack_Player2.. ' + _mapStats['statTotNum_HandBack_Player2'].toString());


    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
    // .where('pointService_PlayerNum', isEqualTo: _Player2)
    //     .where('pointPtWon_PlayerNum', isEqualTo: _Player2)
    //     .where('pointPtWon_PlayerNum', whereIn: ['1', '2'])
        .where('pointPlayer2Stroke', whereIn: [
      'Ground',
      'Volley',
      'Overhead',
      'Dropshot',
      'Slice',
      'Push',
      'Lob',
      'OnTheRise',
      'Deep'
    ]).where('pointPlayer2Hand', isEqualTo: 'ForeXCourt').get();
    _mapStats['statTotNum_HandForeXCourt_Player2'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_HandForeXCourt_Player2.. ' + _mapStats['statTotNum_HandForeXCourt_Player2'].toString());

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
    // .where('pointService_PlayerNum', isEqualTo: _Player2)
    //     .where('pointPtWon_PlayerNum', isEqualTo: _Player2)
    //     .where('pointPtWon_PlayerNum', whereIn: ['1', '2'])
        .where('pointPlayer2Stroke', whereIn: [
      'Ground',
      'Volley',
      'Overhead',
      'Dropshot',
      'Slice',
      'Push',
      'Lob',
      'OnTheRise',
      'Deep'
    ]).where('pointPlayer2Hand', isEqualTo: 'BackXCourt').get();
    _mapStats['statTotNum_HandBackXCourt_Player2'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_HandBackXCourt_Player2.. ' + _mapStats['statTotNum_HandBackXCourt_Player2'].toString());

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
    // .where('pointService_PlayerNum', isEqualTo: _Player2)
        .where('pointPtWon_PlayerNum', isEqualTo: _Player2)
        .where('pointPlayer2Stroke', whereIn: [
      'Ground',
      'Volley',
      'Overhead',
      'Dropshot',
      'Slice',
      'Push',
      'Lob',
      'OnTheRise',
      'Deep'
    ])
    // .where('pointPlayer2Hand', whereIn: ['Fore', 'Back'])
        .get();
    _mapStats['statTotNum_PtWonHandALL_Player2'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_PtWonHandALL_Player2.. ' + _mapStats['statTotNum_PtWonHandALL_Player2'].toString());

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
    // .where('pointService_PlayerNum', isEqualTo: _Player2)
        .where('pointPtWon_PlayerNum', isEqualTo: _Player2)
        .where('pointPlayer2Stroke', whereIn: [
      'Ground',
      'Volley',
      'Overhead',
      'Dropshot',
      'Slice',
      'Push',
      'Lob',
      'OnTheRise',
      'Deep'
    ]).where('pointPlayer2Hand', isEqualTo: 'Fore').get();
    _mapStats['statTotNum_PtWonHandFore_Player2'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_PtWonHandFore_Player2.. ' + _mapStats['statTotNum_PtWonHandFore_Player2'].toString());

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
    // .where('pointService_PlayerNum', isEqualTo: _Player2)
        .where('pointPtWon_PlayerNum', isEqualTo: _Player2)
        .where('pointPlayer2Stroke', whereIn: [
      'Ground',
      'Volley',
      'Overhead',
      'Dropshot',
      'Slice',
      'Push',
      'Lob',
      'OnTheRise',
      'Deep'
    ]).where('pointPlayer2Hand', isEqualTo: 'Back').get();
    _mapStats['statTotNum_PtWonHandBack_Player2'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_PtWonHandBack_Player2.. ' + _mapStats['statTotNum_PtWonHandBack_Player2'].toString());

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
    // .where('pointService_PlayerNum', isEqualTo: _Player2)
        .where('pointPtWon_PlayerNum', isEqualTo: _Player2)
        .where('pointPlayer2Stroke', whereIn: [
      'Ground',
      'Volley',
      'Overhead',
      'Dropshot',
      'Slice',
      'Push',
      'Lob',
      'OnTheRise',
      'Deep'
    ]).where('pointPlayer2Hand', isEqualTo: 'ForeXCourt').get();
    _mapStats['statTotNum_PtWonHandForeXCourt_Player2'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_PtWonHandForeXCourt_Player2.. ' + _mapStats['statTotNum_PtWonHandForeXCourt_Player2'].toString());

    qSnap = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_mapMatchData['matchID'])
        .collection('Points')
    // .where('pointService_PlayerNum', isEqualTo: _Player2)
        .where('pointPtWon_PlayerNum', isEqualTo: _Player2)
        .where('pointPlayer2Stroke', whereIn: [
      'Ground',
      'Volley',
      'Overhead',
      'Dropshot',
      'Slice',
      'Push',
      'Lob',
      'OnTheRise',
      'Deep'
    ]).where('pointPlayer2Hand', isEqualTo: 'BackXCourt').get();
    _mapStats['statTotNum_PtWonHandBackXCourt_Player2'] = qSnap.docs.length;
    // print('StatScreenState.. statTotNum_PtWonHandBackXCourt_Player2.. ' + _mapStats['statTotNum_PtWonHandBackXCourt_Player2'].toString());

    _tmpInt = _mapStats['statTotNum_FirstServeRally_Player2'] +
        _mapStats['statTotNum_SecondServeRally_Player2'] +
        _mapStats['statTotNum_RecGame_Player2'];
    _mapStats['statMsg_HandALL_Player2'] =
    '${(_tmpInt == 0) ? 0 : (_mapStats['statTotNum_HandALL_Player2'] / _tmpInt * 100).round()}% (${_mapStats['statTotNum_HandALL_Player2']}/${_tmpInt})';
    _mapStats['statMsg_HandFore_Player2'] =
    '${(_mapStats['statTotNum_HandALL_Player2'] == 0) ? 0 : (_mapStats['statTotNum_HandFore_Player2'] / _mapStats['statTotNum_HandALL_Player2'] * 100).round()}% (${_mapStats['statTotNum_HandFore_Player2']}/${_mapStats['statTotNum_HandALL_Player2']})';
    _mapStats['statMsg_HandBack_Player2'] =
    '${(_mapStats['statTotNum_HandALL_Player2'] == 0) ? 0 : (_mapStats['statTotNum_HandBack_Player2'] / _mapStats['statTotNum_HandALL_Player2'] * 100).round()}% (${_mapStats['statTotNum_HandBack_Player2']}/${_mapStats['statTotNum_HandALL_Player2']})';
    _mapStats['statMsg_HandForeXCourt_Player2'] =
    '${(_mapStats['statTotNum_HandALL_Player2'] == 0) ? 0 : (_mapStats['statTotNum_HandForeXCourt_Player2'] / _mapStats['statTotNum_HandALL_Player2'] * 100).round()}% (${_mapStats['statTotNum_HandForeXCourt_Player2']}/${_mapStats['statTotNum_HandALL_Player2']})';
    _mapStats['statMsg_HandBackXCourt_Player2'] =
    '${(_mapStats['statTotNum_HandALL_Player2'] == 0) ? 0 : (_mapStats['statTotNum_HandBackXCourt_Player2'] / _mapStats['statTotNum_HandALL_Player2'] * 100).round()}% (${_mapStats['statTotNum_HandBackXCourt_Player2']}/${_mapStats['statTotNum_HandALL_Player2']})';

    _mapStats['statMsg_PtWonHandALL_Player2'] =
    '${(_mapStats['statTotNum_HandALL_Player2'] == 0) ? 0 : (_mapStats['statTotNum_PtWonHandALL_Player2'] / _mapStats['statTotNum_HandALL_Player2'] * 100).round()}% (${_mapStats['statTotNum_PtWonHandALL_Player2']}/${_mapStats['statTotNum_HandALL_Player2']})';
    _mapStats['statMsg_PtWonHandFore_Player2'] =
    '${(_mapStats['statTotNum_HandFore_Player2'] == 0) ? 0 : (_mapStats['statTotNum_PtWonHandFore_Player2'] / _mapStats['statTotNum_HandFore_Player2'] * 100).round()}% (${_mapStats['statTotNum_PtWonHandFore_Player2']}/${_mapStats['statTotNum_HandFore_Player2']})';
    _mapStats['statMsg_PtWonHandBack_Player2'] =
    '${(_mapStats['statTotNum_HandBack_Player2'] == 0) ? 0 : (_mapStats['statTotNum_PtWonHandBack_Player2'] / _mapStats['statTotNum_HandBack_Player2'] * 100).round()}% (${_mapStats['statTotNum_PtWonHandBack_Player2']}/${_mapStats['statTotNum_HandBack_Player2']})';
    _mapStats['statMsg_PtWonHandForeXCourt_Player2'] =
    '${(_mapStats['statTotNum_HandForeXCourt_Player2'] == 0) ? 0 : (_mapStats['statTotNum_PtWonHandForeXCourt_Player2'] / _mapStats['statTotNum_HandForeXCourt_Player2'] * 100).round()}% (${_mapStats['statTotNum_PtWonHandForeXCourt_Player2']}/${_mapStats['statTotNum_HandForeXCourt_Player2']})';
    _mapStats['statMsg_PtWonHandBackXCourt_Player2'] =
    '${(_mapStats['statTotNum_HandBackXCourt_Player2'] == 0) ? 0 : (_mapStats['statTotNum_PtWonHandBackXCourt_Player2'] / _mapStats['statTotNum_HandBackXCourt_Player2'] * 100).round()}% (${_mapStats['statTotNum_PtWonHandBackXCourt_Player2']}/${_mapStats['statTotNum_HandBackXCourt_Player2']})';




    print('StatScreenState.. EOP.. ');

    return _mapStats;
  }

  @override
  Widget build(BuildContext context) {
    // _calcStats();
    // print('StatScreen.. ' + _statTotNum_PtsInMatch.toString());
    // print('StatScreen.. ' + _statTotNum_FirstServeIn_Player1.toString());
    // print('StatScreen.. ' + _statTotNum_FirstServeIn_Player2.toString());

    return Scaffold(
        appBar: AppBar(
          title: Text('Statistics'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
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
            Row(children: <Widget>[
              Expanded(
                child: SizedBox(),
              ),
              Container(
                width: MediaQuery.of(context).size.width * pctWidth_StatItem,
                height: MediaQuery.of(context).size.height * pctHeight_StatItem,
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: <Widget>[
                        Text(
                          '${_mapMatchData['matchPlayer1FirstName']}',
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
                width: MediaQuery.of(context).size.width * pctWidth_StatItem,
                height: MediaQuery.of(context).size.height * pctHeight_StatItem,
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: <Widget>[
                        Text(
                          '${_mapMatchData['matchPlayer2FirstName']}',
                          style: TextStyle(
                            fontWeight: fontWeight_StatName,
                            color: color_StatName,
                            fontSize: fontSize_StatName,
                          ),
                        ),
                      ],
                    )),
              ),
            ]),
            // Container(
            //   width: double.infinity,
            //   height: height_StatSpace,
            // ),
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

            // STATISTICS
            FutureBuilder<Map<String, dynamic>>(
              // FutureBuilder<List<String>>(
                future: _calcStats(),
                builder: (BuildContext context,
                    AsyncSnapshot<Map<String, dynamic>> snapshot) {
                  List<Widget> children;
                  if (snapshot.hasData) {
                    final _mapStats = snapshot.data as Map<String, dynamic>;
                    children = <Widget>[
                      Column(children: <Widget>[
                        Container(
                          width: double.infinity,
                          height: height_StatSpace,
                        ),

                        // Pts Won >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                        Row(children: <Widget>[
                          Expanded(
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      'Points Won',
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
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_PtWon_Player1']}',
                                      style: TextStyle(
                                        fontWeight: fontWeight_StatItem,
                                        color: color_StatItem,
                                        fontSize: fontSize_StatItem,
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width *
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_PtWon_Player2']}',
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

                        // Serve Pts Won >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                        Row(children: <Widget>[
                          Expanded(
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      'Serve Pts Won',
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
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_WonServiceGame_Player1']}',
                                      style: TextStyle(
                                        fontWeight: fontWeight_StatItem,
                                        color: color_StatItem,
                                        fontSize: fontSize_StatItem,
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width *
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_WonServiceGame_Player2']}',
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
                        // Receiving Pts Won >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                        Row(children: <Widget>[
                          Expanded(
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      'Receiving Pts Won',
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
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_WonRecGame_Player1']}',
                                      style: TextStyle(
                                        fontWeight: fontWeight_StatItem,
                                        color: color_StatItem,
                                        fontSize: fontSize_StatItem,
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width *
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_WonRecGame_Player2']}',
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
                        // First Serve Completion >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                        Row(children: <Widget>[
                          Expanded(
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      'First Serve Completion',
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
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_FirstServeCompletion_Player1']}',
                                      style: TextStyle(
                                        fontWeight: fontWeight_StatItem,
                                        color: color_StatItem,
                                        fontSize: fontSize_StatItem,
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width *
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_FirstServeCompletion_Player2']}',
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

                        // Total Serve Won >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                        Row(children: <Widget>[
                          Expanded(
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      'Total Serve Won',
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
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_TotalAce_Player1']}',
                                      style: TextStyle(
                                        fontWeight: fontWeight_StatItem,
                                        color: color_StatItem,
                                        fontSize: fontSize_StatItem,
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width *
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_TotalAce_Player2']}',
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
                        // First Serve Won >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                        Row(children: <Widget>[
                          Expanded(
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '1st Serve Won',
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
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_FirstServeAce_Player1']}',
                                      style: TextStyle(
                                        fontWeight: fontWeight_StatItem,
                                        color: color_StatItem,
                                        fontSize: fontSize_StatItem,
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width *
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_FirstServeAce_Player2']}',
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
                        // Second Serve Won >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                        Row(children: <Widget>[
                          Expanded(
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '2nd Serve Won',
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
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_SecondServeAce_Player1']}',
                                      style: TextStyle(
                                        fontWeight: fontWeight_StatItem,
                                        color: color_StatItem,
                                        fontSize: fontSize_StatItem,
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width *
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_SecondServeAce_Player2']}',
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
                        // Double Faults >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                        Row(children: <Widget>[
                          Expanded(
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      'Double Faults',
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
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_DoubleFault_Player1']}',
                                      style: TextStyle(
                                        fontWeight: fontWeight_StatItem,
                                        color: color_StatItem,
                                        fontSize: fontSize_StatItem,
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width *
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_DoubleFault_Player2']}',
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



                        // Tot Pts - Unforced Error >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                        Row(children: <Widget>[
                          Expanded(
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      'Tot Pts - Unforced Error',
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
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_UnforcedErrorTotPts_Player1']}',
                                      style: TextStyle(
                                        fontWeight: fontWeight_StatItem,
                                        color: color_StatItem,
                                        fontSize: fontSize_StatItem,
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width *
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_UnforcedErrorTotPts_Player2']}',
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

                        // Pt Lost - Unforced Error >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                        Row(children: <Widget>[
                          Expanded(
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      'Pt Lost - Unforced Error',
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
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_UnforcedError_Player1']}',
                                      style: TextStyle(
                                        fontWeight: fontWeight_StatItem,
                                        color: color_StatItem,
                                        fontSize: fontSize_StatItem,
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width *
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_UnforcedError_Player2']}',
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
                        // Pt Lost - Double Fault >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                        Row(children: <Widget>[
                          Expanded(
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      'Pt Lost - Double Fault',
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
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_DoubleFaultPtLost_Player1']}',
                                      style: TextStyle(
                                        fontWeight: fontWeight_StatItem,
                                        color: color_StatItem,
                                        fontSize: fontSize_StatItem,
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width *
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_DoubleFaultPtLost_Player2']}',
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
                        // Pt Lost - Net >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                        Row(children: <Widget>[
                          Expanded(
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      'Pt Lost - Net',
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
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_FoulBallNet_Player1']}',
                                      style: TextStyle(
                                        fontWeight: fontWeight_StatItem,
                                        color: color_StatItem,
                                        fontSize: fontSize_StatItem,
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width *
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_FoulBallNet_Player2']}',
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
                        // Pt Lost - Back >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                        Row(children: <Widget>[
                          Expanded(
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      'Pt Lost - Back',
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
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_FoulBallBack_Player1']}',
                                      style: TextStyle(
                                        fontWeight: fontWeight_StatItem,
                                        color: color_StatItem,
                                        fontSize: fontSize_StatItem,
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width *
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_FoulBallBack_Player2']}',
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
                        // Pt Lost - Side >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                        Row(children: <Widget>[
                          Expanded(
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      'Pt Lost - Side',
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
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_FoulBallSide_Player1']}',
                                      style: TextStyle(
                                        fontWeight: fontWeight_StatItem,
                                        color: color_StatItem,
                                        fontSize: fontSize_StatItem,
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width *
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_FoulBallSide_Player2']}',
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
                        // Pt Lost - Shank >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                        Row(children: <Widget>[
                          Expanded(
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      'Pt Lost - Shank',
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
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_FoulBallShank_Player1']}',
                                      style: TextStyle(
                                        fontWeight: fontWeight_StatItem,
                                        color: color_StatItem,
                                        fontSize: fontSize_StatItem,
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width *
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_FoulBallShank_Player2']}',
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
                        Container(
                          width: double.infinity,
                          height: height_StatSpace,
                        ),


                        // // Rally - Stroke Capture% >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                        // Row(children: <Widget>[
                        //   Expanded(
                        //     child: Align(
                        //         alignment: Alignment.centerLeft,
                        //         child: Row(
                        //           children: <Widget>[
                        //             Text(
                        //               'Rally - Stroke Capture%',
                        //               style: TextStyle(
                        //                 fontWeight: fontWeight_StatName,
                        //                 color: color_StatName,
                        //                 fontSize: fontSize_StatName,
                        //               ),
                        //             ),
                        //           ],
                        //         )),
                        //   ),
                        //   Container(
                        //     width: MediaQuery.of(context).size.width *
                        //         pctWidth_StatItem,
                        //     height: MediaQuery.of(context).size.height *
                        //         pctHeight_StatItem,
                        //     child: Align(
                        //         alignment: Alignment.centerLeft,
                        //         child: Row(
                        //           children: <Widget>[
                        //             Text(
                        //               '${_mapStats['statMsg_StrokeALL_Player1']}',
                        //               style: TextStyle(
                        //                 fontWeight: fontWeight_StatItem,
                        //                 color: color_StatItem,
                        //                 fontSize: fontSize_StatItem,
                        //               ),
                        //             ),
                        //           ],
                        //         )),
                        //   ),
                        //   Container(
                        //     width: MediaQuery.of(context).size.width *
                        //         pctWidth_StatItem,
                        //     height: MediaQuery.of(context).size.height *
                        //         pctHeight_StatItem,
                        //     child: Align(
                        //         alignment: Alignment.centerLeft,
                        //         child: Row(
                        //           children: <Widget>[
                        //             Text(
                        //               '${_mapStats['statMsg_StrokeALL_Player2']}',
                        //               style: TextStyle(
                        //                 fontWeight: fontWeight_StatItem,
                        //                 color: color_StatItem,
                        //                 fontSize: fontSize_StatItem,
                        //               ),
                        //             ),
                        //           ],
                        //         )),
                        //   ),
                        // ]),

                        // Pt Won - All Locations >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                        Row(children: <Widget>[
                          Expanded(
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      'Pt Won - All Locations',
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
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_PtWonLocALL_Player1']}',
                                      style: TextStyle(
                                        fontWeight: fontWeight_StatItem,
                                        color: color_StatItem,
                                        fontSize: fontSize_StatItem,
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width *
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_PtWonLocALL_Player2']}',
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
                        // Pt Won - Baseline >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                        Row(children: <Widget>[
                          Expanded(
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      'Pt Won - Baseline',
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
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_PtWonLocBaseline_Player1']}',
                                      style: TextStyle(
                                        fontWeight: fontWeight_StatItem,
                                        color: color_StatItem,
                                        fontSize: fontSize_StatItem,
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width *
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_PtWonLocBaseline_Player2']}',
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
                        // Pt Won - Approach >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                        Row(children: <Widget>[
                          Expanded(
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      'Pt Won - Approach',
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
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_PtWonLocApproach_Player1']}',
                                      style: TextStyle(
                                        fontWeight: fontWeight_StatItem,
                                        color: color_StatItem,
                                        fontSize: fontSize_StatItem,
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width *
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_PtWonLocApproach_Player2']}',
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
                        // Pt Won - Net >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                        Row(children: <Widget>[
                          Expanded(
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      'Pt Won - Net',
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
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_PtWonLocNet_Player1']}',
                                      style: TextStyle(
                                        fontWeight: fontWeight_StatItem,
                                        color: color_StatItem,
                                        fontSize: fontSize_StatItem,
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width *
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_PtWonLocNet_Player2']}',
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

                        // // Rally - Hand Capture% >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                        // Row(children: <Widget>[
                        //   Expanded(
                        //     child: Align(
                        //         alignment: Alignment.centerLeft,
                        //         child: Row(
                        //           children: <Widget>[
                        //             Text(
                        //               'Rally - Hand Capture%',
                        //               style: TextStyle(
                        //                 fontWeight: fontWeight_StatName,
                        //                 color: color_StatName,
                        //                 fontSize: fontSize_StatName,
                        //               ),
                        //             ),
                        //           ],
                        //         )),
                        //   ),
                        //   Container(
                        //     width: MediaQuery.of(context).size.width *
                        //         pctWidth_StatItem,
                        //     height: MediaQuery.of(context).size.height *
                        //         pctHeight_StatItem,
                        //     child: Align(
                        //         alignment: Alignment.centerLeft,
                        //         child: Row(
                        //           children: <Widget>[
                        //             Text(
                        //               '${_mapStats['statMsg_HandALL_Player1']}',
                        //               style: TextStyle(
                        //                 fontWeight: fontWeight_StatItem,
                        //                 color: color_StatItem,
                        //                 fontSize: fontSize_StatItem,
                        //               ),
                        //             ),
                        //           ],
                        //         )),
                        //   ),
                        //   Container(
                        //     width: MediaQuery.of(context).size.width *
                        //         pctWidth_StatItem,
                        //     height: MediaQuery.of(context).size.height *
                        //         pctHeight_StatItem,
                        //     child: Align(
                        //         alignment: Alignment.centerLeft,
                        //         child: Row(
                        //           children: <Widget>[
                        //             Text(
                        //               '${_mapStats['statMsg_HandALL_Player2']}',
                        //               style: TextStyle(
                        //                 fontWeight: fontWeight_StatItem,
                        //                 color: color_StatItem,
                        //                 fontSize: fontSize_StatItem,
                        //               ),
                        //             ),
                        //           ],
                        //         )),
                        //   ),
                        // ]),





                        // Pt Won - All Hands >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                        Row(children: <Widget>[
                          Expanded(
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      'Pt Won - All Hands',
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
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_PtWonHandALL_Player1']}',
                                      style: TextStyle(
                                        fontWeight: fontWeight_StatItem,
                                        color: color_StatItem,
                                        fontSize: fontSize_StatItem,
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width *
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_PtWonHandALL_Player2']}',
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
                        // Pt Won - Fore >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                        Row(children: <Widget>[
                          Expanded(
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      'Pt Won - Fore',
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
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_PtWonHandFore_Player1']}',
                                      style: TextStyle(
                                        fontWeight: fontWeight_StatItem,
                                        color: color_StatItem,
                                        fontSize: fontSize_StatItem,
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width *
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_PtWonHandFore_Player2']}',
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
                        // Pt Won - Back >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                        Row(children: <Widget>[
                          Expanded(
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      'Pt Won - Back',
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
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_PtWonHandBack_Player1']}',
                                      style: TextStyle(
                                        fontWeight: fontWeight_StatItem,
                                        color: color_StatItem,
                                        fontSize: fontSize_StatItem,
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width *
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_PtWonHandBack_Player2']}',
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
                        // Pt Won - ForeXCourt >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                        Row(children: <Widget>[
                          Expanded(
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      'Pt Won - ForeXCourt',
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
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_PtWonHandForeXCourt_Player1']}',
                                      style: TextStyle(
                                        fontWeight: fontWeight_StatItem,
                                        color: color_StatItem,
                                        fontSize: fontSize_StatItem,
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width *
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_PtWonHandForeXCourt_Player2']}',
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
                        // Pt Won - BackXCourt >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                        Row(children: <Widget>[
                          Expanded(
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      'Pt Won - BackXCourt',
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
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_PtWonHandBackXCourt_Player1']}',
                                      style: TextStyle(
                                        fontWeight: fontWeight_StatItem,
                                        color: color_StatItem,
                                        fontSize: fontSize_StatItem,
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width *
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_PtWonHandBackXCourt_Player2']}',
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




                        // Pt Won - All Strokes >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                        Row(children: <Widget>[
                          Expanded(
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      'Pt Won - All Strokes',
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
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_PtWonStrokeALL_Player1']}',
                                      style: TextStyle(
                                        fontWeight: fontWeight_StatItem,
                                        color: color_StatItem,
                                        fontSize: fontSize_StatItem,
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width *
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_PtWonStrokeALL_Player2']}',
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
                        // Pt Won - Ground >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                        Row(children: <Widget>[
                          Expanded(
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      'Pt Won - Ground',
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
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_PtWonStrokeGround_Player1']}',
                                      style: TextStyle(
                                        fontWeight: fontWeight_StatItem,
                                        color: color_StatItem,
                                        fontSize: fontSize_StatItem,
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width *
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_PtWonStrokeGround_Player2']}',
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
                        // Pt Won - Volley >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                        Row(children: <Widget>[
                          Expanded(
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      'Pt Won - Volley',
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
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_PtWonStrokeVolley_Player1']}',
                                      style: TextStyle(
                                        fontWeight: fontWeight_StatItem,
                                        color: color_StatItem,
                                        fontSize: fontSize_StatItem,
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width *
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_PtWonStrokeVolley_Player2']}',
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
                        // Pt Won - Overhead >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                        Row(children: <Widget>[
                          Expanded(
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      'Pt Won - Overhead',
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
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_PtWonStrokeOverhead_Player1']}',
                                      style: TextStyle(
                                        fontWeight: fontWeight_StatItem,
                                        color: color_StatItem,
                                        fontSize: fontSize_StatItem,
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width *
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_PtWonStrokeOverhead_Player2']}',
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
                        // Pt Won - Dropshot >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                        Row(children: <Widget>[
                          Expanded(
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      'Pt Won - Dropshot',
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
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_PtWonStrokeDropshot_Player1']}',
                                      style: TextStyle(
                                        fontWeight: fontWeight_StatItem,
                                        color: color_StatItem,
                                        fontSize: fontSize_StatItem,
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width *
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_PtWonStrokeDropshot_Player2']}',
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
                        // Pt Won - Slice >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                        Row(children: <Widget>[
                          Expanded(
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      'Pt Won - Slice',
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
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_PtWonStrokeSlice_Player1']}',
                                      style: TextStyle(
                                        fontWeight: fontWeight_StatItem,
                                        color: color_StatItem,
                                        fontSize: fontSize_StatItem,
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width *
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_PtWonStrokeSlice_Player2']}',
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
                        // Pt Won - Push >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                        Row(children: <Widget>[
                          Expanded(
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      'Pt Won - Push',
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
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_PtWonStrokePush_Player1']}',
                                      style: TextStyle(
                                        fontWeight: fontWeight_StatItem,
                                        color: color_StatItem,
                                        fontSize: fontSize_StatItem,
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width *
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_PtWonStrokePush_Player2']}',
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
                        // Pt Won - Lob >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                        Row(children: <Widget>[
                          Expanded(
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      'Pt Won - Lob',
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
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_PtWonStrokeLob_Player1']}',
                                      style: TextStyle(
                                        fontWeight: fontWeight_StatItem,
                                        color: color_StatItem,
                                        fontSize: fontSize_StatItem,
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width *
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_PtWonStrokeLob_Player2']}',
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
                        // Pt Won - OnTheRise >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                        Row(children: <Widget>[
                          Expanded(
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      'Pt Won - OnTheRise',
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
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_PtWonStrokeOnTheRise_Player1']}',
                                      style: TextStyle(
                                        fontWeight: fontWeight_StatItem,
                                        color: color_StatItem,
                                        fontSize: fontSize_StatItem,
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width *
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_PtWonStrokeOnTheRise_Player2']}',
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
                        // Pt Won - Deep >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                        Row(children: <Widget>[
                          Expanded(
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      'Pt Won - Deep',
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
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_PtWonStrokeDeep_Player1']}',
                                      style: TextStyle(
                                        fontWeight: fontWeight_StatItem,
                                        color: color_StatItem,
                                        fontSize: fontSize_StatItem,
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width *
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_PtWonStrokeDeep_Player2']}',
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

                        Container(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height *
                              pctHeight_PtAttrib /
                              pctHeight_PtAttrib_DenomAdj,
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


                                                // DISTRIBUTION - Serves >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                        // First Serve >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                        Row(children: <Widget>[
                          Expanded(
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      'First Serve',
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
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_FirstServe_Player1']}',
                                      style: TextStyle(
                                        fontWeight: fontWeight_StatItem,
                                        color: color_StatItem,
                                        fontSize: fontSize_StatItem,
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width *
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_FirstServe_Player2']}',
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
                        // Second Serve >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                        Row(children: <Widget>[
                          Expanded(
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      'Second Serve',
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
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_SecondServe_Player1']}',
                                      style: TextStyle(
                                        fontWeight: fontWeight_StatItem,
                                        color: color_StatItem,
                                        fontSize: fontSize_StatItem,
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width *
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_SecondServe_Player2']}',
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
                        // First Serve Rally >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                        Row(children: <Widget>[
                          Expanded(
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      'First Serve Rally',
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
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_FirstServeRally_Player1']}',
                                      style: TextStyle(
                                        fontWeight: fontWeight_StatItem,
                                        color: color_StatItem,
                                        fontSize: fontSize_StatItem,
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width *
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_FirstServeRally_Player2']}',
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
                        // Second Serve Rally >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                        Row(children: <Widget>[
                          Expanded(
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      'Second Serve Rally',
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
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_SecondServeRally_Player1']}',
                                      style: TextStyle(
                                        fontWeight: fontWeight_StatItem,
                                        color: color_StatItem,
                                        fontSize: fontSize_StatItem,
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width *
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_SecondServeRally_Player2']}',
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


// DISTRIBUTION - Rally / Locations

                        // Rally - Baseline >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                        Row(children: <Widget>[
                          Expanded(
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      'Rally - Baseline',
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
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_LocBaseline_Player1']}',
                                      style: TextStyle(
                                        fontWeight: fontWeight_StatItem,
                                        color: color_StatItem,
                                        fontSize: fontSize_StatItem,
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width *
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_LocBaseline_Player2']}',
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
                        // Rally - Approach >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                        Row(children: <Widget>[
                          Expanded(
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      'Rally - Approach',
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
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_LocApproach_Player1']}',
                                      style: TextStyle(
                                        fontWeight: fontWeight_StatItem,
                                        color: color_StatItem,
                                        fontSize: fontSize_StatItem,
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width *
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_LocApproach_Player2']}',
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
                        // Rally - Net >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                        Row(children: <Widget>[
                          Expanded(
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      'Rally - Net',
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
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_LocNet_Player1']}',
                                      style: TextStyle(
                                        fontWeight: fontWeight_StatItem,
                                        color: color_StatItem,
                                        fontSize: fontSize_StatItem,
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width *
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_LocNet_Player2']}',
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



// DISTRIBUTION - Rally / Hands

                        // Rally - Fore >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                        Row(children: <Widget>[
                          Expanded(
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      'Rally - Fore',
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
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_HandFore_Player1']}',
                                      style: TextStyle(
                                        fontWeight: fontWeight_StatItem,
                                        color: color_StatItem,
                                        fontSize: fontSize_StatItem,
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width *
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_HandFore_Player2']}',
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
                        // Rally - Back >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                        Row(children: <Widget>[
                          Expanded(
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      'Rally - Back',
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
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_HandBack_Player1']}',
                                      style: TextStyle(
                                        fontWeight: fontWeight_StatItem,
                                        color: color_StatItem,
                                        fontSize: fontSize_StatItem,
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width *
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_HandBack_Player2']}',
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
                        // Rally - ForeXCourt >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                        Row(children: <Widget>[
                          Expanded(
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      'Rally - ForeXCourt',
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
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_HandForeXCourt_Player1']}',
                                      style: TextStyle(
                                        fontWeight: fontWeight_StatItem,
                                        color: color_StatItem,
                                        fontSize: fontSize_StatItem,
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width *
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_HandForeXCourt_Player2']}',
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
                        // Rally - BackXCourt >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                        Row(children: <Widget>[
                          Expanded(
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      'Rally - BackXCourt',
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
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_HandBackXCourt_Player1']}',
                                      style: TextStyle(
                                        fontWeight: fontWeight_StatItem,
                                        color: color_StatItem,
                                        fontSize: fontSize_StatItem,
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width *
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_HandBackXCourt_Player2']}',
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


// DISTRIBUTION - Rally / Strokes

                        // Rally - Ground >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                        Row(children: <Widget>[
                          Expanded(
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      'Rally - Ground',
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
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_StrokeGround_Player1']}',
                                      style: TextStyle(
                                        fontWeight: fontWeight_StatItem,
                                        color: color_StatItem,
                                        fontSize: fontSize_StatItem,
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width *
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_StrokeGround_Player2']}',
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
                        // Rally - Volley >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                        Row(children: <Widget>[
                          Expanded(
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      'Rally - Volley',
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
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_StrokeVolley_Player1']}',
                                      style: TextStyle(
                                        fontWeight: fontWeight_StatItem,
                                        color: color_StatItem,
                                        fontSize: fontSize_StatItem,
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width *
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_StrokeVolley_Player2']}',
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
                        // Rally - Overhead >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                        Row(children: <Widget>[
                          Expanded(
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      'Rally - Overhead',
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
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_StrokeOverhead_Player1']}',
                                      style: TextStyle(
                                        fontWeight: fontWeight_StatItem,
                                        color: color_StatItem,
                                        fontSize: fontSize_StatItem,
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width *
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_StrokeOverhead_Player2']}',
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
                        // Rally - Dropshot >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                        Row(children: <Widget>[
                          Expanded(
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      'Rally - Dropshot',
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
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_StrokeDropshot_Player1']}',
                                      style: TextStyle(
                                        fontWeight: fontWeight_StatItem,
                                        color: color_StatItem,
                                        fontSize: fontSize_StatItem,
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width *
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_StrokeDropshot_Player2']}',
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
                        // Rally - Slice >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                        Row(children: <Widget>[
                          Expanded(
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      'Rally - Slice',
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
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_StrokeSlice_Player1']}',
                                      style: TextStyle(
                                        fontWeight: fontWeight_StatItem,
                                        color: color_StatItem,
                                        fontSize: fontSize_StatItem,
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width *
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_StrokeSlice_Player2']}',
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
                        // Rally - Push >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                        Row(children: <Widget>[
                          Expanded(
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      'Rally - Push',
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
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_StrokePush_Player1']}',
                                      style: TextStyle(
                                        fontWeight: fontWeight_StatItem,
                                        color: color_StatItem,
                                        fontSize: fontSize_StatItem,
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width *
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_StrokePush_Player2']}',
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
                        // Rally - Lob >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                        Row(children: <Widget>[
                          Expanded(
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      'Rally - Lob',
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
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_StrokeLob_Player1']}',
                                      style: TextStyle(
                                        fontWeight: fontWeight_StatItem,
                                        color: color_StatItem,
                                        fontSize: fontSize_StatItem,
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width *
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_StrokeLob_Player2']}',
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
                        // Rally - OnTheRise >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                        Row(children: <Widget>[
                          Expanded(
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      'Rally - OnTheRise',
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
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_StrokeOnTheRise_Player1']}',
                                      style: TextStyle(
                                        fontWeight: fontWeight_StatItem,
                                        color: color_StatItem,
                                        fontSize: fontSize_StatItem,
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width *
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_StrokeOnTheRise_Player2']}',
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
                        // Rally - Deep >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                        Row(children: <Widget>[
                          Expanded(
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      'Rally - Deep',
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
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_StrokeDeep_Player1']}',
                                      style: TextStyle(
                                        fontWeight: fontWeight_StatItem,
                                        color: color_StatItem,
                                        fontSize: fontSize_StatItem,
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width *
                                pctWidth_StatItem,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_StatItem,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${_mapStats['statMsg_StrokeDeep_Player2']}',
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


                      ]),
                    ];



                    
                  } else {
                    children = <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Calculating Statistics..'
                          // style: TextStyle(
                          //   fontWeight: fontWeight_ScoreBoard_PrevSets,
                          //   color: color_ScoreBoard_Text,
                          //   fontSize: fontSize_ScoreBoard,
                          // ),
                        ),
                      ),
                    ];
                  }
                  return Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: children,
                  );
                }),
          ],
        ));
  }
}