import 'package:flutter/material.dart';
import 'home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:softwaretutorials/presentation/routes/bloc_observer.dart';

import 'package:bloc/bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences sharedPreferences = await SharedPreferences.getInstance(); // for storing role and token
  BlocOverrides.runZoned(
   () {
     runApp(Home(sharedPreferences: sharedPreferences));
   },
   blocObserver: NavigationBlocObserver(),
 );
}
