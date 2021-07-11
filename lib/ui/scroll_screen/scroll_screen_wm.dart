import 'package:flutter/material.dart';
import 'package:mwwm/mwwm.dart';
import 'package:relation/relation.dart';

import 'package:mwwm_demo/domain/detail.dart';
import 'package:mwwm_demo/domain/page_filter.dart';
import 'package:mwwm_demo/service/demo_service.dart';

/// WM для ScrollScreen
class ScrollScreenWidgetModel extends WidgetModel {
  ScrollScreenWidgetModel(WidgetModelDependencies baseDependencies)
      : _service = DemoService.instance,
        super(baseDependencies);

  final DemoService _service;

  final scrollController = ScrollController();

  /// Данные для экрана
  final dataListState = EntityStreamedState<List<DetailData>>()..loading();

  /// Перезагрузить состояние в случае ошибки при загрузке
  final reloadErrorAction = VoidAction();

  /// Состояние фильтра пагинации текущей страницы
  final pageFilterState = StreamedState(PageFilter());

  /// Состояние дозагрузки следующей страницы списка
  final addLoadingState = EntityStreamedState<Object>();

  /// Повторно загрузить следующую страницу списка, если произошла ошибка
  final reloadNextPageAction = VoidAction();

  @override
  void onLoad() {
    _init();
    super.onLoad();
  }

  @override
  void onBind() {
    subscribe(reloadErrorAction.stream, _reload);
    scrollController.addListener(_onScroll);
    subscribe(reloadNextPageAction.stream, (_) => _loadNextPage());
    super.onBind();
  }

  @override
  void dispose() {
    scrollController.removeListener(_onScroll);
    super.dispose();
  }

  void _init() {
    _service
        .fetchDetailDataList(pageFilter: pageFilterState.value)
        .then(dataListState.content)
        .catchError((e) => dataListState.error(e));
  }

  void _onScroll() {
    final position = scrollController.position;
    if (position.pixels < position.maxScrollExtent) return;
    if (dataListState.value.isLoading) return;
    if (dataListState.value.hasError) return;
    if (addLoadingState.value.isLoading) return;
    if (addLoadingState.value.hasError) return;
    _loadNextPage();
  }

  void _loadNextPage() {
    addLoadingState.loading();
    final nextPageFilter = pageFilterState.value.nextPage;
    _service.fetchDetailDataList(pageFilter: nextPageFilter).then(
      (list) {
        (dataListState.value.data ?? []).addAll(list);
        dataListState.content(dataListState.value.data!);
        pageFilterState.accept(nextPageFilter);
        addLoadingState.content(Object());
      },
    ).catchError(
      (e) {
        addLoadingState.error(e);
      },
    );
  }

  void _reload(_) {
    pageFilterState.accept(PageFilter());
    dataListState.loading();
    addLoadingState.content(Object());
    _init();
  }
}
