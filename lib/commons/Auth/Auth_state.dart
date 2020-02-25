import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  /// notify change state without deep clone state
  final int version;

  final List propss;
  AuthState(this.version, [this.propss]);

  /// Copy object for use in action
  /// if need use deep clone
  AuthState getStateCopy();

  AuthState getNewVersion();

  @override
  List<Object> get props => (propss);
}

class TokenExpiredState extends AuthState {
  TokenExpiredState(int version) : super(version);

  @override
  TokenExpiredState getNewVersion() {
    return TokenExpiredState(version);
  }

  @override
  TokenExpiredState getStateCopy() {
    return TokenExpiredState(version + 1);
  }
}

/// UnInitialized
class TokenValidState extends AuthState {
  TokenValidState(int version) : super(version);

  @override
  String toString() => 'UnAuthState';

  @override
  TokenValidState getStateCopy() {
    return TokenValidState(0);
  }

  @override
  TokenValidState getNewVersion() {
    return TokenValidState(version + 1);
  }
}
