import 'dart:async';
//import 'dart:convert';
import '../firebase_options.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
//import 'package:provider/provider.dart';
// import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:dropdown_search/dropdown_search.dart';

import '../config/palette.dart';

//import '../screens/players_screen.dart';
import '../screens/matches_screen.dart';
import '../screens/point_edit_screen.dart';
//import '../screens/new_player_screen.dart';

const absHeight_PlayerID_matchEdit = 70.0;

enum MatchLevelOptions {
  L1,
  L2,
  L3,
  L4,
  L5,
  L6,
  UTR,
  Practice,
}

enum MatchTypeOptions {
  Men_Singles,
  Women_Singles,
  Mix_Singles,
  // Men_Double,
  // Women_Double,
  // Mix_Double,
}

enum MatchAdOptions {
  Ad,
  NoAd,
}

enum MatchFormatSetOptions {
  OneSet,
  TwoOfThree,
  ThreeOfFive,
}

enum MatchFormatFinalSetOptions {
  Regular,
  SuperTieBreak,
  TieBreak,
  NoTieBreak,
}

final Map<String, dynamic> mapMatchData_INIT = {
  'matchID': '',
  'matchOwner': '',
  'matchLevel': 'L4',
  'matchType': 'Boy16',
  'matchVenue': '',
  'matchCity': '-',
  'matchState': 'NY',
  'matchCountry': 'USA',
  'matchPlayer1ID': '',
  'matchPlayer1FirstName': '',
  'matchPlayer1LastName': '',
  'matchPlayer2ID': '',
  'matchPlayer2FirstName': '',
  'matchPlayer2LastName': '',
  'matchSetFormat': 'TwoOfThree',
  'matchNumOfGamesPerSet': 6,
  'matchAd': 'Ad',
  'matchFinalSetFormat': 'SuperTieBreak',
  'matchNotes': '',
  'matchLastUpdateDate': '', // was DateTime.now()
  'matchEntryDate': '', // was DateTime.now()
  'matchIsGamePt': false,
  'matchIsSetPt': false,
  'matchIsMatchPt': false,
  'matchIsMatchOver': false,
  'matchService_PlayerNum': '1',
  'matchCurrSet': 1,
  'matchCurrGameFormat': 'Regular',
  'matchCurrGamePts_Player1': 0,
  'matchCurrGamePts_Player2': 0,
  'matchCurrGamePts_PlayerMAX': 0,
  'matchCurrGamePts_PlayerDIFF': 0,
  'matchCurrSetPts_Player1': 0,
  'matchCurrSetPts_Player2': 0,
  'matchSetsWon_Player1': 0,
  'matchSetsWon_Player2': 0,
  'matchSetsWon_PlayerMAX': 0,
  'matchSetsWon_PlayerDIFF': 0,
  'matchSetTotPts_Player1': [],
  'matchSetTotPts_Player2': [],
  'matchCurrGameScores_Player1': '0',
  'matchCurrGameScores_Player2': '0',
  'matchCurrSetGames_Player1': 0,
  'matchCurrSetGames_Player2': 0,
  'matchCurrSetGames_PlayerMAX': 0,
  'matchCurrSetGames_PlayerDIFF': 0,
  'matchPriorSetGames_Player1': [],
  'matchPriorSetGames_Player2': [],
  'matchSetMMAX': 0,
  'matchSetMAX': 0,
  'matchGameMAX': 0,
  'matchPtMAX': 0,
};

class matchScreenArgs {
  // int index = -1;
  String index = '-1';
  Map<String, dynamic> mapMatchData = {};

  matchScreenArgs(this.index, this.mapMatchData);
}

class MatchEditScreen extends StatefulWidget with ChangeNotifier {
  static const routeName = '/edit-match';

  @override
  MatchEditScreenState createState() => MatchEditScreenState();
}

class MatchEditScreenState extends State<MatchEditScreen> with ChangeNotifier {
  final _keyForm = GlobalKey<FormState>(debugLabel: 'MatchEditScreenState');
  final _matchTypeController = TextEditingController();
  final _venueController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _countryController = TextEditingController();
  // final _firstToServeController = TextEditingController();
  final _numOfSetsController = TextEditingController();
  final _numOfGamesPerSetController = TextEditingController();
  final _noteController = TextEditingController();

  var _isInit = true;
  var _initValues_matchLevel = MatchLevelOptions.L4;

  var _initValues_matchServicePlayerNum = '1';
  var _initValues_matchSetFormat = MatchFormatSetOptions.TwoOfThree;
  var _initValues_matchAd = MatchAdOptions.NoAd;
  var _initValues_matchFinalSetFormat =
      MatchFormatFinalSetOptions.SuperTieBreak;

  var _args;
  // int index = -1;
  String index = '-1';
  Map<String, dynamic> mapMatchData = {};
// Map<String, dynamic> mapMatchData =
//     new Map<String, dynamic>.from(mapMatchData_INIT);
  List<String> listPlayerID = [];

  // static final Map<String, dynamic> mapMatchData_INIT = {
  //   'matchID': '',
  //   'matchLevel': 'L4',
  //   'matchType': 'Boy16',
  //   'matchVenue': '-',
  //   'matchCity': '-',
  //   'matchState': 'NY',
  //   'matchCountry': 'USA',
  //   'matchPlayer1ID': '',
  //   'matchPlayer1FirstName': '',
  //   'matchPlayer1LastName': '',
  //   'matchPlayer2ID': '',
  //   'matchPlayer2FirstName': '',
  //   'matchPlayer2LastName': '',
  //   'matchSetFormat': 'ThreeOfFive',
  //   'matchNumOfGamesPerSet': 6,
  //   'matchAd': 'NoAd',
  //   'matchFinalSetFormat': 'SuperTieBreak',
  //   'matchNotes': '',
  //   'matchLastUpdateDate': '', // was DateTime.now()
  //   'matchEntryDate': '', // was DateTime.now()
  //   'matchIsGamePt': false,
  //   'matchIsSetPt': false,
  //   'matchIsMatchPt': false,
  //   'matchIsMatchOver': false,
  //   'matchService_PlayerNum': '1',
  //   'matchCurrSet': 1,
  //   'matchCurrGameFormat': 'Regular',
  //   'matchCurrGamePts_Player1': 0,
  //   'matchCurrGamePts_Player2': 0,
  //   'matchCurrGamePts_PlayerMAX': 0,
  //   'matchCurrGamePts_PlayerDIFF': 0,
  //   'matchCurrSetPts_Player1': 0,
  //   'matchCurrSetPts_Player2': 0,
  //   'matchSetsWon_Player1': 0,
  //   'matchSetsWon_Player2': 0,
  //   'matchSetsWon_PlayerMAX': 0,
  //   'matchSetsWon_PlayerDIFF': 0,
  //   'matchSetTotPts_Player1': [],
  //   'matchSetTotPts_Player2': [],
  //   'matchCurrGameScores_Player1': '0',
  //   'matchCurrGameScores_Player2': '0',
  //   'matchCurrSetGames_Player1': 0,
  //   'matchCurrSetGames_Player2': 0,
  //   'matchCurrSetGames_PlayerMAX': 0,
  //   'matchCurrSetGames_PlayerDIFF': 0,
  //   'matchPriorSetGames_Player1': [],
  //   'matchPriorSetGames_Player2': [],
  //   'matchSetMMAX': 0,
  //   'matchSetMAX': 0,
  //   'matchGameMAX': 0,
  //   'matchPtMAX': 0,
  // };

  // void initState() {
  //   // print('DEBUG.. initState');
  //   super.initState();
  //
  //   // this.updateListPlayerID();
  //   // setState(() {
  //   //   final listPlayerID = updateListPlayerID();
  //   // });
  //   // final listPlayerID = updateListPlayerID();
  // }

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

  addMatchData(mapMatchData) {
    CollectionReference collectionReference =
    FirebaseFirestore.instance.collection('Matches');

    // collectionReference.add(mapMatchData);
    collectionReference.doc(mapMatchData['matchID']).set(mapMatchData);
  }

  updateMatchData(_args) async {
    String _index = _args.index;
    Map<String, dynamic> _mapMatchData = _args.mapMatchData;

    // CollectionReference collectionReference =
    //     FirebaseFirestore.instance.collection('Matches');
    // QuerySnapshot querySnapshot = await collectionReference.get();
    // querySnapshot.docs[_index].reference.update(_mapMatchData);

    CollectionReference collectionReference =
    await FirebaseFirestore.instance.collection('Matches');
    collectionReference.doc(_index).set(_mapMatchData);
  }

  deleteMatchData(_index) async {
    // CollectionReference collectionReference =
    //     FirebaseFirestore.instance.collection('Matches');
    // QuerySnapshot querySnapshot = await collectionReference.get();
    // querySnapshot.docs[_index].reference.delete();

    CollectionReference collectionReference =
    await FirebaseFirestore.instance.collection('Matches');
    collectionReference.doc(_index).delete();
  }

  @override
  void didChangeDependencies() {
    //didChangeDependencies is called just a few moments after the state loads its dependencies and context is available at this moment so here you can use context.

    // print('MatchEditScreenState.. didChangeDependencies');
    // print('MatchEditScreenState.. _isInit: ' + _isInit.toString());

    if (_isInit) {
      // var mapMatchData = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      final _args =
      ModalRoute.of(context)!.settings.arguments as matchScreenArgs;

      index = _args.index;
      if (index == '-1') {
        // if (index == -1 || _args.mapMatchData.isEmpty) {
        // mapMatchData = mapMatchData_INIT;
        // Map<String, dynamic> mapMatchData =
        //     new Map<String, dynamic>.from(mapMatchData_INIT);
        mapMatchData = new Map<String, dynamic>.from(mapMatchData_INIT);
        mapMatchData['matchSetTotPts_Player1'] = [];
        mapMatchData['matchSetTotPts_Player2'] = [];
        mapMatchData['matchPriorSetGames_Player1'] = [];
        mapMatchData['matchPriorSetGames_Player2'] = [];
        // print('MatchEditScreenState.. mapMatchData.mapMatchData_INIT matchCity: ' + mapMatchData['matchCity']);
      } else if (!_args.mapMatchData.isEmpty) {
        // print('MatchEditScreenState.. mapMatchData NOT Empty.. ' +
        //     _args.mapMatchData['matchID']);
        mapMatchData = _args.mapMatchData;
      } else {
        // print('MatchEditScreenState.. NOT SUPPOSED TO HAPPEN.. ');
      }

      // print(index);
      // print(mapMatchData['matchCity']);
      // print(mapMatchData_INIT['matchCity']);

      _matchTypeController.text = mapMatchData['matchType'];
      _venueController.text = mapMatchData['matchVenue'];
      _cityController.text = mapMatchData['matchCity'];
      _stateController.text = mapMatchData['matchState'];
      _countryController.text = mapMatchData['matchCountry'];
      _numOfGamesPerSetController.text =
          mapMatchData['matchNumOfGamesPerSet'].toString();
      _noteController.text = mapMatchData['matchNotes'];

      _initValues_matchLevel = MatchLevelOptions.values.firstWhere((e) =>
      e.toString() == 'MatchLevelOptions.' + mapMatchData['matchLevel']);

      _initValues_matchServicePlayerNum =
      mapMatchData['matchService_PlayerNum'];
      _initValues_matchSetFormat = MatchFormatSetOptions.values.firstWhere(
              (e) =>
          e.toString() ==
              'MatchFormatSetOptions.' + mapMatchData['matchSetFormat']);
      _initValues_matchAd = MatchAdOptions.values.firstWhere(
              (e) => e.toString() == 'MatchAdOptions.' + mapMatchData['matchAd']);
      _initValues_matchFinalSetFormat = MatchFormatFinalSetOptions.values
          .firstWhere((e) =>
      e.toString() ==
          'MatchFormatFinalSetOptions.' +
              mapMatchData['matchFinalSetFormat']);
    }
    _isInit = false;
    // super.didChangeDependencies();
  }

  void _saveForm() {
    var _tmp;

    // print('DEBUG...');
    // print(index);
    // print(mapMatchData);
    // print(mapMatchData['matchID']);
    // print(mapMatchData['matchAd']);
    final isValid = _keyForm.currentState!.validate();
    if (!isValid) {
      return;
    }
    _keyForm.currentState!.save();
    if (index == '-1') {
      // if (index == -1 || mapMatchData['matchID'] == '') {
      // Add new match
      _tmp = mapMatchData['matchPlayer1ID'].split('_');
      mapMatchData['matchPlayer1FirstName'] = _tmp[1];
      mapMatchData['matchPlayer1LastName'] = _tmp[0];

      _tmp = mapMatchData['matchPlayer2ID'].split('_');
      mapMatchData['matchPlayer2FirstName'] = _tmp[1];
      mapMatchData['matchPlayer2LastName'] = _tmp[0];

      mapMatchData['matchID'] =
      ('${mapMatchData['matchLevel']}_${mapMatchData['matchType']}_${mapMatchData['matchCity']}_${mapMatchData['matchPlayer1LastName']}-${mapMatchData['matchPlayer2LastName']}_${DateTime.now().year}${DateTime.now().month.toString().padLeft(2, '0')}${DateTime.now().day.toString().padLeft(2, '0')}_${DateTime.now().hour.toString().padLeft(2, '0')}${DateTime.now().minute.toString().padLeft(2, '0')}${DateTime.now().second.toString().padLeft(2, '0')}');
      mapMatchData['matchEntryDate'] = DateTime.now();
      mapMatchData['matchLastUpdateDate'] = DateTime.now();

      mapMatchData['matchOwner'] = FirebaseAuth.instance.currentUser!.uid;

      addMatchData(mapMatchData);
    } else {
      // Update match
      mapMatchData['matchLastUpdateDate'] = DateTime.now();

      _tmp = mapMatchData['matchPlayer1ID'].split('_');
      mapMatchData['matchPlayer1FirstName'] = _tmp[1];
      mapMatchData['matchPlayer1LastName'] = _tmp[0];

      _tmp = mapMatchData['matchPlayer2ID'].split('_');
      mapMatchData['matchPlayer2FirstName'] = _tmp[1];
      mapMatchData['matchPlayer2LastName'] = _tmp[0];

      updateMatchData(matchScreenArgs(index, mapMatchData));
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    //It must not be created during the State.build or StatelessWidget.build method call when constructing the FutureBuilder. If the future is created at the same time as the FutureBuilder, then every time the FutureBuilder's parent is rebuilt, the asynchronous task will be restarted.
    // updateListPlayerID();
    // setState(() {
    //   final listPlayerID = updateListPlayerID();
    // });
    return Scaffold(
      floatingActionButton: new FloatingActionButton.extended(
        label: const Text(
          'NEXT',
          // style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          style: TextStyle(color: Palette.umBlue, fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          _saveForm();
          Navigator.of(context)
              .pushNamed(PointEditScreen.routeName, arguments: mapMatchData);
        },
        backgroundColor: Palette.umMaize,
        icon: const Icon(
          // Icons.arrow_forward_ios_rounded,
          Icons.send,
          // color: Colors.white,
          color: Palette.umBlue,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      appBar: AppBar(
        title: Text('Edit Match'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              showDialog<void>(
                context: context,
                barrierDismissible: false, // user must tap button!
                builder: (BuildContext context) {
                  return AlertDialog(
                    // title: Text('Are you sure you want to permanently remove this record?'),
                    title: Text('WARNING!'),
                    content: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          // Text('WARNING!'),
                          Text(
                              'Are you sure you want to permanently delete this record?'),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: Text('Confirm'),
                        onPressed: () {
                          // Provider.of<MatchEditScreenState>(context,
                          //         listen: false)
                          //     .deleteMatchData(index);
                          deleteMatchData(index);
                          Navigator.of(context).pop();
                          Navigator.of(context).pushNamed(
                            MatchesScreen.routeName,
                          );
                        },
                      ),
                      TextButton(
                        child: Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                          // _args = matchScreenArgs(-1,{});
                          Navigator.of(context).pushNamed(
                            MatchesScreen.routeName,
                            // arguments: _args,
                          );
                        },
                      ),
                    ],
                  );
                },
              );
            },
            // color: Theme.of(context).errorColor,
          ),
          IconButton(
            // icon: Icon(Icons.save),
            // icon: Icon(Icons.next_plan),
            // icon: Icon(Icons.smart_display),
            // icon: Icon(Icons.navigate_next),
              icon: Icon(Icons.send),
              onPressed: () {
                _saveForm();
                Navigator.of(context).pushNamed(PointEditScreen.routeName,
                    arguments: mapMatchData);
                // print('DEBUG...');
                // print('DEBUG...' + listPlayerID.length.toString());
                // print('DEBUG...' + listPlayerID[0]);
                // print('DEBUG...' + listPlayerID[1]);
              }),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _keyForm,
          child: ListView(
            children: <Widget>[
              // Container(
              //   padding: const EdgeInsets.symmetric(vertical:10),
              //   child: Text('ID: '),
              // ),
              Row(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: DropdownButtonFormField<MatchLevelOptions>(
                      value: _initValues_matchLevel,
                      isExpanded: true,
                      decoration: InputDecoration(labelText: 'Level'),
                      validator: (value) {
                        if (value == null || value == '') {
                          return 'Please provide a Level.';
                        }
                        return null;
                      },
                      onChanged: (MatchLevelOptions? value) {
                        setState(() {
                          // print('DEBUG.. ' + describeEnum(value!).toString());
                          mapMatchData['matchLevel'] =
                              describeEnum(value!).toString();
                        });
                      },
                      onSaved: (MatchLevelOptions? value) {
                        setState(() {
                          // print('DEBUG.. ' + describeEnum(value!).toString());
                          mapMatchData['matchLevel'] =
                              describeEnum(value!).toString();
                        });
                      },
                      items: MatchLevelOptions.values
                          .map((MatchLevelOptions value) {
                        return DropdownMenuItem<MatchLevelOptions>(
                            value: value, child: Text(describeEnum(value)));
                        // child: Text(value.toString()));
                      }).toList(),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: TextFormField(
                        controller: _matchTypeController,
                        decoration: InputDecoration(
                            labelText: 'Gender/ Age', hintText: 'Boy16'),
                        validator: (value) {
                          if (value == null || value!.isEmpty) {
                            return 'Please provide Match Type.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          mapMatchData['matchType'] = value;
                        },
                      ),
                    ),
                  ),
                ],
              ),
              TextFormField(
                controller: _venueController,
                decoration: InputDecoration(labelText: 'Venue'),
                // validator: (value) {
                //   if (value == null || value!.isEmpty) {
                //     return 'Please provide a City.';
                //   }
                //   return null;
                // },
                onSaved: (value) {
                  mapMatchData['matchVenue'] = value;
                },
              ),
              Row(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: TextFormField(
                      controller: _cityController,
                      decoration: InputDecoration(labelText: 'City'),
                      // validator: (value) {
                      //   if (value == null || value!.isEmpty) {
                      //     return 'Please provide a City.';
                      //   }
                      //   return null;
                      // },
                      onSaved: (value) {
                        mapMatchData['matchCity'] = value;
                      },
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: _stateController,
                      decoration: InputDecoration(labelText: 'State'),
                      // validator: (value) {
                      //   if (value == null || value!.isEmpty) {
                      //     return 'Please provide a State.';
                      //   }
                      //   return null;
                      // },
                      onSaved: (value) {
                        mapMatchData['matchState'] = value;
                      },
                    ),
                  ),
                ],
              ),

              TextFormField(
                controller: _countryController,
                decoration: InputDecoration(labelText: 'Country'),
                // validator: (value) {
                //   if (value == null || value!.isEmpty) {
                //     return 'Please provide a Country.';
                //   }
                //   return null;
                // },
                onSaved: (value) {
                  mapMatchData['matchCountry'] = value;
                },
              ),
              // Text(listPlayerID.length.toString()),
              FutureBuilder<List<String>>(
                // FutureBuilder<List<String>>(
                future:
                updateListPlayerID(), // a previously-obtained Future<String> or null
                builder: (BuildContext context,
                    AsyncSnapshot<List<String>> snapshot) {
                  // AsyncSnapshot<QuerySnapshot> snapshot) {
                  List<Widget> children;
                  if (snapshot.hasData) {
                    final _listPlayerID = snapshot.data as List<String>;
                    // print('DEBUG... snapshot.hasData');
                    // print('DEBUG.. updateListPlayerID.. ' + _listPlayerID.length.toString());
                    // print('DEBUG.. updateListPlayerID.. ' + _listPlayerID[0]);
                    // print('DEBUG.. updateListPlayerID.. ' + _listPlayerID[1]);
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
                          selectedItem: (mapMatchData['matchPlayer1ID'] == '')
                              ? _listPlayerID[_listPlayerID.length - 1]
                              : mapMatchData['matchPlayer1ID'],
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
                              mapMatchData['matchPlayer1ID'] = value!;
                            });
                          },
                          onSaved: (String? value) {
                            setState(() {
                              mapMatchData['matchPlayer1ID'] = value!;
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
                          selectedItem: (mapMatchData['matchPlayer2ID'] == '')
                              ? _listPlayerID[_listPlayerID.length - 2]
                              : mapMatchData['matchPlayer2ID'],
                          items: _listPlayerID,
                          dropdownSearchDecoration: InputDecoration(
                            labelText: 'Player2 ID',
                          ),
                          onChanged: (String? value) {
                            setState(() {
                              mapMatchData['matchPlayer2ID'] = value!;
                            });
                          },
                          onSaved: (String? value) {
                            setState(() {
                              mapMatchData['matchPlayer2ID'] = value!;
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

                      // DropdownButtonFormField<String>(
                      //   // value: mapMatchData['matchPlayer1ID'],
                      //   // value: _listPlayerID[0],
                      //   value: (mapMatchData['matchPlayer1ID'] == '')
                      //       ? _listPlayerID[1]
                      //       : mapMatchData['matchPlayer1ID'],
                      //   isExpanded: true,
                      //   decoration: InputDecoration(labelText: 'Player1 ID'),
                      //   validator: (value) {
                      //     if (value == null || value == '') {
                      //       return 'Please provide an ID.';
                      //     }
                      //     return null;
                      //   },
                      //   onChanged: (String? value) {
                      //     setState(() {
                      //       mapMatchData['matchPlayer1ID'] = value!;
                      //     });
                      //   },
                      //   onSaved: (String? value) {
                      //     setState(() {
                      //       mapMatchData['matchPlayer1ID'] = value!;
                      //     });
                      //   },
                      //   items: _listPlayerID.map((String value) {
                      //     return DropdownMenuItem<String>(
                      //         value: value, child: Text(value));
                      //   }).toList(),
                      // ),
                      // DropdownButtonFormField<String>(
                      //   // value: mapMatchData['matchPlayer2ID'],
                      //   value: (mapMatchData['matchPlayer2ID'] == '')
                      //       ? _listPlayerID[0]
                      //       : mapMatchData['matchPlayer2ID'],
                      //   isExpanded: true,
                      //   decoration: InputDecoration(labelText: 'Player2 ID'),
                      //   validator: (value) {
                      //     if (value == null || value == '') {
                      //       return 'Please provide an ID.';
                      //     } else if (value == mapMatchData['matchPlayer1ID']) {
                      //       return 'Player1 and Player2 cannot have the same ID';
                      //     }
                      //     return null;
                      //   },
                      //   onChanged: (String? value) {
                      //     setState(() {
                      //       mapMatchData['matchPlayer2ID'] = value!;
                      //     });
                      //   },
                      //   onSaved: (String? value) {
                      //     setState(() {
                      //       mapMatchData['matchPlayer2ID'] = value!;
                      //     });
                      //   },
                      //   items: _listPlayerID.map((String value) {
                      //     return DropdownMenuItem<String>(
                      //         value: value, child: Text(value));
                      //   }).toList(),
                      // ),
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

              DropdownButtonFormField<String>(
                value: _initValues_matchServicePlayerNum, //'1',
                isExpanded: true,
                decoration:
                InputDecoration(labelText: 'Player to Serve: 1 or 2'),
                onChanged: (String? value) {
                  setState(() {
                    mapMatchData['matchService_PlayerNum'] = value!;
                  });
                },
                onSaved: (String? value) {
                  setState(() {
                    mapMatchData['matchService_PlayerNum'] = value!;
                  });
                },
                items: ['1', '2'].map((String value) {
                  return DropdownMenuItem<String>(
                      value: value, child: Text(value));
                  // child: Text(value.toString()));
                }).toList(),
              ),
              Row(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: DropdownButtonFormField<MatchFormatSetOptions>(
                      value:
                      _initValues_matchSetFormat, //MatchFormatSetOptions.TwoOfThree,
                      isExpanded: true,
                      decoration: InputDecoration(labelText: 'Set Format'),
                      onChanged: (MatchFormatSetOptions? value) {
                        setState(() {
                          mapMatchData['matchSetFormat'] =
                              describeEnum(value!).toString();
                        });
                      },
                      onSaved: (MatchFormatSetOptions? value) {
                        setState(() {
                          mapMatchData['matchSetFormat'] =
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
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.4,
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
                        onSaved: (value) {
                          mapMatchData['matchNumOfGamesPerSet'] =
                              int.parse(value!);
                        },
                      ),
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
                            mapMatchData['matchAd'] =
                                describeEnum(value!).toString();
                          });
                        },
                        onSaved: (MatchAdOptions? value) {
                          setState(() {
                            mapMatchData['matchAd'] =
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
                            mapMatchData['matchFinalSetFormat'] =
                                describeEnum(value!).toString();
                          });
                        },
                        onSaved: (MatchFormatFinalSetOptions? value) {
                          setState(() {
                            mapMatchData['matchFinalSetFormat'] =
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
              TextFormField(
                controller: _noteController,
                decoration: InputDecoration(
                  labelText: 'Notes',
                ),
                maxLines: 5,
                keyboardType: TextInputType.multiline,
                onSaved: (value) {
                  mapMatchData['matchNotes'] = value;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
