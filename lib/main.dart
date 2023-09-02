import 'dart:async';
import 'dart:ffi';
import 'package:brie_tennis/screens/new_player_screen.dart';

import '../firebase_options.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart'; // Import the firebase_app_check plugin

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import './config/application_state.dart';
import './config/authentication.dart';
import './config/custom_styles.dart';
import './config/palette.dart';

// import './screens/main_screen.dart';
import './screens/players_screen.dart';
import './screens/player_edit_screen.dart';
import './screens/matches_screen.dart';
import './screens/match_edit_screen.dart';
import './screens/point_edit_screen.dart';
import './screens/points_screen.dart';
import './screens/score_edit_screen.dart';
import './screens/stat_screen.dart';
import './screens/debug_screen.dart';
import './screens/pracServe_screen.dart';
import './screens/pracServe_edit_screen.dart';
import './screens/new_player_screen.dart';

import './widgets/app_drawer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // await FirebaseAppCheck.instance.activate();
  } on FirebaseException catch (e) {
    if (e.code == 'duplicate-app') {
// you can choose not to do anything here or either
// In a case where you are assigning the initializer instance to a FirebaseApp variable, // do something like this:
//
//   app = Firebase.app('SecondaryApp');
//
    } else {
      throw e;
    }
  } catch (e) {
    rethrow;
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ThemeData theme = ThemeData();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: ApplicationState(),
        ),
        ChangeNotifierProvider.value(
          value: PlayersScreen(),
        ),
        ChangeNotifierProvider.value(
          value: PlayerEditScreen(),
        ),
        ChangeNotifierProvider.value(
          value: MatchesScreen(),
        ),
        ChangeNotifierProvider.value(
          value: MatchEditScreen(),
        ),
        ChangeNotifierProvider.value(
          value: PointEditScreen(),
        ),
        ChangeNotifierProvider.value(
          value: PointsScreen(),
        ),
        ChangeNotifierProvider.value(
          value: ScoreEditScreen(),
        ),
        ChangeNotifierProvider.value(
          value: StatScreen(),
        ),
        ChangeNotifierProvider.value(
          value: DebugScreen(),
        ),
        ChangeNotifierProvider.value(
          value: PracServeScreen(),
        ),
        ChangeNotifierProvider.value(
          value: PracServeEditScreen(),
        ),
        ChangeNotifierProvider.value(
          value: NewPlayerScreen(),
        ),
      ],
      child: MaterialApp(
          title: 'BrieTennis by BrieSports',
          theme: ThemeData(
            primarySwatch: Palette.umBlue,
            hintColor: Palette.umMaize, //accentColor
          ),
          // theme: theme.copyWith(
          //   colorScheme: theme.colorScheme
          //       .copyWith(primary: Palette.umBlue, secondary: Palette.umMaize),
          // ),
          home: MainScreen(),
          routes: {
            PlayersScreen.routeName: (ctx) => PlayersScreen(),
            PlayerEditScreen.routeName: (ctx) => PlayerEditScreen(),
            MatchesScreen.routeName: (ctx) => MatchesScreen(),
            MatchEditScreen.routeName: (ctx) => MatchEditScreen(),
            PointEditScreen.routeName: (ctx) => PointEditScreen(),
            PointsScreen.routeName: (ctx) => PointsScreen(),
            ScoreEditScreen.routeName: (ctx) => ScoreEditScreen(),
            StatScreen.routeName: (ctx) => StatScreen(),
            DebugScreen.routeName: (ctx) => DebugScreen(),
            PracServeScreen.routeName: (ctx) => PracServeScreen(),
            PracServeEditScreen.routeName: (ctx) => PracServeEditScreen(),
            NewPlayerScreen.routeName: (ctx) => NewPlayerScreen(),
          }),
    );
  }
}

class MainScreen extends StatelessWidget {
  MainScreen({Key? key}) : super(key: key);

  var _args;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BrieTennis'),
      ),
      drawer: AppDrawer(),
      body: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Image.asset('assets/wilson_usopen_tennis_ball.jpg'),
          // Image.asset('assets/cc_bama_bw_summer2021.jpg'),
          const SizedBox(height: 8),
          Consumer<ApplicationState>(
            builder: (context, appState, _) => Authentication(
              email: appState.email,
              loginState: appState.loginState,
              startLoginFlow: appState.startLoginFlow,
              verifyEmail: appState.verifyEmail,
              signInWithEmailAndPassword: appState.signInWithEmailAndPassword,
              cancelRegistration: appState.cancelRegistration,
              registerAccount: appState.registerAccount,
              signOut: appState.signOut,
            ),
          ),
          // const SizedBox(height: 8),
          const Divider(
            height: 8,
            thickness: 1,
            indent: 8,
            endIndent: 8,
            color: Colors.grey,
          ),

          Column(
            children: [
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * pctHeight_PtAttrib / 2,
              ),
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * pctHeight_PtAttrib,
                // margin: const EdgeInsets.all(10.0),
                child: SizedBox(
                  width: double.infinity, // <-- match_parent
                  // height: double.infinity, // <-- match-parent
                  child: TextButton(
                      onPressed: () async {
                        // _args = matchScreenArgs(-1, {});
                        _args = playerScreenArgs('-1', {});
                        Navigator.of(context).pushNamed(
                          NewPlayerScreen.routeName,
                          arguments: _args,
                        );
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Palette.umMaize),
                        // padding: MaterialStateProperty.all<EdgeInsets>(
                        //     // EdgeInsets.fromLTRB(10, 10, 10, 10)),
                        //     EdgeInsets.all(10)),
                        // shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        //     borderRadius: BorderRadius.circular(10.0))),
                      ),
                      child: const Text('NEW MATCH',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),),
                    ),
                ),
              ),
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * pctHeight_PtAttrib / 10,
              ),
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * pctHeight_PtAttrib,
                // margin: const EdgeInsets.all(10.0),
                child: SizedBox(
                  width: double.infinity, // <-- match_parent
                  // height: double.infinity, // <-- match-parent
                  child: TextButton(
                    onPressed: () async {
                      // _args = matchScreenArgs(-1, {});
                      Navigator.of(context).pushNamed(
                        MatchesScreen.routeName,
                        // arguments: _args,
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all(Palette.umMaize),
                      // padding: MaterialStateProperty.all<EdgeInsets>(
                      //     // EdgeInsets.fromLTRB(10, 10, 10, 10)),
                      //     EdgeInsets.all(10)),
                      // shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      //     borderRadius: BorderRadius.circular(10.0))),
                    ),
                    child: const Text('EXISTING MATCH',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * pctHeight_PtAttrib / 5,
              ),
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * pctHeight_PtAttrib,
                // margin: const EdgeInsets.all(10.0),
                child: SizedBox(
                  width: double.infinity, // <-- match_parent
                  // height: double.infinity, // <-- match-parent
                  child: TextButton(
                    onPressed: () async {
                      _args = pracServeScreenArgs('-1', {});
                      Navigator.of(context).pushNamed(
                        PracServeEditScreen.routeName,
                        arguments: _args,
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all(Palette.tiffanyBlue),
                      // padding: MaterialStateProperty.all<EdgeInsets>(
                      //     // EdgeInsets.fromLTRB(10, 10, 10, 10)),
                      //     EdgeInsets.all(10)),
                      // shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      //     borderRadius: BorderRadius.circular(10.0))),
                    ),
                    child: const Text('NEW SERVE PRACTICE',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * pctHeight_PtAttrib / 10,
              ),
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * pctHeight_PtAttrib,
                // margin: const EdgeInsets.all(10.0),
                child: SizedBox(
                  width: double.infinity, // <-- match_parent
                  // height: double.infinity, // <-- match-parent
                  child: TextButton(
                    onPressed: () async {
                      // _args = matchScreenArgs(-1, {});
                      Navigator.of(context).pushNamed(
                        PracServeScreen.routeName,
                        // arguments: _args,
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all(Palette.tiffanyBlue),
                      // padding: MaterialStateProperty.all<EdgeInsets>(
                      //     // EdgeInsets.fromLTRB(10, 10, 10, 10)),
                      //     EdgeInsets.all(10)),
                      // shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      //     borderRadius: BorderRadius.circular(10.0))),
                    ),
                    child: const Text('EDIT SERVE PRACTICE',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),),
                  ),
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }
}
