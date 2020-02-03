import 'dart:async';

import 'package:klik_deals/LoginScreen/LoginValidator.dart';
import 'package:rxdart/rxdart.dart';

import 'ErrorGen.dart';

class LoginBloc extends Object with LoginValidator implements BaseLoginBloc{
  
  final _emailController = BehaviorSubject<ErroGen>();
  final _passwordController = BehaviorSubject<ErroGen>();

  Stream<String> get email => _emailController.stream.transform(emailValidator);
  Stream<String> get password => _passwordController.stream.transform(passwordValidator);

  Stream<bool> get submitChck => Observable.combineLatest2(email, password, (e,p)=> true);

Function(ErroGen) get emailChanged => _emailController.sink.add;

Function(ErroGen) get passwordChanged => _passwordController.sink.add;

  @override
  void dispose() {
    _emailController?.close();
    _passwordController?.close();
  }

}

abstract class BaseLoginBloc{
  void dispose();
}