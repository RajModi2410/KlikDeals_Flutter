import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klik_deals/LoginScreen/LoginPage.dart';
import 'package:klik_deals/commons/Auth/index.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({
    Key key,
    @required AuthBloc authBloc,
  })  : _authBloc = authBloc,
        super(key: key);

  final AuthBloc _authBloc;

  @override
  AuthScreenState createState() {
    return AuthScreenState(_authBloc);
  }
}

class AuthScreenState extends State<AuthScreen> {
  final AuthBloc _authBloc;
  AuthScreenState(this._authBloc);

  @override
  void initState() {
    super.initState();
    this._load();
  }

  @override
  void dispose() {
    super.dispose();
    print("AuthScreenState dispose");
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
        bloc: _authBloc,
        listener: (context, currentState) {
          print("AuthScreen: AuthScreen currentState We got state : " +
              currentState.toString());
          if (currentState is TokenExpiredState) {
            Navigator.of(context).popAndPushNamed(LoginPage.routeName);
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
            bloc: _authBloc,
            builder: (
              BuildContext context,
              AuthState currentState,
            ) {
              print("currentState We got state : " + currentState.toString());
              if (currentState is TokenValidState) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (currentState is TokenExpiredState) {
                return Container(
                  child: Text("Good"),
                );
              }
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Flutter files: done'),
                    Padding(
                      padding: const EdgeInsets.only(top: 32.0),
                      child: RaisedButton(
                        color: Colors.red,
                        child: Text('throw error'),
                        onPressed: () => this._load(true),
                      ),
                    ),
                  ],
                ),
              );
            }));
  }

  void _load([bool isError = false]) {
    // widget._authBloc.add(UnAuthEvent());
    // widget._authBloc.add(LoadAuthEvent(isError));
  }
}
