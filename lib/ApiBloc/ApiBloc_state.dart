import 'package:equatable/equatable.dart';
import 'package:klik_deals/ApiBloc/models/CouponListResponse.dart';
import 'package:klik_deals/ApiBloc/models/LoginResponse.dart';

import 'models/SearchResponse.dart';

abstract class ApiBlocState extends Equatable {}

class ApiUninitializedState extends ApiBlocState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class ApiFetchingState extends ApiBlocState {
  @override // TODO: implement props
  List<Object> get props => [];
}

class ApiFetchedState extends ApiBlocState {
  final SearchResponse searchResult;

  ApiFetchedState({this.searchResult});

  @override
  List<Object> get props => [searchResult];
}

class LoginApiFetchedState extends ApiBlocState {
  final LoginResponse loginResponse;

  LoginApiFetchedState(this.loginResponse);

  @override
  // TODO: implement props
  List<Object> get props => [loginResponse];
}


class CouponListFetchedState extends ApiBlocState{
  final CouponListResponse couponlist;


  CouponListFetchedState(this.couponlist);

  @override
  // TODO: implement props
  List<Object> get props => [couponlist];
}


class ApiErrorState extends ApiBlocState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class ApiEmptyState extends ApiBlocState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}
