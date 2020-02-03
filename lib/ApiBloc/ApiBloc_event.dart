import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'repositories/ApiBloc_repository.dart';

@immutable
abstract class ApiBlocEvent extends Equatable {
  final ApiBlocRepository _apiBlocRepository = ApiBlocRepository();
}

class RestaurantSearchEvent extends ApiBlocEvent {
  final String query;
  final int numberOfRecord;

  RestaurantSearchEvent(this.query, this.numberOfRecord);

  @override
  // TODO: implement props
  List<Object> get props => [this.query, this.numberOfRecord];
}

class TokenGenerateEvent extends ApiBlocEvent {
  final String token;

  TokenGenerateEvent(this.token);

  @override
  // TODO: implement props
  List<Object> get props => [token];
}

class LoginEvent extends ApiBlocEvent {
  final String email;
  final String pass;

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["email"] = email;
    map["password"] = pass;

    return map;
  }

  LoginEvent(this.email, this.pass);

  @override
  // TODO: implement props
  List<Object> get props => [this.email, this.pass];
}

class CouponListEvent extends ApiBlocEvent{

  final int perPage;
  final String action;

  CouponListEvent(this.perPage, this.action);

  Map toMap() {
    var map = new Map<String, dynamic>();
    map ["per_page"] = perPage;
    if (action != null && action.isNotEmpty) {
      map["action"] = action;
    }
    return map;
  }
  // TODO: implement props
  List<Object> get props => [ this.perPage, this.action];
}