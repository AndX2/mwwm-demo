import 'package:flutter/material.dart';
import 'package:mwwm_demo/auth_screen/auth_screen.dart';
import 'package:mwwm_demo/detail_screen/detail_screen.dart';
import 'package:mwwm_demo/scroll_screen/scroll_screen.dart';

final rootScaffoldKey = GlobalKey<ScaffoldState>();

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ScreenRouteKey _currentScreen = ScreenRouteKey.details;
  @override
  Widget build(BuildContext context) {
    final pages = <ScreenRouteKey, Widget>{
      ScreenRouteKey.details: DetailScreen(),
      ScreenRouteKey.auth: AuthScreen(),
      ScreenRouteKey.scroll: ScrollScreen(),
    };
    return Scaffold(
      key: rootScaffoldKey,
      body: Stack(
        children: pages.entries.map<Widget>((e) => _buildOffstagePage(e)).toList(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: ScreenRouteKey.values.indexOf(_currentScreen),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.details), label: 'details'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'auth'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'scroll'),
        ],
        onTap: (index) {
          setState(() => _currentScreen = ScreenRouteKey.values[index]);
        },
      ),
    );
  }

  Widget _buildOffstagePage(MapEntry<ScreenRouteKey, Widget> e) =>
      Offstage(offstage: _currentScreen != e.key, child: e.value);
}

enum ScreenRouteKey {
  details,
  auth,
  scroll,
}
