import 'dart:async';

import 'package:vendor/LoginScreen/CPValidator.dart';
import 'package:vendor/LoginScreen/LoginValidator.dart';
import 'package:rxdart/rxdart.dart';

import 'ErrorGen.dart';

class CPBloc extends Object with CPValidator implements BaseLoginBloc{
  
  final _oldPasswordController = BehaviorSubject<ErrorGen>();
  final _passwordController = BehaviorSubject<ErrorGen>();

  Stream<String> get email => _oldPasswordController.stream.transform(oldPasswordValidator);
  Stream<String> get password => _passwordController.stream.transform(passwordValidator);

  Stream<bool> get submitCheck => Rx.combineLatest2(email, password, (e,p)=> true);

Function(ErrorGen) get oldPasswordChanged => _oldPasswordController.sink.add;

Function(ErrorGen) get passwordChanged => _passwordController.sink.add;

  @override
  void dispose() {
    _oldPasswordController?.close();
    _passwordController?.close();
  }

}

abstract class BaseLoginBloc{
  void dispose();
}