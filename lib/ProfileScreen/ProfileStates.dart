import 'package:klik_deals/ApiBloc/ApiBloc_state.dart';
import 'package:klik_deals/ApiBloc/models/GetProfileResponse.dart';
import 'package:klik_deals/ApiBloc/models/UpdateProfileResponse.dart';

class GetProfileApiFetchedState extends ApiBlocState {
  final GetProfileResponse getProfileResponse;

  GetProfileApiFetchedState(this.getProfileResponse);

  @override
  
  List<Object> get props => [getProfileResponse];
}

class GetProfileApiErrorState extends ApiBlocState {
  final GetProfileResponse getProfileResponse;

  GetProfileApiErrorState(this.getProfileResponse);

  @override
  
  List<Object> get props => [getProfileResponse];
}

class UpdateProfileSuccessState extends ApiBlocState {
  final UpdateProfileResponse updateProfileResponse;

  UpdateProfileSuccessState(this.updateProfileResponse);

  @override
  
  List<Object> get props => [updateProfileResponse];
}

class UpdateProfileApiErrorState extends ApiBlocState {
  final UpdateProfileResponse updateProfileResponse;
  final String error;

  UpdateProfileApiErrorState(this.updateProfileResponse, this.error);

  @override
  
  List<Object> get props => [updateProfileResponse];
}

class NoProfileFoundState extends ApiBlocState{
  @override
  
  List<Object> get props => [];

}
