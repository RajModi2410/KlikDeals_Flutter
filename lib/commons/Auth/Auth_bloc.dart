import 'dart:async';
import 'dart:developer' as developer;

import 'package:bloc/bloc.dart';
import 'package:klik_deals/commons/Auth/index.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  // todo: check singleton for logic in project
  static final AuthBloc _authBlocSingleton = AuthBloc._internal();
  factory AuthBloc() {
    return _authBlocSingleton;
  }
  AuthBloc._internal();
  
  @override
  Future<void> close() async{
    // dispose objects
    await super.close();
  }

  @override
  void onTransition(Transition<AuthEvent, AuthState> transition) {
    super.onTransition(transition);
    print("AuthBloc:" + transition.toString());
  }

  @override
  AuthState get initialState => TokenValidState(0);

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    try {
      print("we are getting ${event.toString()}");
      yield await event.applyAsync(currentState: state, bloc: this);
    } catch (_, stackTrace) {
      developer.log('$_', name: 'AuthBloc', error: _, stackTrace: stackTrace);
      yield state;
    }
  }
}
