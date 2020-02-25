import 'dart:async';
import 'dart:developer' as developer;

import 'package:bloc/bloc.dart';
import 'package:klik_deals/ApiBloc/ApiBloc_event.dart';
import 'package:klik_deals/ApiBloc/ApiBloc_state.dart';
import 'package:klik_deals/ApiBloc/repositories/ApiBloc_repository.dart';
import 'package:klik_deals/HomeScreen/HomeState.dart';
import 'package:klik_deals/commons/AppExceptions.dart';

class HistoryBloc extends Bloc<ApiBlocEvent, ApiBlocState> {
  final ApiBlocRepository playerRepository;

  HistoryBloc(this.playerRepository);

  // todo: check singleton for logic in project
  // static final HistoryBloc _historyBlocSingleton = HistoryBloc._internal(this.playerRepository);
  // factory HistoryBloc() {
  //   return _historyBlocSingleton;
  // }
  // HistoryBloc._internal(this.playerRepository);

  @override
  Future<void> close() async {
    // dispose objects
    await super.close();
  }

  @override
  ApiBlocState get initialState => ApiUninitializedState();

  @override
  Stream<ApiBlocState> mapEventToState(ApiBlocEvent event) async* {
    // TODO: implement mapEventToState
    if (event is CouponListEvent) {
      yield* _mapCouponListResponseEvents(event);
    }
  }

  Stream<ApiBlocState> _mapCouponListResponseEvents(
      CouponListEvent event) async* {
    yield ApiFetchingState();
    try {
      final response = await playerRepository.coupon(event.toMap());
      if (response.status) {
        yield CouponHistoryListFetchedState(response);
      } else {
        yield CouponHistoryErroState(response);
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

  // @override
  // Stream<ApiBlocState> mapEventToState(
  //   ApiBlocState event,
  // ) async* {
  //   try {
  //     yield await event.applyAsync(currentState: state, bloc: this);
  //   } catch (_, stackTrace) {
  //     developer.log('$_', name: 'HistoryBloc', error: _, stackTrace: stackTrace);
  //     yield state;
  //   }
  // }
}
