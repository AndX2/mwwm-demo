
import 'package:mwwm/mwwm.dart';
import 'package:relation/relation.dart';

import 'package:mwwm_demo/domain/detail.dart';
import 'package:mwwm_demo/service/demo_service.dart';

class DetailScreenWidgetModel extends WidgetModel {
  DetailScreenWidgetModel(WidgetModelDependencies baseDependencies)
      : _service = DemoService.instance,
        super(baseDependencies);

  final DemoService _service;

  /// Данные для экрана
  final contentState = EntityStreamedState<DetailData>()..loading();

  /// Перезагрузить состояние в случае ошибки при загрузке
  final reloadErrorAction = VoidAction();

  @override
  void onLoad() {
    _init();
    super.onLoad();
  }

  @override
  void onBind() {
    subscribe(reloadErrorAction.stream, _reload);
    super.onBind();
  }

  void _init() {
    _service
        .fetchDetailData()
        .then((value) => contentState.content(value))
        .catchError((e) => contentState.error(e));
  }

  void _reload(_) {
    if (contentState.value.isLoading) return;
    contentState.loading();
    _service
        .fetchDetailData()
        .then((value) => contentState.content(value))
        .catchError((e) => contentState.error(e));
  }
}