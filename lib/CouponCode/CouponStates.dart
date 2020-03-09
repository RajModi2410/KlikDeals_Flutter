import 'package:klik_deals/ApiBloc/ApiBloc_state.dart';
import 'package:klik_deals/ApiBloc/models/AddCouponResponse.dart';
import 'package:klik_deals/ApiBloc/models/EditCouponResponse.dart';

class CouponApiFetchedState extends ApiBlocState {
  final AddCouponResponse addCouponResponse;

  CouponApiFetchedState(this.addCouponResponse);

  @override
  
  List<Object> get props => [CouponApiErrorState];
}

class CouponApiErrorState extends ApiBlocState {
  final AddCouponResponse addCouponResponse;

  CouponApiErrorState(this.addCouponResponse);

  @override
  
  List<Object> get props => [CouponApiErrorState];
}

class EditCouponApiFetchedState extends ApiBlocState {
  final EditCouponResponse editCouponResponse;

  EditCouponApiFetchedState(this.editCouponResponse);

  @override
  
  List<Object> get props => [editCouponResponse];
}

class EditCouponApiErrorState extends ApiBlocState {
  final EditCouponResponse editCouponResponse;

  EditCouponApiErrorState(this.editCouponResponse);

  @override
  
  List<Object> get props => [editCouponResponse];
}
