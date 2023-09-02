// import 'dart:async';
// import '../firebase_options.dart';
//
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
//
// import '../config/custom_styles.dart';
import '../config/authentication.dart';
// import '../config/application_state.dart';

// import '../widgets/player.dart';
// import '../widgets/players.dart';

import '../screens/players_screen.dart';

// final keyForm_playerEdit = GlobalKey<FormState>(debugLabel: '_PlayerEditScreenState');
GlobalKey<FormState> keyForm_playerEdit = new GlobalKey<FormState>(debugLabel: '_PlayerEditScreenState');

enum PlayerGenderOptions {
  Men,
  Women,
  NA,
}

enum PlayerHandOptions {
  Right,
  Left,
  Ambidextrous,
}

enum PlayerFavoriteOptions {
  Favorites,
  All,
}

String index = '-1';
// int index = -1;
// Map<String, dynamic> mapPlayerData = mapPlayerData_INIT;
Map<String, dynamic> mapPlayerData = new Map<String, dynamic>.from(mapPlayerData_INIT);

class PlayerEditScreen extends StatefulWidget with ChangeNotifier {
  static const routeName = '/edit-player';

  @override
  _PlayerEditScreenState createState() => _PlayerEditScreenState();
}

class _PlayerEditScreenState extends State<PlayerEditScreen> {

  final _firstNameController = TextEditingController();
  final _middleNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _countryController = TextEditingController();
  final _clubController = TextEditingController();
  final _noteController = TextEditingController();
  final _ageController = TextEditingController();
  final _utrController = TextEditingController();

  var _isInit = true;
  var _initValues_playerGender = PlayerGenderOptions.Men;
  var _initValues_playerHand = PlayerHandOptions.Right;
  var _initValues_PlayerIsFavorite = PlayerFavoriteOptions.Favorites;

  @override
  void didChangeDependencies() { //didChangeDependencies is called just a few moments after the state loads its dependencies and context is available at this moment so here you can use context.

    // print('_PlayerEditScreenState.. didChangeDependencies..');
    if (_isInit) {

      // keyForm_playerEdit.currentState!.reset();
      // _initValues_playerGender = PlayerGenderOptions.Men;
      // _initValues_playerHand = PlayerHandOptions.Right;
      // _initValues_PlayerIsFavorite = PlayerFavoriteOptions.Favorites;

      // var mapPlayerData = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      final args = ModalRoute.of(context)!.settings.arguments as playerScreenArgs;

      index = args.index;
      if (index == '-1') {
        // if (index == -1) {
        // mapPlayerData = mapPlayerData_INIT;
        mapPlayerData = new Map<String, dynamic>.from(mapPlayerData_INIT);
        print('_PlayerEditScreenState.. didChangeDependencies2.. index: ' + index + '.. playerID: ' + mapPlayerData['playerID']);
      } else if (!args.mapPlayerData.isEmpty) {
        mapPlayerData = args.mapPlayerData;
        print('_PlayerEditScreenState.. didChangeDependencies3.. index: ' + index + '.. playerID: ' + mapPlayerData['playerID']);
      } else {
        print('_PlayerEditScreenState.. didChangeDependencies4.. index: ' + index + '.. playerID: ' + mapPlayerData['playerID']);
      }

      _firstNameController.text = mapPlayerData['playerFirstName'];
      _middleNameController.text = mapPlayerData['playerMiddleName'];
      _lastNameController.text = mapPlayerData['playerLastName'];
      _utrController.text = mapPlayerData['playerUtr'].toString();
      _ageController.text = mapPlayerData['playerAge'].toString();
      _cityController.text = mapPlayerData['playerCity'];
      _stateController.text = mapPlayerData['playerState'];
      _countryController.text = mapPlayerData['playerCountry'];
      _clubController.text = mapPlayerData['playerClub'];
      _noteController.text = mapPlayerData['playerNotes'];
    }
    _isInit = false;
    // super.didChangeDependencies();
  }

  void _saveForm() {

    final isValid = keyForm_playerEdit.currentState!.validate();
    if (!isValid) {
      return;
    }
    keyForm_playerEdit.currentState!.save();

    // if (index == -1) { // Add new player
    if (index == '-1') { // Add new player
      mapPlayerData['playerID'] = ('${mapPlayerData['playerLastName']}_${mapPlayerData['playerFirstName']}_${mapPlayerData['playerMiddleName']}_${DateTime.now().year}${DateTime.now().month.toString().padLeft(2, '0')}${DateTime.now().day.toString().padLeft(2, '0')}_${DateTime.now().hour.toString().padLeft(2, '0')}${DateTime.now().minute.toString().padLeft(2, '0')}${DateTime.now().second.toString().padLeft(2, '0')}');
      mapPlayerData['playerEntryDate'] = DateTime.now();
      mapPlayerData['playerLastUpdateDate'] = DateTime.now();
      mapPlayerData['playerOwner'] = FirebaseAuth.instance.currentUser!.uid;

      // print('DEBUG.. Adding ' + mapPlayerData['playerID']);
      Provider.of<PlayersScreen>(context, listen: false).updatePlayerData(playerScreenArgs(mapPlayerData['playerID'], mapPlayerData));

    } else { // Update player
      mapPlayerData['playerLastUpdateDate'] = DateTime.now();
      Provider.of<PlayersScreen>(context, listen: false).updatePlayerData(playerScreenArgs(mapPlayerData['playerID'], mapPlayerData));
    }
    // print('_PlayerEditScreenState.. _saveForm.. ' + index.toString() + ' <=> ' + mapPlayerData['playerID']);

    // Resetting form and data
    mapPlayerData = new Map<String, dynamic>.from(mapPlayerData_INIT);
    keyForm_playerEdit.currentState!.reset();

    // Return to prior page
    Navigator.of(context).pop();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Player'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              // print('_PlayerEditScreenState.. PRE-_saveForm.. ' + index.toString() + ' <=> ' + mapPlayerData['playerID']);
              _saveForm();
            }
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: keyForm_playerEdit,
          child: ListView(
            children: <Widget>[
              // Container(
              //   padding: const EdgeInsets.symmetric(vertical:10),
              //   child: Text('ID: '),
              // ),
              TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(labelText: 'First Name'),
                // decoration: InputDecoration(hintText: 'First Name'),
                validator: (value) {
                  // validator: controller.isNumberValid(value!) {
                  if (value == null || value!.isEmpty) {
                    return 'Please provide a name.';
                  }
                  return null;
                },
                // onFieldSubmitted: (value) {
                //   print(mapPlayerData['playerCountry'] + " <> " + value);
                // },
                onSaved: (value) {
                  mapPlayerData['playerFirstName'] = value;
                },
              ),
              TextFormField(
                controller: _middleNameController,
                decoration: InputDecoration(labelText: 'Middle Name'),
                validator: (value) {
                  if (value == null || value!.isEmpty) {
                    return 'Please provide a name.';
                  }
                  return null;
                },
                onSaved: (value) {
                  mapPlayerData['playerMiddleName'] = value;
                },
              ),
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(labelText: 'Last Name'),
                validator: (value) {
                  if (value == null || value!.isEmpty) {
                    return 'Please provide a name.';
                  }
                  return null;
                },
                onSaved: (value) {
                  mapPlayerData['playerLastName'] = value;
                },
              ),TextFormField(
                controller: _utrController,
                decoration: InputDecoration(labelText: 'UTR'),
                keyboardType: TextInputType.number,
                // validator: (value) {
                //   if (value == null || value!.isEmpty) {
                //     return 'Please enter a price.';
                //   }
                //   if (double.tryParse(value!) == null) {
                //     return 'Please enter a valid number.';
                //   }
                //   if (double.parse(value!) <= 0) {
                //     return 'Please enter a number greater than zero.';
                //   }
                //   return null;
                // },
                onSaved: (value) {
                  mapPlayerData['playerUtr'] = value;
                },
              ),TextFormField(
                controller: _ageController,
                decoration: InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                // validator: (value) {
                //   if (value == null || value!.isEmpty) {
                //     return 'Please enter an age.';
                //   }
                //   if (double.tryParse(value!) == null) {
                //     return 'Please enter a valid number.';
                //   }
                //   if (double.parse(value!) <= 0) {
                //     return 'Please enter a number greater than zero.';
                //   }
                //   return null;
                // },
                onSaved: (value) {
                  mapPlayerData['playerAge'] = value;
                },
              ),
              DropdownButtonFormField<PlayerGenderOptions>(
                value: _initValues_playerGender,
                isExpanded: true,
                decoration: InputDecoration(labelText: 'Gender'),
                onChanged: (PlayerGenderOptions? value) {
                  setState(() {
                    mapPlayerData['playerGender'] = describeEnum(value!).toString();
                  });
                },
                items: PlayerGenderOptions.values.map((PlayerGenderOptions value) {
                  return DropdownMenuItem<PlayerGenderOptions>(
                      value: value, child: Text(describeEnum(value)));
                  // child: Text(value.toString()));
                }).toList(),
              ),
              DropdownButtonFormField<PlayerHandOptions>(
                value: _initValues_playerHand,
                isExpanded: true,
                decoration: InputDecoration(labelText: 'Hand'),
                onChanged: (PlayerHandOptions? value) {
                  setState(() {
                    mapPlayerData['playerHand'] = describeEnum(value!).toString();
                  });
                },
                items: PlayerHandOptions.values.map((PlayerHandOptions value) {
                  return DropdownMenuItem<PlayerHandOptions>(
                      value: value, child: Text(describeEnum(value)));
                  // child: Text(value.toString()));
                }).toList(),
              ),
              TextFormField(
                controller: _cityController,
                decoration: InputDecoration(labelText: 'City'),
                // validator: (value) {
                //   if (value == null || value!.isEmpty) {
                //     return 'Please provide a City.';
                //   }
                //   return null;
                // },
                onSaved: (value) {
                  mapPlayerData['playerCity'] = value;
                },
              ),
              TextFormField(
                controller: _stateController,
                decoration: InputDecoration(labelText: 'State'),
                // validator: (value) {
                //   if (value == null || value!.isEmpty) {
                //     return 'Please provide a State.';
                //   }
                //   return null;
                // },
                onSaved: (value) {
                  mapPlayerData['playerState'] = value;
                },
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
                  mapPlayerData['playerCountry'] = value;
                },
              ),
              TextFormField(
                controller: _clubController,
                decoration: InputDecoration(labelText: 'Club'),
                // validator: (value) {
                //   if (value == null || value!.isEmpty) {
                //     return 'Please provide a Club.';
                //   }
                //   return null;
                // },
                onSaved: (value) {
                  mapPlayerData['playerClub'] = value;
                },
              ),
              TextFormField(
                controller: _noteController,
                decoration: InputDecoration(labelText: 'Notes'),
                maxLines: 10,
                keyboardType: TextInputType.multiline,
                onSaved: (value) {
                  mapPlayerData['playerNotes'] = value;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}



