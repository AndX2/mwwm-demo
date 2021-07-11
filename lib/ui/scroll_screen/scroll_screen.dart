import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:relation/relation.dart';
import 'package:mwwm/mwwm.dart';

import 'package:mwwm_demo/ui/scroll_screen/widget/list_item.dart';
import 'package:mwwm_demo/ui/scroll_screen/scroll_screen_wm.dart';
import 'package:mwwm_demo/ui/scroll_screen/widget/list_error_stub.dart';
import 'package:mwwm_demo/ui/scroll_screen/widget/scroll_header_delegate.dart';
import 'package:mwwm_demo/domain/detail.dart';

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
        loadingChild: _buildLoadingView(),
        errorBuilder: (_, e) => _buildErrorView(e),
      ),
    );
  }

  Widget _buildScrollView(List<DetailData>? dataList) {
    final topPadding = MediaQuery.of(context).padding.top;
    return LayoutBuilder(builder: (context, constraints) {
      return CustomScrollView(
        controller: wm.scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: ScrollHeaderDelegate(topPadding, wm.reloadErrorAction),
          ),
          SliverToBoxAdapter(child: SizedBox(height: _scrollTopPadding)),
          if (dataList != null) _buildContentList(dataList),
          SliverToBoxAdapter(
            child: _buildPageLoadItem(),
          ),
          SliverToBoxAdapter(child: SizedBox(height: _scrollBottomPadding)),
        ],
      );
    });
  }

  Widget _buildLoadingView() {
    final topPadding = MediaQuery.of(context).padding.top;
    return LayoutBuilder(builder: (context, constraints) {
      return CustomScrollView(
        controller: wm.scrollController,
        physics: const NeverScrollableScrollPhysics(),
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: ScrollHeaderDelegate(topPadding, wm.reloadErrorAction),
          ),
          SliverToBoxAdapter(child: SizedBox(height: _scrollTopPadding)),
          _buildLoaderList(),
          SliverToBoxAdapter(child: SizedBox(height: _scrollBottomPadding)),
        ],
      );
    });
  }

  Widget _buildErrorView(dynamic error) {
    return LayoutBuilder(builder: (context, constraints) {
      final topPadding = MediaQuery.of(context).padding.top;
      final maxListHeight = constraints.maxHeight - headerMaxExtent - _scrollTopPadding;
      return CustomScrollView(
        controller: wm.scrollController,
        physics: const NeverScrollableScrollPhysics(),
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: ScrollHeaderDelegate(topPadding, wm.reloadErrorAction),
          ),
          SliverToBoxAdapter(child: ListErrorStub(error, maxListHeight, wm.reloadErrorAction)),
        ],
      );
    });
  }

  Widget _buildPageLoadItem() {
    return EntityStateBuilder(
      streamedState: wm.addLoadingState,
      builder: (_, __) => SizedBox(),
      loadingChild: DemoListItem.loading(),
      errorBuilder: (_, error) => DemoListItem.error(error, wm.reloadNextPageAction),
    );
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
