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

import '../screens/pracServe_edit_screen.dart';

Map<String, dynamic> mapPracServeData_INIT = {
  'pracServe_ID': '',
  'pracServe_Owner': '',
  'pracServe_yyyymmdd': '',
  'pracServe_Venue': 'Concordia',
  'pracServe_Player1_PlayerID': 'NA_NA_-_20230120_145727',
  'pracServe_Player1_FirstName': 'NA',
  'pracServe_Player1_LastName': 'NA',
  'pracServe_Player1_ServiceType': 'FirstServe',
  'pracServe_Player1_ServicePos': 'NA',
  'pracServe_Player1_Ct_1st_NA_IN': 0,
  'pracServe_Player1_Ct_1st_NA_OUT': 0,
  'pracServe_Player1_Ct_1st_Deuce_IN': 0,
  'pracServe_Player1_Ct_1st_Deuce_OUT': 0,
  'pracServe_Player1_Ct_1st_Ad_IN': 0,
  'pracServe_Player1_Ct_1st_Ad_OUT': 0,
  'pracServe_Player1_Ct_2nd_NA_IN': 0,
  'pracServe_Player1_Ct_2nd_NA_OUT': 0,
  'pracServe_Player1_Ct_2nd_Deuce_IN': 0,
  'pracServe_Player1_Ct_2nd_Deuce_OUT': 0,
  'pracServe_Player1_Ct_2nd_Ad_IN': 0,
  'pracServe_Player1_Ct_2nd_Ad_OUT': 0,
  'pracServe_Player2_PlayerID': 'NA_NA_-_20230120_145727',
  'pracServe_Player2_FirstName': 'NA',
  'pracServe_Player2_LastName': 'NA',
  'pracServe_Player2_ServiceType': 'FirstServe',
  'pracServe_Player2_ServicePos': 'NA',
  'pracServe_Player2_Ct_1st_NA_IN': 0,
  'pracServe_Player2_Ct_1st_NA_OUT': 0,
  'pracServe_Player2_Ct_1st_Deuce_IN': 0,
  'pracServe_Player2_Ct_1st_Deuce_OUT': 0,
  'pracServe_Player2_Ct_1st_Ad_IN': 0,
  'pracServe_Player2_Ct_1st_Ad_OUT': 0,
  'pracServe_Player2_Ct_2nd_NA_IN': 0,
  'pracServe_Player2_Ct_2nd_NA_OUT': 0,
  'pracServe_Player2_Ct_2nd_Deuce_IN': 0,
  'pracServe_Player2_Ct_2nd_Deuce_OUT': 0,
  'pracServe_Player2_Ct_2nd_Ad_IN': 0,
  'pracServe_Player2_Ct_2nd_Ad_OUT': 0,
};

var args;

CollectionReference collectionReference =
FirebaseFirestore.instance.collection('PracServe');

class pracServeScreenArgs {
  // int index = -1;
  String index = '-1';
  Map<String, dynamic> mapPracServeData = {};

  pracServeScreenArgs(this.index, this.mapPracServeData);
}

class PracServeScreen extends StatelessWidget with ChangeNotifier {
  static const routeName = '/pracServe_screen';

  var data;
  List? documents;

  updatePracServeData(args) async {
    // int _index = args.index;
    String _index = args.index;
    Map<String, dynamic> _mapPracServeData = args.mapPracServeData;

    CollectionReference collectionReference =
    FirebaseFirestore.instance.collection('PracServe');

    // QuerySnapshot querySnapshot = await collectionReference.get();
    // querySnapshot.docs[_index].reference.update({'pracServeAge': 65});
    // querySnapshot.docs[_index].reference.update(_mapPracServeData);

    collectionReference.doc(_index).set(_mapPracServeData);
  }

  deletePracServeData(_index) async {
    CollectionReference collectionReference =
    await FirebaseFirestore.instance.collection('PracServe');
    collectionReference.doc(_index).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Serve Practice'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              args = pracServeScreenArgs('-1', {});
              Navigator.of(context).pushNamed(
                PracServeEditScreen.routeName,
                arguments: args,
              );
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: StreamBuilder(
        stream: collectionReference
            //.where('pracServe_Owner', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .orderBy('pracServe_yyyymmdd', descending: false)
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
                      doc['pracServe_yyyymmdd'] +
                          ": " +
                          doc['pracServe_Venue'],
                      // style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          // color: Colors.red,
                          child: Text(
                            "Player1: " +
                                doc['pracServe_Player1_PlayerID'],
                            // style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          child: Text(
                            "Player2: " +
                                doc['pracServe_Player2_PlayerID'],
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
                              args = pracServeScreenArgs(doc['pracServe_ID'],
                                  doc.data() as Map<String, dynamic>);
                              // index, doc.data() as Map<String, dynamic>);
                              Navigator.of(context).pushNamed(
                                  PracServeEditScreen.routeName,
                                  arguments: args);
                            },
                            color: Theme.of(context).primaryColor,
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              // print('deletePracServeData ${doc['pracServe_ID']}');
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
                                          //     'deletePracServeData ${doc['pracServe_ID']}');
                                          // deletePracServeData(index);
                                          deletePracServeData(doc['pracServe_ID']);
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
            return Text('Loading Serve Practices...');
          }
        },
      ),
    );
  }
}
