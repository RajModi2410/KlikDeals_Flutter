import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:vendor/ApiBloc/repositories/ApiBloc_repository.dart';
import 'package:vendor/HomeScreen/HomeState.dart';
import 'package:vendor/LoginScreen/LoginStates.dart';
import 'package:vendor/commons/AppExceptions.dart';

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
    } else if (event is CouponDeleteEvent) {
      yield* _mapDeleteCouponEventResponseEvents(event);
    } else if (event is ReloadEvent) {
      yield* _mapReloadResponseEvents();
    } else if (event is ResetPasswordEvent){
      yield* event.getProcessAsync(playerRepository);
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
    } on NoInternetException catch (_) {
      print("No Internet exception");
      yield NoInternetState(true);
    }on RetryErrorException catch(_){
      print("Retry error exception");
      yield NoInternetState(false);
    }
    catch (e, s) {
      print("error $e");
      print("stacktrace $s");
      yield ApiErrorState();
    }
  }

  CouponListFetchedState couponFetchState;

  Stream<ApiBlocState> _mapCouponListResponseEvents(
      CouponListEvent event) async* {
    // final currentState = state;
    if (event.currentPage == 1) {
      yield ApiFetchingState();
    }

    try {
      final response = await playerRepository.coupon(event.toMap());
      if (response.status) {
        if (couponFetchState!= null && couponFetchState is CouponListFetchedState && event.currentPage != 1) {
          response.response.data =
              couponFetchState.couponList.response.data + response.response.data;
        } else {
          print("state not matched");
        }
        couponFetchState = CouponListFetchedState(response);
        yield couponFetchState;
      } else {
        yield CouponApiErrorState(response);
      }
    } on NoInternetException catch (_) {
      print("No Internet exception");
      yield NoInternetState(true);
    } on RetryErrorException catch(_){
      print("Retry error exception");
      yield NoInternetState(false);
    }catch (e, s) {
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
    } on NoInternetException catch (_) {
      print("No Internet exception");
      yield NoInternetState(true);
    } on RetryErrorException catch(_){
      print("Retry error exception");
      yield NoInternetState(false);
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
