
import 'package:flutter/material.dart';
import 'package:mwwm_demo/domain/detail.dart';
import 'package:mwwm_demo/ui/widget/shimmer.dart';

/// Элемент списка для [ScrollScreen]
abstract class DemoListItem extends StatelessWidget {
  const DemoListItem({Key? key}) : super(key: key);

  factory DemoListItem.content(DetailData data, {Key? key}) =>
      DemoListItemContent(data: data, key: key);

  factory DemoListItem.loading({Key? key}) => DemoListItemLoading(key: key);

  factory DemoListItem.error(dynamic error, Function() onReload, {Key? key}) =>
      DemoListItemError(error, onReload, key: key);
}

class DemoListItemContent extends DemoListItem {
  const DemoListItemContent({
    required this.data,
    Key? key,
  }) : super(key: key);

  final DetailData data;

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
                  image: AssetImage(data.imgPath),
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
                  data.title,
                  maxLines: 1,
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4.0),
                Text(
                  data.description,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
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
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset('asset/image/error.png', height: 72.0, width: 72.0),
          const SizedBox(width: 16.0),
          Expanded(
            child: Text(error.toString(), overflow: TextOverflow.ellipsis, maxLines: 4),
          ),
          const SizedBox(width: 16.0),
          ElevatedButton(
            onPressed: onReload,
            child: Column(
              children: [
                Icon(Icons.refresh),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
