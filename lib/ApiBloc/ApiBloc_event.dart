import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'repositories/ApiBloc_repository.dart';

@immutable
abstract class ApiBlocEvent extends Equatable {
  final ApiBlocRepository _apiBlocRepository = ApiBlocRepository();
}

class TokenGenerateEvent extends ApiBlocEvent {
  final String token;

  TokenGenerateEvent(this.token);

  @override
  // TODO: implement props
  List<Object> get props => [token];
}

class ReloadEvent extends ApiBlocEvent {
  final bool isReload;

  ReloadEvent(this.isReload);

  @override
  // TODO: implement props
  List<Object> get props => [isReload];
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

class CouponListEvent extends ApiBlocEvent {
  final int perPage;
  final String action;

  CouponListEvent(this.perPage, this.action);

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["per_page"] = perPage;
    if (action != null && action.isNotEmpty) {
      map["action"] = action;
    }
    return map;
  }

  // TODO: implement props
  List<Object> get props => [this.perPage, this.action];
}

class CouponDeleteEvent extends ApiBlocEvent {
  final String couponId;

  CouponDeleteEvent(this.couponId);

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = couponId;
    return map;
  }

  List<Object> get props => [this.couponId];
}

class GetProfileEvent extends ApiBlocEvent {
  GetProfileEvent();

  List<Object> get props => [null];
}

class AddCouponEvent extends ApiBlocEvent {
  String couponCodeValue;
  String startDateValue;
  String endDateValue;
  String descValue;
  File image;

  AddCouponEvent(this.couponCodeValue, this.startDateValue, this.endDateValue,
      this.descValue, this.image);

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["coupon_code"] = couponCodeValue;
    map["start_date"] = startDateValue;
    map["end_date"] = endDateValue;
    map["description"] = descValue;

    return map;
  }

  // TODO: implement props
  List<Object> get props =>
      [
        this.couponCodeValue,
        this.startDateValue,
        this.endDateValue,
        this.descValue,
        this.image
      ];
}

class EditCouponEvent extends ApiBlocEvent {
  String couponCodeValue;
  String startDateValue;
  String endDateValue;
  String descValue;
  String id;
  File image;

  EditCouponEvent(this.couponCodeValue, this.startDateValue, this.endDateValue,
      this.descValue, this.id, this.image);

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["coupon_code"] = couponCodeValue;
    map["start_date"] = startDateValue;
    map["end_date"] = endDateValue;
    map["description"] = descValue;
    map["id"] = id;

    return map;
  }

  // TODO: implement props
  List<Object> get props =>
      [
        this.couponCodeValue,
        this.startDateValue,
        this.endDateValue,
        this.descValue,
        this.id,
        this.image
      ];
}

class UpdatePofileEvent extends ApiBlocEvent {
  String name;
  String address;
  String map_lat;
  String map_log;
  String phone_number;
  String email;
  String website;
  String about;
  File logo;
  File banner;

  UpdatePofileEvent(this.name,
      this.address,
      this.map_lat,
      this.map_log,
      this.phone_number,
      this.email,
      this.website,
      this.about,
      this.logo,
      this.banner);

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["name"] = name;
    map["address"] = address;
    map["map_lat"] = map_lat;
    map["map_log"] = map_log;
    map["phone_number"] = phone_number;
    map["email"] = email;
    map["website"] = website;
    map["about"] = about;

    return map;
  }

  // TODO: implement props
  List<Object> get props =>
      [
        this.name,
        this.address,
        this.map_lat,
        this.map_log,
        this.phone_number,
        this.email,
        this.website,
        this.about,
        this.logo,
        this.banner
      ];
}
