import 'package:klik_deals/ApiBloc/ApiBloc_state.dart';
import 'package:klik_deals/ApiBloc/models/AddCouponResponse.dart';
import 'package:klik_deals/ApiBloc/models/CouponListResponse.dart';
import 'package:klik_deals/ApiBloc/models/DeleteCouponResponse.dart';

class CouponListFetchedState extends ApiBlocState{
  final CouponListResponse couponList;

  CouponListFetchedState(this.couponList);

  @override
  List<Object> get props => [couponList];
}

class CouponApiErrorState extends ApiBlocState {
  final CouponListResponse couponList;

  CouponApiErrorState(this.couponList);

  @override
  List<Object> get props => [couponList];
}

class CouponHistoryListFetchedState extends  ApiBlocState{
  final CouponListResponse couponList;

  CouponHistoryListFetchedState(this.couponList);

  @override
  List<Object> get props => [couponList];
}

class CouponHistoryErrorState extends ApiBlocState {
  final CouponListResponse couponList;

  CouponHistoryErrorState(this.couponList);

  @override
  List<Object> get props => [couponList];
}

class CouponDeleteFetchedState extends ApiBlocState {
  final DeleteCouponResponse deleteCouponResponse;

  CouponDeleteFetchedState(this.deleteCouponResponse);

  @override
  List<Object> get props => [deleteCouponResponse];
}


class CouponDeleteErrorState extends ApiBlocState {
  final DeleteCouponResponse deleteCouponResponse;

  CouponDeleteErrorState(this.deleteCouponResponse);

  @override
  List<Object> get props => [deleteCouponResponse];
}


class CouponAddFetchedState extends ApiBlocState {
  final AddCouponResponse addCouponResponse;

  CouponAddFetchedState(this.addCouponResponse);

  @override
  List<Object> get props => [addCouponResponse];
}


class CouponAddErrorState extends ApiBlocState {
  final AddCouponResponse addCouponResponse;

  CouponAddErrorState(this.addCouponResponse);

  @override
  List<Object> get props => [addCouponResponse];
}

