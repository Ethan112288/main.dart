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

// import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:dropdown_search/dropdown_search.dart';

import '../config/palette.dart';
import '../config/custom_styles.dart';
import '../config/globals.dart' as globals;

import '../screens/match_edit_screen.dart';
import '../screens/point_edit_screen.dart';
import '../screens/pracServe_screen.dart';

import '../widgets/app_drawer.dart';

enum PracServe_ServiceTypeOptions {
  FirstServe,
  SecondServe,
  NA, // Point Won
}

enum PracServe_ServicePosOptions {
  Deuce,
  Ad,
  NA,
}

var _args;
String index = '-1';
Map<String, dynamic> mapPracServeData =
    new Map<String, dynamic>.from(mapPracServeData_INIT);

GlobalKey<FormState> keyForm_pracServeEdit =
    new GlobalKey<FormState>(debugLabel: 'PracServeEditScreenState');

class PracServeEditScreen extends StatefulWidget with ChangeNotifier {
  static const routeName = '/edit-pracServe';

  @override
  PracServeEditScreenState createState() => PracServeEditScreenState();
}

class PracServeEditScreenState extends State<PracServeEditScreen> {
  final _yyyymmddController = TextEditingController();
  final _venueController = TextEditingController();
  final GlobalKey<FormFieldState> _keyDropdown_Player1ServiceType = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _keyDropdown_Player2ServiceType = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _keyDropdown_Player1ServicePos = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _keyDropdown_Player2ServicePos = GlobalKey<FormFieldState>();

  var _isInit = true;
  var _initValues_ServiceType = PracServe_ServiceTypeOptions.FirstServe;
  var _initValues_ServicePos = PracServe_ServicePosOptions.NA;

  var _tmp;
  var _tmp2;
  var _Ct_Player1_1st_PCT = 0.0;
  var _Ct_Player1_1st_TOT = 0;
  var _Ct_Player1_1st_IN = 0;
  var _Ct_Player1_1st_OUT = 0;
  var _Ct_Player2_1st_PCT = 0.0;
  var _Ct_Player2_1st_TOT = 0;
  var _Ct_Player2_1st_IN = 0;
  var _Ct_Player2_1st_OUT = 0;
  var _Ct_Player1_2nd_PCT = 0.0;
  var _Ct_Player1_2nd_TOT = 0;
  var _Ct_Player1_2nd_IN = 0;
  var _Ct_Player1_2nd_OUT = 0;
  var _Ct_Player2_2nd_PCT = 0.0;
  var _Ct_Player2_2nd_TOT = 0;
  var _Ct_Player2_2nd_IN = 0;
  var _Ct_Player2_2nd_OUT = 0;

  List<String> listPlayerID = [];

  Future<List<String>> updateListPlayerID() async {
    List<String> _listPlayerID = [];
    // FirebaseFirestore.instance.collection('Players').get().then((snapshot) => {
    //       snapshot.docs.forEach((doc) {
    //         listPlayerID.add(doc['playerID']);
    //       })
    //     });

    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('Players');
    QuerySnapshot querySnapshot = await collectionReference
        .where('playerOwner', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    querySnapshot.docs.forEach((doc) {
      _listPlayerID.add(doc['playerID']);
    });
    // print('MatchEditScreenState.. updateListPlayerID.. ' + _listPlayerID.length.toString());
    // print('MatchEditScreenState.. updateListPlayerID.. ' + _listPlayerID[0].toString());

    return _listPlayerID;
  }

  @override
  void didChangeDependencies() {
    //didChangeDependencies is called just a few moments after the state loads its dependencies and context is available at this moment so here you can use context.

    // print('PracServeEditScreenState.. didChangeDependencies..');
    if (_isInit) {

      // Resetting form and data
      //keyForm_pracServeEdit.currentState!.reset();
/*      mapPracServeData['pracServe_Player1_ServiceType'] = 'FirstServe';
      mapPracServeData['pracServe_Player2_ServiceType'] = 'FirstServe';
      mapPracServeData['pracServe_Player1_ServicePos'] = 'NA';
      mapPracServeData['pracServe_Player2_ServicePos'] = 'NA';
      _keyDropdown_Player1ServiceType.currentState!.reset();
      _keyDropdown_Player2ServiceType.currentState!.reset();
      _keyDropdown_Player1ServicePos.currentState!.reset();
      _keyDropdown_Player2ServicePos.currentState!.reset();*/

      final args =
      ModalRoute.of(context)!.settings.arguments as pracServeScreenArgs;

      index = args.index;
      if (index == '-1') {

        mapPracServeData = new Map<String, dynamic>.from(mapPracServeData_INIT);
        mapPracServeData['pracServe_yyyymmdd'] =
            '${DateTime.now().year}${DateTime.now().month.toString().padLeft(2, '0')}${DateTime.now().day.toString().padLeft(2, '0')}';

        print('PracServeEditScreenState.. didChangeDependencies2.. index: ' +
            index +
            '.. pracServe_ID: ' +
            mapPracServeData['pracServe_ID']);
      } else if (!args.mapPracServeData.isEmpty) {
        mapPracServeData = args.mapPracServeData;
        print('PracServeEditScreenState.. didChangeDependencies3.. index: ' +
            index +
            '.. pracServe_ID: ' +
            mapPracServeData['pracServe_ID']);
      } else {
        print('PracServeEditScreenState.. didChangeDependencies4.. index: ' +
            index +
            '.. pracServe_ID: ' +
            mapPracServeData['pracServe_ID']);
      }
      _yyyymmddController.text = mapPracServeData['pracServe_yyyymmdd'];
      _venueController.text = mapPracServeData['pracServe_Venue'];
    }
    _isInit = false;

    _Ct_Player1_1st_IN = mapPracServeData['pracServe_Player1_Ct_1st_NA_IN'] + mapPracServeData['pracServe_Player1_Ct_1st_Deuce_IN'] + mapPracServeData['pracServe_Player1_Ct_1st_Ad_IN'];
    _Ct_Player1_1st_OUT = mapPracServeData['pracServe_Player1_Ct_1st_NA_OUT'] + mapPracServeData['pracServe_Player1_Ct_1st_Deuce_OUT'] + mapPracServeData['pracServe_Player1_Ct_1st_Ad_OUT'];
    _Ct_Player1_1st_TOT = _Ct_Player1_1st_IN + _Ct_Player1_1st_OUT;
    _Ct_Player1_1st_PCT = _Ct_Player1_1st_TOT == 0 ?0 :_Ct_Player1_1st_IN / _Ct_Player1_1st_TOT * 100;
    _Ct_Player1_2nd_IN = mapPracServeData['pracServe_Player1_Ct_2nd_NA_IN'] + mapPracServeData['pracServe_Player1_Ct_2nd_Deuce_IN'] + mapPracServeData['pracServe_Player1_Ct_2nd_Ad_IN'];
    _Ct_Player1_2nd_OUT = mapPracServeData['pracServe_Player1_Ct_2nd_NA_OUT'] + mapPracServeData['pracServe_Player1_Ct_2nd_Deuce_OUT'] + mapPracServeData['pracServe_Player1_Ct_2nd_Ad_OUT'];
    _Ct_Player1_2nd_TOT = _Ct_Player1_2nd_IN + _Ct_Player1_2nd_OUT;
    _Ct_Player1_2nd_PCT = _Ct_Player1_2nd_TOT == 0 ?0 :_Ct_Player1_2nd_IN / _Ct_Player1_2nd_TOT * 100;

    _Ct_Player2_1st_IN = mapPracServeData['pracServe_Player2_Ct_1st_NA_IN'] + mapPracServeData['pracServe_Player2_Ct_1st_Deuce_IN'] + mapPracServeData['pracServe_Player2_Ct_1st_Ad_IN'];
    _Ct_Player2_1st_OUT = mapPracServeData['pracServe_Player2_Ct_1st_NA_OUT'] + mapPracServeData['pracServe_Player2_Ct_1st_Deuce_OUT'] + mapPracServeData['pracServe_Player2_Ct_1st_Ad_OUT'];
    _Ct_Player2_1st_TOT = _Ct_Player2_1st_IN + _Ct_Player2_1st_OUT;
    _Ct_Player2_1st_PCT = _Ct_Player2_1st_TOT == 0 ?0 :_Ct_Player2_1st_IN / _Ct_Player2_1st_TOT * 100;
    _Ct_Player2_2nd_IN = mapPracServeData['pracServe_Player2_Ct_2nd_NA_IN'] + mapPracServeData['pracServe_Player2_Ct_2nd_Deuce_IN'] + mapPracServeData['pracServe_Player2_Ct_2nd_Ad_IN'];
    _Ct_Player2_2nd_OUT = mapPracServeData['pracServe_Player2_Ct_2nd_NA_OUT'] + mapPracServeData['pracServe_Player2_Ct_2nd_Deuce_OUT'] + mapPracServeData['pracServe_Player2_Ct_2nd_Ad_OUT'];
    _Ct_Player2_2nd_TOT = _Ct_Player2_2nd_IN + _Ct_Player2_2nd_OUT;
    _Ct_Player2_2nd_PCT = _Ct_Player2_2nd_TOT == 0 ?0 :_Ct_Player2_2nd_IN / _Ct_Player2_2nd_TOT * 100;

    // super.didChangeDependencies();
  }

  void _saveForm() {
    final isValid = keyForm_pracServeEdit.currentState!.validate();
    if (!isValid) {
      return;
    }
    keyForm_pracServeEdit.currentState!.save();

    if (index == '-1') {
      // Add new pracServe
      _tmp =
          mapPracServeData['pracServe_Player1_PlayerID']
              .split('_');
      _tmp2 =
          mapPracServeData['pracServe_Player2_PlayerID']
              .split('_');
      mapPracServeData['pracServe_ID'] =
          ('${mapPracServeData['pracServe_yyyymmdd']}_${mapPracServeData['pracServe_Venue']}_${_tmp[0]}-${_tmp2[0]}');
      mapPracServeData['pracServe_Owner'] =
          FirebaseAuth.instance.currentUser!.uid;

      // print('DEBUG.. Adding ' + mapPracServeData['pracServe_ID']);
      Provider.of<PracServeScreen>(context, listen: false).updatePracServeData(
          pracServeScreenArgs(
              mapPracServeData['pracServe_ID'], mapPracServeData));
    } else {
      // Update pracServe
      Provider.of<PracServeScreen>(context, listen: false).updatePracServeData(
          pracServeScreenArgs(
              mapPracServeData['pracServe_ID'], mapPracServeData));
    }
    // print('PracServeEditScreenState.. _saveForm.. ' + index.toString() + ' <=> ' + mapPracServeData['pracServe_ID']);

    // Resetting form and data
    //mapPracServeData = new Map<String, dynamic>.from(mapPracServeData_INIT);
    //keyForm_pracServeEdit.currentState!.reset();
    mapPracServeData['pracServe_Player1_ServiceType'] = 'FirstServe';
    mapPracServeData['pracServe_Player2_ServiceType'] = 'FirstServe';
    mapPracServeData['pracServe_Player1_ServicePos'] = 'NA';
    mapPracServeData['pracServe_Player2_ServicePos'] = 'NA';
    _keyDropdown_Player1ServiceType.currentState!.reset();
    _keyDropdown_Player2ServiceType.currentState!.reset();
    _keyDropdown_Player1ServicePos.currentState!.reset();
    _keyDropdown_Player2ServicePos.currentState!.reset();

    // Return to prior page
    //Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Serve Practice'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                // print('PracServeEditScreenState.. PRE-_saveForm.. ' + index.toString() + ' <=> ' + mapPracServeData['pracServe_ID']);
                _saveForm();
              }),
        ],
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: keyForm_pracServeEdit,
          child: ListView(
            children: <Widget>[
              // SCORE BOARD >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
              Container(
                color: color_ScoreBoard_Bkgrd,
                height:
                    MediaQuery.of(context).size.height * pctHeight_ScoreBoard * 2,
                child: Column(
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height *
                          pctHeight_ScoreBoard *
                          0.05,
                    ),

                    // PLAYER1
                    // PLAYER NAME..
                    Container(
                      height: MediaQuery.of(context).size.height *
                          pctHeight_ScoreBoard *
                          0.4,
                      child: Row(
                        children: <Widget>[
                          // SPACE..
                          Container(
                            width: MediaQuery.of(context).size.width * 0.05,
                          ),
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    '${mapPracServeData['pracServe_Player1_FirstName']} ${mapPracServeData['pracServe_Player1_LastName'].toUpperCase()}',
                                    style: TextStyle(
                                      fontWeight: fontWeight_ScoreBoard_Name,
                                      color: color_ScoreBoard_Text,
                                      fontSize: fontSize_ScoreBoard,
                                    ),
                                  ),
                                ],
                              )),
                        ],
                      ),
                    ),

                    // 1ST SERVE..
                    Container(
                      height: MediaQuery.of(context).size.height *
                          pctHeight_ScoreBoard *
                          0.2,
                      child: Row(
                        children: <Widget>[
                          // SPACE..
                          Container(
                            width: MediaQuery.of(context).size.width * 0.05,
                          ),

                          Container(
                            //width: MediaQuery.of(context).size.width * 0.5,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                //'ACCURACY 1ST: 90% (in: 9 | out: 1)',
                                'ACCURACY 1ST: ${_Ct_Player1_1st_PCT.toStringAsFixed(0)}% (in: ${_Ct_Player1_1st_IN.toString()} | out: ${_Ct_Player1_1st_OUT.toString()})',
                                style: TextStyle(
                                  fontWeight: fontWeight_ScoreBoard_PrevSets,
                                  color: color_ScoreBoard_Text,
                                  fontSize: fontSize_ScoreBoard * 0.75,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 2ND SERVE..
                    Container(
                      height: MediaQuery.of(context).size.height *
                          pctHeight_ScoreBoard *
                          0.2,
                      child: Row(
                        children: <Widget>[
                          // SPACE..
                          Container(
                            width: MediaQuery.of(context).size.width * 0.05,
                          ),
                          Container(
                            //width: MediaQuery.of(context).size.width * 0.5,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                // 'ACCURACY 2ND: 90% (in: 9 | out: 1)',
                                'ACCURACY 2ND: ${_Ct_Player1_2nd_PCT.toStringAsFixed(0)}% (in: ${_Ct_Player1_2nd_IN.toString()} | out: ${_Ct_Player1_2nd_OUT.toString()})',
                                style: TextStyle(
                                  fontWeight: fontWeight_ScoreBoard_PrevSets,
                                  color: color_ScoreBoard_Text,
                                  fontSize: fontSize_ScoreBoard * 0.75,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // PLAYER SPACE
                    Container(
                      height: MediaQuery.of(context).size.height *
                          pctHeight_ScoreBoard *
                          0.1,
                    ),

                    // PLAYER2
                    // PLAYER NAME..
                    Container(
                      height: MediaQuery.of(context).size.height *
                          pctHeight_ScoreBoard *
                          0.4,
                      child: Row(
                        children: <Widget>[
                          // SPACE..
                          Container(
                            width: MediaQuery.of(context).size.width * 0.05,
                          ),
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    '${mapPracServeData['pracServe_Player2_FirstName']} ${mapPracServeData['pracServe_Player2_LastName'].toUpperCase()}',
                                    style: TextStyle(
                                      fontWeight: fontWeight_ScoreBoard_Name,
                                      color: color_ScoreBoard_Text,
                                      fontSize: fontSize_ScoreBoard,
                                    ),
                                  ),
                                ],
                              )),
                        ],
                      ),
                    ),

                    // 1ST SERVE..
                    Container(
                      height: MediaQuery.of(context).size.height *
                          pctHeight_ScoreBoard *
                          0.2,
                      child: Row(
                        children: <Widget>[
                          // SPACE..
                          Container(
                            width: MediaQuery.of(context).size.width * 0.05,
                          ),

                          Container(
                            //width: MediaQuery.of(context).size.width * 0.5,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                //'ACCURACY 1ST: 90% (in: 9 | out: 1)',
                                'ACCURACY 1ST: ${_Ct_Player2_1st_PCT.toStringAsFixed(0)}% (in: ${_Ct_Player2_1st_IN.toString()} | out: ${_Ct_Player2_1st_OUT.toString()})',
                                style: TextStyle(
                                  fontWeight: fontWeight_ScoreBoard_PrevSets,
                                  color: color_ScoreBoard_Text,
                                  fontSize: fontSize_ScoreBoard * 0.75,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 2ND SERVE..
                    Container(
                      height: MediaQuery.of(context).size.height *
                          pctHeight_ScoreBoard *
                          0.2,
                      child: Row(
                        children: <Widget>[
                          // SPACE..
                          Container(
                            width: MediaQuery.of(context).size.width * 0.05,
                          ),

                          Container(
                            //width: MediaQuery.of(context).size.width * 0.5,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                // 'ACCURACY 2ND: 90% (in: 9 | out: 1)',
                                'ACCURACY 2ND: ${_Ct_Player2_2nd_PCT.toStringAsFixed(0)}% (in: ${_Ct_Player2_2nd_IN.toString()} | out: ${_Ct_Player2_2nd_OUT.toString()})',
                                style: TextStyle(
                                  fontWeight: fontWeight_ScoreBoard_PrevSets,
                                  color: color_ScoreBoard_Text,
                                  fontSize: fontSize_ScoreBoard * 0.75,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // PLAYER SPACE
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

              // HEADER: Date / Venue >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
              Container(
                  width: double.infinity,
                  height:
                      MediaQuery.of(context).size.height * pctHeight_PtAttrib,
                  child: Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.25,
                        height: MediaQuery.of(context).size.height *
                            pctHeight_PtAttrib,
                        // margin: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          controller: _yyyymmddController,
                          decoration:
                              InputDecoration(labelText: 'Date (yyyymmdd)'),
                          validator: (value) {
                            // validator: controller.isNumberValid(value!) {
                            if (value == null || value!.isEmpty) {
                              return 'Please provide a date.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            mapPracServeData['pracServe_yyyymmdd'] = value;
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: SizedBox(
                          width: double.infinity, // <-- match_parent
                          // height: double.infinity, // <-- match-parent
                          height: MediaQuery.of(context).size.height *
                              pctHeight_PtAttrib,
                          child: TextFormField(
                            controller: _venueController,
                            decoration: InputDecoration(labelText: 'Venue'),
                            validator: (value) {
                              // validator: controller.isNumberValid(value!) {
                              if (value == null || value!.isEmpty) {
                                return 'Please provide a venue.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              mapPracServeData['pracServe_Venue'] = value;
                            },
                          ),
                        ),
                      )
                    ],
                  )),

              // PLAYERS ID >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
              FutureBuilder<List<String>>(
                future:
                    updateListPlayerID(), // a previously-obtained Future<String> or null
                builder: (BuildContext context,
                    AsyncSnapshot<List<String>> snapshot) {
                  List<Widget> children;
                  if (snapshot.hasData) {
                    final _listPlayerID = snapshot.data as List<String>;
                    children = <Widget>[
                      Container(
                        height: absHeight_PlayerID_matchEdit,
                        child: DropdownSearch<String>(
                          mode: Mode.MENU,
                          showSelectedItems: true,
                          // hint: "country in menu mode",
                          // popupItemDisabled: (String s) => s.startsWith('I'),
                          showSearchBox: true,
                          showClearButton: true,
                          // showFavoriteItems: true,
                          selectedItem: (mapPracServeData[
                                      'pracServe_Player1_PlayerID'] ==
                                  '')
                              ? _listPlayerID[_listPlayerID.length - 1]
                              : mapPracServeData['pracServe_Player1_PlayerID'],
                          items: _listPlayerID,
                          // label: 'Player1 ID',
                          // dropdownSearchDecoration: InputDecoration.collapsed(
                          //   hintText: 'Player1 ID',
                          // ),
                          dropdownSearchDecoration: InputDecoration(
                            labelText: 'Player1 ID',
                            // labelStyle: TextStyle(fontSize: 10),
                            // isDense: true,
                            // isCollapsed: true
                          ),
                          onChanged: (String? value) {
                            setState(() {
                              mapPracServeData['pracServe_Player1_PlayerID'] =
                                  value!;
                              _tmp =
                                  mapPracServeData['pracServe_Player1_PlayerID']
                                      .split('_');
                              mapPracServeData['pracServe_Player1_FirstName'] =
                                  _tmp[1];
                              mapPracServeData['pracServe_Player1_LastName'] =
                                  _tmp[0];
                            });
                          },
                          onSaved: (String? value) {
                            setState(() {
                              mapPracServeData['pracServe_Player1_PlayerID'] =
                                  value!;
                              _tmp =
                                  mapPracServeData['pracServe_Player1_PlayerID']
                                      .split('_');
                              mapPracServeData['pracServe_Player1_FirstName'] =
                                  _tmp[1];
                              mapPracServeData['pracServe_Player1_LastName'] =
                                  _tmp[0];
                            });
                          },
                          validator: (value) {
                            if (value == null || value == '') {
                              return 'Please provide an ID.';
                            }
                            return null;
                          },
                        ),
                      ),
                      Container(
                        height: absHeight_PlayerID_matchEdit,
                        child: DropdownSearch<String>(
                          mode: Mode.MENU,
                          showSelectedItems: true,
                          // hint: "country in menu mode",
                          // popupItemDisabled: (String s) => s.startsWith('I'),
                          showSearchBox: true,
                          showClearButton: true,
                          // showFavoriteItems: true,
                          selectedItem: (mapPracServeData[
                                      'pracServe_Player2_PlayerID'] ==
                                  '')
                              ? _listPlayerID[_listPlayerID.length - 2]
                              : mapPracServeData['pracServe_Player2_PlayerID'],
                          items: _listPlayerID,
                          dropdownSearchDecoration: InputDecoration(
                            labelText: 'Player2 ID',
                          ),
                          onChanged: (String? value) {
                            setState(() {
                              mapPracServeData['pracServe_Player2_PlayerID'] =
                                  value!;
                              _tmp =
                                  mapPracServeData['pracServe_Player2_PlayerID']
                                      .split('_');
                              mapPracServeData['pracServe_Player2_FirstName'] =
                                  _tmp[1];
                              mapPracServeData['pracServe_Player2_LastName'] =
                                  _tmp[0];
                            });
                          },
                          onSaved: (String? value) {
                            setState(() {
                              mapPracServeData['pracServe_Player2_PlayerID'] =
                                  value!;
                              _tmp =
                                  mapPracServeData['pracServe_Player2_PlayerID']
                                      .split('_');
                              mapPracServeData['pracServe_Player2_FirstName'] =
                                  _tmp[1];
                              mapPracServeData['pracServe_Player2_LastName'] =
                                  _tmp[0];
                            });
                          },
                          validator: (value) {
                            if (value == null || value == '') {
                              return 'Please provide an ID.';
                            }
                            return null;
                          },
                        ),
                      ),
                    ];
                  } else {
                    // print('DEBUG... NO snapshot.hasData');
                    // if (snapshot.connectionState == ConnectionState.waiting) {
                    children = const <Widget>[
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: CircularProgressIndicator(),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Text('Awaiting Player IDs...'),
                      )
                    ];
                  }
                  return Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: children,
                  );
                },
              ),

              // Service Type >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * pctHeight_PtAttrib,
                child: Row(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child:
                          DropdownButtonFormField<PracServe_ServiceTypeOptions>(
                            key: _keyDropdown_Player1ServiceType,
                        value:
                            _initValues_ServiceType, //PracServe_ServiceTypeOptions.TwoOfThree,
                        isExpanded: true,
                        decoration:
                            InputDecoration(labelText: 'Player1 Service Type'),
                        onChanged: (PracServe_ServiceTypeOptions? value) {
                          setState(() {
                            mapPracServeData['pracServe_Player1_ServiceType'] =
                                describeEnum(value!).toString();
                          });
                        },
                        onSaved: (PracServe_ServiceTypeOptions? value) {
                          setState(() {
                            mapPracServeData['pracServe_Player1_ServiceType'] =
                                describeEnum(value!).toString();
                          });
                        },
                        items: PracServe_ServiceTypeOptions.values
                            .map((PracServe_ServiceTypeOptions value) {
                          return DropdownMenuItem<PracServe_ServiceTypeOptions>(
                              value: value, child: Text(describeEnum(value)));
                          // child: Text(value.toString()));
                        }).toList(),
                      ),
                    ),
                    Expanded(
                      child: const SizedBox(width: 10),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child:
                          DropdownButtonFormField<PracServe_ServiceTypeOptions>(
                        value:
                            _initValues_ServiceType, //PracServe_ServiceTypeOptions.TwoOfThree,
                        isExpanded: true,
                        decoration:
                            InputDecoration(labelText: 'Player2 Service Type'),
                        onChanged: (PracServe_ServiceTypeOptions? value) {
                          setState(() {
                            mapPracServeData['pracServe_Player2_ServiceType'] =
                                describeEnum(value!).toString();
                          });
                        },
                        onSaved: (PracServe_ServiceTypeOptions? value) {
                          setState(() {
                            mapPracServeData['pracServe_Player2_ServiceType'] =
                                describeEnum(value!).toString();
                          });
                        },
                        items: PracServe_ServiceTypeOptions.values
                            .map((PracServe_ServiceTypeOptions value) {
                          return DropdownMenuItem<PracServe_ServiceTypeOptions>(
                              value: value, child: Text(describeEnum(value)));
                          // child: Text(value.toString()));
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),

              // Service Pos >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * pctHeight_PtAttrib,
                child: Row(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child:
                          DropdownButtonFormField<PracServe_ServicePosOptions>(
                        value:
                            _initValues_ServicePos, //PracServe_ServicePosOptions.TwoOfThree,
                        isExpanded: true,
                        decoration:
                            InputDecoration(labelText: 'Player1 Service Pos'),
                        onChanged: (PracServe_ServicePosOptions? value) {
                          setState(() {
                            mapPracServeData['pracServe_Player1_ServicePos'] =
                                describeEnum(value!).toString();
                          });
                        },
                        onSaved: (PracServe_ServicePosOptions? value) {
                          setState(() {
                            mapPracServeData['pracServe_Player1_ServicePos'] =
                                describeEnum(value!).toString();
                          });
                        },
                        items: PracServe_ServicePosOptions.values
                            .map((PracServe_ServicePosOptions value) {
                          return DropdownMenuItem<PracServe_ServicePosOptions>(
                              value: value, child: Text(describeEnum(value)));
                          // child: Text(value.toString()));
                        }).toList(),
                      ),
                    ),
                    Expanded(
                      child: const SizedBox(width: 10),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child:
                          DropdownButtonFormField<PracServe_ServicePosOptions>(
                        value:
                            _initValues_ServicePos, //PracServe_ServicePosOptions.TwoOfThree,
                        isExpanded: true,
                        decoration:
                            InputDecoration(labelText: 'Player2 Service Pos'),
                        onChanged: (PracServe_ServicePosOptions? value) {
                          setState(() {
                            mapPracServeData['pracServe_Player2_ServicePos'] =
                                describeEnum(value!).toString();
                          });
                        },
                        onSaved: (PracServe_ServicePosOptions? value) {
                          setState(() {
                            mapPracServeData['pracServe_Player2_ServicePos'] =
                                describeEnum(value!).toString();
                          });
                        },
                        items: PracServe_ServicePosOptions.values
                            .map((PracServe_ServicePosOptions value) {
                          return DropdownMenuItem<PracServe_ServicePosOptions>(
                              value: value, child: Text(describeEnum(value)));
                          // child: Text(value.toString()));
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),

              // SPACE >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
              Container(
                width: double.infinity,
                height:
                    MediaQuery.of(context).size.height * pctHeight_PtAttrib / 4,
              ),

              // Service IN >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height *
                    pctHeight_PtAttrib *
                    1.2,
                child: Row(
                  children: <Widget>[
                    // PLAYER1 SERVE IN+
                    Container(
                      width: MediaQuery.of(context).size.width * 0.30,
                      child: SizedBox(
                        width: double.infinity, // <-- match_parent
                        height: double.infinity, // <-- match-parent
                        child: Padding(
                          padding: EdgeInsets.all(2.0),
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                mapPracServeData[
                                            'pracServe_Player1_ServiceType'] ==
                                        'FirstServe'
                                    ? mapPracServeData[
                                                'pracServe_Player1_ServicePos'] ==
                                            'NA'
                                        ? mapPracServeData[
                                            'pracServe_Player1_Ct_1st_NA_IN']++
                                        : mapPracServeData[
                                                    'pracServe_Player1_ServicePos'] ==
                                                'Deuce'
                                            ? mapPracServeData[
                                                'pracServe_Player1_Ct_1st_Deuce_IN']++
                                            : mapPracServeData[
                                                'pracServe_Player1_Ct_1st_Ad_IN']++
                                    : mapPracServeData[
                                                'pracServe_Player1_ServicePos'] ==
                                            'NA'
                                        ? mapPracServeData[
                                            'pracServe_Player1_Ct_2nd_NA_IN']++
                                        : mapPracServeData[
                                                    'pracServe_Player1_ServicePos'] ==
                                                'Deuce'
                                            ? mapPracServeData[
                                                'pracServe_Player1_Ct_2nd_Deuce_IN']++
                                            : mapPracServeData[
                                                'pracServe_Player1_Ct_2nd_Ad_IN']++;

                                _Ct_Player1_1st_IN = mapPracServeData['pracServe_Player1_Ct_1st_NA_IN'] + mapPracServeData['pracServe_Player1_Ct_1st_Deuce_IN'] + mapPracServeData['pracServe_Player1_Ct_1st_Ad_IN'];
                                _Ct_Player1_1st_OUT = mapPracServeData['pracServe_Player1_Ct_1st_NA_OUT'] + mapPracServeData['pracServe_Player1_Ct_1st_Deuce_OUT'] + mapPracServeData['pracServe_Player1_Ct_1st_Ad_OUT'];
                                _Ct_Player1_1st_TOT = _Ct_Player1_1st_IN + _Ct_Player1_1st_OUT;
                                _Ct_Player1_1st_PCT = _Ct_Player1_1st_TOT == 0 ?0 :_Ct_Player1_1st_IN / _Ct_Player1_1st_TOT * 100;
                                _Ct_Player1_2nd_IN = mapPracServeData['pracServe_Player1_Ct_2nd_NA_IN'] + mapPracServeData['pracServe_Player1_Ct_2nd_Deuce_IN'] + mapPracServeData['pracServe_Player1_Ct_2nd_Ad_IN'];
                                _Ct_Player1_2nd_OUT = mapPracServeData['pracServe_Player1_Ct_2nd_NA_OUT'] + mapPracServeData['pracServe_Player1_Ct_2nd_Deuce_OUT'] + mapPracServeData['pracServe_Player1_Ct_2nd_Ad_OUT'];
                                _Ct_Player1_2nd_TOT = _Ct_Player1_2nd_IN + _Ct_Player1_2nd_OUT;
                                _Ct_Player1_2nd_PCT = _Ct_Player1_2nd_TOT == 0 ?0 :_Ct_Player1_2nd_IN / _Ct_Player1_2nd_TOT * 100;

                              });
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Palette.tiffanyBlue[500]),
                              padding: MaterialStateProperty.all<EdgeInsets>(
                                  // EdgeInsets.fromLTRB(10, 10, 10, 10)),
                                  EdgeInsets.all(10)),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0))),
                            ),
                            child: const Text('Player1 Serve IN+'),
                          ),
                        ),
                      ),
                    ),

                    // PLAYER1 SERVE IN-
                    Container(
                      width: MediaQuery.of(context).size.width * 0.15,
                      child: SizedBox(
                        width: double.infinity, // <-- match_parent
                        height: double.infinity, // <-- match-parent
                        child: Padding(
                          padding: EdgeInsets.all(2.0),
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                mapPracServeData[
                                            'pracServe_Player1_ServiceType'] ==
                                        'FirstServe'
                                    ? mapPracServeData[
                                                'pracServe_Player1_ServicePos'] ==
                                            'NA'
                                        ? mapPracServeData[
                                            'pracServe_Player1_Ct_1st_NA_IN']--
                                        : mapPracServeData[
                                                    'pracServe_Player1_ServicePos'] ==
                                                'Deuce'
                                            ? mapPracServeData[
                                                'pracServe_Player1_Ct_1st_Deuce_IN']--
                                            : mapPracServeData[
                                                'pracServe_Player1_Ct_1st_Ad_IN']--
                                    : mapPracServeData[
                                                'pracServe_Player1_ServicePos'] ==
                                            'NA'
                                        ? mapPracServeData[
                                            'pracServe_Player1_Ct_2nd_NA_IN']--
                                        : mapPracServeData[
                                                    'pracServe_Player1_ServicePos'] ==
                                                'Deuce'
                                            ? mapPracServeData[
                                                'pracServe_Player1_Ct_2nd_Deuce_IN']--
                                            : mapPracServeData[
                                                'pracServe_Player1_Ct_2nd_Ad_IN']--;

                                _Ct_Player1_1st_IN = mapPracServeData['pracServe_Player1_Ct_1st_NA_IN'] + mapPracServeData['pracServe_Player1_Ct_1st_Deuce_IN'] + mapPracServeData['pracServe_Player1_Ct_1st_Ad_IN'];
                                _Ct_Player1_1st_OUT = mapPracServeData['pracServe_Player1_Ct_1st_NA_OUT'] + mapPracServeData['pracServe_Player1_Ct_1st_Deuce_OUT'] + mapPracServeData['pracServe_Player1_Ct_1st_Ad_OUT'];
                                _Ct_Player1_1st_TOT = _Ct_Player1_1st_IN + _Ct_Player1_1st_OUT;
                                _Ct_Player1_1st_PCT = _Ct_Player1_1st_TOT == 0 ?0 :_Ct_Player1_1st_IN / _Ct_Player1_1st_TOT * 100;
                                _Ct_Player1_2nd_IN = mapPracServeData['pracServe_Player1_Ct_2nd_NA_IN'] + mapPracServeData['pracServe_Player1_Ct_2nd_Deuce_IN'] + mapPracServeData['pracServe_Player1_Ct_2nd_Ad_IN'];
                                _Ct_Player1_2nd_OUT = mapPracServeData['pracServe_Player1_Ct_2nd_NA_OUT'] + mapPracServeData['pracServe_Player1_Ct_2nd_Deuce_OUT'] + mapPracServeData['pracServe_Player1_Ct_2nd_Ad_OUT'];
                                _Ct_Player1_2nd_TOT = _Ct_Player1_2nd_IN + _Ct_Player1_2nd_OUT;
                                _Ct_Player1_2nd_PCT = _Ct_Player1_2nd_TOT == 0 ?0 :_Ct_Player1_2nd_IN / _Ct_Player1_2nd_TOT * 100;

                              });
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Palette.red[500]),
                              padding: MaterialStateProperty.all<EdgeInsets>(
                                  // EdgeInsets.fromLTRB(10, 10, 10, 10)),
                                  EdgeInsets.all(10)),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0))),
                            ),
                            child: const Text('\nIN-'),
                          ),
                        ),
                      ),
                    ),

                    Expanded(
                      child: const SizedBox(width: 10),
                    ),

                    // Player2 SERVE IN+
                    Container(
                      width: MediaQuery.of(context).size.width * 0.30,
                      child: SizedBox(
                        width: double.infinity, // <-- match_parent
                        height: double.infinity, // <-- match-parent
                        child: Padding(
                          padding: EdgeInsets.all(2.0),
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                mapPracServeData[
                                            'pracServe_Player2_ServiceType'] ==
                                        'FirstServe'
                                    ? mapPracServeData[
                                                'pracServe_Player2_ServicePos'] ==
                                            'NA'
                                        ? mapPracServeData[
                                            'pracServe_Player2_Ct_1st_NA_IN']++
                                        : mapPracServeData[
                                                    'pracServe_Player2_ServicePos'] ==
                                                'Deuce'
                                            ? mapPracServeData[
                                                'pracServe_Player2_Ct_1st_Deuce_IN']++
                                            : mapPracServeData[
                                                'pracServe_Player2_Ct_1st_Ad_IN']++
                                    : mapPracServeData[
                                                'pracServe_Player2_ServicePos'] ==
                                            'NA'
                                        ? mapPracServeData[
                                            'pracServe_Player2_Ct_2nd_NA_IN']++
                                        : mapPracServeData[
                                                    'pracServe_Player2_ServicePos'] ==
                                                'Deuce'
                                            ? mapPracServeData[
                                                'pracServe_Player2_Ct_2nd_Deuce_IN']++
                                            : mapPracServeData[
                                                'pracServe_Player2_Ct_2nd_Ad_IN']++;

                                _Ct_Player2_1st_IN = mapPracServeData['pracServe_Player2_Ct_1st_NA_IN'] + mapPracServeData['pracServe_Player2_Ct_1st_Deuce_IN'] + mapPracServeData['pracServe_Player2_Ct_1st_Ad_IN'];
                                _Ct_Player2_1st_OUT = mapPracServeData['pracServe_Player2_Ct_1st_NA_OUT'] + mapPracServeData['pracServe_Player2_Ct_1st_Deuce_OUT'] + mapPracServeData['pracServe_Player2_Ct_1st_Ad_OUT'];
                                _Ct_Player2_1st_TOT = _Ct_Player2_1st_IN + _Ct_Player2_1st_OUT;
                                _Ct_Player2_1st_PCT = _Ct_Player2_1st_TOT == 0 ?0 :_Ct_Player2_1st_IN / _Ct_Player2_1st_TOT * 100;
                                _Ct_Player2_2nd_IN = mapPracServeData['pracServe_Player2_Ct_2nd_NA_IN'] + mapPracServeData['pracServe_Player2_Ct_2nd_Deuce_IN'] + mapPracServeData['pracServe_Player2_Ct_2nd_Ad_IN'];
                                _Ct_Player2_2nd_OUT = mapPracServeData['pracServe_Player2_Ct_2nd_NA_OUT'] + mapPracServeData['pracServe_Player2_Ct_2nd_Deuce_OUT'] + mapPracServeData['pracServe_Player2_Ct_2nd_Ad_OUT'];
                                _Ct_Player2_2nd_TOT = _Ct_Player2_2nd_IN + _Ct_Player2_2nd_OUT;
                                _Ct_Player2_2nd_PCT = _Ct_Player2_2nd_TOT == 0 ?0 :_Ct_Player2_2nd_IN / _Ct_Player2_2nd_TOT * 100;

                              });
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Palette.tiffanyBlue[500]),
                              padding: MaterialStateProperty.all<EdgeInsets>(
                                  // EdgeInsets.fromLTRB(10, 10, 10, 10)),
                                  EdgeInsets.all(10)),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0))),
                            ),
                            child: const Text('Player2 Serve IN+'),
                          ),
                        ),
                      ),
                    ),

                    // Player2 SERVE IN-
                    Container(
                      width: MediaQuery.of(context).size.width * 0.15,
                      child: SizedBox(
                        width: double.infinity, // <-- match_parent
                        height: double.infinity, // <-- match-parent
                        child: Padding(
                          padding: EdgeInsets.all(2.0),
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                mapPracServeData[
                                            'pracServe_Player2_ServiceType'] ==
                                        'FirstServe'
                                    ? mapPracServeData[
                                                'pracServe_Player2_ServicePos'] ==
                                            'NA'
                                        ? mapPracServeData[
                                            'pracServe_Player2_Ct_1st_NA_IN']--
                                        : mapPracServeData[
                                                    'pracServe_Player2_ServicePos'] ==
                                                'Deuce'
                                            ? mapPracServeData[
                                                'pracServe_Player2_Ct_1st_Deuce_IN']--
                                            : mapPracServeData[
                                                'pracServe_Player2_Ct_1st_Ad_IN']--
                                    : mapPracServeData[
                                                'pracServe_Player2_ServicePos'] ==
                                            'NA'
                                        ? mapPracServeData[
                                            'pracServe_Player2_Ct_2nd_NA_IN']--
                                        : mapPracServeData[
                                                    'pracServe_Player2_ServicePos'] ==
                                                'Deuce'
                                            ? mapPracServeData[
                                                'pracServe_Player2_Ct_2nd_Deuce_IN']--
                                            : mapPracServeData[
                                                'pracServe_Player2_Ct_2nd_Ad_IN']--;


                                _Ct_Player2_1st_IN = mapPracServeData['pracServe_Player2_Ct_1st_NA_IN'] + mapPracServeData['pracServe_Player2_Ct_1st_Deuce_IN'] + mapPracServeData['pracServe_Player2_Ct_1st_Ad_IN'];
                                _Ct_Player2_1st_OUT = mapPracServeData['pracServe_Player2_Ct_1st_NA_OUT'] + mapPracServeData['pracServe_Player2_Ct_1st_Deuce_OUT'] + mapPracServeData['pracServe_Player2_Ct_1st_Ad_OUT'];
                                _Ct_Player2_1st_TOT = _Ct_Player2_1st_IN + _Ct_Player2_1st_OUT;
                                _Ct_Player2_1st_PCT = _Ct_Player2_1st_TOT == 0 ?0 :_Ct_Player2_1st_IN / _Ct_Player2_1st_TOT * 100;
                                _Ct_Player2_2nd_IN = mapPracServeData['pracServe_Player2_Ct_2nd_NA_IN'] + mapPracServeData['pracServe_Player2_Ct_2nd_Deuce_IN'] + mapPracServeData['pracServe_Player2_Ct_2nd_Ad_IN'];
                                _Ct_Player2_2nd_OUT = mapPracServeData['pracServe_Player2_Ct_2nd_NA_OUT'] + mapPracServeData['pracServe_Player2_Ct_2nd_Deuce_OUT'] + mapPracServeData['pracServe_Player2_Ct_2nd_Ad_OUT'];
                                _Ct_Player2_2nd_TOT = _Ct_Player2_2nd_IN + _Ct_Player2_2nd_OUT;
                                _Ct_Player2_2nd_PCT = _Ct_Player2_2nd_TOT == 0 ?0 :_Ct_Player2_2nd_IN / _Ct_Player2_2nd_TOT * 100;

                              });
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Palette.red[500]),
                              padding: MaterialStateProperty.all<EdgeInsets>(
                                  // EdgeInsets.fromLTRB(10, 10, 10, 10)),
                                  EdgeInsets.all(10)),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0))),
                            ),
                            child: const Text('\nIN-'),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Service OUT >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height *
                    pctHeight_PtAttrib *
                    1.2,
                child: Row(
                  children: <Widget>[
                    // PLAYER1 SERVE OUT+
                    Container(
                      width: MediaQuery.of(context).size.width * 0.30,
                      child: SizedBox(
                        width: double.infinity, // <-- match_parent
                        height: double.infinity, // <-- match-parent
                        child: Padding(
                          padding: EdgeInsets.all(2.0),
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                mapPracServeData[
                                            'pracServe_Player1_ServiceType'] ==
                                        'FirstServe'
                                    ? mapPracServeData[
                                                'pracServe_Player1_ServicePos'] ==
                                            'NA'
                                        ? mapPracServeData[
                                            'pracServe_Player1_Ct_1st_NA_OUT']++
                                        : mapPracServeData[
                                                    'pracServe_Player1_ServicePos'] ==
                                                'Deuce'
                                            ? mapPracServeData[
                                                'pracServe_Player1_Ct_1st_Deuce_OUT']++
                                            : mapPracServeData[
                                                'pracServe_Player1_Ct_1st_Ad_OUT']++
                                    : mapPracServeData[
                                                'pracServe_Player1_ServicePos'] ==
                                            'NA'
                                        ? mapPracServeData[
                                            'pracServe_Player1_Ct_2nd_NA_OUT']++
                                        : mapPracServeData[
                                                    'pracServe_Player1_ServicePos'] ==
                                                'Deuce'
                                            ? mapPracServeData[
                                                'pracServe_Player1_Ct_2nd_Deuce_OUT']++
                                            : mapPracServeData[
                                                'pracServe_Player1_Ct_2nd_Ad_OUT']++;


                                _Ct_Player1_1st_IN = mapPracServeData['pracServe_Player1_Ct_1st_NA_IN'] + mapPracServeData['pracServe_Player1_Ct_1st_Deuce_IN'] + mapPracServeData['pracServe_Player1_Ct_1st_Ad_IN'];
                                _Ct_Player1_1st_OUT = mapPracServeData['pracServe_Player1_Ct_1st_NA_OUT'] + mapPracServeData['pracServe_Player1_Ct_1st_Deuce_OUT'] + mapPracServeData['pracServe_Player1_Ct_1st_Ad_OUT'];
                                _Ct_Player1_1st_TOT = _Ct_Player1_1st_IN + _Ct_Player1_1st_OUT;
                                _Ct_Player1_1st_PCT = _Ct_Player1_1st_TOT == 0 ?0 :_Ct_Player1_1st_IN / _Ct_Player1_1st_TOT * 100;
                                _Ct_Player1_2nd_IN = mapPracServeData['pracServe_Player1_Ct_2nd_NA_IN'] + mapPracServeData['pracServe_Player1_Ct_2nd_Deuce_IN'] + mapPracServeData['pracServe_Player1_Ct_2nd_Ad_IN'];
                                _Ct_Player1_2nd_OUT = mapPracServeData['pracServe_Player1_Ct_2nd_NA_OUT'] + mapPracServeData['pracServe_Player1_Ct_2nd_Deuce_OUT'] + mapPracServeData['pracServe_Player1_Ct_2nd_Ad_OUT'];
                                _Ct_Player1_2nd_TOT = _Ct_Player1_2nd_IN + _Ct_Player1_2nd_OUT;
                                _Ct_Player1_2nd_PCT = _Ct_Player1_2nd_TOT == 0 ?0 :_Ct_Player1_2nd_IN / _Ct_Player1_2nd_TOT * 100;

                              });
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Palette.pink[100]),
                              padding: MaterialStateProperty.all<EdgeInsets>(
                                  // EdgeInsets.fromLTRB(10, 10, 10, 10)),
                                  EdgeInsets.all(10)),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0))),
                            ),
                            child: const Text('Player1 Serve OUT+'),
                          ),
                        ),
                      ),
                    ),

                    // PLAYER1 SERVE OUT-
                    Container(
                      width: MediaQuery.of(context).size.width * 0.15,
                      child: SizedBox(
                        width: double.infinity, // <-- match_parent
                        height: double.infinity, // <-- match-parent
                        child: Padding(
                          padding: EdgeInsets.all(2.0),
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                mapPracServeData[
                                            'pracServe_Player1_ServiceType'] ==
                                        'FirstServe'
                                    ? mapPracServeData[
                                                'pracServe_Player1_ServicePos'] ==
                                            'NA'
                                        ? mapPracServeData[
                                            'pracServe_Player1_Ct_1st_NA_OUT']--
                                        : mapPracServeData[
                                                    'pracServe_Player1_ServicePos'] ==
                                                'Deuce'
                                            ? mapPracServeData[
                                                'pracServe_Player1_Ct_1st_Deuce_OUT']--
                                            : mapPracServeData[
                                                'pracServe_Player1_Ct_1st_Ad_OUT']--
                                    : mapPracServeData[
                                                'pracServe_Player1_ServicePos'] ==
                                            'NA'
                                        ? mapPracServeData[
                                            'pracServe_Player1_Ct_2nd_NA_OUT']--
                                        : mapPracServeData[
                                                    'pracServe_Player1_ServicePos'] ==
                                                'Deuce'
                                            ? mapPracServeData[
                                                'pracServe_Player1_Ct_2nd_Deuce_OUT']--
                                            : mapPracServeData[
                                                'pracServe_Player1_Ct_2nd_Ad_OUT']--;

                                _Ct_Player1_1st_IN = mapPracServeData['pracServe_Player1_Ct_1st_NA_IN'] + mapPracServeData['pracServe_Player1_Ct_1st_Deuce_IN'] + mapPracServeData['pracServe_Player1_Ct_1st_Ad_IN'];
                                _Ct_Player1_1st_OUT = mapPracServeData['pracServe_Player1_Ct_1st_NA_OUT'] + mapPracServeData['pracServe_Player1_Ct_1st_Deuce_OUT'] + mapPracServeData['pracServe_Player1_Ct_1st_Ad_OUT'];
                                _Ct_Player1_1st_TOT = _Ct_Player1_1st_IN + _Ct_Player1_1st_OUT;
                                _Ct_Player1_1st_PCT = _Ct_Player1_1st_TOT == 0 ?0 :_Ct_Player1_1st_IN / _Ct_Player1_1st_TOT * 100;
                                _Ct_Player1_2nd_IN = mapPracServeData['pracServe_Player1_Ct_2nd_NA_IN'] + mapPracServeData['pracServe_Player1_Ct_2nd_Deuce_IN'] + mapPracServeData['pracServe_Player1_Ct_2nd_Ad_IN'];
                                _Ct_Player1_2nd_OUT = mapPracServeData['pracServe_Player1_Ct_2nd_NA_OUT'] + mapPracServeData['pracServe_Player1_Ct_2nd_Deuce_OUT'] + mapPracServeData['pracServe_Player1_Ct_2nd_Ad_OUT'];
                                _Ct_Player1_2nd_TOT = _Ct_Player1_2nd_IN + _Ct_Player1_2nd_OUT;
                                _Ct_Player1_2nd_PCT = _Ct_Player1_2nd_TOT == 0 ?0 :_Ct_Player1_2nd_IN / _Ct_Player1_2nd_TOT * 100;

                              });
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Palette.red[500]),
                              padding: MaterialStateProperty.all<EdgeInsets>(
                                  // EdgeInsets.fromLTRB(10, 10, 10, 10)),
                                  EdgeInsets.all(10)),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0))),
                            ),
                            child: const Text('\nOUT-'),
                          ),
                        ),
                      ),
                    ),

                    Expanded(
                      child: const SizedBox(width: 10),
                    ),

                    // Player2 SERVE OUT+
                    Container(
                      width: MediaQuery.of(context).size.width * 0.30,
                      child: SizedBox(
                        width: double.infinity, // <-- match_parent
                        height: double.infinity, // <-- match-parent
                        child: Padding(
                          padding: EdgeInsets.all(2.0),
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                mapPracServeData[
                                            'pracServe_Player2_ServiceType'] ==
                                        'FirstServe'
                                    ? mapPracServeData[
                                                'pracServe_Player2_ServicePos'] ==
                                            'NA'
                                        ? mapPracServeData[
                                            'pracServe_Player2_Ct_1st_NA_OUT']++
                                        : mapPracServeData[
                                                    'pracServe_Player2_ServicePos'] ==
                                                'Deuce'
                                            ? mapPracServeData[
                                                'pracServe_Player2_Ct_1st_Deuce_OUT']++
                                            : mapPracServeData[
                                                'pracServe_Player2_Ct_1st_Ad_OUT']++
                                    : mapPracServeData[
                                                'pracServe_Player2_ServicePos'] ==
                                            'NA'
                                        ? mapPracServeData[
                                            'pracServe_Player2_Ct_2nd_NA_OUT']++
                                        : mapPracServeData[
                                                    'pracServe_Player2_ServicePos'] ==
                                                'Deuce'
                                            ? mapPracServeData[
                                                'pracServe_Player2_Ct_2nd_Deuce_OUT']++
                                            : mapPracServeData[
                                                'pracServe_Player2_Ct_2nd_Ad_OUT']++;


                                _Ct_Player2_1st_IN = mapPracServeData['pracServe_Player2_Ct_1st_NA_IN'] + mapPracServeData['pracServe_Player2_Ct_1st_Deuce_IN'] + mapPracServeData['pracServe_Player2_Ct_1st_Ad_IN'];
                                _Ct_Player2_1st_OUT = mapPracServeData['pracServe_Player2_Ct_1st_NA_OUT'] + mapPracServeData['pracServe_Player2_Ct_1st_Deuce_OUT'] + mapPracServeData['pracServe_Player2_Ct_1st_Ad_OUT'];
                                _Ct_Player2_1st_TOT = _Ct_Player2_1st_IN + _Ct_Player2_1st_OUT;
                                _Ct_Player2_1st_PCT = _Ct_Player2_1st_TOT == 0 ?0 :_Ct_Player2_1st_IN / _Ct_Player2_1st_TOT * 100;
                                _Ct_Player2_2nd_IN = mapPracServeData['pracServe_Player2_Ct_2nd_NA_IN'] + mapPracServeData['pracServe_Player2_Ct_2nd_Deuce_IN'] + mapPracServeData['pracServe_Player2_Ct_2nd_Ad_IN'];
                                _Ct_Player2_2nd_OUT = mapPracServeData['pracServe_Player2_Ct_2nd_NA_OUT'] + mapPracServeData['pracServe_Player2_Ct_2nd_Deuce_OUT'] + mapPracServeData['pracServe_Player2_Ct_2nd_Ad_OUT'];
                                _Ct_Player2_2nd_TOT = _Ct_Player2_2nd_IN + _Ct_Player2_2nd_OUT;
                                _Ct_Player2_2nd_PCT = _Ct_Player2_2nd_TOT == 0 ?0 :_Ct_Player2_2nd_IN / _Ct_Player2_2nd_TOT * 100;


                              });
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Palette.pink[100]),
                              padding: MaterialStateProperty.all<EdgeInsets>(
                                  // EdgeInsets.fromLTRB(10, 10, 10, 10)),
                                  EdgeInsets.all(10)),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0))),
                            ),
                            child: const Text('Player2 Serve OUT+'),
                          ),
                        ),
                      ),
                    ),

                    // Player2 SERVE OUT-
                    Container(
                      width: MediaQuery.of(context).size.width * 0.15,
                      child: SizedBox(
                        width: double.infinity, // <-- match_parent
                        height: double.infinity, // <-- match-parent
                        child: Padding(
                          padding: EdgeInsets.all(2.0),
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                mapPracServeData[
                                            'pracServe_Player2_ServiceType'] ==
                                        'FirstServe'
                                    ? mapPracServeData[
                                                'pracServe_Player2_ServicePos'] ==
                                            'NA'
                                        ? mapPracServeData[
                                            'pracServe_Player2_Ct_1st_NA_OUT']--
                                        : mapPracServeData[
                                                    'pracServe_Player2_ServicePos'] ==
                                                'Deuce'
                                            ? mapPracServeData[
                                                'pracServe_Player2_Ct_1st_Deuce_OUT']--
                                            : mapPracServeData[
                                                'pracServe_Player2_Ct_1st_Ad_OUT']--
                                    : mapPracServeData[
                                                'pracServe_Player2_ServicePos'] ==
                                            'NA'
                                        ? mapPracServeData[
                                            'pracServe_Player2_Ct_2nd_NA_OUT']--
                                        : mapPracServeData[
                                                    'pracServe_Player2_ServicePos'] ==
                                                'Deuce'
                                            ? mapPracServeData[
                                                'pracServe_Player2_Ct_2nd_Deuce_OUT']--
                                            : mapPracServeData[
                                                'pracServe_Player2_Ct_2nd_Ad_OUT']--;


                                _Ct_Player2_1st_IN = mapPracServeData['pracServe_Player2_Ct_1st_NA_IN'] + mapPracServeData['pracServe_Player2_Ct_1st_Deuce_IN'] + mapPracServeData['pracServe_Player2_Ct_1st_Ad_IN'];
                                _Ct_Player2_1st_OUT = mapPracServeData['pracServe_Player2_Ct_1st_NA_OUT'] + mapPracServeData['pracServe_Player2_Ct_1st_Deuce_OUT'] + mapPracServeData['pracServe_Player2_Ct_1st_Ad_OUT'];
                                _Ct_Player2_1st_TOT = _Ct_Player2_1st_IN + _Ct_Player2_1st_OUT;
                                _Ct_Player2_1st_PCT = _Ct_Player2_1st_TOT == 0 ?0 :_Ct_Player2_1st_IN / _Ct_Player2_1st_TOT * 100;
                                _Ct_Player2_2nd_IN = mapPracServeData['pracServe_Player2_Ct_2nd_NA_IN'] + mapPracServeData['pracServe_Player2_Ct_2nd_Deuce_IN'] + mapPracServeData['pracServe_Player2_Ct_2nd_Ad_IN'];
                                _Ct_Player2_2nd_OUT = mapPracServeData['pracServe_Player2_Ct_2nd_NA_OUT'] + mapPracServeData['pracServe_Player2_Ct_2nd_Deuce_OUT'] + mapPracServeData['pracServe_Player2_Ct_2nd_Ad_OUT'];
                                _Ct_Player2_2nd_TOT = _Ct_Player2_2nd_IN + _Ct_Player2_2nd_OUT;
                                _Ct_Player2_2nd_PCT = _Ct_Player2_2nd_TOT == 0 ?0 :_Ct_Player2_2nd_IN / _Ct_Player2_2nd_TOT * 100;


                              });
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Palette.red[500]),
                              padding: MaterialStateProperty.all<EdgeInsets>(
                                  // EdgeInsets.fromLTRB(10, 10, 10, 10)),
                                  EdgeInsets.all(10)),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0))),
                            ),
                            child: const Text('\nOUT-'),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
