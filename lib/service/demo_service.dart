import 'package:mwwm_demo/domain/detail.dart';

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
    return DetailData(
      'MWWM',
      '''
About 
MVVM-inspired lightweight architectural framework for Flutter apps made with respect to Clean Architecture.

Currently supported features 
Complete separation of the application's codebase into independent layers: UI, presentation and business logic;
Keeps widget tree clear: the main building block is just an extended version of StatefulWidget;
Built-in mechanisms for handling asynchronous operations;
The ability to easily implement the default error handling strategy;
An event-like mechanism that helps keep the business logic well structured and testable.
      ''',
      'asset/image/gear_logo.png',
    );
  }

  Future<bool?> fetchAccessToken(String login, String pass) async {
    await Future.delayed(Duration(seconds: 5));
    if (isProduceException)
      throw Exception(
          'Исключение спродуцировано установкой параметра DemoService.isProduceException');
    return true;
  }
}
