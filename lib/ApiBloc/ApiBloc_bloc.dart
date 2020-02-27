import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:klik_deals/ApiBloc/repositories/ApiBloc_repository.dart';
import 'package:klik_deals/CouponCode/CouponStates.dart';
import 'package:klik_deals/HomeScreen/HomeState.dart';
import 'package:klik_deals/LoginScreen/LoginStates.dart';
import 'package:klik_deals/commons/AppExceptions.dart';

import 'ApiBloc_event.dart';
import 'ApiBloc_state.dart';

class ApiBlocBloc extends Bloc<ApiBlocEvent, ApiBlocState> {
  final ApiBlocRepository playerRepository;

  ApiBlocBloc(this.playerRepository) : assert(playerRepository != null);

  @override
  void onTransition(Transition<ApiBlocEvent, ApiBlocState> transition) {
    super.onTransition(transition);
    print("ApiBlocBloc:" + transition.toString());
  }

  @override
  Future<void> close() async {
    // dispose objects
    await super.close();
  }

  @override
  ApiBlocState get initialState => ApiUninitializedState();

  @override
  Stream<ApiBlocState> mapEventToState(
    ApiBlocEvent event,
  ) async* {
    if (event is LoginEvent) {
      yield* _mapLoginEventResponseEvents(event);
    } else if (event is TokenGenerateEvent) {
      playerRepository.token = event.token;
      yield ApiUninitializedState();
    } else if (event is CouponListEvent) {
      yield* _mapCouponListResponseEvents(event);
    } else if (event is AddCouponEvent) {
      yield* _mapAddCouponEventResponseEvents(event);
    } else if (event is CouponDeleteEvent) {
      yield* _mapDeleteCouponEventResponseEvents(event);
    } else if (event is EditCouponEvent) {
      yield* _mapEditCouponEventResponseEvents(event);
    } else if (event is ReloadEvent) {
      yield* _mapReloadResponseEvents();
    }
  }

  Stream<ApiBlocState> _mapLoginEventResponseEvents(LoginEvent event) async* {
    yield ApiFetchingState();
    try {
      final response = await playerRepository.login(event.toMap());
      if (response.status) {
        yield LoginApiFetchedState(response);
      } else {
        yield LoginApiErrorState(response);
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

  Stream<ApiBlocState> _mapCouponListResponseEvents(
      CouponListEvent event) async* {
    yield ApiFetchingState();
    try {
      final response = await playerRepository.coupon(event.toMap());
      if (response.status) {
        yield CouponListFetchedState(response);
      } else {
        yield couponApiErrorState(response);
      }
    } on NoInternetException catch (e) {
      print("No Intenet exception");
      yield NoInternetState();
    } catch (e, s) {
      print("We got error 1:: ${e.toString()}");
      print(s);
//      e.printStackTrace();
      yield ApiErrorState();
    }
  }

  Stream<ApiBlocState> _mapDeleteCouponEventResponseEvents(
      CouponDeleteEvent event) async* {
    yield ApiFetchingState();
    try {
      final response = await playerRepository.deleteCoupon(event.toMap());
      if (response.status) {
        yield CouponDeleteFetchedState(response);
      } else {
        yield CouponDeleteErrorState(response);
      }
    } on NoInternetException catch (e) {
      print("No Intenet exception");
      yield NoInternetState();
    } catch (e, s) {
      print("We got error 1:: ${e.toString()}");
      print(s);
//      e.printStackTrace();
      yield ApiErrorState();
    }
  }

  Stream<ApiBlocState> _mapReloadResponseEvents() async* {
    yield ApiReloadState();
  }
}
