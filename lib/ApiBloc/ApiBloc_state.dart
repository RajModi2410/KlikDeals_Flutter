import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ApiBlocState extends Equatable {}

class ApiUninitializedState extends ApiBlocState {
  @override
  List<Object> get props => [];
}

class ApiFetchingState extends ApiBlocState {
  @override
  List<Object> get props => [];
}

class ApiErrorState extends ApiBlocState {
  @override
  List<Object> get props => [];
}

class ApiEmptyState extends ApiBlocState {
  @override
  List<Object> get props => [];
}

class ApiReloadState extends ApiBlocState {
  @override
  List<Object> get props => [];
}

// True = Socket timeout && False = error code == 429
class NoInternetState extends ApiBlocState {
  final bool isFromInternetConnection;
  @override
  List<Object> get props => [];

  NoInternetState(this.isFromInternetConnection);
}

class RetryErrorState extends ApiBlocState {
  @override
  List<Object> get props => [];
}
