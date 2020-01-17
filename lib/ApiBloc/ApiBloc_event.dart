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
