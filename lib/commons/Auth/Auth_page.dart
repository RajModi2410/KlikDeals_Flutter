import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vendor/commons/Auth/index.dart';

class AuthPage extends StatelessWidget {
  static const String routeName = '/auth';
  AuthBloc _authBloc;
  final dynamic Function(AuthBloc) simples;

  AuthPage({Key key, this.simples}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _authBloc = BlocProvider.of<AuthBloc>(context);
    simples(_authBloc);
    return AuthScreen(authBloc: _authBloc);
  }
}
