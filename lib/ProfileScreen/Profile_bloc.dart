import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:vendor/ApiBloc/ApiBloc_event.dart';
import 'package:vendor/ApiBloc/ApiBloc_state.dart';
import 'package:vendor/ApiBloc/models/UpdateProfileResponse.dart';
import 'package:vendor/ApiBloc/repositories/ApiBloc_repository.dart';
import 'package:vendor/ProfileScreen/ProfileStates.dart';
import 'package:vendor/commons/AppExceptions.dart';

class ProfileBloc extends Bloc<ApiBlocEvent, ApiBlocState> {
  ApiBlocRepository playerRepository;

  static final ProfileBloc _profileBlocSingleton = ProfileBloc._internal();

  factory ProfileBloc(ApiBlocRepository playerRepository) {
    _profileBlocSingleton.playerRepository = playerRepository;
    return _profileBlocSingleton;
  }
  ProfileBloc._internal();

  @override
  Future<void> close() async {
    // dispose objects
    await super.close();
  }

  @override
  ApiBlocState get initialState => NoProfileFoundState();

  @override
  Stream<ApiBlocState> mapEventToState(
    ApiBlocEvent event,
  ) async* {
    if (event is UpdateProfileEvent) {
      yield* _mapUpdateProfileEventResponseEvents(event);
    } else if (event is GetProfileEvent) {
      yield* _mapGetProfileEventResponseEvents(event);
    }
  }

  Stream<ApiBlocState> _mapUpdateProfileEventResponseEvents(
      UpdateProfileEvent event) async* {
    yield ApiFetchingState();
    try {
      final response =
          await playerRepository.updateProfile(event, event.logo, event.banner);
      if (response.status) {
        yield UpdateProfileSuccessState(response);
      } else {
        String error = getError(response.errorMessage);
        yield UpdateProfileApiErrorState(response, error);
      }
    } on NoInternetException catch (_) {
      print("No Internet exception");
      yield NoInternetState();
    } catch (e, s) {
      print("error $e");
      print("stacktrace $s");
      yield ApiErrorState();
    }
  }

  String getError(ErrorMessage errors) {
    String error = "";
    if (errors.mapLat != null && errors.mapLat.length > 0) {
      error = errors.mapLat.first;
      print("We got the error in Coupon Code::$error");
    } else if (errors.mapLog != null && errors.mapLog.length > 0) {
      error = errors.mapLog.first;
    } else if (errors.phoneNumber != null && errors.phoneNumber.length > 0) {
      error = errors.phoneNumber.first;
    } else if (errors.banner != null && errors.banner.length > 0) {
      error = errors.banner.first;
    } else if (errors.logo != null && errors.logo.length > 0) {
      error = errors.logo.first;
    } else if (errors.error != null && errors.error.length > 0) {
      error = errors.error.first;
    }
    return error;
  }

  Stream<ApiBlocState> _mapGetProfileEventResponseEvents(
      GetProfileEvent event) async* {
    yield ApiFetchingState();
    try {
      final response = await playerRepository.getProfile();
      if (response.status) {
        yield GetProfileApiFetchedState(response);
      } else {
        yield GetProfileApiErrorState(response);
      }
    } on NoInternetException catch (_) {
      print("No Internet exception");
      yield NoInternetState();
    } catch (e, s) {
      print("We got error 1:: ${e.toString()}");
      print(s);
//      e.printStackTrace();
      yield ApiErrorState();
    }
  }
}
