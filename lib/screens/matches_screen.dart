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

import '../screens/match_edit_screen.dart';

var _args;

CollectionReference collectionReference =
    FirebaseFirestore.instance.collection('Matches');

class MatchesScreen extends StatefulWidget with ChangeNotifier {
  static const routeName = '/matches_screen';

  var data;
  List? documents;

  @override
  MatchesScreenState createState() => MatchesScreenState();
}

class MatchesScreenState extends State<MatchesScreen> {

  ScrollController _controller = ScrollController();

  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(_scrollListener);//the listener for up and down.
    // super.initState();
  }

  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {//you can do anything here
      });
    }
    if (_controller.offset <= _controller.position.minScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {//you can do anything here
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Match'),
        // actions: <Widget>[
        //   IconButton(
        //     icon: const Icon(Icons.add),
        //     onPressed: () {
        //
        //     },
        //   ),
        // ],
      ),
      drawer: AppDrawer(),
      body: Container(
        width: MediaQuery.of(context).size.width * 1,
        height: MediaQuery.of(context).size.height * 1,
        child: StreamBuilder(
          stream: collectionReference
              .where('matchOwner', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
              .orderBy('matchEntryDate', descending: true)
              .snapshots(),
          builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
            // print('MatchesScreen... docs.length: ' + snapshot.data!.docs.length.toString());
            if (snapshot.hasData) {
            return ListView.builder(
              controller: _controller,//new line
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (_, index) {
                DocumentSnapshot doc = snapshot.data!.docs[index];
                // Map<String, dynamic> doc = snapshot.data!.docs[index] as Map<String, dynamic>;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    onTap: () {
                      _args = matchScreenArgs(
                          doc['matchID'], doc.data() as Map<String, dynamic>);
                      // index, doc.data() as Map<String, dynamic>);
                      Navigator.of(context).pushNamed(
                        MatchEditScreen.routeName,
                        arguments: _args,
                      );
                    },
                    // title: Text('TESTING'),
                    title: Text(
                      doc['matchID'],
                      // style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          // color: Colors.red,
                          child: Text(
                            "Player1: " + doc['matchPlayer1ID'].toString(),
                            // style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          // color: Colors.red,
                          child: Text(
                            "Player2: " + doc['matchPlayer2ID'].toString(),
                            // style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ]),
                    // trailing: Container(
                    //   width: 50,
                    //   child: Row(
                    //     children: <Widget>[
                    //       IconButton(
                    //         icon: Icon(Icons.delete),
                    //         onPressed: () {
                    //           Provider.of<MatchEditScreenState>(context, listen: false).deleteMatchData(index);
                    //         },
                    //         color: Theme.of(context).errorColor,
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ),
                );
              },
            );
            } else {
              return Text('Loading Matches...');
            }
          },
        ),
      ),
    );
  }
}

