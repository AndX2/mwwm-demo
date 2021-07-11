import 'package:flutter/material.dart';
import 'package:mwwm/mwwm.dart';
import 'package:relation/relation.dart';

import 'package:mwwm_demo/service/demo_service.dart';

class AuthScreenWidgetModel extends WidgetModel {
  AuthScreenWidgetModel(
    BuildContext context,
    WidgetModelDependencies baseDependencies,
  )   : _navigator = Navigator.of(context),
        _service = DemoService.instance,
        super(baseDependencies);

  final DemoService _service;
  final NavigatorState _navigator;

  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  /// Контроллер ввода логина
  final loginTextController = TextEditingController();

  /// Контроллер ввода пароля
  final passTextController = TextEditingController();

  /// Состояние Скрыт ли пароль
  final passObscureState = StreamedState<bool>(true);

  /// Сменить состояние Скрыт пароль
  final passObscureToggleAction = VoidAction();

  /// Авторизоваться
  final acceptAction = VoidAction();

  /// Идет ли запрос авторизации (busy state)
  final loadingProceedState = StreamedState<bool>(false);

  @override
  void onBind() {
    subscribe(
      passObscureToggleAction.stream,
      (_) => passObscureState.accept(!passObscureState.value),
    );
    subscribe(acceptAction.stream, _onAccept);
    super.onBind();
  }

  void _onAccept(_) async {
    if (loadingProceedState.value) return;
    if (!(formKey.currentState?.validate() ?? false)) return;
    loadingProceedState.accept(true);
    final result = await _service
        .fetchAccessToken(loginTextController.text, passTextController.text)
        .catchError(_showError)
        .whenComplete(() => loadingProceedState.accept(false));
    if (result ?? false) {
      _navigateToMain();
    } else {}
  }

  Future<bool?> _showError(dynamic error) async {
    final snackBar = SnackBar(content: Text(error.toString()), backgroundColor: Colors.red);
    scaffoldKey.currentState?.showSnackBar(snackBar);
  }

  void _navigateToMain() {
    // _navigator.pushReplacement(...);
  }
}

String? loginValidator(String? value) {
  if (value == null || value.length <= 2) return 'логин дб не менее 2 символов';
  return null;
}

String? passValidator(String? value) {
  if (value == null || value.length <= 3) return 'пароль дб не менее 3 символов';
  return null;
}
