import 'package:klik_deals/ApiBloc/ApiBloc_state.dart';
import 'package:klik_deals/ApiBloc/models/AddCouponResponse.dart';

class CouponApiFetchedState extends ApiBlocState {
  final AddCouponResponse addCouponResponse;

  CouponApiFetchedState(this.addCouponResponse);

  @override
  // TODO: implement props
  List<Object> get props => [CouponApiErrorState];
}

class CouponApiErrorState extends ApiBlocState {
  final AddCouponResponse addCouponResponse;

  CouponApiErrorState(this.addCouponResponse);

  @override
  // TODO: implement props
  List<Object> get props => [CouponApiErrorState];
}
