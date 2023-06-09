import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spacenews/datas/riverpodVar.dart';
import 'router.dart';
import 'datas/database_functions.dart';
import 'datas/database_helper.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

bool TruefalseBool = true;
var truefalse = true;
var a;
final dbHelper = DatabaseHelper();
var mydbfunctions = dbfunctions();
var next;
String link =
    'https://api.spaceflightnewsapi.net/v4/articles/?format=json&has_event=true&has_launch=true&limit=20';

final haberlerProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  a = await _getArticles(link);

  return a;
});

final haberlernextProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  a = await _getArticles(a != null ? a['next'] : link);

  return a;
});
Future<Map<String, dynamic>> _getArticles(String link) async {
  final response = await http.get(Uri.parse(link));
  final data = jsonDecode(response.body);
  return data;
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  a = await _getArticles(link);
  // await dbHelper.init();
  next = await _getArticles(a['next']);
  await Hive.initFlutter();
  var box = await Hive.openBox('testBox');

  if (box.isEmpty) {
    bool forfirstput = true;
    box.put('DisclaimerTFHive', forfirstput);
  }

  TruefalseBool = box.get('DisclaimerTFHive');

  runApp(ProviderScope(child: MyApp()));
}

extension StringExtension on String {
  bool toBoolean() {
    return (this.toLowerCase() == "true" || this.toLowerCase() == "1")
        ? true
        : (this.toLowerCase() == "false" || this.toLowerCase() == "0"
            ? false
            : a);
  }
}

final GoRouter _router = Rotalar();

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var nextdatalink = a["next"];
    var previousdatalink = a["previous"];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(NextLinkProvider.notifier).state = nextdatalink;
      ref.read(PreviousLinkProvider.notifier).state = previousdatalink;
      ref.read(DisclaimerTFProvider.notifier).state = TruefalseBool;
    });

    return MaterialApp.router(
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
      title: 'SpaceNews',
      theme: ThemeData(
          appBarTheme: AppBarTheme(color: Colors.black),
          bottomAppBarTheme: BottomAppBarTheme(color: Colors.black)),
    );
  }
}
