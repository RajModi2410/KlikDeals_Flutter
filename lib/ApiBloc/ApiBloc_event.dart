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
