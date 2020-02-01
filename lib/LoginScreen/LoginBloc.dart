import 'dart:async';

class LoginBloc implements BaseLoginBloc{
  
  final _emailController = StreamController<String>();
  final _passwordController = StreamController<String>();
  @override
  void dispose() {
    _emailController?.close();
  }

}

abstract class BaseLoginBloc{
  void dispose();
}