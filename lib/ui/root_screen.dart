import 'package:flutter/material.dart';
import 'package:mwwm/mwwm.dart';
import 'package:relation/relation.dart';

import 'package:mwwm_demo/ui/auth_screen/auth_screen.dart';
import 'package:mwwm_demo/ui/detail_screen/detail_screen.dart';
import 'package:mwwm_demo/ui/scroll_screen/scroll_screen.dart';
import 'package:mwwm_demo/service/demo_service.dart';

final rootScaffoldKey = GlobalKey<ScaffoldState>();

enum ScreenRouteKey {
  details,
  auth,
  scroll,
}

class RootScreen extends CoreMwwmWidget<RootScreenModel> {
  RootScreen({Key? key})
      : super(
          key: key,
          widgetModelBuilder: (context) => RootScreenModel(WidgetModelDependencies()),
        );

  @override
  WidgetState<RootScreen, RootScreenModel> createWidgetState() => _RootScreenState();
}

class _RootScreenState extends WidgetState<RootScreen, RootScreenModel> {
  ScreenRouteKey _currentScreen = ScreenRouteKey.details;
  late final Map<ScreenRouteKey, Widget> pages;

  @override
  void initState() {
    pages = <ScreenRouteKey, Widget>{
      ScreenRouteKey.details: DetailScreen(),
      ScreenRouteKey.auth: AuthScreen(),
      ScreenRouteKey.scroll: ScrollScreen(),
    };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: rootScaffoldKey,
      endDrawer: _buildSettingsDrawer(),
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

  Widget _buildSettingsDrawer() {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 192.0),
            ListTile(
              title: Text('Выбросить ошибку в репозитории'),
              trailing: StreamedStateBuilder<bool>(
                streamedState: wm.demoServerProduceExceptionState,
                builder: (_, isProducedException) {
                  return Switch(
                    value: isProducedException,
                    onChanged: wm.demoServerProduceExceptionAction,
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildOffstagePage(MapEntry<ScreenRouteKey, Widget> e) =>
      Offstage(offstage: _currentScreen != e.key, child: e.value);
}

class RootScreenModel extends WidgetModel {
  RootScreenModel(WidgetModelDependencies baseDependencies)
      : _service = DemoService.instance,
        super(baseDependencies);

  final DemoService _service;

  final demoServerProduceExceptionState = StreamedState<bool>(false);
  final demoServerProduceExceptionAction = StreamedAction<bool>();

  @override
  void onLoad() {
    demoServerProduceExceptionState.accept(_service.isProduceException);
    super.onLoad();
  }

  @override
  void onBind() {
    subscribe<bool>(demoServerProduceExceptionAction.stream, _setProduceException);
    super.onBind();
  }

  void _setProduceException(value) {
    _service.produceException(value);
    demoServerProduceExceptionState.accept(_service.isProduceException);
  }
}
