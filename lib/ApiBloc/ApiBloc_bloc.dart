import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:klik_deals/ApiBloc/repositories/ApiBloc_repository.dart';

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
    // yield ApiFetchingState();
    // try {
    if (event is RestaurantSearchEvent) {
      yield* mapSearchResponseEvents(event);
    } else if (event is LoginEvent) {
      yield* mapLoginEventResponseEvents(event);
    }
    // }
    //  catch (_, stackTrace) {
    //   developer.log('$_',
    //       name: 'ApiBlocBloc', error: _, stackTrace: stackTrace);
    //   yield* ApiErrorState();
    // }
  }

  Stream<ApiBlocState> mapLoginEventResponseEvents(LoginEvent event) async* {
    if (event.email.isEmpty || event.pass.isEmpty) {
      yield ApiUninitializedState();
    } else {
      yield ApiFetchingState();

      try {
        final response = await playerRepository.login(
            event.email, event.pass);
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

  Stream<ApiBlocState> mapSearchResponseEvents(
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

