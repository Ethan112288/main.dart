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

import '../screens/point_edit_screen.dart';

String matchID = '';
var _args;

class pointsScreenArgs {

  String _matchID = '';
  int _index = -1;

  pointsScreenArgs(this._matchID, this._index);
}

class PointsScreen extends StatefulWidget with ChangeNotifier {
  static const routeName = '/points_screen';
  // var data;
  // List? documents;

  @override
  PointsScreenState createState() => PointsScreenState();
}

class PointsScreenState extends State<PointsScreen> {
  var _isInit = true;

  @override
  void didChangeDependencies() {
    //didChangeDependencies is called just a few moments after the state loads its dependencies and context is available at this moment so here you can use context.

    // print('PointsScreen DEBUG.. didChangeDependencies');
    // print('PointsScreen DEBUG.. ' + _isInit.toString());

    if (_isInit) {
      matchID = ModalRoute.of(context)!.settings.arguments as String;

    }
    _isInit = false;
    super.didChangeDependencies();
  }

  // updatePointData(args) async {
  //   int _index = args.index;
  //   Map<String, dynamic> _mapPointData = args.mapPointData;
  //
  //   CollectionReference collectionReference =
  //       FirebaseFirestore.instance.collection('Points');
  //   QuerySnapshot querySnapshot = await collectionReference.get();
  //   // querySnapshot.docs[_index].reference.update({'playerAge': 65});
  //   querySnapshot.docs[_index].reference.update(_mapPointData);
  // }

  deletePointData(args) async {
    String _matchID = args._matchID;
    int _index = args._index;

    CollectionReference collectionReference = await FirebaseFirestore.instance
        .collection('Matches')
        .doc(_matchID)
        .collection('Points');

    QuerySnapshot querySnapshot = await collectionReference.get();
    querySnapshot.docs[_index].reference.delete();
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference collectionReference = FirebaseFirestore.instance
        .collection('Matches')
        .doc(matchID)
        .collection('Points');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Point'),
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
      body: StreamBuilder(
        stream: collectionReference.snapshots(),
        builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
          // if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (_, index) {
              DocumentSnapshot doc = snapshot.data!.docs[index];
              // Map<String, dynamic> doc = snapshot.data!.docs[index] as Map<String, dynamic>;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  title: Text(
                    doc['pointID'],
                    // style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        // color: Colors.red,
                        child: Text(
                          "Winner: " +
                              doc['pointPtWon_PlayerNum'].toString() +
                              ". Server: " +
                              doc['pointService_PlayerNum'].toString() +
                              ". Service Type: " +
                              doc['pointService_Type'].toString(),
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
                            // args = playerScreenArgs(
                            //     index, doc.data() as Map<String, dynamic>);
                            // Navigator.of(context).pushNamed(
                            //     PointEditScreen.routeName,
                            //     arguments: args);
                          },
                          color: Theme.of(context).primaryColor,
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            // print('pointsScreenArgs DEBUG.. ' + matchID.toString());
                            // print('pointsScreenArgs DEBUG.. ' + index.toString());
                            _args = pointsScreenArgs(
                                matchID, index);
                            deletePointData(_args);
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
          // }
        },
      ),
    );
  }
}
