import 'package:klik_deals/ApiBloc/ApiBloc_state.dart';
import 'package:klik_deals/ApiBloc/models/GetProfileResponse.dart';
import 'package:klik_deals/ApiBloc/models/UpdateProfileResponse.dart';

class GetProfileApiFetchedState extends ApiBlocState {
  final GetProfileResponse getProfileResponse;

  GetProfileApiFetchedState(this.getProfileResponse);

  @override
  // TODO: implement props
  List<Object> get props => [getProfileResponse];
}

class GetProfileApiErrorState extends ApiBlocState {
  final GetProfileResponse getProfileResponse;

  GetProfileApiErrorState(this.getProfileResponse);

  @override
  // TODO: implement props
  List<Object> get props => [getProfileResponse];
}

class UpdateProfileApiFetchedState extends ApiBlocState {
  final UpdateProfileResponse updateProfileResponse;

  UpdateProfileApiFetchedState(this.updateProfileResponse);

  @override
  // TODO: implement props
  List<Object> get props => [updateProfileResponse];
}

class UpdateProfileApiErrorState extends ApiBlocState {
  final UpdateProfileResponse updateProfileResponse;

  UpdateProfileApiErrorState(this.updateProfileResponse);

  @override
  // TODO: implement props
  List<Object> get props => [updateProfileResponse];
}
