import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:klik_deals/ApiBloc/repositories/ApiBloc_repository.dart';
import 'package:klik_deals/HomeScreen/HomeState.dart';
import 'package:klik_deals/LoginScreen/LoginStates.dart';

import 'ApiBloc_event.dart';
import 'ApiBloc_state.dart';

class ApiBlocBloc extends Bloc<ApiBlocEvent, ApiBlocState> {
  final ApiBlocRepository playerRepository;

  ApiBlocBloc(this.playerRepository) : assert(playerRepository != null);

  @override
  void onTransition(Transition<ApiBlocEvent, ApiBlocState> transition) {
    super.onTransition(transition);
    print(transition);
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
    if (event is RestaurantSearchEvent) {
      yield* _mapSearchResponseEvents(event);
    } else if (event is LoginEvent) {
      yield* _mapLoginEventResponseEvents(event);
    } else if (event is TokenGenerateEvent) {
      playerRepository.token = event.token;
      yield ApiUninitializedState();
    } else if (event is CouponListEvent) {
      yield* _mapCouponListResponseEvents(event);
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
    } catch (e, s) {
      print("We got error 1:: ${e.toString()}");
      print(s);
//      e.printStackTrace();
      yield ApiErrorState();
    }
  }

  Stream<ApiBlocState> _mapSearchResponseEvents(
      RestaurantSearchEvent event) async* {
    if (event.query.isEmpty) {
      yield ApiUninitializedState();
    } else {
      yield ApiFetchingState();

      try {
        final response = await playerRepository.searchRestaurant(
            event.query, event.numberOfRecord);
        if (response.restaurants != null) {
          if (response.restaurants.length == 0) {
            yield ApiEmptyState();
          } else {
            yield ApiFetchedState(searchResult: response);
          }
        } else {
          yield ApiEmptyState();
        }
      } catch (e) {
        yield ApiErrorState();
      }
    }
  }
}
