import 'package:flutter/material.dart';

import '../config/palette.dart';

import '../screens/players_screen.dart';
import '../screens/match_edit_screen.dart';
import '../screens/matches_screen.dart';
import '../screens/pracServe_edit_screen.dart';
import '../screens/pracServe_screen.dart';

var _args;

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Shortcuts'),
            automaticallyImplyLeading: false,
          ),
          // Divider(),
          Container(
            decoration: BoxDecoration(color: Palette.umMaize),
            child: ListTile(
              leading: Icon(Icons.sports_tennis),
              // title: Text('NEW MATCH'),
              title: Text('New Match',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              onTap: () {
                // _args = matchScreenArgs(-1, {});
                _args = matchScreenArgs('-1', {});
                Navigator.of(context).pushNamed(
                  MatchEditScreen.routeName,
                  arguments: _args,
                );
              },
            ),
          ),
          Divider(),
          // Divider(),
          Container(
            decoration: BoxDecoration(color: Palette.tiffanyBlue),
            child: ListTile(
              leading: Icon(Icons.sports_tennis),
              title: Text('New Serve Practice',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              onTap: () {
                _args = pracServeScreenArgs('-1', {});
                Navigator.of(context).pushNamed(
                  PracServeEditScreen.routeName,
                  arguments: _args,
                );
              },
            ),
          ),
          Divider(),
          // Divider(),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Main Page'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.people_sharp),
            title: Text('Edit Players'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(PlayersScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            // leading: Icon(Icons.sports_tennis),
            leading: Icon(Icons.auto_awesome_outlined),
            title: Text('Edit Matches'),
            onTap: () {
              // _args = matchScreenArgs(-1,{});
              Navigator.of(context).pushNamed(
                MatchesScreen.routeName,
                // arguments: _args,
              );
            },
          ),
          Divider(),
          ListTile(
            // leading: Icon(Icons.sports_tennis),
            leading: Icon(Icons.auto_awesome_outlined),
            title: Text('Edit Serve Practices'),
            onTap: () {
              // _args = matchScreenArgs(-1,{});
              Navigator.of(context).pushNamed(
                PracServeScreen.routeName,
                // arguments: _args,
              );
            },
          ),
          Divider(),
        ],
      ),
    );
  }
}
