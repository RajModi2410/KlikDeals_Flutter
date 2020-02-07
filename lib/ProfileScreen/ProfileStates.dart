import 'package:klik_deals/ApiBloc/ApiBloc_state.dart';
import 'package:klik_deals/ApiBloc/models/GetProfileResponse.dart';

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
