import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import './screens/bookmark_screen.dart';
import './screens/search_screen.dart';
import './screens/torrent_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (ctx) => const HomeScren(),
        BookMarkScreen.routeName: (ctx) => const BookMarkScreen(),
        SearchScreen.routeName: (ctx) => SearchScreen(),
        TorrentScreen.routeName: (ctx) => TorrentScreen(),
      },
    );
  }
}
