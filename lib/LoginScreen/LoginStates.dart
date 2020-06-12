
import 'package:vendor/ApiBloc/ApiBloc_state.dart';
import 'package:vendor/ApiBloc/models/LoginResponse.dart';
import 'package:vendor/ApiBloc/models/ResetPasswordResponse.dart';

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

class PasswordSuccessState extends ApiBlocState{
  final ResetPasswordResponse resetPasswordResponse;

  PasswordSuccessState(this.resetPasswordResponse);

  @override
  List<Object> get props => [resetPasswordResponse];

}

class PasswordErrorState extends ApiBlocState{
  final ResetPasswordResponse resetPasswordResponse;

  PasswordErrorState(this.resetPasswordResponse);
  
  @override
  List<Object> get props => [resetPasswordResponse];

}