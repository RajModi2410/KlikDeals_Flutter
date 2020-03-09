import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ApiBlocEvent extends Equatable {}

class TokenGenerateEvent extends ApiBlocEvent {
  final String token;

  TokenGenerateEvent(this.token);

  @override
  List<Object> get props => [token];
}

class ReloadEvent extends ApiBlocEvent {
  final bool isReload;

  ReloadEvent(this.isReload);

  @override
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
  List<Object> get props => [this.email, this.pass];
}

class CouponListEvent extends ApiBlocEvent {
  final int perPage;
  final String action;
  final int currentPage;
  CouponListEvent(
    this.perPage,
    this.action,
    this.currentPage,
  );

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["per_page"] = perPage;
    if (action != null && action.isNotEmpty) {
      map["action"] = action;
    }
    map["page"] = currentPage;
    return map;
  }

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
  final String couponCodeValue;
  final String startDateValue;
  final String endDateValue;
  final String descValue;
  final File image;

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

  List<Object> get props => [
        this.couponCodeValue,
        this.startDateValue,
        this.endDateValue,
        this.descValue,
        this.image
      ];
}

class EditCouponEvent extends ApiBlocEvent {
  final String couponCodeValue;
  final String startDateValue;
  final String endDateValue;
  final String descValue;
  final String id;
  final File image;

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

  List<Object> get props => [
        this.couponCodeValue,
        this.startDateValue,
        this.endDateValue,
        this.descValue,
        this.id,
        this.image
      ];
}

class UpdateProfileEvent extends ApiBlocEvent {
  final String name;
  final String address;
  final String mapLat;
  final String mapLog;
  final String phoneNumber;
  final String email;
  final String website;
  final String about;
  final File logo;
  final File banner;

  UpdateProfileEvent(
      this.name,
      this.address,
      this.mapLat,
      this.mapLog,
      this.phoneNumber,
      this.email,
      this.website,
      this.about,
      this.logo,
      this.banner);

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["name"] = name;
    map["address"] = address;
    map["map_lat"] = mapLat;
    map["map_log"] = mapLog;
    map["phone_number"] = phoneNumber;
    map["email"] = email;
    map["website"] = website;
    map["about"] = about;

    return map;
  }

  List<Object> get props => [
        this.name,
        this.address,
        this.mapLat,
        this.mapLog,
        this.phoneNumber,
        this.email,
        this.website,
        this.about,
        this.logo,
        this.banner
      ];
}
