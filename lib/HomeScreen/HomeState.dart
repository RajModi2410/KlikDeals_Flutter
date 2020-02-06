import 'package:klik_deals/ApiBloc/ApiBloc_state.dart';
import 'package:klik_deals/ApiBloc/models/CouponListResponse.dart';

class CouponListFetchedState extends ApiBlocState{
  final CouponListResponse couponlist;

  CouponListFetchedState(this.couponlist);

  @override
  List<Object> get props => [couponlist];
}

class couponApiErrorState extends ApiBlocState {
  final CouponListResponse couponlist;

  couponApiErrorState(this.couponlist);

  @override
  List<Object> get props => [couponlist];
}

class CouponHistoryListFetchedState extends  ApiBlocState{
  final CouponListResponse couponlist;

  CouponHistoryListFetchedState(this.couponlist);

  @override
  List<Object> get props => [couponlist];
}

class CouponHistoryErroState extends ApiBlocState {
  final CouponListResponse couponlist;

  CouponHistoryErroState(this.couponlist);

  @override
  List<Object> get props => [couponlist];
}

