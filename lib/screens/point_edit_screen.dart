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
import '../config/custom_styles.dart';
import '../config/globals.dart' as globals;

import '../screens/match_edit_screen.dart';
import '../screens/points_screen.dart';
import '../screens/score_edit_screen.dart';
import '../screens/stat_screen.dart';
import '../screens/debug_screen.dart';

import '../widgets/app_drawer.dart';

enum YesNoOptions { Y, N, U }

enum PointErrorOptions {
  Forced,
  Unforced,
  NA, // Point Won
}

enum PointFoulBallLocationOptions {
  Net,
  Back,
  Side,
  Shank,
  NA,
}

enum PointHandOptions { Fore, Back, ForeXCourt, BackXCourt }

enum ServiceTypeOptions {
  FirstServe,
  SecondServe,
  DoubleFault,
  FirstServeRally,
  SecondServeRally,
}

enum PointStrokeOptions {
  ServeAce1st,
  ServeWin1st,
  ServeAce2nd,
  ServeWin2nd,
  DoubleFault,
  ServeReturn,
  Ground,
  Volley,
  Overhead,
  Dropshot,
  Slice,
  Push,
  Lob,
  OnTheRise,
  Deep,
  NA,
}

enum PointLocationOptions {
  Baseline,
  Approach,
  Net,
  NA,
}

const pctHeight_ScoreBoard = 0.10;
const pctHeight_PtAttrib = 0.08;
const pctHeight_PtAttrib_DenomAdj = 5.0;
const fontSize_ScoreBoard = 18.0;
// const pctHeight_ScoreBoard = 0.10;
// const pctHeight_PtAttrib = 0.09;
// const pctHeight_PtAttrib_DenomAdj = 5.0;
// const fontSize_ScoreBoard = 18.0;

// const fontWeight_ScoreBoard_Name = FontWeight.bold;
const fontWeight_ScoreBoard_Name = FontWeight.normal;
const fontWeight_ScoreBoard_PrevSets = FontWeight.normal;
const fontWeight_ScoreBoard_CurrSet = FontWeight.bold;
const color_ScoreBoard_Bkgrd = Palette.umMaize;
const color_ScoreBoard_Text = Palette.umBlue;
// const color_ScoreBoard_Bkgrd = Color.fromRGBO(0,0,0,0);
// const color_ScoreBoard_Text = Palette.umBlue;
const color_ScoreBoard_Icon = Palette.umBlue;
// const color_ScoreBoard_Icon = Colors.white;

var _args;
// int index = -1;
String index = '-1';
// Map<String, dynamic> mapPointData_ptEditScreen = {};
// Map<String, dynamic> mapMatchData_ptEditScreen = {};
Map<String, dynamic> mapPointData_ptEditScreen =
    new Map<String, dynamic>.from(mapPointData_INIT);
Map<String, dynamic> mapMatchData_ptEditScreen =
    new Map<String, dynamic>.from(mapMatchData_INIT);

// final List<GlobalObjectKey<FormState>> formKeyList = List.generate(2, (index) => GlobalObjectKey<FormState>(index));
// final keyForm1 = formKeyList[0];
// GlobalKey<FormState>(debugLabel: 'PointEditScreenState_Player1');
// final keyForm_pointEdit2 = formKeyList[1];
// GlobalKey<FormState>(debugLabel: 'PointEditScreenState_Player2');
GlobalKey<FormState> keyForm_pointEdit1 =
    new GlobalKey<FormState>(debugLabel: 'keyForm_pointEdit1');
GlobalKey<FormState> keyForm_pointEdit2 =
    new GlobalKey<FormState>(debugLabel: 'keyForm_pointEdit2');

final Map<String, dynamic> mapPointData_INIT = {
  'pointID': '',
  'pointMatchID': '',
  'pointPlayer1ID': '',
  'pointPlayer2ID': '',
  'pointPtWon_PlayerNum': '0',
  'pointService_PlayerNum': '1',
  'pointService_Type': 'FirstServe',
  'pointPlayer1Stroke': 'Ground',
  'pointPlayer1ForceUnforced': 'Forced',
  'pointPlayer1FoulBallLocation': 'NA',
  'pointPlayer1Hand': 'Fore',
  'pointPlayer1Location': 'Baseline',
  'pointPlayer2Stroke': 'Ground',
  'pointPlayer2ForceUnforced': 'Forced',
  'pointPlayer2FoulBallLocation': 'NA',
  'pointPlayer2Hand': 'Fore',
  'pointPlayer2Location': 'Baseline',
  'pointEntryDate': '', // was DateTime.now()
};

class Player1WonPt extends StatelessWidget {
  Player1WonPt({required this.ptWon_PlayerNum, required this.onSelection});

  final String ptWon_PlayerNum;
  final void Function(String selection) onSelection;
  YesNoOptions flagPlayerWinner = YesNoOptions.U;

  @override
  Widget build(BuildContext context) {
    flagPlayerWinner = (ptWon_PlayerNum == '1')
        ? YesNoOptions.Y
        : (ptWon_PlayerNum == '2')
            ? YesNoOptions.N
            : YesNoOptions.U;

    switch (flagPlayerWinner) {
      case YesNoOptions.Y:
        // print('Player1WonPt flagPlayerWinner.. YesNoOptions.Y');
        return Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.height * pctHeight_PtAttrib,
              child: SizedBox(
                width: double.infinity, // <-- match_parent
                // height: double.infinity, // <-- match-parent
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(elevation: 0),
                  onPressed: () {
                    onSelection('1');
                    // notifyListeners();
                  },
                  child: Text(
                      '${mapMatchData_ptEditScreen['matchPlayer1FirstName']}\nWon Point'),
                ),
              ),
            ),
            // const SizedBox(width: 8),
            Expanded(
              child: SizedBox(
                width: double.infinity, // <-- match_parent
                // height: double.infinity, // <-- match-parent
                height: MediaQuery.of(context).size.height * pctHeight_PtAttrib,
                child: TextButton(
                  onPressed: () {
                    onSelection('2');
                    // notifyListeners();
                  },
                  child: Text(
                      '${mapMatchData_ptEditScreen['matchPlayer2FirstName']}\nWon Point'),
                ),
              ),
            ),
          ],
        );
      case YesNoOptions.N:
        // print('Player1WonPt flagPlayerWinner.. YesNoOptions.N');
        return Row(
          children: [
            Expanded(
              child: SizedBox(
                width: double.infinity, // <-- match_parent
                // height: double.infinity, // <-- match-parent
                height: MediaQuery.of(context).size.height * pctHeight_PtAttrib,
                child: TextButton(
                  onPressed: () {
                    onSelection('1');
                    // notifyListeners();
                  },
                  child: Text(
                      '${mapMatchData_ptEditScreen['matchPlayer1FirstName']}\nWon Point'),
                ),
              ),
            ),
            // const SizedBox(width: 8),
            Container(
                width: MediaQuery.of(context).size.width * 0.5,
                height: MediaQuery.of(context).size.height * pctHeight_PtAttrib,
                child: SizedBox(
                  width: double.infinity, // <-- match_parent
                  // height: double.infinity, // <-- match-parent
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(elevation: 0),
                    onPressed: () {
                      onSelection('2');
                      // notifyListeners();
                    },
                    child: Text(
                        '${mapMatchData_ptEditScreen['matchPlayer2FirstName']}\nWon Point'),
                  ),
                )),
            // const SizedBox(width: 8),
          ],
        );
      default:
        // print('Player1WonPt flagPlayerWinner.. YesNoOptions.U');
        return Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.height * pctHeight_PtAttrib,
              child: SizedBox(
                width: double.infinity, // <-- match_parent
                // height: double.infinity, // <-- match-parent
                child: StyledButton(
                  onPressed: () {
                    onSelection('1');
                    // notifyListeners();
                  },
                  child: Text(
                      '${mapMatchData_ptEditScreen['matchPlayer1FirstName']}\nWon Point'),
                ),
              ),
            ),
            // const SizedBox(width: 8),
            Expanded(
              child: SizedBox(
                width: double.infinity, // <-- match_parent
                // height: double.infinity, // <-- match-parent
                height: MediaQuery.of(context).size.height * pctHeight_PtAttrib,
                child: StyledButton(
                  onPressed: () {
                    onSelection('2');
                    // notifyListeners();
                  },
                  child: Text(
                      '${mapMatchData_ptEditScreen['matchPlayer2FirstName']}\nWon Point'),
                ),
              ),
            )
          ],
        );
    }
  }
}

class Form_PlayerPoint extends StatefulWidget {
  Form_PlayerPoint(
      {required this.ptWon_PlayerNum,
      required this.service_PlayerNum,
      required this.service_Type,
      required this.keyForm,
      required this.PlayerNum,
      required this.dummy2SetState});

  final String ptWon_PlayerNum;
  final String service_PlayerNum;
  final String service_Type;
  final keyForm;
  final String PlayerNum;
  final void Function(String _dummy2SetState) dummy2SetState;

  @override
  Form_PlayerPointState createState() => Form_PlayerPointState();
}

class Form_PlayerPointState extends State<Form_PlayerPoint> {
  // final keyForm_pointEdit1 =
  //     GlobalKey<FormState>(debugLabel: 'PointEditScreenState_Player1');
  // final keyForm_pointEdit2 =
  //     GlobalKey<FormState>(debugLabel: 'PointEditScreenState_Player2');

  PointStrokeOptions _dropdownListStroke0 = PointStrokeOptions.values[0];
  PointFoulBallLocationOptions _dropdownListFoulBallLocation0 =
      PointFoulBallLocationOptions.values[0];
  PointLocationOptions _dropdownListLocation0 = PointLocationOptions.values[0];
  PointHandOptions _dropdownListHand0 = PointHandOptions.values[0];

  @override
  // void initState() {
  //   setState(() {
  //   });
  //   super.initState();
  //
  //   print('Form_PlayerPointState.. initState.. ');
  // }
  //
  // @override
  // void didChangeDependencies() {
  //   setState(() {
  //   });
  //   super.didChangeDependencies();
  //
  //   print('Form_PlayerPointState.. didChangeDependencies.. ');
  // }

  void _saveForm() {
    // print('Form_PlayerPointState.. _saveForm BOP.. ');

    final isValid = widget.keyForm.currentState!.validate();
    if (!isValid) {
      return;
    }
    widget.keyForm.currentState!.save();

    // Navigator.of(context).pushNamed(
    //     PointEditScreen.routeName, arguments: mapMatchData_ptEditScreen);

    // setState(() {
    // });

    // print('Form_PlayerPointState.. _saveForm EOP.. ');
  }

  Future<Map<String, dynamic>> _updateDropdownLists(widget) async {
    Map<String, dynamic> _mapDropDowns = {};

    _mapDropDowns['_dropdownListStroke'] =
        ((widget.service_Type == 'FirstServeRally') ||
                (widget.service_Type == 'SecondServeRally'))
            ? [
                PointStrokeOptions.Ground,
                PointStrokeOptions.Volley,
                PointStrokeOptions.Overhead,
                PointStrokeOptions.Dropshot,
                PointStrokeOptions.Slice,
                PointStrokeOptions.Push,
                PointStrokeOptions.Lob,
                PointStrokeOptions.OnTheRise,
                PointStrokeOptions.Deep,
              ] // Rally
            : (widget.service_Type == 'DoubleFault')
                ? (widget.service_PlayerNum != widget.PlayerNum)
                    ? [PointStrokeOptions.NA]
                    : [PointStrokeOptions.DoubleFault]
                : (widget.service_PlayerNum != widget.PlayerNum)
                    ? [PointStrokeOptions.ServeReturn] // Player receiving serve
                    : (widget.ptWon_PlayerNum != widget.PlayerNum)
                        ? [PointStrokeOptions.NA] // Pt Lost
                        : (widget.service_Type == 'FirstServe') // Pt Won
                            ? [
                                PointStrokeOptions.ServeAce1st,
                                PointStrokeOptions.ServeWin1st
                              ]
                            : [
                                PointStrokeOptions.ServeAce2nd,
                                PointStrokeOptions.ServeWin2nd
                              ];

    // _mapDropDowns['_dropdownListPointError'] =
    //     (widget.ptWon_PlayerNum == widget.PlayerNum)
    //         ? [PointErrorOptions.NA] // Point Won
    //         : (widget.service_Type == 'DoubleFault')
    //             ? (widget.service_PlayerNum != widget.PlayerNum)
    //                 ? [PointErrorOptions.NA] // Player receiving and point lost
    //                 : [PointErrorOptions.Unforced]
    //             : [PointErrorOptions.Forced, PointErrorOptions.Unforced];

    _mapDropDowns['_dropdownListFoulBallLocation'] =
        (widget.ptWon_PlayerNum == widget.PlayerNum)
            ? [PointFoulBallLocationOptions.NA] // Point Won
            : ((widget.service_Type == 'FirstServe') ||
                    (widget.service_Type == 'SecondServe'))
                ? [PointFoulBallLocationOptions.NA] // Service game
                : [
                    PointFoulBallLocationOptions.NA,
                    PointFoulBallLocationOptions.Net,
                    PointFoulBallLocationOptions.Back,
                    PointFoulBallLocationOptions.Side,
                    PointFoulBallLocationOptions.Shank,
                  ];

    _mapDropDowns['_dropdownListLocation'] =
        ((widget.service_Type != 'FirstServeRally') &&
                (widget.service_Type != 'SecondServeRally'))
            ? [PointLocationOptions.NA] // Service game
            : [
                PointLocationOptions.Baseline,
                PointLocationOptions.Approach,
                PointLocationOptions.Net
              ];

    _mapDropDowns['_dropdownListHand'] =
        ((widget.service_PlayerNum == widget.PlayerNum) &&
                (widget.service_Type != 'FirstServeRally') &&
                (widget.service_Type != 'SecondServeRally'))
            ? [PointHandOptions.Fore] // Serve
            : [
                PointHandOptions.Fore,
                PointHandOptions.Back,
                PointHandOptions.ForeXCourt,
                PointHandOptions.BackXCourt,
              ];

    return _mapDropDowns;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(

        // INITIALIZE DROPDOWNLISTS
        future: _updateDropdownLists(widget),
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, dynamic>> snapshot) {
          List<Widget> children;

          if (snapshot.hasData) {
            final _mapDropDowns = snapshot.data as Map<String, dynamic>;

            // print('Form_PlayerPointState.. _mapDropDowns: ' +
            //     _mapDropDowns.toString());

            List<PointStrokeOptions> _dropdownListStroke =
                _mapDropDowns['_dropdownListStroke'];
            // List<PointErrorOptions> _dropdownListPointError =
            //     _mapDropDowns['_dropdownListPointError'];
            List<PointFoulBallLocationOptions> _dropdownListFoulBallLocation =
                _mapDropDowns['_dropdownListFoulBallLocation'];
            List<PointLocationOptions> _dropdownListLocation =
                _mapDropDowns['_dropdownListLocation'];
            List<PointHandOptions> _dropdownListHand =
                _mapDropDowns['_dropdownListHand'];

            PointStrokeOptions _dropdownListStroke0 = _dropdownListStroke[0];
            PointFoulBallLocationOptions _dropdownListFoulBallLocation0 =
                _dropdownListFoulBallLocation[0];
            PointLocationOptions _dropdownListLocation0 =
                _dropdownListLocation[0];
            PointHandOptions _dropdownListHand0 = _dropdownListHand[0];

            // print('Form_PlayerPointState.. _dropdownListStroke: ' + _dropdownListStroke[0].toString());
            // print('Form_PlayerPointState.. _dropdownListPointError: ' + _dropdownListPointError[0].toString());
            // print('Form_PlayerPointState.. _dropdownListFoulBallLocation: ' + _dropdownListFoulBallLocation[0].toString());
            // print('Form_PlayerPointState.. _dropdownListLocation: ' + _dropdownListLocation[0].toString());
            // print('Form_PlayerPointState.. Player: ' +
            //     widget.PlayerNum +
            //     '.. _dropdownListHand: ' +
            //     _dropdownListHand[0].toString());
            // print('Form_PlayerPointState.. pointPlayer1Stroke: ' + mapPointData_ptEditScreen['pointPlayer1Stroke'] + '..2: ' + mapPointData_ptEditScreen['pointPlayer2Stroke']);
            // print('Form_PlayerPointState.. pointPlayer1Hand: ' +
            //     mapPointData_ptEditScreen['pointPlayer1Hand'] +
            //     '..2: ' +
            //     mapPointData_ptEditScreen['pointPlayer2Hand']);

            // FORM WIDGETS
            children = <Widget>[
              // DEBUG Form_PlayerPointState >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
              // Align(
              //   alignment: Alignment.centerLeft,
              //   child: Text(
              //       'FoulBall: ${describeEnum(_dropdownListFoulBallLocation[0]).toString()}\nLoc: ${describeEnum(_dropdownListLocation[0]).toString()}\nHand: ${describeEnum(_dropdownListHand[0]).toString()}'
              //       // style: TextStyle(
              //       //   fontWeight: fontWeight_ScoreBoard_PrevSets,
              //       //   color: color_ScoreBoard_Text,
              //       //   fontSize: fontSize_ScoreBoard,
              //       // ),
              //       ),
              // ),
              // DEBUG Form_PlayerPointState <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

              Container(
                width: MediaQuery.of(context).size.width * 0.5,
                // height: 200,
                height:
                    MediaQuery.of(context).size.height * pctHeight_PtAttrib * 6,
                child: Form(
                  // key: (widget.PlayerNum == '1') ? keyForm_pointEdit1 : keyForm_pointEdit2,
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
                            pctHeight_PtAttrib,
                        child: DropdownButtonFormField<PointStrokeOptions>(
                          // child: DropdownButton<PointStrokeOptions>(
                          //   key: widget.keyForm,
                          value: _dropdownListStroke0,
                          isExpanded: true,
                          decoration: InputDecoration(labelText: 'Stroke'),
                          validator: (value) {
                            if (value == null || value == '') {
                              return 'Please provide a value.';
                            }
                            return null;
                          },
                          onTap: () {
                            _saveForm();
                          },
                          onChanged: (PointStrokeOptions? value) {
                            setState(() {
                              // this._dropdownListStroke0 =
                              _dropdownListStroke0 =
                                  value as PointStrokeOptions;
                              if (widget.PlayerNum == '1') {
                                mapPointData_ptEditScreen[
                                        'pointPlayer1Stroke'] =
                                    describeEnum(value!).toString();
                              } else {
                                mapPointData_ptEditScreen[
                                        'pointPlayer2Stroke'] =
                                    describeEnum(value!).toString();
                              }
                              _saveForm();
                            });
                          },
                          onSaved: (PointStrokeOptions? value) {
                            if (widget.PlayerNum == '1') {
                              mapPointData_ptEditScreen['pointPlayer1Stroke'] =
                                  describeEnum(value!).toString();
                            } else {
                              mapPointData_ptEditScreen['pointPlayer2Stroke'] =
                                  describeEnum(value!).toString();
                            }

                            // print(
                            //     'Form_PlayerPointState.. Stroke.. PlayerNum: ' +
                            //         widget.PlayerNum.toString() +
                            //         '.. value: ' +
                            //         describeEnum(value!).toString());
                            // setState(() {
                            //   _saveForm();
                            // });
                          },
                          items: _dropdownListStroke
                              .map((PointStrokeOptions value) {
                            return DropdownMenuItem<PointStrokeOptions>(
                                value: value, child: Text(describeEnum(value)));
                            // value: _dropdownListStroke[0], child: Text(describeEnum(value)));
                            // child: Text(value.toString()));
                          }).toList(),
                        ),
                      ),
                      // Container(
                      //   width: double.infinity,
                      //   height: MediaQuery.of(context).size.height *
                      //       pctHeight_PtAttrib,
                      //   child: DropdownButtonFormField<PointErrorOptions>(
                      //     value: _dropdownListPointError[0],
                      //     isExpanded: true,
                      //     decoration: InputDecoration(
                      //         labelText: 'Forced/ Unforced Error'),
                      //     validator: (value) {
                      //       if (value == null || value == '') {
                      //         return 'Please provide a value.';
                      //       }
                      //       return null;
                      //     },
                      //     onTap: () {
                      //       _saveForm();
                      //     },
                      //     onChanged: (PointErrorOptions? value) {
                      //       if (widget.PlayerNum == '1') {
                      //         mapPointData_ptEditScreen[
                      //                 'pointPlayer1ForceUnforced'] =
                      //             describeEnum(value!).toString();
                      //       } else {
                      //         mapPointData_ptEditScreen[
                      //                 'pointPlayer2ForceUnforced'] =
                      //             describeEnum(value!).toString();
                      //       }
                      //       setState(() {
                      //         _saveForm();
                      //       });
                      //     },
                      //     onSaved: (PointErrorOptions? value) {
                      //       if (widget.PlayerNum == '1') {
                      //         mapPointData_ptEditScreen[
                      //                 'pointPlayer1ForceUnforced'] =
                      //             describeEnum(value!).toString();
                      //       } else {
                      //         mapPointData_ptEditScreen[
                      //                 'pointPlayer2ForceUnforced'] =
                      //             describeEnum(value!).toString();
                      //       }
                      //
                      //       // print('Form_PlayerPointState.. PointError.. PlayerNum: ' + widget.PlayerNum.toString() + '.. value: ' + describeEnum(value!).toString());
                      //       // setState(() {
                      //       //   _saveForm();
                      //       // });
                      //     },
                      //     items: _dropdownListPointError
                      //         .map((PointErrorOptions value) {
                      //       return DropdownMenuItem<PointErrorOptions>(
                      //           value: value, child: Text(describeEnum(value)));
                      //       // child: Text(value.toString()));
                      //     }).toList(),
                      //   ),
                      // ),
                      // Container(
                      //   width: double.infinity,
                      //   height: MediaQuery.of(context).size.height *
                      //       pctHeight_PtAttrib /
                      //       pctHeight_PtAttrib_DenomAdj,
                      // ),
                      Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height *
                            pctHeight_PtAttrib /
                            pctHeight_PtAttrib_DenomAdj,
                      ),
                      Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height *
                            pctHeight_PtAttrib,
                        child: DropdownButtonFormField<PointHandOptions>(
                          // child: DropdownButton<PointHandOptions>(
                          //   key: widget.keyForm,
                          value: _dropdownListHand0,
                          isExpanded: true,
                          decoration: InputDecoration(labelText: 'Player Hand'),
                          validator: (value) {
                            if (value == null || value == '') {
                              return 'Please provide a value.';
                            }
                            return null;
                          },
                          onTap: () {
                            _saveForm();
                          },
                          onChanged: (PointHandOptions? value) {
                            setState(() {
                              // this._dropdownListHand0 = value as PointHandOptions;
                              _dropdownListHand0 = value as PointHandOptions;
                              if (widget.PlayerNum == '1') {
                                mapPointData_ptEditScreen['pointPlayer1Hand'] =
                                    describeEnum(value!).toString();
                              } else {
                                mapPointData_ptEditScreen['pointPlayer2Hand'] =
                                    describeEnum(value!).toString();
                              }
                              _saveForm();
                            });
                          },
                          onSaved: (PointHandOptions? value) {
                            if (widget.PlayerNum == '1') {
                              mapPointData_ptEditScreen['pointPlayer1Hand'] =
                                  describeEnum(value!).toString();
                            } else {
                              mapPointData_ptEditScreen['pointPlayer2Hand'] =
                                  describeEnum(value!).toString();
                            }

                            // setState(() {
                            //   _saveForm();
                            // });
                          },
                          items:
                              _dropdownListHand.map((PointHandOptions value) {
                            return DropdownMenuItem<PointHandOptions>(
                                value: value, child: Text(describeEnum(value)));
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
                        height: MediaQuery.of(context).size.height *
                            pctHeight_PtAttrib,
                        child: DropdownButtonFormField<PointLocationOptions>(
                          // child: DropdownButton<PointLocationOptions>(
                          //   key: widget.keyForm,
                          // value: _dropdownListLocation0,
                          value: ((widget.PlayerNum == '1' &&
                              mapPointData_ptEditScreen[
                              'pointPlayer1Stroke'] ==
                                  'Volley') ||
                              (widget.PlayerNum == '2' &&
                                  mapPointData_ptEditScreen[
                                  'pointPlayer2Stroke'] ==
                                      'Volley'))
                              ? PointLocationOptions.Net
                              : ((widget.PlayerNum == '2' &&
                              mapPointData_ptEditScreen[
                              'pointPlayer1Stroke'] ==
                                  'Lob') ||
                              (widget.PlayerNum == '1' &&
                                  mapPointData_ptEditScreen[
                                  'pointPlayer2Stroke'] ==
                                      'Lob'))
                              ? PointLocationOptions.Net
                              : _dropdownListLocation0,
                          isExpanded: true,
                          decoration:
                          InputDecoration(labelText: 'Player Location'),
                          validator: (value) {
                            if (value == null || value == '') {
                              return 'Please provide a value.';
                            }
                            return null;
                          },
                          onTap: () {
                            _saveForm();
                          },
                          onChanged: (PointLocationOptions? value) {
                            setState(() {
                              // this._dropdownListLocation0 =
                              _dropdownListLocation0 =
                              value as PointLocationOptions;
                              if (widget.PlayerNum == '1') {
                                mapPointData_ptEditScreen[
                                'pointPlayer1Location'] =
                                    describeEnum(value!).toString();
                              } else {
                                mapPointData_ptEditScreen[
                                'pointPlayer2Location'] =
                                    describeEnum(value!).toString();
                              }
                              _saveForm();
                            });
                          },
                          onSaved: (PointLocationOptions? value) {
                            if (widget.PlayerNum == '1') {
                              mapPointData_ptEditScreen[
                              'pointPlayer1Location'] =
                                  describeEnum(value!).toString();
                            } else {
                              mapPointData_ptEditScreen[
                              'pointPlayer2Location'] =
                                  describeEnum(value!).toString();
                            }

                            // setState(() {
                            //   _saveForm();
                            // });
                          },
                          items: _dropdownListLocation
                              .map((PointLocationOptions value) {
                            return DropdownMenuItem<PointLocationOptions>(
                                value: value, child: Text(describeEnum(value)));
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
                        height: MediaQuery.of(context).size.height *
                            pctHeight_PtAttrib,
                        child: DropdownButtonFormField<
                            PointFoulBallLocationOptions>(
                          // child: DropdownButton<PointFoulBallLocationOptions>(
                          //   key: widget.keyForm,
                          value: _dropdownListFoulBallLocation0,
                          isExpanded: true,
                          decoration:
                          //InputDecoration(labelText: 'Foul Ball Location'),
                          InputDecoration(labelText: 'Unforced Error Type'),
                          validator: (value) {
                            if (value == null || value == '') {
                              return 'Please provide a value.';
                            }
                            return null;
                          },
                          onTap: () {
                            _saveForm();
                          },
                          onChanged: (PointFoulBallLocationOptions? value) {
                            setState(() {
                              // this._dropdownListFoulBallLocation0 =
                              _dropdownListFoulBallLocation0 =
                              value as PointFoulBallLocationOptions;
                              if (widget.PlayerNum == '1') {
                                mapPointData_ptEditScreen[
                                'pointPlayer1FoulBallLocation'] =
                                    describeEnum(value!).toString();
                              } else {
                                mapPointData_ptEditScreen[
                                'pointPlayer2FoulBallLocation'] =
                                    describeEnum(value!).toString();
                              }
                              _saveForm();
                            });
                          },
                          onSaved: (PointFoulBallLocationOptions? value) {
                            if (widget.PlayerNum == '1') {
                              mapPointData_ptEditScreen[
                              'pointPlayer1FoulBallLocation'] =
                                  describeEnum(value!).toString();
                            } else {
                              mapPointData_ptEditScreen[
                              'pointPlayer2FoulBallLocation'] =
                                  describeEnum(value!).toString();
                            }

                            // setState(() {
                            //   _saveForm();
                            // });
                          },
                          items: _dropdownListFoulBallLocation
                              .map((PointFoulBallLocationOptions value) {
                            return DropdownMenuItem<
                                PointFoulBallLocationOptions>(
                                value: value, child: Text(describeEnum(value)));
                            // value: _dropdownListFoulBallLocation[0], child: Text(describeEnum(value)));
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
                    ],
                  ),
                ),
              ),
            ];
            // FORM WIDGETS

          } else {
            children = <Widget>[
              Text('ERROR: FutureBuilder updateDropdownLists'),
            ];
          }
          return Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: children,
          );
        });
  }
}

class pointsScreenArgs {
  String matchID = '';
  // int index = -1;
  String index = '-1';

  pointsScreenArgs(this.matchID, this.index);
}

class PointEditScreenArgs {
  String _mapID = '';
  String _point = '';

  PointEditScreenArgs(this._mapID, this._point);
}

class PointEditScreen extends StatefulWidget with ChangeNotifier {
  static const routeName = '/edit-point';

  @override
  PointEditScreenState createState() => PointEditScreenState();
}

class PointEditScreenState extends State<PointEditScreen> with ChangeNotifier {
  var _isInit = true;
  var _boolMatchAlreadyOver = false;

  // Map<String, dynamic> mapPointData_ptEditScreen = {};

  // @override
  // void didUpdateWidget(PointEditScreen oldWidget) {
  //   if (this.mapPointData_ptEditScreen != widget.mapPointData_ptEditScreen) {
  //     setState(() {
  //       this.mapPointData_ptEditScreen = widget.mapPointData_ptEditScreen;
  //     });
  //   }
  //   super.didUpdateWidget(oldWidget);
  // }

  @override
  void didChangeDependencies() {
    //didChangeDependencies is called just a few moments after the state loads its dependencies and context is available at this moment so here you can use context.

    // print('PointEditScreen.. didChangeDependencies.. ' + _isInit.toString());

    // reset Forms
    // keyForm_pointEdit1.currentState!.reset();
    // keyForm_pointEdit2.currentState!.reset();

    if (_isInit) {
      // Load maps
      mapMatchData_ptEditScreen =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      if (mapMatchData_ptEditScreen.isEmpty) {
        // print('PointEditScreenState.. mapMatchData_ptEditScreen.isEmpty' +
        //     _isInit.toString());
      }
      mapPointData_ptEditScreen =
          new Map<String, dynamic>.from(mapPointData_INIT);
      // Map<String, dynamic> mapPointData_ptEditScreen = mapPointData_INIT;

      mapPointData_ptEditScreen['pointMatchID'] =
          mapMatchData_ptEditScreen['matchID'];
      mapPointData_ptEditScreen['pointPlayer1ID'] =
          mapMatchData_ptEditScreen['matchPlayer1ID'];
      mapPointData_ptEditScreen['pointPlayer2ID'] =
          mapMatchData_ptEditScreen['matchPlayer2ID'];
      mapPointData_ptEditScreen['pointService_PlayerNum'] =
          mapMatchData_ptEditScreen['matchService_PlayerNum'];

      // print('PointEditScreen.. didChangeDependencies.. pointMatchID: ' +
      //     mapPointData_ptEditScreen['pointMatchID'].toString());
      // print('PointEditScreen.. didChangeDependencies.. matchID: ' +
      //     mapMatchData_ptEditScreen['matchID'].toString());
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _savePoint2FB(mapPointData_ptEditScreen, _matchID) async {
    // final isValid = widget.keyForm.currentState!.validate();
    // if (!isValid) {
    //   return;
    // }

    final Map<int, String> _mapPt2Score = {
      0: '0',
      1: '15',
      2: '30',
      3: '40',
    };

    // commit Form values to variables
    keyForm_pointEdit1.currentState!.save();
    keyForm_pointEdit2.currentState!.save();

    // Recalc Match Stats
    globals.stringGameLeadingPlayer =
        (mapMatchData_ptEditScreen['matchCurrGamePts_Player1'] ==
                    mapMatchData_ptEditScreen['matchCurrGamePts_PlayerMAX'] &&
                mapMatchData_ptEditScreen['matchCurrGamePts_Player1'] ==
                    mapMatchData_ptEditScreen['matchCurrGamePts_Player2'])
            ? '9' // Tied and at game point
            : (mapMatchData_ptEditScreen['matchCurrGamePts_Player1'] ==
                    mapMatchData_ptEditScreen['matchCurrGamePts_PlayerMAX'])
                ? '1'
                : (mapMatchData_ptEditScreen['matchCurrGamePts_Player2'] ==
                        mapMatchData_ptEditScreen['matchCurrGamePts_PlayerMAX'])
                    ? '2'
                    : '0';

     globals.boolGameLeadingPlayerWon = (globals.stringGameLeadingPlayer == '9')
        ? true // 20230116 -> Necessary??
        : (mapPointData_ptEditScreen['pointPtWon_PlayerNum'] ==
                globals.stringGameLeadingPlayer)
            ? true
            : false;

     globals.stringSetLeadingPlayer = (mapMatchData_ptEditScreen[
                    'matchCurrSetGames_Player1'] ==
                mapMatchData_ptEditScreen['matchCurrSetGames_PlayerMAX'] &&
            mapMatchData_ptEditScreen['matchCurrSetGames_Player1'] ==
                mapMatchData_ptEditScreen['matchCurrSetGames_Player2'])
        ? '9' // Tied and at game point
        : (mapMatchData_ptEditScreen['matchCurrSetGames_Player1'] ==
                mapMatchData_ptEditScreen['matchCurrSetGames_PlayerMAX'])
            ? '1'
            : (mapMatchData_ptEditScreen['matchCurrSetGames_Player2'] ==
                    mapMatchData_ptEditScreen['matchCurrSetGames_PlayerMAX'])
                ? '2'
                : '0';
    globals.boolSetLeadingPlayerWon = (globals.stringSetLeadingPlayer == '9')
        ? true
        : (mapPointData_ptEditScreen['pointPtWon_PlayerNum'] ==
                globals.stringSetLeadingPlayer)
            ? true
            : false;

    globals.stringMatchLeadingPlayer =
        (mapMatchData_ptEditScreen['matchSetsWon_Player1'] ==
                    mapMatchData_ptEditScreen['matchSetsWon_PlayerMAX'] &&
                mapMatchData_ptEditScreen['matchSetsWon_Player1'] ==
                    mapMatchData_ptEditScreen['matchSetsWon_Player2'])
            ? '9' // Tied and at game point
            : (mapMatchData_ptEditScreen['matchSetsWon_Player1'] ==
                    mapMatchData_ptEditScreen['matchSetsWon_PlayerMAX'])
                ? '1'
                : (mapMatchData_ptEditScreen['matchSetsWon_Player2'] ==
                        mapMatchData_ptEditScreen['matchSetsWon_PlayerMAX'])
                    ? '2'
                    : '0';
    globals.boolMatchLeadingPlayerWon = (globals.stringMatchLeadingPlayer == '9')
        ? true
        : (mapPointData_ptEditScreen['pointPtWon_PlayerNum'] ==
                globals.stringMatchLeadingPlayer)
            ? true
            : false;

    if (mapPointData_ptEditScreen['pointPtWon_PlayerNum'] != '0') {
      // UPDATE GAMES + SETS + MATCH BUT NOT POINTS >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
      // matchCurrSetGames_Player++
      // matchCurrGameScores_Player = 0
      // matchCurrGameScores_Player = 0
      // matchSetsWon_Player++
      // matchCurrSet++

      // New Game
      if (mapMatchData_ptEditScreen['matchIsGamePt'] == true) {
        if (globals.boolGameLeadingPlayerWon) {
          mapMatchData_ptEditScreen['matchIsGamePt'] = false;

          mapMatchData_ptEditScreen['matchService_PlayerNum'] =
              (mapMatchData_ptEditScreen['matchService_PlayerNum'] == '1')
                  ? '2'
                  : (mapMatchData_ptEditScreen['matchService_PlayerNum'] == '2')
                      ? '1'
                      : '0';
          mapPointData_ptEditScreen['pointService_PlayerNum'] =
              mapMatchData_ptEditScreen['matchService_PlayerNum'];

          if (mapPointData_ptEditScreen['pointPtWon_PlayerNum'] == '1') {
            mapMatchData_ptEditScreen['matchCurrSetGames_Player1']++;
          } else if (mapPointData_ptEditScreen['pointPtWon_PlayerNum'] == '2') {
            mapMatchData_ptEditScreen['matchCurrSetGames_Player2']++;
          }

          if (mapPointData_ptEditScreen['pointPtWon_PlayerNum'] == '1') {
            mapMatchData_ptEditScreen['matchCurrGamePts_Player1'] =
                -1; // ++ later in code
            mapMatchData_ptEditScreen['matchCurrGamePts_Player2'] =
                0; // ++ later in code
          } else if (mapPointData_ptEditScreen['pointPtWon_PlayerNum'] == '2') {
            mapMatchData_ptEditScreen['matchCurrGamePts_Player1'] =
                0; // ++ later in code
            mapMatchData_ptEditScreen['matchCurrGamePts_Player2'] =
                -1; // ++ later in code
          }
          mapMatchData_ptEditScreen['matchCurrGameScores_Player1'] = '0';
          mapMatchData_ptEditScreen['matchCurrGameScores_Player2'] = '0';
        }
      }

      // New Set
      if (mapMatchData_ptEditScreen['matchIsSetPt'] == true) {
        if (globals.boolGameLeadingPlayerWon && globals.boolSetLeadingPlayerWon) {
          mapMatchData_ptEditScreen['matchIsSetPt'] = false;

          if (mapPointData_ptEditScreen['pointPtWon_PlayerNum'] == '1') {
            mapMatchData_ptEditScreen['matchSetsWon_Player1']++;
          } else if (mapPointData_ptEditScreen['pointPtWon_PlayerNum'] == '2') {
            mapMatchData_ptEditScreen['matchSetsWon_Player2']++;
          }

          mapMatchData_ptEditScreen['matchPriorSetGames_Player1']
              .add(mapMatchData_ptEditScreen['matchCurrSetGames_Player1']);
          mapMatchData_ptEditScreen['matchPriorSetGames_Player2']
              .add(mapMatchData_ptEditScreen['matchCurrSetGames_Player2']);
          mapMatchData_ptEditScreen['matchSetTotPts_Player1']
              .add(mapMatchData_ptEditScreen['matchCurrSetPts_Player1']);
          mapMatchData_ptEditScreen['matchSetTotPts_Player2']
              .add(mapMatchData_ptEditScreen['matchCurrSetPts_Player2']);

          mapMatchData_ptEditScreen['matchCurrSetPts_Player1'] = 0;
          mapMatchData_ptEditScreen['matchCurrSetPts_Player2'] = 0;
          mapMatchData_ptEditScreen['matchCurrSetGames_Player1'] = 0;
          mapMatchData_ptEditScreen['matchCurrSetGames_Player2'] = 0;
          mapMatchData_ptEditScreen['matchCurrSet']++;
        }
      }

      // New Match
      if (mapMatchData_ptEditScreen['matchIsMatchPt'] == true &&
          globals.boolGameLeadingPlayerWon &&
          globals.boolSetLeadingPlayerWon &&
          globals.boolMatchLeadingPlayerWon) {
        mapMatchData_ptEditScreen['matchIsMatchPt'] = false;
        if (mapMatchData_ptEditScreen['matchIsMatchPt'] == true) {
          _boolMatchAlreadyOver = true;
        }
        mapMatchData_ptEditScreen['matchIsMatchOver'] = true;
      }
    }

    // UPDATE POINTS. GAMES + SETS + MATCH ALREADY UPDATED >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    // matchCurrGamePts_Player
    // matchCurrGameScores_Player
    // matchCurrSetPts_Player

    // Condition not met to save to FB
    // if (mapPointData_ptEditScreen['pointPtWon_PlayerNum'] == '0') {
    if (mapPointData_ptEditScreen['pointPtWon_PlayerNum'] == '0' ||
        _boolMatchAlreadyOver == true) {
      // print('_savePoint2FB.. matchIsMatchOver: ' +
      //     mapMatchData_ptEditScreen['matchIsMatchOver'].toString() +
      //     '.. WINNER: ' +
      //     mapPointData_ptEditScreen['pointPtWon_PlayerNum']);
    } else {
      // Update mapPointData_ptEditScreen locally
      mapPointData_ptEditScreen['pointID'] =
          ('PT=${DateTime.now().year}${DateTime.now().month.toString().padLeft(2, '0')}${DateTime.now().day.toString().padLeft(2, '0')}_${DateTime.now().hour.toString().padLeft(2, '0')}${DateTime.now().minute.toString().padLeft(2, '0')}${DateTime.now().second.toString().padLeft(2, '0')}_Match=${_matchID}');
      mapPointData_ptEditScreen['pointEntryDate'] = DateTime.now();
      // mapPointData_ptEditScreen['pointService_PlayerNum'] =
      //     mapMatchData_ptEditScreen['matchService_PlayerNum'];

      // ForceUnforced is now determined by Foul Ball Location
      mapPointData_ptEditScreen['pointPlayer1ForceUnforced'] =
          (mapPointData_ptEditScreen['pointPtWon_PlayerNum'] == '1')
              ? 'NA'
              : (mapPointData_ptEditScreen['pointPlayer1FoulBallLocation'] ==
                      'NA')
                  ? 'Forced'
                  : 'Unforced';
      mapPointData_ptEditScreen['pointPlayer2ForceUnforced'] =
          (mapPointData_ptEditScreen['pointPtWon_PlayerNum'] == '2')
              ? 'NA'
              : (mapPointData_ptEditScreen['pointPlayer2FoulBallLocation'] ==
                      'NA')
                  ? 'Forced'
                  : 'Unforced';

      // print('_savePoint2FB.. ' + mapPointData_ptEditScreen['pointID']);
      // print('_savePoint2FB.. ' + _matchID);

      // print('_savePoint2FB.. pointPlayer1Hand: ' + mapPointData_ptEditScreen['pointPlayer1Hand'] + '..2: ' + mapPointData_ptEditScreen['pointPlayer2Hand']);
      // print('_savePoint2FB.. pointPlayer1Hand: ' +
      //     mapPointData_ptEditScreen.toString());

      // Add mapPointData_ptEditScreen to FB
      CollectionReference collectionReference = await FirebaseFirestore.instance
          .collection('Matches')
          .doc(_matchID)
          .collection('Points');

      // print('_savePoint2FB length' + collectionReference.snapshots().length.toString());
      // collectionReference.add(mapMatchData_ptEditScreen);
      collectionReference
          .doc(mapPointData_ptEditScreen['pointID'])
          .set(mapPointData_ptEditScreen);

      // Update mapMatchData_ptEditScreen locally
      // mapMatchData_ptEditScreen['matchService_PlayerNum'] =
      //     mapPointData_ptEditScreen['pointService_PlayerNum'];

      // Calc Scores
      // print('_savePoint2FB CurrGamePts BOP 1: ' +
      //     mapMatchData_ptEditScreen['matchCurrGamePts_Player1'].toString() +
      //     '.. 2: ' +
      //     mapMatchData_ptEditScreen['matchCurrGamePts_Player2'].toString());
      if (mapPointData_ptEditScreen['pointPtWon_PlayerNum'] == '1') {
        mapMatchData_ptEditScreen['matchCurrGamePts_Player1']++;
        mapMatchData_ptEditScreen['matchCurrSetPts_Player1']++;
      } else if (mapPointData_ptEditScreen['pointPtWon_PlayerNum'] == '2') {
        mapMatchData_ptEditScreen['matchCurrGamePts_Player2']++;
        mapMatchData_ptEditScreen['matchCurrSetPts_Player2']++;
      }
      // print('_savePoint2FB CurrGamePts EOP 1: ' +
      //     mapMatchData_ptEditScreen['matchCurrGamePts_Player1'].toString() +
      //     '.. 2: ' +
      //     mapMatchData_ptEditScreen['matchCurrGamePts_Player2'].toString());


      // TieBreak Serve Changing - Pts has not been updated
      int _tmp = mapMatchData_ptEditScreen['matchCurrGamePts_Player1'] +
          mapMatchData_ptEditScreen['matchCurrGamePts_Player2'];
      if (mapMatchData_ptEditScreen['matchCurrGameFormat'] == 'TieBreak' ||
          mapMatchData_ptEditScreen['matchCurrGameFormat'] == 'SuperTieBreak') {
        // if (_tmp < 0 || _tmp % 3 == 0) {
        if (_tmp % 2 == 1) {
          // print('_savePoint2FB.. TieBreak Serve Changing.. Pre-Pts : ' + _tmp.toString());

          mapMatchData_ptEditScreen['matchService_PlayerNum'] =
          (mapMatchData_ptEditScreen['matchService_PlayerNum'] == '1')
              ? '2'
              : (mapMatchData_ptEditScreen['matchService_PlayerNum'] == '2')
              ? '1'
              : '0';
          mapPointData_ptEditScreen['pointService_PlayerNum'] =
          mapMatchData_ptEditScreen['matchService_PlayerNum'];
        } else {
          // print('_savePoint2FB.. TieBreak Serve NOT Changing.. Pre-Pts : ' + _tmp.toString());
        }
      }

      mapMatchData_ptEditScreen['matchCurrGameScores_Player1'] =
          (mapMatchData_ptEditScreen['matchCurrGamePts_Player1'] <= 3)
              ? _mapPt2Score[
                  mapMatchData_ptEditScreen['matchCurrGamePts_Player1']]
              : (mapMatchData_ptEditScreen['matchCurrGamePts_Player1'] >
                      mapMatchData_ptEditScreen['matchCurrGamePts_Player2'])
                  ? 'Ad'
                  : '40';

      mapMatchData_ptEditScreen['matchCurrGameScores_Player2'] =
          (mapMatchData_ptEditScreen['matchCurrGamePts_Player2'] <= 3)
              ? _mapPt2Score[
                  mapMatchData_ptEditScreen['matchCurrGamePts_Player2']]
              : (mapMatchData_ptEditScreen['matchCurrGamePts_Player2'] >
                      mapMatchData_ptEditScreen['matchCurrGamePts_Player1'])
                  ? 'Ad'
                  : '40';

      // print('_savePoint2FB.. ' + mapMatchData_ptEditScreen['matchCurrSetGames_Player1'].toString());
      // print('_savePoint2FB.. ' + int.parse(mapMatchData_ptEditScreen['matchCurrSetGames_Player1']));

      // print('_savePoint2FB CurrSetScores BOP 1: ' +
      //     mapMatchData_ptEditScreen['matchCurrSetGames_Player1'].toString() +
      //     '.. 2: ' +
      //     mapMatchData_ptEditScreen['matchCurrSetGames_Player2'].toString());
      List<int> _tmpList = [];
      _tmpList.add(mapMatchData_ptEditScreen['matchSetsWon_Player1']);
      _tmpList.add(mapMatchData_ptEditScreen['matchSetsWon_Player2']);
      mapMatchData_ptEditScreen['matchSetsWon_PlayerMAX'] =
          _tmpList.reduce(max); // _setMax
      mapMatchData_ptEditScreen['matchSetsWon_PlayerMIN'] =
          _tmpList.reduce(min); // _setMin
      mapMatchData_ptEditScreen['matchSetsWon_PlayerDIFF'] =
          (mapMatchData_ptEditScreen['matchSetsWon_Player1'] -
                  mapMatchData_ptEditScreen['matchSetsWon_Player2'])
              .abs(); //_setDiff

      // print('_savePoint2FB CurrSetScores BOP 1: ' +
      //     mapMatchData_ptEditScreen['matchCurrSetGames_Player1'].toString() +
      //     '.. 2: ' +
      //     mapMatchData_ptEditScreen['matchCurrSetGames_Player2'].toString());
      // print('_savePoint2FB.. _setMax: ' + mapMatchData_ptEditScreen['matchSetsWon_PlayerMAX'].toString());
      // print('_savePoint2FB.. _setMin: ' + mapMatchData_ptEditScreen['matchSetsWon_PlayerMIN'].toString());

      _tmpList = [];
      _tmpList.add(mapMatchData_ptEditScreen['matchCurrSetGames_Player1']);
      _tmpList.add(mapMatchData_ptEditScreen['matchCurrSetGames_Player2']);
      mapMatchData_ptEditScreen['matchCurrSetGames_PlayerMAX'] =
          _tmpList.reduce(max); // _gameMax

      mapMatchData_ptEditScreen['matchCurrSetGames_PlayerDIFF'] =
          (mapMatchData_ptEditScreen['matchCurrSetGames_Player1'] -
                  mapMatchData_ptEditScreen['matchCurrSetGames_Player2'])
              .abs(); //_gameDiff

      _tmpList = [];
      _tmpList.add(mapMatchData_ptEditScreen['matchCurrGamePts_Player1']);
      _tmpList.add(mapMatchData_ptEditScreen['matchCurrGamePts_Player2']);
      mapMatchData_ptEditScreen['matchCurrGamePts_PlayerMAX'] =
          _tmpList.reduce(max); // _ptMax

      mapMatchData_ptEditScreen['matchCurrGamePts_PlayerDIFF'] =
          (mapMatchData_ptEditScreen['matchCurrGamePts_Player1'] -
                  mapMatchData_ptEditScreen['matchCurrGamePts_Player2'])
              .abs(); // _ptDiff

      if (mapMatchData_ptEditScreen['matchSetFormat'] == 'ThreeOfFive') {
        mapMatchData_ptEditScreen['matchSetMMAX'] =
            5; // mapMatchData_ptEditScreen['matchSetMMAX']
        // if (mapMatchData_ptEditScreen['matchSetsWon_PlayerMAX'] == 3 &&
        //     mapMatchData_ptEditScreen['matchSetsWon_PlayerMIN'] == 0) {
        // if (mapMatchData_ptEditScreen['matchSetsWon_PlayerMIN'] == 0) {
        //  mapMatchData_ptEditScreen['matchSetMAX'] = 3; // _maxSet
        //} else {
        //  mapMatchData_ptEditScreen['matchSetMAX'] = 5; // _maxSet
        //}
        if (mapMatchData_ptEditScreen['matchSetsWon_PlayerDIFF'] >= 2) {
          mapMatchData_ptEditScreen['matchSetMAX'] =
              mapMatchData_ptEditScreen['matchSetsWon_PlayerMAX'];
        } else {
          mapMatchData_ptEditScreen['matchSetMAX'] =
              mapMatchData_ptEditScreen['matchSetsWon_PlayerMIN'] + 2;
          if (mapMatchData_ptEditScreen['matchSetMAX'] <= 3) {
            mapMatchData_ptEditScreen['matchSetMAX'] = 3;
          } else if (mapMatchData_ptEditScreen['matchSetMAX'] >= 5) {
            mapMatchData_ptEditScreen['matchSetMAX'] = 5;
          }
        }
      } else if (mapMatchData_ptEditScreen['matchSetFormat'] == 'TwoOfThree') {
        mapMatchData_ptEditScreen['matchSetMMAX'] = 3; // _maxmaxSet
        // if (mapMatchData_ptEditScreen['matchSetsWon_PlayerMAX'] == 2 &&
        //     mapMatchData_ptEditScreen['matchSetsWon_PlayerMIN'] == 0) {
        if (mapMatchData_ptEditScreen['matchSetsWon_PlayerMIN'] == 0) {
          mapMatchData_ptEditScreen['matchSetMAX'] = 2; // _maxSet
        } else {
          mapMatchData_ptEditScreen['matchSetMAX'] = 3; // _maxSet
        }
      } else if (mapMatchData_ptEditScreen['matchSetFormat'] == 'OneSet' ||
          mapMatchData_ptEditScreen['matchSetFormat'] == 'ProSet') {
        mapMatchData_ptEditScreen['matchSetMMAX'] = 1; // _maxmaxSet
        mapMatchData_ptEditScreen['matchSetMAX'] = 1; // _maxSet

      } else {
        mapMatchData_ptEditScreen['matchSetMMAX'] =
            1; // not supposed to happen // _maxmaxSet
        mapMatchData_ptEditScreen['matchSetMAX'] =
            1; // not supposed to happen // _maxSet

        // print('_savePoint2FB.. _maxSet Calc Error: ' +
        //     mapMatchData_ptEditScreen['matchSetFormat'] +
        //     '.. _setMax: ' +
        //     mapMatchData_ptEditScreen['matchSetsWon_PlayerMAX'].toString() +
        //     '.. _setMin: ' +
        //     mapMatchData_ptEditScreen['matchSetsWon_PlayerMIN'].toString());
      }

      // print('_savePoint2FB.. matchCurrSet: ' +
      //     mapMatchData_ptEditScreen['matchCurrSet'].toString() +
      //     '.. matchSetMMAX: ' +
      //     mapMatchData_ptEditScreen['matchSetMMAX'].toString() +
      //     '.. matchFinalSetFormat: ' +
      //     mapMatchData_ptEditScreen['matchFinalSetFormat']);

      // Last Set
      if (mapMatchData_ptEditScreen['matchCurrSet'] ==
              mapMatchData_ptEditScreen['matchSetMMAX'] - 0 &&
          mapMatchData_ptEditScreen['matchCurrSetGames_Player1'] ==
              mapMatchData_ptEditScreen['matchCurrSetGames_Player2'] &&
          mapMatchData_ptEditScreen['matchFinalSetFormat'] == 'SuperTieBreak') {
        mapMatchData_ptEditScreen['matchCurrGameFormat'] =
        'SuperTieBreak'; // Final set has 1 Super Tiebreak game
        // Last Set
      } else if (mapMatchData_ptEditScreen['matchCurrSet'] ==
          mapMatchData_ptEditScreen['matchSetMMAX'] - 0 &&
          mapMatchData_ptEditScreen['matchCurrSetGames_Player1'] ==
              mapMatchData_ptEditScreen['matchCurrSetGames_Player2'] &&
          mapMatchData_ptEditScreen['matchFinalSetFormat'] == 'TieBreak') {
        mapMatchData_ptEditScreen['matchCurrGameFormat'] =
        'TieBreak'; // Final set has 1 Tiebreak game fo UTR tournaments
      // Last Set
      } else if ((mapMatchData_ptEditScreen['matchCurrSet'] ==
                  mapMatchData_ptEditScreen['matchSetMMAX'] - 0 ||
              mapMatchData_ptEditScreen['matchSetsWon_PlayerMAX'] ==
                  mapMatchData_ptEditScreen['matchSetMAX'] - 0) &&
          mapMatchData_ptEditScreen['matchCurrSetGames_Player1'] ==
              mapMatchData_ptEditScreen[
                  'matchCurrSetGames_Player2'] && // Last Set
          mapMatchData_ptEditScreen['matchCurrSetGames_PlayerMAX'] >=
              mapMatchData_ptEditScreen['matchNumOfGamesPerSet'] -
                  0 && // Last Game of Set
          mapMatchData_ptEditScreen['matchFinalSetFormat'] == 'NoTieBreak') {
        mapMatchData_ptEditScreen['matchCurrGameFormat'] =
            'NoTieBreak'; // Final set has no Tiebreak
      // Tie Break
      } else if (mapMatchData_ptEditScreen['matchCurrSetGames_PlayerMAX'] >=
              mapMatchData_ptEditScreen['matchNumOfGamesPerSet'] &&
          mapMatchData_ptEditScreen['matchCurrSetGames_Player1'] ==
              mapMatchData_ptEditScreen['matchCurrSetGames_Player2']) {
        mapMatchData_ptEditScreen['matchCurrGameFormat'] =
            'TieBreak'; // Final set has Tiebreak
      // Regular
      } else {
        // NOT Last Set
        mapMatchData_ptEditScreen['matchCurrGameFormat'] = 'Regular';
      }

      mapMatchData_ptEditScreen['matchGameMAX'] =
          (mapMatchData_ptEditScreen['matchCurrGameFormat'] == 'SuperTieBreak')
              ? 1
              : (mapMatchData_ptEditScreen['matchCurrGameFormat'] == 'TieBreak')
                  ? mapMatchData_ptEditScreen['matchNumOfGamesPerSet'] + 1
                  : (mapMatchData_ptEditScreen['matchCurrGameFormat'] ==
                          'NoTieBreak')
                      ? (mapMatchData_ptEditScreen[
                                  'matchCurrSetGames_PlayerDIFF'] >=
                              1)
                          ? mapMatchData_ptEditScreen[
                                  'matchCurrSetGames_PlayerMAX'] +
                              1
                          : 999
                      : mapMatchData_ptEditScreen[
                          'matchNumOfGamesPerSet']; // _maxGame

      mapMatchData_ptEditScreen['matchPtMAX'] =
          (mapMatchData_ptEditScreen['matchCurrGameFormat'] == 'SuperTieBreak')
              ? 10
              : (mapMatchData_ptEditScreen['matchCurrGameFormat'] == 'TieBreak')
                  ? 7
                  : 4; // _maxPt
      mapMatchData_ptEditScreen[
          'matchPtMAX'] = (mapMatchData_ptEditScreen['matchAd'] == 'NoAd' &&
              (!(['SuperTieBreak', 'TieBreak']
                  .contains(mapMatchData_ptEditScreen['matchCurrGameFormat']))))
          ? 4
          : (mapMatchData_ptEditScreen['matchCurrGamePts_PlayerMAX'] <
                      mapMatchData_ptEditScreen['matchPtMAX'] &&
                  mapMatchData_ptEditScreen['matchCurrGamePts_PlayerDIFF'] >= 1)
              ? mapMatchData_ptEditScreen['matchPtMAX']
              : (mapMatchData_ptEditScreen['matchCurrGamePts_PlayerMAX'] >=
                          mapMatchData_ptEditScreen['matchPtMAX'] &&
                      mapMatchData_ptEditScreen[
                              'matchCurrGamePts_PlayerDIFF'] >=
                          1)
                  ? mapMatchData_ptEditScreen['matchCurrGamePts_PlayerMAX'] + 1
                  : 999; // _maxPt

      mapMatchData_ptEditScreen['matchIsMatchPt'] = false;
      mapMatchData_ptEditScreen['matchIsSetPt'] = false;
      mapMatchData_ptEditScreen['matchIsGamePt'] = false;
      // Last Point of Game
      // if (mapMatchData_ptEditScreen['matchCurrGamePts_PlayerMAX'] >=
      //     mapMatchData_ptEditScreen['matchPtMAX'] - 1 &&
      //     globals.boolGameLeadingPlayerWon) {
      if (mapMatchData_ptEditScreen['matchCurrGamePts_PlayerMAX'] >=
          mapMatchData_ptEditScreen['matchPtMAX'] - 1) {
        mapMatchData_ptEditScreen['matchIsGamePt'] = true;
        // Last Game of Set
        if (mapMatchData_ptEditScreen['matchCurrSetGames_PlayerMAX'] >=
            mapMatchData_ptEditScreen['matchGameMAX'] - 1 &&
            globals.stringGameLeadingPlayer == globals.stringSetLeadingPlayer) {
          //if (mapMatchData_ptEditScreen['matchCurrSetGames_PlayerMAX'] >=
          //      mapMatchData_ptEditScreen['matchGameMAX'] - 1) {
          mapMatchData_ptEditScreen['matchIsSetPt'] = true;

          // Last Set of Match
          //if ((mapMatchData_ptEditScreen['matchSetsWon_PlayerMAX'] >=
          //    mapMatchData_ptEditScreen['matchSetMAX'] - 1 ||
          //    mapMatchData_ptEditScreen['matchCurrSet'] >=
          //        mapMatchData_ptEditScreen['matchSetMMAX'] - 1) &&
          //    globals.stringGameLeadingPlayer == globals.stringSetLeadingPlayer &&
          //    globals.stringGameLeadingPlayer == globals.stringMatchLeadingPlayer) {
          //  mapMatchData_ptEditScreen['matchIsMatchPt'] = true;
          //}
          if ((mapMatchData_ptEditScreen['matchSetsWon_PlayerMAX'] >=
                      mapMatchData_ptEditScreen['matchSetMAX'] - 1 ||
                  mapMatchData_ptEditScreen['matchCurrSet'] >=
                      mapMatchData_ptEditScreen['matchSetMMAX'] - 1)) {
            mapMatchData_ptEditScreen['matchIsMatchPt'] = true;
          }
        }
      }

      // print('_savePoint2FB.. matchCurrGamePts_PlayerMAX: ' +
      //     mapMatchData_ptEditScreen['matchCurrGamePts_PlayerMAX'].toString() +
      //     '.. matchCurrGamePts_PlayerDIFF: ' +
      //     mapMatchData_ptEditScreen['matchCurrGamePts_PlayerDIFF'].toString() +
      //     '.. _maxPt: ' +
      //     mapMatchData_ptEditScreen['matchPtMAX'].toString());
      // print('_savePoint2FB.. matchCurrSetGames_PlayerMAX: ' +
      //     mapMatchData_ptEditScreen['matchCurrSetGames_PlayerMAX'].toString() +
      //     '.. matchCurrSetGames_PlayerDIFF: ' +
      //     mapMatchData_ptEditScreen['matchCurrSetGames_PlayerDIFF'].toString() +
      //     '.. _maxGame: ' +
      //     mapMatchData_ptEditScreen['matchGameMAX'].toString());
      // print('_savePoint2FB.. matchSetsWon_PlayerMAX: ' +
      //     mapMatchData_ptEditScreen['matchSetsWon_PlayerMAX'].toString() +
      //     '.. matchCurrSet: ' +
      //     mapMatchData_ptEditScreen['matchCurrSet'].toString() +
      //     '.. _maxSet: ' +
      //     mapMatchData_ptEditScreen['matchSetMAX'].toString() +
      //     '.. _maxmaxSet: ' +
      //     mapMatchData_ptEditScreen['matchSetMMAX'].toString());
      // print('_savePoint2FB.. matchIsGamePt: ' +
      //     mapMatchData_ptEditScreen['matchIsGamePt'].toString() +
      //     '.. matchIsSetPt: ' +
      //     mapMatchData_ptEditScreen['matchIsSetPt'].toString() +
      //     '.. matchIsMatchPt: ' +
      //     mapMatchData_ptEditScreen['matchIsMatchPt'].toString());
      // print('_savePoint2FB.. globals.boolGameLeadingPlayerWon: ' +
      //     globals.boolGameLeadingPlayerWon.toString() +
      //     '.. globals.boolSetLeadingPlayerWon: ' +
      //     globals.boolSetLeadingPlayerWon.toString() +
      //     '.. globals.boolMatchLeadingPlayerWon: ' +
      //     globals.boolMatchLeadingPlayerWon.toString());

      // Update mapMatchData_ptEditScreen on FB
      CollectionReference collectionReference2 =
          await FirebaseFirestore.instance.collection('Matches');
      // .doc(_matchID)
      // .collection('Points');
      collectionReference2.doc(_matchID).set(mapMatchData_ptEditScreen);

      // Reset variables
      mapPointData_ptEditScreen['pointService_Type'] = 'FirstServe';
      mapPointData_ptEditScreen['pointPtWon_PlayerNum'] = '0';
    } // Condition met to save to FB

    // reset Forms
    keyForm_pointEdit1.currentState!.reset();
    keyForm_pointEdit2.currentState!.reset();
  } // _savePoint2FB

  // PointEditScreenState
  @override
  Widget build(BuildContext context) {
    // print('PointEditScreenState.. ' + mapPointData_ptEditScreen.toString());

    String _stringStatusMsg =
        '${mapPointData_ptEditScreen['pointService_Type']} ${(mapPointData_ptEditScreen['pointService_PlayerNum'] == '1') ? mapMatchData_ptEditScreen['matchPlayer1FirstName'] : mapMatchData_ptEditScreen['matchPlayer2FirstName']}... ';
    if (mapMatchData_ptEditScreen['matchIsMatchOver']) {
      _stringStatusMsg = 'MATCH IS OVER... ';
    } else if (mapMatchData_ptEditScreen['matchIsMatchPt']) {
      _stringStatusMsg = _stringStatusMsg + 'Match Point... ';
    } else if (mapMatchData_ptEditScreen['matchIsSetPt']) {
      _stringStatusMsg = _stringStatusMsg + 'Set Point... ';
    } else if (mapMatchData_ptEditScreen['matchIsGamePt']) {
      _stringStatusMsg = _stringStatusMsg + 'Game Point... ';
    } else {
      _stringStatusMsg = _stringStatusMsg +
          'Game: ${mapMatchData_ptEditScreen['matchCurrGameFormat']}';
    }

    return Scaffold(
        appBar: AppBar(
          // title: const Text('Match In Progress'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons
                  .bar_chart), // insert_chart_outlined, insert_chart, bar_chart
              onPressed: () {
                _args = StatScreenArgs(
                    mapPointData_ptEditScreen as Map<String, dynamic>,
                    mapMatchData_ptEditScreen as Map<String, dynamic>);
                Navigator.of(context).pushNamed(
                  StatScreen.routeName,
                  arguments: _args,
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.analytics_outlined),
              onPressed: () {
                _args = DebugScreenArgs(
                    mapPointData_ptEditScreen as Map<String, dynamic>,
                    mapMatchData_ptEditScreen as Map<String, dynamic>);
                Navigator.of(context)
                    .pushNamed(
                  DebugScreen.routeName,
                  arguments: _args,
                )
                    .then((value) => setState(() {}));
              },
            ),
            IconButton(
              icon: const Icon(Icons.dynamic_feed),
              onPressed: () {
                Navigator.of(context).pushNamed(
                  PointsScreen.routeName,
                  arguments: mapMatchData_ptEditScreen['matchID'],
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                _args = scoreEditScreenArgs(
                    mapPointData_ptEditScreen as Map<String, dynamic>,
                    mapMatchData_ptEditScreen as Map<String, dynamic>);
                Navigator.of(context)
                    .pushNamed(
                      ScoreEditScreen.routeName,
                      // arguments: mapMatchData_ptEditScreen,
                      arguments: _args,
                    )
                    .then((value) => setState(() {}));
              },
            ),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: () {
                setState(() {
                  _savePoint2FB(mapPointData_ptEditScreen,
                      mapMatchData_ptEditScreen['matchID']);
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
              _savePoint2FB(mapPointData_ptEditScreen,
                  mapMatchData_ptEditScreen['matchID']);
              // Navigator.of(context)
              //     .pushNamed(PointEditScreen.routeName, arguments: '');
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

        body: Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Column(
            children: <Widget>[
              // SCORE BOARD >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
              Container(
                color: color_ScoreBoard_Bkgrd,
                height:
                    MediaQuery.of(context).size.height * pctHeight_ScoreBoard,
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
                                      '${mapMatchData_ptEditScreen['matchPlayer1FirstName']} ${mapMatchData_ptEditScreen['matchPlayer1LastName'].toUpperCase()}',
                                      style: TextStyle(
                                        fontWeight: fontWeight_ScoreBoard_Name,
                                        color: color_ScoreBoard_Text,
                                        fontSize: fontSize_ScoreBoard,
                                      ),
                                    ),
                                    (mapPointData_ptEditScreen[
                                                'pointService_PlayerNum'] ==
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
                                mapMatchData_ptEditScreen[
                                        'matchPriorSetGames_Player1']
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
                                '${mapMatchData_ptEditScreen['matchCurrSetGames_Player1']}  ${(mapMatchData_ptEditScreen['matchCurrGameFormat'] == 'Regular' || mapMatchData_ptEditScreen['matchIsMatchOver']) ? mapMatchData_ptEditScreen['matchCurrGameScores_Player1'] : mapMatchData_ptEditScreen['matchCurrGamePts_Player1']}',
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
                                      '${mapMatchData_ptEditScreen['matchPlayer2FirstName']} ${mapMatchData_ptEditScreen['matchPlayer2LastName'].toUpperCase()}',
                                      style: TextStyle(
                                        fontWeight: fontWeight_ScoreBoard_Name,
                                        color: color_ScoreBoard_Text,
                                        fontSize: fontSize_ScoreBoard,
                                      ),
                                    ),
                                    (mapPointData_ptEditScreen[
                                                'pointService_PlayerNum'] ==
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
                                mapMatchData_ptEditScreen[
                                        'matchPriorSetGames_Player2']
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
                                '${mapMatchData_ptEditScreen['matchCurrSetGames_Player2']}  ${(mapMatchData_ptEditScreen['matchCurrGameFormat'] == 'Regular' || mapMatchData_ptEditScreen['matchIsMatchOver']) ? mapMatchData_ptEditScreen['matchCurrGameScores_Player2'] : mapMatchData_ptEditScreen['matchCurrGamePts_Player2']}',
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
                height: 5.0,
                // MediaQuery.of(context).size.height * pctHeight_PtAttrib / pctHeight_PtAttrib_DenomAdj,
              ),

              // STATUS BAR >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
              Container(
                color: color_ScoreBoard_Bkgrd,
                width: double.infinity,
                height:
                    MediaQuery.of(context).size.height * pctHeight_PtAttrib / 3,
                child: Text(
                  // 'PROBLEM HERE..${mapMatchData_ptEditScreen['matchID'].toString()}',
                  // '${mapPointData_ptEditScreen['pointService_Type']} ${(mapPointData_ptEditScreen['pointService_PlayerNum'] == '1') ? mapMatchData_ptEditScreen['matchPlayer1FirstName'] : mapMatchData_ptEditScreen['matchPlayer2FirstName']}... Game: ${mapMatchData_ptEditScreen['matchCurrGameFormat']}...',
                  _stringStatusMsg,
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                width: double.infinity,
                height: 5.0,
                // MediaQuery.of(context).size.height * pctHeight_PtAttrib / pctHeight_PtAttrib_DenomAdj,
              ),

              // SERVICE LOGIC >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * pctHeight_PtAttrib,
                child: (mapPointData_ptEditScreen['pointService_Type'] ==
                        'FirstServe')
                    ? Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            height: MediaQuery.of(context).size.height *
                                pctHeight_PtAttrib,
                            // margin: const EdgeInsets.all(10.0),
                            child: SizedBox(
                              width: double.infinity, // <-- match_parent
                              // height: double.infinity, // <-- match-parent
                              child: Padding(
                                padding: EdgeInsets.all(2.0),
                                child: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      mapPointData_ptEditScreen[
                                          'pointService_Type'] = 'SecondServe';
                                    });
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Palette.tiffanyBlue[500]),
                                    padding: MaterialStateProperty.all<
                                            EdgeInsets>(
                                        // EdgeInsets.fromLTRB(10, 10, 10, 10)),
                                        EdgeInsets.all(10)),
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0))),
                                  ),
                                  child: const Text('Second Serve'),
                                ),
                              ),
                            ),
                          ),
                          // const SizedBox(width: 8),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            // height: double.infinity, // <-- match-parent
                            height: MediaQuery.of(context).size.height *
                                pctHeight_PtAttrib,
                            // margin: const EdgeInsets.all(10.0),
                            child: SizedBox(
                              width: double.infinity, // <-- match_parent
                              // height: double.infinity, // <-- match-parent
                              // height: MediaQuery.of(context).size.height *
                              //     pctHeight_PtAttrib,
                              child: Padding(
                                padding: EdgeInsets.all(2.0),
                                child: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      mapPointData_ptEditScreen[
                                              'pointService_Type'] =
                                          'FirstServeRally';
                                    });
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Palette.tiffanyBlue[500]),
                                    padding:
                                        MaterialStateProperty.all<EdgeInsets>(
                                            EdgeInsets.all(10)),
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0))),
                                  ),
                                  child: const Text('Rally'),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : (mapPointData_ptEditScreen['pointService_Type'] ==
                            'SecondServe')
                        ? Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.5,
                                height: MediaQuery.of(context).size.height *
                                    pctHeight_PtAttrib,
                                // margin: const EdgeInsets.all(10.0),
                                child: SizedBox(
                                  width: double.infinity, // <-- match_parent
                                  // height: double.infinity, // <-- match-parent
                                  child: Padding(
                                    padding: EdgeInsets.all(2.0),
                                    child: TextButton(
                                      onPressed: () {
                                        setState(() {
                                          mapPointData_ptEditScreen[
                                                  'pointService_Type'] =
                                              'DoubleFault';
                                          mapPointData_ptEditScreen[
                                                  'pointPtWon_PlayerNum'] =
                                              (mapPointData_ptEditScreen[
                                                          'pointService_PlayerNum'] ==
                                                      '1')
                                                  ? '2'
                                                  : '1';
                                        });
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Palette.tiffanyBlue[500]),
                                        padding: MaterialStateProperty.all<
                                                EdgeInsets>(
                                            // EdgeInsets.fromLTRB(10, 10, 10, 10)),
                                            EdgeInsets.all(10)),
                                        shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10.0))),
                                      ),
                                      child: const Text('Double Fault'),
                                    ),
                                  ),
                                ),
                              ),
                              // const SizedBox(width: 8),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.5,
                                // height: double.infinity, // <-- match-parent
                                height: MediaQuery.of(context).size.height *
                                    pctHeight_PtAttrib,
                                // margin: const EdgeInsets.all(10.0),
                                child: SizedBox(
                                  width: double.infinity, // <-- match_parent
                                  // height: double.infinity, // <-- match-parent
                                  // height: MediaQuery.of(context).size.height *
                                  //     pctHeight_PtAttrib,
                                  child: Padding(
                                    padding: EdgeInsets.all(2.0),
                                    child: TextButton(
                                      onPressed: () {
                                        setState(() {
                                          mapPointData_ptEditScreen[
                                                  'pointService_Type'] =
                                              'SecondServeRally';
                                        });
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Palette.tiffanyBlue[500]),
                                        padding: MaterialStateProperty.all<
                                            EdgeInsets>(EdgeInsets.all(10)),
                                        shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10.0))),
                                      ),
                                      child: const Text('Rally'),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Container(
                            width: double.infinity,
                          ),
              ),

              // WINNING LOGIC >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
              Player1WonPt(
                  ptWon_PlayerNum:
                      mapPointData_ptEditScreen['pointPtWon_PlayerNum'],
                  onSelection: (value) {
                    if (mapPointData_ptEditScreen['pointPtWon_PlayerNum'] !=
                        value) {
                      setState(() {
                        // print('Player1WonPt setState');
                        // print('classFlagPlayer1Winner: ' +
                        //     mapPointData_ptEditScreen['pointPtWon_PlayerNum'].toString());
                        // print('onSelection: ' + value.toString());
                        mapPointData_ptEditScreen['pointPtWon_PlayerNum'] =
                            value;
                      });
                    }
                  }),

              // FORM LOGIC >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
              GestureDetector(
                onTap: () {
                  // setState(() {});
                  // print("Form_PlayerPoint was tapped");
                },
                child: Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      // height: 200,
                      height: MediaQuery.of(context).size.height *
                          pctHeight_PtAttrib *
                          6,
                      child: Form_PlayerPoint(
                          ptWon_PlayerNum:
                              mapPointData_ptEditScreen['pointPtWon_PlayerNum'],
                          service_PlayerNum: mapPointData_ptEditScreen[
                              'pointService_PlayerNum'],
                          service_Type:
                              mapPointData_ptEditScreen['pointService_Type'],
                          keyForm: keyForm_pointEdit1,
                          PlayerNum: '1',
                          dummy2SetState: (value) {
                            // print('Form_PlayerPoint.. dummy2SetState1..');
                            setState(() {});
                          }),
                    ),
                    // const SizedBox(width: 8),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      // height: 200,
                      height: MediaQuery.of(context).size.height *
                          pctHeight_PtAttrib *
                          6,
                      child: Form_PlayerPoint(
                          ptWon_PlayerNum:
                              mapPointData_ptEditScreen['pointPtWon_PlayerNum'],
                          service_PlayerNum: mapPointData_ptEditScreen[
                              'pointService_PlayerNum'],
                          service_Type:
                              mapPointData_ptEditScreen['pointService_Type'],
                          keyForm: keyForm_pointEdit2,
                          PlayerNum: '2',
                          dummy2SetState: (value) {
                            // print('Form_PlayerPoint.. dummy2SetState2..');
                            setState(() {});
                          }),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
