import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'models/SearchResponse.dart';

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

class NoInternetState extends ApiBlocState{

  @override
  List<Object> get props => [];

}
