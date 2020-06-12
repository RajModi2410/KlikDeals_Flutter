import 'package:vendor/ApiBloc/ApiBloc_state.dart';
import 'package:vendor/ApiBloc/models/ChangePasswordResponse.dart';

class ChangePasswordSuccessState extends ApiBlocState{
  final ChangePasswordResponse changePasswordResponse;

  ChangePasswordSuccessState(this.changePasswordResponse);

  @override
  List<Object> get props => [changePasswordResponse];

}

class ChangePasswordErrorState extends ApiBlocState{
  final ChangePasswordResponse changePasswordResponse;

  ChangePasswordErrorState(this.changePasswordResponse);
  
  @override
  List<Object> get props => [changePasswordResponse];

}