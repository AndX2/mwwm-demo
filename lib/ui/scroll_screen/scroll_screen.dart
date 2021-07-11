import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mwwm_demo/ui/scroll_screen/widget/list_error_stub.dart';
import 'package:mwwm_demo/ui/scroll_screen/widget/scroll_header_delegate.dart';
import 'package:relation/relation.dart';
import 'package:mwwm/mwwm.dart';

import 'package:mwwm_demo/service/demo_service.dart';
import 'package:mwwm_demo/domain/detail.dart';
import 'package:mwwm_demo/ui/widget/shimmer.dart';

const _scrollTopPadding = 16.0;
const _scrollBottomPadding = 16.0;

class ScrollScreen extends CoreMwwmWidget<ScrollScreenWidgetModel> {
  ScrollScreen({Key? key})
      : super(
          key: key,
          widgetModelBuilder: (context) => ScrollScreenWidgetModel(WidgetModelDependencies()),
        );

  @override
  WidgetState<ScrollScreen, ScrollScreenWidgetModel> createWidgetState() {
    return _ScrollScreenState();
  }
}

class _ScrollScreenState extends WidgetState<ScrollScreen, ScrollScreenWidgetModel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: EntityStateBuilder<List<DetailData>?>(
        streamedState: wm.dataListState,
        builder: (_, dataList) => _buildScrollView(dataList),
        loadingChild: _buildScrollView(null),
        errorBuilder: (_, e) => _buildScrollView(null, error: e),
      ),
    );
  }

  Widget _buildScrollView(
    List<DetailData>? dataList, {
    dynamic error,
  }) {
    return LayoutBuilder(builder: (context, constraints) {
      final topPadding = MediaQuery.of(context).padding.top;
      final maxListHeight = constraints.maxHeight - headerMaxExtent - _scrollTopPadding;
      return CustomScrollView(
        physics: (dataList != null)
            ? const BouncingScrollPhysics()
            : const NeverScrollableScrollPhysics(),
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: ScrollHeaderDelegate(topPadding),
          ),
          SliverToBoxAdapter(child: SizedBox(height: _scrollTopPadding)),
          if (dataList != null) _buildContentList(dataList),
          if (dataList == null && error == null) _buildLoaderList(),
          if (error != null)
            SliverToBoxAdapter(child: ListErrorStub(error, maxListHeight, wm.reloadErrorAction)),
          SliverToBoxAdapter(child: SizedBox(height: _scrollBottomPadding)),
        ],
      );
    });
  }

  SliverList _buildContentList(List<DetailData> dataList) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
          (_, index) => DemoListItem.content(
                dataList[index],
              ),
          childCount: dataList.length),
    );
  }

  SliverList _buildLoaderList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate((_, index) => DemoListItem.loading(), childCount: 3),
    );
  }
}

abstract class DemoListItem extends StatelessWidget {
  const DemoListItem({Key? key}) : super(key: key);

  factory DemoListItem.content(DetailData? data, {Key? key}) =>
      DemoListItemContent(data: data, key: key);

  factory DemoListItem.loading({Key? key}) => DemoListItemLoading(key: key);

  factory DemoListItem.error(dynamic error, Function() onReload, {Key? key}) =>
      DemoListItemError(error, onReload, key: key);
}

class DemoListItemContent extends DemoListItem {
  const DemoListItemContent({
    this.data,
    Key? key,
  }) : super(key: key);

  final DetailData? data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 72.0,
            width: 72.0,
            decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('asset/image/gear_logo.png'),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(8.0)),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'MWWM',
                  maxLines: 1,
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4.0),
                Text(
                  'MWWM ',
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class DemoListItemLoading extends DemoListItem {
  const DemoListItemLoading({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShimmerContainer(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShimmerItem(width: 72.0, height: 72.0),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerItem(width: 96.0, height: 14.0),
                  SizedBox(height: 8.0),
                  ShimmerItem(width: 240.0, height: 10.0),
                  SizedBox(height: 4.0),
                  ShimmerItem(width: 184.0, height: 10.0),
                  SizedBox(height: 4.0),
                  ShimmerItem(width: 120.0, height: 10.0),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class DemoListItemError extends DemoListItem {
  const DemoListItemError(
    this.error,
    this.onReload, {
    Key? key,
  }) : super(key: key);

  final dynamic error;
  final Function() onReload;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}


class ScrollScreenWidgetModel extends WidgetModel {
  ScrollScreenWidgetModel(WidgetModelDependencies baseDependencies)
      : _service = DemoService.instance,
        super(baseDependencies);

  final DemoService _service;

  /// Данные для экрана
  final dataListState = EntityStreamedState<List<DetailData>>()
    // ..error(Exception('sakjbfjkabwefbawebfkabefibebf'));
    ..content([]);

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

  void _init() {}

  void _reload(_) {}
}
