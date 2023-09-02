import 'dart:async';
import 'dart:convert';
import '../firebase_options.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';

import '../screens/player_edit_screen.dart';

Map<String, dynamic> mapPlayerData_TEST = {
  'playerID':
      ('wu_aidan_y_${DateTime.now().year}${DateTime.now().month.toString().padLeft(2, '0')}${DateTime.now().day.toString().padLeft(2, '0')}_${DateTime.now().hour.toString().padLeft(2, '0')}${DateTime.now().minute.toString().padLeft(2, '0')}${DateTime.now().second.toString().padLeft(2, '0')}'),
  'playerOwner': FirebaseAuth.instance.currentUser!.uid,
  'playerFirstName': 'Aidan',
  'playerMiddleName': 'Y',
  'playerLastName': 'Wu',
  'playerUtr': 5,
  'playerAge': 10,
  'playerGender': 'Men',
  'playerHand': 'Right',
  'playerCity': 'Scarsdale',
  'playerState': 'NY',
  'playerCountry': 'USA',
  'playerClub': 'Carl Thorsen',
  'playerNotes': '',
  'playerLastUpdateDate': DateTime.now(),
  'playerEntryDate': DateTime.now(),
  'playerIsFavorite': true,
};

Map<String, dynamic> mapPlayerData_INIT = {
  'playerID': '',
  'playerOwner': '',
  'playerFirstName': '',
  'playerMiddleName': '-',
  'playerLastName': '',
  'playerUtr': 0,
  'playerAge': 0,
  'playerGender': 'Men',
  'playerHand': 'Right',
  'playerCity': '',
  'playerState': '',
  'playerCountry': 'USA',
  'playerClub': '',
  'playerNotes': '',
  'playerLastUpdateDate': DateTime.now(),
  'playerEntryDate': DateTime.now(),
  'playerIsFavorite': false,
};

var args;

CollectionReference collectionReference =
    FirebaseFirestore.instance.collection('Players');

class playerScreenArgs {
  // int index = -1;
  String index = '-1';
  Map<String, dynamic> mapPlayerData = {};

  playerScreenArgs(this.index, this.mapPlayerData);
}

class PlayersScreen extends StatelessWidget with ChangeNotifier {
  static const routeName = '/players_screen';

  var data;
  List? documents;

  addPlayerData(mapPlayerData) {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('Players');

    // collectionReference.add(mapPlayerData);
    collectionReference.doc(mapPlayerData['playerID']).set(mapPlayerData);
  }

  updatePlayerData(args) async {
    // int _index = args.index;
    String _index = args.index;
    Map<String, dynamic> _mapPlayerData = args.mapPlayerData;

    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('Players');

    // QuerySnapshot querySnapshot = await collectionReference.get();
    // querySnapshot.docs[_index].reference.update({'playerAge': 65});
    // querySnapshot.docs[_index].reference.update(_mapPlayerData);

    collectionReference.doc(_index).set(_mapPlayerData);
  }

  deletePlayerData(_index) async {
    CollectionReference collectionReference =
        await FirebaseFirestore.instance.collection('Players');
    collectionReference.doc(_index).delete();
  }

  // fetchPlayerData(_index) {
  //   CollectionReference collectionReference =
  //       FirebaseFirestore.instance.collection('Players');
  //   collectionReference.snapshots().listen((snapshot) {
  //     // data = snapshot.docs[_index].data;
  //     // return data;
  //
  //     data = snapshot.size;
  //     print('DEBUG.. ' + data.toString());
  //     // documents = snapshot.docs;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Player'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // keyForm_playerEdit.currentState!.reset();
              args = playerScreenArgs('-1', {});
              // args = playerScreenArgs(-1, {});
              // args = playerScreenArgs(-1,{'playerFirstName': ''});
              // print(args.index.toString() + ".." + args.mapPlayerData["playerFirstName"]);
              Navigator.of(context).pushNamed(
                PlayerEditScreen.routeName,
                arguments: args,
              );
            },
            // addPlayerTEST();
            // fetchPlayerData();
            // print('DEBUG.. ' + documents![0].data()['playerFirstName'].toString());
            // print('DEBUG.. ' + documents![1].data()['playerFirstName'].toString());
            // deletePlayerData();
            // updatePlayerData();
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: StreamBuilder(
        stream: collectionReference
            .where('playerOwner', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .orderBy('playerFirstName', descending: false)
            .snapshots(),
        builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (_, index) {
                DocumentSnapshot doc = snapshot.data!.docs[index];
                // Map<String, dynamic> doc = snapshot.data!.docs[index] as Map<String, dynamic>;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    title: Text(
                      doc['playerFirstName'] +
                          " " +
                          doc['playerMiddleName'] +
                          " " +
                          doc['playerLastName'],
                      // style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          // color: Colors.red,
                          child: Text(
                            "UTR: " +
                                doc['playerUtr'].toString() +
                                ". Hand: " +
                                doc['playerHand'] +
                                ". Age: " +
                                doc['playerAge'].toString(),
                            // style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          child: Text(
                            doc['playerCity'] +
                                " " +
                                doc['playerState'] +
                                " " +
                                doc['playerCountry'],
                            // style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ]),
                    trailing: Container(
                      width: 100,
                      child: Row(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              // print(doc.id.toString());
                              // print(doc.data());
                              // print(index.toString());
                              // print(fetchPlayerData(index));
                              args = playerScreenArgs(doc['playerID'],
                                  doc.data() as Map<String, dynamic>);
                              // index, doc.data() as Map<String, dynamic>);
                              Navigator.of(context).pushNamed(
                                  PlayerEditScreen.routeName,
                                  arguments: args);
                            },
                            color: Theme.of(context).primaryColor,
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              // print('deletePlayerData ${doc['playerID']}');
                              showDialog<void>(
                                context: context,
                                barrierDismissible:
                                    false, // user must tap button!
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('WARNING!'),
                                    content: SingleChildScrollView(
                                      child: Column(
                                        children: <Widget>[
                                          Text(
                                              'Are you sure you want to permanently delete this record?'),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text('Confirm'),
                                        onPressed: () {
                                          // print(
                                          //     'deletePlayerData ${doc['playerID']}');
                                          // deletePlayerData(index);
                                          deletePlayerData(doc['playerID']);
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: Text('Cancel'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            color: Theme.of(context).errorColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return Text('Loading Players...');
          }
        },
      ),
    );
  }
}
