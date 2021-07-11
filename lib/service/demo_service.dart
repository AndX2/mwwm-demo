import 'dart:math';

import 'package:mwwm_demo/domain/detail.dart';
import 'package:mwwm_demo/domain/page_filter.dart';
import 'package:mwwm_demo/service/data_src.dart';


/// Сервис для демонстрационных данных
class DemoService {
  static final _instance = DemoService._();

  static DemoService get instance => _instance;

  DemoService._();

  bool _isNeedProduceException = false;

  bool get isProduceException => _isNeedProduceException;

  void produceException(bool value) => _isNeedProduceException = value;

  Future<DetailData> fetchDetailData() async {
    await Future.delayed(Duration(seconds: 5));
    if (_isNeedProduceException) {
      throw Exception(
          'Исключение спродуцировано установкой параметра DemoService.isProduceException');
    }
    return detailDataSrc[0];
  }

  Future<bool?> fetchAccessToken(String login, String pass) async {
    await Future.delayed(Duration(seconds: 5));
    if (isProduceException)
      throw Exception(
          'Исключение спродуцировано установкой параметра DemoService.isProduceException');
    return true;
  }

  Future<List<DetailData>> fetchDetailDataList({PageFilter? pageFilter}) async {
    await Future.delayed(Duration(seconds: 5));
    if (_isNeedProduceException) {
      throw Exception(
          'Исключение спродуцировано установкой параметра DemoService.isProduceException');
    }
    if(pageFilter == null) pageFilter = PageFilter();
    final rndDelegate = Random();
    final result = List<DetailData>.generate(
      pageFilter.limit,
      (index) {
        final rndSrcItem = detailDataSrc[rndDelegate.nextInt(detailDataSrc.length)];
        return rndSrcItem.copyWith(title: '${rndSrcItem.title} # ${pageFilter!.offset + index}');
      },
    );
    return result;
  }
}
