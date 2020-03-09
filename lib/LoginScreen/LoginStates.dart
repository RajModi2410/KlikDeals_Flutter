
import 'package:klik_deals/ApiBloc/ApiBloc_state.dart';
import 'package:klik_deals/ApiBloc/models/LoginResponse.dart';

class LoginApiFetchedState extends ApiBlocState {
  final LoginResponse loginResponse;

  LoginApiFetchedState(this.loginResponse);

  @override
  
  List<Object> get props => [loginResponse];
}

class LoginApiErrorState extends ApiBlocState{
   final LoginResponse loginResponse;

  LoginApiErrorState(this.loginResponse);

  @override
  
  List<Object> get props => [loginResponse];
}