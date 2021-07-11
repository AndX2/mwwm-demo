import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:relation/relation.dart';
import 'package:mwwm/mwwm.dart';

import 'package:mwwm_demo/ui/detail_screen/detail_screen_wm.dart';
import 'package:mwwm_demo/domain/detail.dart';
import 'package:mwwm_demo/ui/widget/shimmer.dart';

class DetailScreen extends CoreMwwmWidget<DetailScreenWidgetModel> {
  DetailScreen({Key? key})
      : super(
          key: key,
          widgetModelBuilder: (context) => DetailScreenWidgetModel(WidgetModelDependencies()),
        );

  @override
  WidgetState<DetailScreen, DetailScreenWidgetModel> createWidgetState() {
    return _DetailScreenState();
  }
}

class _DetailScreenState extends WidgetState<DetailScreen, DetailScreenWidgetModel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail screen'),
        actions: [
          CupertinoButton(
            child: Icon(Icons.refresh, color: Colors.white),
            onPressed: wm.reloadErrorAction,
          ),
        ],
      ),
      body: EntityStateBuilder<DetailData>(
        streamedState: wm.contentState,
        builder: (_, data) => _DetailContent(data),
        loadingChild: _DetailLoadingStub(),
        errorBuilder: (_, e) => _DetailErrorStub(wm.reloadErrorAction, e),
      ),
    );
  }
}


class _DetailLoadingStub extends StatelessWidget {
  const _DetailLoadingStub({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 128.0),
        child: ShimmerContainer(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ShimmerItem(height: 104.0, width: 104.0),
                SizedBox(height: 48.0),
                ShimmerItem(height: 16.0, width: 96.0),
                SizedBox(height: 16.0),
                ShimmerItem(height: 8.0, width: double.infinity),
                SizedBox(height: 6.0),
                ShimmerItem(height: 8.0, width: double.infinity),
                SizedBox(height: 6.0),
                ShimmerItem(height: 10.0, width: double.infinity),
                SizedBox(height: 8.0),
                ShimmerItem(height: 10.0, width: double.infinity),
                SizedBox(height: 6.0),
                ShimmerItem(height: 18.0, width: 124.0),
                SizedBox(height: 6.0),
                ShimmerItem(height: 8.0, width: 88.0),
                SizedBox(height: 24.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DetailContent extends StatelessWidget {
  const _DetailContent(this.data, {Key? key}) : super(key: key);

  final DetailData data;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 128.0),
            Align(
              child: Container(
                height: 104.0,
                width: 104.0,
                decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage(data.imgPath), fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            SizedBox(height: 48.0),
            Text(data.title, style: TextStyle(fontSize: 18.0)),
            SizedBox(height: 16.0),
            Text(data.description),
            SizedBox(height: 24.0),
          ],
        ),
      ),
    );
  }
}

class _DetailErrorStub extends StatelessWidget {
  const _DetailErrorStub(
    this.onReload,
    this.error, {
    Key? key,
  }) : super(key: key);

  final VoidCallback onReload;
  final dynamic error;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 128.0),
            Align(
              child: Container(
                height: 104.0,
                width: 104.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('asset/image/error.png'), fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            SizedBox(height: 48.0),
            Text(
              error.toString(),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 48.0),
            ElevatedButton(onPressed: onReload, child: Text('Попробовать еще раз')),
            SizedBox(height: 24.0),
          ],
        ),
      ),
    );
  }
}
