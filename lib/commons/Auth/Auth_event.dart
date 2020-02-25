import 'dart:async';
import 'dart:developer' as developer;

import 'package:klik_deals/commons/Auth/index.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AuthEvent {
  Future<AuthState> applyAsync({AuthState currentState, AuthBloc bloc});
}

class TokenValidEvent extends AuthEvent {
  @override
  Future<AuthState> applyAsync({AuthState currentState, AuthBloc bloc}) async {
    return TokenValidState(0);
  }
}

class TokenExpiredEvent extends AuthEvent{
  @override
  Future<TokenExpiredState> applyAsync({AuthState currentState, AuthBloc bloc}) async{
    return TokenExpiredState(0);
  }

}
