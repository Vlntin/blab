import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:parla_italiano/handler/startLoader.dart';
import 'package:parla_italiano/handler/userHandler.dart';
import 'package:parla_italiano/dbModels/appUser.dart';
import 'package:parla_italiano/screens/oneVsOneScreen.dart';

import 'screens/ugoScreen.dart';
import 'screen_one.dart';
import 'screens/start_screen.dart';
import 'screens/vocabularyListScreen.dart';
import 'screens/vocabularyDetailsScreen.dart';
import 'screens/signInScreen.dart';
import 'screens/testScreen.dart';
import 'package:parla_italiano/globals/globalData.dart' as uD;
import 'package:parla_italiano/routes.dart' as routes;

bool canTestBeLeaved = false;

final _router = GoRouter(
  redirect: (BuildContext context, GoRouterState state) async {// your logic to check if user is authenticated
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    if (user == null){
      return '/';
    } else {
      AppUser? appUser = await UserHandler().findUserByID(user!.uid);
      StartLoader().loadData(appUser!);
      return null;
    }
   },
  routes: [
    GoRoute(
      path: '/ugoScreen', 
      builder: (context, state) => const HomeScreen()
    ),
    GoRoute(
      path: '/', 
      builder: (context, state) => const SignInScreen(),

    ),
    GoRoute(
      path: '/startScreen',
      builder: (context, state) => const StartScreen(),
    ),
    GoRoute(
      path: '/vocabularyListsScreen', 
      builder: (context, state) => const VocabularyListsScreen(),
    ),
    GoRoute(
      path: '/oneVsOneScreen', 
      builder: (context, state) => const OneVSOneScreen(),
    ),
    GoRoute(
      path: '/vocabularies_test', 
      builder: (context, state) => VocabularyTestScreen(),     
      onExit: (BuildContext context) async {
        if (routes.canTestBeLeaved){
          routes.canTestBeLeaved = false;
          return true;
        } else {
          return await _buildLeaveDialog(context);
        }
      }
    ),   
    GoRoute(
      path: '/signInScreen', 
      builder: (context, state) => const SignInScreen(),

    ),
    GoRoute(
      path: '/screen_one/:id/:tablename', 
      name:'screen_one', 
      builder: (context, state) => ScreenOne(id: state.pathParameters['id'], tableName: state.pathParameters['tablename']),
    ),
    GoRoute(
      path: '/vocabularies_details/:tablename/:table_id', 
      name:'vocabularies_details', 
      builder: (context, state) => VocabularyDetailsScreen(tablename: state.pathParameters['tablename'], table_id: state.pathParameters['table_id']),
    ),
  ]
);

GoRouter createRouter() {
  return _router;
}

_buildLeaveDialog(BuildContext context) async {
    var response = await showDialog<bool>(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Möchtest du diese Seite verlassen?'),
              actions: <Widget>[
                TextButton(
                  child: const Text('nein, weiterspielen'),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                TextButton(
                  child: const Text('ja, verlassen'),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            );
          },
        );
    return response ?? false;
}