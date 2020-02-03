import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klik_deals/ApiBloc/ApiBloc_bloc.dart';
import 'package:klik_deals/ApiBloc/ApiBloc_event.dart';
import 'package:klik_deals/ApiBloc/ApiBloc_state.dart';
import 'package:klik_deals/HomeScreen/home.dart';
import 'package:klik_deals/LoginScreen/LoginBloc.dart';
import 'package:klik_deals/LoginScreen/LoginStates.dart';
import 'package:klik_deals/mywidgets/RoundWidget.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ErrorGen.dart';

ProgressDialog pr;
var token = "";
SharedPreferences sharedPreferences;

class LoginFormV1 extends StatefulWidget {
  @override
  State<LoginFormV1> createState() => _LoginFormV1State();
}

String emailValidator(String value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp exp = new RegExp(pattern);
  if (!exp.hasMatch(value)) {
    return 'Please enter valid email.';
  } else {
    return null;
  }
}

String passwordValidator(String value) {
  int length = 5;
  if (value.length < length) {
    return 'Password must be longer than $length characters.';
  } else {
    return null;
  }
}

class _LoginFormV1State extends State<LoginFormV1> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailInputController;
  TextEditingController pwdInputController;
  bool _isLoading;
  String _email;
  String _password;
  String _errorMessage;
  ApiBlocBloc auth;
  var loginBloc = LoginBloc();
RoundWidget round;
  @override
  void initState() {
    emailInputController =
        new TextEditingController(text: "testing9@webdesksolution.com");
    pwdInputController = new TextEditingController(text: "12345678");
    emailInputController.addListener(_printEmailValue);
    pwdInputController.addListener(_printPasswordValue);
    _isLoading = false;
    _errorMessage = "";
    super.initState();
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
              if (state.loginResponse.errorMessage.general_error.length > 0) {
                error = state.loginResponse.errorMessage.general_error.first;
              } else if (state.loginResponse.errorMessage.user_error.length >
                  0) {
                // error = state.loginResponse.errorMessage.user_error.first;
                this
                    .loginBloc
                    .emailChanged(ErroGen(isError: true, value: state.loginResponse.errorMessage.user_error.first));
                error = null;
              }
              if (error != null) {
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text(error),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            } else if (state is LoginApiFetchedState) {
              token = state.loginResponse.token.toString();
              auth.add(TokenGenerateEvent(token));
              _onSetOnShredPrefe(token);
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
                  round = RoundWidget();
                  return round;
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
                image: AssetImage('assets/images/splash_bg.png'),
                fit: BoxFit.cover)),
      ),
      new Form(
          key: _formKey,
          child: new ListView(
            children: <Widget>[
              _showLogo(),
              _showEmailLabel(),
              _showEmailTextField(),
              _showDivider(),
              _showPasswordLabel(),
              _showPasswordTextField(),
              _showDivider(),
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
          image: new AssetImage('assets/images/logo.png'),
          height: 50,
          width: MediaQuery.of(context).size.width,
        ),
      ),
    );
  }

  Widget _showEmailLabel() {
    return new Row(
      children: <Widget>[
        new Expanded(
          child: new Padding(
            padding: const EdgeInsets.only(left: 40.0, top: 100.0),
            child: new Text(
              "EMAIL",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(74, 172, 215, 1),
                fontSize: 15.0,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _showEmailTextField() {
    return new Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(left: 40.0, right: 40.0),
      alignment: Alignment.center,
      decoration: new BoxDecoration(
        border: Border(
            bottom: BorderSide(
                color: Color.fromRGBO(74, 172, 215, 1),
                width: 0.5,
                style: BorderStyle.solid)),
      ),
      padding: const EdgeInsets.only(left: 0.0, right: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
              child: Column(
            children: <Widget>[
              StreamBuilder<String>(
                  stream: loginBloc.email,
                  builder: (context, snapshot) {
                    return TextFormField(
                      // onChanged: (value) => loginBloc
                      //     .emailChanged(ErroGen(isError: false, value: value)),
                      keyboardType: TextInputType.emailAddress,
                      autofocus: false,
                      // initialValue: "testing9@webdesksolution.com",
                      validator: emailValidator,
                      onSaved: (value) => _email = value.trim(),
                      obscureText: false,
                      textAlign: TextAlign.left,
                      controller: emailInputController,
                      decoration: InputDecoration(
                          icon: Icon(
                            Icons.alternate_email,
                            color: Colors.grey,
                          ),
                          border: InputBorder.none,
                          hintText: "youremail@abc.com",
                          hintStyle: TextStyle(color: Colors.grey),
                          errorText: snapshot.error,
                          errorMaxLines: 1,
                          errorStyle: TextStyle(color: Colors.red)),
                    );
                  }),
            ],
          )),
        ],
      ),
    );
  }

  Widget _showPasswordLabel() {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        new Expanded(
          child: new Padding(
            padding: const EdgeInsets.only(left: 40.0),
            child: new Text(
              "PASSWORD",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(74, 172, 215, 1),
                fontSize: 15.0,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _showPasswordTextField() /**/ {
    return new Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
              color: Color.fromRGBO(74, 172, 215, 1),
              width: 0.5,
              style: BorderStyle.solid),
        ),
      ),
      padding: const EdgeInsets.only(left: 0.0, right: 10.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new Expanded(
            child: TextFormField(
              validator: passwordValidator,
              // initialValue: "admin@321",
              onSaved: (value) => _password = value.trim(),
              autofocus: false,
              obscureText: _obscureText,
              textAlign: TextAlign.left,
              controller: pwdInputController,
              decoration: InputDecoration(
                icon: Icon(
                  Icons.lock,
                  color: Colors.grey,
                ),
                border: InputBorder.none,
                hintText: '*********',
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ),
          new FlatButton(
              onPressed: _toggle,
              child: new Icon(
                _obscureText ? Icons.visibility : Icons.visibility_off,
                color: Color.fromRGBO(74, 172, 215, 1),
              ))
        ],
      ),
    );
  }

  // Initially password is obscure
  bool _obscureText = true;

  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Widget _showDivider() {
    return Divider(
      height: 24.0,
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
              color: Color.fromRGBO(74, 172, 215, 1),
              onPressed: () {
                validateAndSubmit();
              },
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Padding(
                    padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                    child: Text("LOGIN",
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
          label: 'Undo',
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
        auth.add(LoginEvent(_email, _password));
        setState(() {
          _isLoading = false;
        });
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  void _goToHomePage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }

  void _onWidgetDidBuild(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }

  void _onSetOnShredPrefe(String token) async {
    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("token", token);
  }

  void _printEmailValue() {
    print("Email text field: ${emailInputController.text}");
    loginBloc.emailChanged(
        ErroGen(isError: false, value: emailInputController.text));
  }

  void _printPasswordValue() {
    print("Password text field: ${pwdInputController.text}");
    loginBloc.passwordChanged(
        ErroGen(isError: false, value: pwdInputController.text));
  }

  void displayErrorInEmailValue(String value) {
    loginBloc.emailChanged(ErroGen(isError: true, value: value));
  }

  void displayErrorInPasswordValue(String value) {
    loginBloc.passwordChanged(ErroGen(isError: true, value: value));
  }
}
