import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vendor/ApiBloc/ApiBloc_bloc.dart';
import 'package:vendor/ApiBloc/ApiBloc_event.dart';
import 'package:vendor/ApiBloc/ApiBloc_state.dart';
import 'package:vendor/AppLocalizations.dart';
import 'package:vendor/LoginScreen/LoginBloc.dart';
import 'package:vendor/LoginScreen/LoginPage.dart';
import 'package:vendor/LoginScreen/LoginStates.dart';
import 'package:vendor/commons/AuthUtils.dart';
import 'package:vendor/commons/CenterLoadingIndicator.dart';
import 'package:vendor/myWidgets/HomeMainTab.dart';
import 'package:vendor/myWidgets/NoNetworkWidget.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ErrorGen.dart';

ProgressDialog pr;
var token = "";
SharedPreferences sharedPreferences;

class LoginFormV1 extends StatefulWidget {
  final ClickCallback callback;

  const LoginFormV1({Key key, this.callback}) : super(key: key);

  @override
  State<LoginFormV1> createState() => _LoginFormV1State(this.callback);
}

  String emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]'
        r'{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp exp = new RegExp(pattern);
    if (!exp.hasMatch(value)) {
      return 'Please enter valid email.';
    } else {
      return null;
    }
  }

String passwordValidator(String value) {
  int minLength = 8;
  int maxLength = 15;
  if (value.length < minLength) {
    return 'Password must be longer than $minLength characters.';
  } else if (value.length > maxLength) {
    return 'Password must be smaller than $maxLength characters.';
  } else {
    return null;
  }
}

class _LoginFormV1State extends State<LoginFormV1> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController emailInputController;
  TextEditingController pwdInputController;
  String _email;
  String _password;
  String _errorMessage;
  ApiBlocBloc auth;
  var loginBloc = LoginBloc();
  final ClickCallback callback;
  ApiBlocEvent lastEvent;

  _LoginFormV1State(this.callback);

  @override
  void initState() {
    emailInputController = new TextEditingController();
    pwdInputController = new TextEditingController();
    emailInputController.addListener(_printEmailValue);
    pwdInputController.addListener(_printPasswordValue);
    _errorMessage = "";
    super.initState();

    fetchSessionAndNavigate();
  }

  @override
  void dispose() {
    emailInputController?.dispose();
    pwdInputController?.dispose();
    loginBloc = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    auth = BlocProvider.of<ApiBlocBloc>(context);
    return Stack(children: <Widget>[
      _showForm(),
      BlocListener<ApiBlocBloc, ApiBlocState>(
          listener: (context, state) {
            if (state is LoginApiErrorState) {
              String error = "";
              if (state.loginResponse.errorMessage.generalError.length > 0) {
                error = state.loginResponse.errorMessage.generalError.first;
                print("We got the error in LOGIN VALUE::$error");
              } else if (state.loginResponse.errorMessage.userError.length >
                  0) {
                // error = state.loginResponse.errorMessage.user_error.first;
                this.loginBloc.emailChanged(ErrorGen(
                    isError: true,
                    value: state.loginResponse.errorMessage.userError.first));
                print("We got the error in LOGIN VALUE::$error");
                error = null;
              }
              if (error != null) {
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text(error),
                    backgroundColor: Theme.of(context).errorColor,
                  ),
                );
              }
            } else if (state is LoginApiFetchedState) {
              token = state.loginResponse.token.toString();
              lastEvent = TokenGenerateEvent(token);
              auth.add(lastEvent);
              _onSetOnShredPref(token);
              _goToHomePage();
            }
          },
          child: BlocBuilder<ApiBlocBloc, ApiBlocState>(
              bloc: auth,
              builder: (
                BuildContext context,
                ApiBlocState currentState,
              ) {
                if (currentState is ApiFetchingState) {
                  return CenterLoadingIndicator();
                } else if (currentState is NoInternetState) {
                  return NoNetworkWidget(
                    retry: () {
                      retryCall();
                    },
                    isFromInternetConnection:
                        currentState.isFromInternetConnection,
                  );
                } else {
                  return Container();
                }
              }))
    ]);
  }

  Widget _showForm() {
    return Stack(children: <Widget>[
      Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/splash_bg.webp'),
                fit: BoxFit.cover)),
      ),
      new Form(
          key: _formKey,
          child: new ListView(
            children: <Widget>[
              _showLogo(),
              _showEmailTextField(),
              _showPasswordTextField(),
              _showLoginButton(auth),
            ],
          )),
      Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            children: <Widget>[_showErrorMessage()],
          ))
    ]);
  }

  Widget _showLogo() {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 120, 20, 120),
      child: Center(
        child: new Image(
          image: new AssetImage('assets/images/main_logo.png'),
          height: 50,
          width: MediaQuery.of(context).size.width,
        ),
      ),
    );
  }

  Widget _showEmailTextField() {
    return new Container(
      child: Row(
        children: <Widget>[
          Expanded(
              child: Column(
            children: <Widget>[
              StreamBuilder<String>(
                  stream: loginBloc.email,
                  builder: (context, snapshot) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                      child: TextFormField(
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            decoration: TextDecoration.none),
                        onChanged: (value) => loginBloc.emailChanged(
                            ErrorGen(isError: false, value: value)),
                        keyboardType: TextInputType.emailAddress,
                        autofocus: false,
                        // initialValue: "testing9@webdesksolution.com",
                        validator: emailValidator,
                        onSaved: (value) => _email = value.trim(),
                        obscureText: false,
                        textAlign: TextAlign.left,
                        controller: emailInputController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.mail_outline,
                              color: Theme.of(context).primaryColor),
                          fillColor: Color(0xB3FFFFFF),
                          filled: true,
                          hintStyle:
                              TextStyle(color: Theme.of(context).hintColor),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30.0)),
                              borderSide: BorderSide(color: Colors.grey)),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(30.0)),
                          labelStyle:
                              TextStyle(color: Theme.of(context).primaryColor),
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 20.0, 10.0, 10.0),
                          hintText: "Email",
                        ),
                      ),
                    );
                  }),
            ],
          )),
        ],
      ),
    );
  }

  Widget _showPasswordTextField() /**/ {
    return new Container(
      child: new Row(
        children: <Widget>[
          new Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 24.0, right: 24.0, top: 24.0),
              child: TextFormField(
                style: TextStyle(
                    color: Theme.of(context).primaryColor,),
                validator: passwordValidator,
                onSaved: (value) => _password = value.trim(),
                autofocus: false,
                obscureText: true,
                textAlign: TextAlign.left,
                controller: pwdInputController,
                decoration: InputDecoration(

                  prefixIcon: Icon(Icons.lock_outline,
                      color: Theme.of(context).primaryColor),
                  fillColor: Color(0xB3FFFFFF),
                  filled: true,
                  hintStyle: TextStyle(color: Theme.of(context).hintColor),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      borderSide: BorderSide(color: Colors.grey)),

                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(30.0)),
                  labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                  contentPadding: EdgeInsets.fromLTRB(20.0, 20.0, 10.0, 10.0),
                  hintText:
                      AppLocalizations.of(context).translate("label_password"),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _showLoginButton(ApiBlocBloc auth) {
    return new Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0),
      alignment: Alignment.center,
      child: new Row(
        children: <Widget>[
          Expanded(
            child: new FlatButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              color: Theme.of(context).primaryColor,
              onPressed: () {
                FocusScope.of(context).unfocus();
                validateAndSubmit();
              },
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Padding(
                    padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                    child: Text(
                        AppLocalizations.of(context).translate("label_login"),
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _showErrorMessage() {
    if (_errorMessage != null && _errorMessage.length > 0) {
      return SnackBar(
        content: Text(_errorMessage),
        action: SnackBarAction(
          label: AppLocalizations.of(context).translate("label_undo"),
          onPressed: () {},
        ),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit() {
    print("validateAndSubmit");
    if (validateAndSave()) {
      try {
        lastEvent = LoginEvent(_email, _password);
        auth.add(lastEvent);
        setState(() {});
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  void _goToHomePage() {
    // callback();
    Navigator.of(context).pushNamed(HomeMainTab.routeName);
  }

  void _onWidgetDidBuild(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // callback();
      Navigator.of(context).pushNamed(HomeMainTab.routeName);
    });
  }

  void _onSetOnShredPref(String token) async {
    sharedPreferences.setString("token", token);
  }

  void _printEmailValue() {
    print("Email text field: ${emailInputController.text}");
    loginBloc.emailChanged(
        ErrorGen(isError: false, value: emailInputController.text));
  }

  void _printPasswordValue() {
    print("Password text field: ${pwdInputController.text}");
    loginBloc.passwordChanged(
        ErrorGen(isError: false, value: pwdInputController.text));
  }

  void displayErrorInEmailValue(String value) {
    loginBloc.emailChanged(ErrorGen(isError: true, value: value));
  }

  void displayErrorInPasswordValue(String value) {
    loginBloc.passwordChanged(ErrorGen(isError: true, value: value));
  }

  void fetchSessionAndNavigate() async {
    sharedPreferences = await SharedPreferences.getInstance();
    String authToken = AuthUtils.getToken(sharedPreferences);
    print("we got token $authToken");
    if (authToken != null) {
      lastEvent = TokenGenerateEvent(authToken);
      auth.add(lastEvent);
      this.callback();
    }
  }

  void retryCall() {
    if (lastEvent != null) {
      auth.add(lastEvent);
    }
  }
}
