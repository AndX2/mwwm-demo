import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:relation/relation.dart';
import 'package:mwwm/mwwm.dart';

import 'package:mwwm_demo/ui/auth_screen/auth_screen_wm.dart';
import 'package:mwwm_demo/ui/widget/shimmer.dart';

class AuthScreen extends CoreMwwmWidget<AuthScreenWidgetModel> {
  AuthScreen({Key? key})
      : super(
          key: key,
          widgetModelBuilder: (context) {
            return AuthScreenWidgetModel(
              context,
              WidgetModelDependencies(),
            );
          },
        );

  @override
  WidgetState<AuthScreen, AuthScreenWidgetModel> createWidgetState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends WidgetState<AuthScreen, AuthScreenWidgetModel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: wm.scaffoldKey,
        appBar: AppBar(
          title: Text('Auth screen'),
        ),
        body: StreamedStateBuilder<bool>(
            streamedState: wm.loadingProceedState,
            builder: (_, isProceed) {
              return Column(
                children: [
                  Spacer(),
                  _buildLogo(),
                  SizedBox(height: 32.0),
                  _buildForm(isProceed),
                  SizedBox(height: 8.0),
                  if (isProceed)
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: ShimmerContainer(
                          child: ShimmerItem(height: 36.0, width: 144.0, radius: 2.0)),
                    ),
                  if (!isProceed)
                    ElevatedButton(onPressed: wm.acceptAction, child: Text('Авторизоваться')),
                  SizedBox(height: 16.0),
                  Spacer(),
                ],
              );
            }));
  }

  Widget _buildLogo() {
    return Align(
      child: Container(
        height: 104.0,
        width: 104.0,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('asset/image/gear_logo.png'), fit: BoxFit.cover),
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }

  Widget _buildForm(bool isProceed) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Form(
        key: wm.formKey,
        child: Column(
          children: [
            SizedBox(
              height: 80.0,
              child: TextFormField(
                controller: wm.loginTextController,
                autofocus: true,
                enabled: !isProceed,
                decoration: InputDecoration(labelText: 'Логин'),
                textInputAction: TextInputAction.next,
                validator: loginValidator,
              ),
            ),
            _buildPassField(isProceed),
          ],
        ),
      ),
    );
  }

  Widget _buildPassField(bool isProceed) {
    return StreamedStateBuilder<bool>(
        streamedState: wm.passObscureState,
        builder: (_, isObscure) {
          return SizedBox(
            height: 80.0,
            child: TextFormField(
              controller: wm.passTextController,
              enabled: !isProceed,
              decoration: InputDecoration(
                labelText: 'Пароль',
                suffixIcon: GestureDetector(
                  child: Icon(isObscure ? Icons.visibility : Icons.visibility_off),
                  onTap: wm.passObscureToggleAction,
                ),
              ),
              obscureText: isObscure,
              obscuringCharacter: '✱',
              textInputAction: TextInputAction.done,
              validator: passValidator,
            ),
          );
        });
  }
}
