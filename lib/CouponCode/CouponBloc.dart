import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:klik_deals/ApiBloc/ApiBloc_event.dart';
import 'package:klik_deals/ApiBloc/ApiBloc_state.dart';
import 'package:klik_deals/ApiBloc/repositories/ApiBloc_repository.dart';
import 'package:klik_deals/HomeScreen/HomeState.dart';
import 'package:klik_deals/ProfileScreen/ProfileStates.dart';
import 'package:klik_deals/commons/AppExceptions.dart';

import 'CouponStates.dart';

class CouponBloc extends Bloc<ApiBlocEvent, ApiBlocState> {
  ApiBlocRepository playerRepository;

  static final CouponBloc _profileBlocSingleton = CouponBloc._internal();

  factory CouponBloc(ApiBlocRepository playerRepository) {
    _profileBlocSingleton.playerRepository = playerRepository;
    return _profileBlocSingleton;
  }

  CouponBloc._internal();

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
    if (event is AddCouponEvent) {
      yield* _mapAddCouponEventResponseEvents(event);
    } else if (event is EditCouponEvent) {
      yield* _mapEditCouponEventResponseEvents(event);
    }
  }

  Stream<ApiBlocState> _mapAddCouponEventResponseEvents(
      AddCouponEvent event) async* {
    yield ApiFetchingState();
    try {
      final response = await playerRepository.addCoupon(event, event.image);
      if (response.status) {
        yield CouponAddFetchedState(response);
      } else {
        yield CouponAddErrorState(response);
      }
    } on NoInternetException catch (e) {
      print("No Intenet exception");
      yield NoInternetState();
    } catch (e, s) {
      print("error $e");
      print("stacktrace $s");
      yield ApiErrorState();
    }
  }

  Stream<ApiBlocState> _mapEditCouponEventResponseEvents(
      EditCouponEvent event) async* {
    yield ApiFetchingState();
    try {
      final response = await playerRepository.editCoupon(event, event.image);
      if (response.status) {
        yield EditCouponApiFetchedState(response);
      } else {
        yield EditCouponApiErrorState(response);
      }
    } on NoInternetException catch (e) {
      print("No Intenet exception");
      yield NoInternetState();
    } catch (e, s) {
      print("error $e");
      print("stacktrace $s");
      yield ApiErrorState();
    }
  }
}
