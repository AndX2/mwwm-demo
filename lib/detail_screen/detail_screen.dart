import 'package:flutter/material.dart';
import 'package:mwwm/mwwm.dart';
import 'package:relation/relation.dart';

class DetailScreen extends CoreMwwmWidget<DetailScreenWidgetModel> {
  DetailScreen({Key? key})
      : super(
          key: key,
          widgetModelBuilder: (context) => DetailScreenWidgetModel(WidgetModelDependencies()),
        );

  @override
  WidgetState<CoreMwwmWidget<DetailScreenWidgetModel>, DetailScreenWidgetModel>
      createWidgetState() {
    return _DetailScreenState();
  }
}

class _DetailScreenState extends WidgetState<DetailScreen, DetailScreenWidgetModel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detail screen')),
      body: Center(
        child: EntityStateBuilder<String>(
          streamedState: wm.contentState,
          builder: (_, data) => Text(data),
          loadingChild: Text('loading...'),
          errorBuilder: (_, e) => Text('error: ${e.toString()}'),
        ),
      ),
    );
  }
}

class DetailScreenWidgetModel extends WidgetModel {
  DetailScreenWidgetModel(WidgetModelDependencies baseDependencies) : super(baseDependencies);

  final contentState = EntityStreamedState<String>()..loading();

  final reloadErrorAction = VoidAction();

  @override
  void onLoad() {
    // TODO: implement onLoad
    super.onLoad();
  }

  @override
  void onBind() {
    super.onBind();
    _setContent();
  }

  Future<void> _setContent() async {
    await Future.delayed(Duration(seconds: 3));
    contentState.content('data');
    await Future.delayed(Duration(seconds: 5));
    contentState.error(Exception('Stub exception'));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
