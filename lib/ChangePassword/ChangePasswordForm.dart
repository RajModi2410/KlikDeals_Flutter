import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vendor/ApiBloc/ApiBloc_bloc.dart';
import 'package:vendor/ApiBloc/ApiBloc_event.dart';
import 'package:vendor/ApiBloc/ApiBloc_state.dart';
import 'package:vendor/AppLocalizations.dart';
import 'package:vendor/ChangePassword/ChangePasswordState.dart';
import 'package:vendor/LoginScreen/ApprovedByPopupScreen.dart';
import 'package:vendor/LoginScreen/CPBloc.dart';
import 'package:vendor/LoginScreen/ErrorGen.dart';
import 'package:vendor/LoginScreen/LoginBloc.dart';
import 'package:vendor/LoginScreen/LoginPage.dart';
import 'package:vendor/LoginScreen/LoginStates.dart';
import 'package:vendor/LoginScreen/PasswordResetDialog.dart';
import 'package:vendor/ProfileScreen/Profile_bloc.dart';
import 'package:vendor/commons/AuthUtils.dart';
import 'package:vendor/commons/CenterLoadingIndicator.dart';
import 'package:vendor/myWidgets/HomeMainTab.dart';
import 'package:vendor/myWidgets/NoNetworkWidget.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'ErrorGen.dart';

ProgressDialog pr;
var token = "";
SharedPreferences sharedPreferences;

class ChangePasswordForm extends StatefulWidget {
  final ClickCallback callback;

  const ChangePasswordForm({Key key, this.callback}) : super(key: key);

  @override
  State<ChangePasswordForm> createState() =>
      _ChangePasswordFormState(this.callback);
}

String passwordValidator(String value) {
  int minLength = 8;
  int maxLength = 15;
  if (value.isEmpty) {
    return 'Password is empty.';
  } else if (value.length < minLength) {
    return 'Password must be longer than $minLength characters.';
  } else if (value.length > maxLength) {
    return 'Password must be smaller than $maxLength characters.';
  } else {
    return null;
  }
}

String oldPasswordValidator(String value) {
  int minLength = 6;
  if (value.isEmpty) {
    return 'Old Password is empty.';
  } else if (value.length < minLength) {
    return 'Old Password must be longer than $minLength characters.';
  } else {
    return null;
  }
}

class _ChangePasswordFormState extends State<ChangePasswordForm> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController oldPasswordInputController;
  TextEditingController pwdInputController;
  String _oldPassword;
  String _password;
  String _errorMessage;
  ProfileBloc auth;
  var loginBloc = CPBloc();
  final ClickCallback callback;
  ApiBlocEvent lastEvent;

  _ChangePasswordFormState(this.callback);

  @override
  void initState() {
    oldPasswordInputController = new TextEditingController();
    pwdInputController = new TextEditingController();
    oldPasswordInputController.addListener(_printOldPasswordValue);
    pwdInputController.addListener(_printPasswordValue);
    _errorMessage = "";
    super.initState();
  }

  @override
  void dispose() {
    oldPasswordInputController?.dispose();
    pwdInputController?.dispose();
    loginBloc = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    auth = BlocProvider.of<ProfileBloc>(context);
    return Stack(children: <Widget>[
      _showForm(context),
      BlocListener<ProfileBloc , ApiBlocState>(
          bloc: auth,
          listener: (context, state) {
            if (state is ChangePasswordErrorState) {
              String error = "";
              if (state
                      .changePasswordResponse.errorMessage.generalError.length >
                  0) {
                error = state
                    .changePasswordResponse.errorMessage.generalError.first;
                print("We got the error in LOGIN VALUE::$error");
              } else if (state
                      .changePasswordResponse.errorMessage.userError.length >
                  0) {
                // error = state.loginResponse.errorMessage.user_error.first;
                this.loginBloc.oldPasswordChanged(ErrorGen(
                    isError: true,
                    value: state
                        .changePasswordResponse.errorMessage.userError.first));
                print("We got the error in ChnagePassword VALUE::$error");
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
            } else if (state is ChangePasswordSuccessState) {
              token = state.changePasswordResponse.message;
              showDialogForChangePassword(token);
            }
          },
          child: BlocBuilder<ProfileBloc, ApiBlocState>(
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

  Widget _showForm(BuildContext context) {
    return Stack(children: <Widget>[
      new Form(
          key: _formKey,
          child: Center(
            child: SingleChildScrollView(
              child: Column(children: <Widget>[
                _showOldPasswordTextField(),
                _showPasswordTextField(),
                _showLoginButton(auth),
              ]),
            ),
          )),
      Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            children: <Widget>[_showErrorMessage()],
          ))
    ]);
  }

  Widget _showOldPasswordTextField() {
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
                        validator: oldPasswordValidator,
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            decoration: TextDecoration.none),
                        onChanged: (value) => loginBloc.oldPasswordChanged(
                            ErrorGen(isError: false, value: value)),
                        keyboardType: TextInputType.emailAddress,
                        autofocus: false,
                        // initialValue: "testing9@webdesksolution.com",
                        onSaved: (value) => _oldPassword = value.trim(),
                        obscureText: true,
                        textAlign: TextAlign.left,
                        controller: oldPasswordInputController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock_outline,
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
                          hintText: "Old Password",
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
                  color: Theme.of(context).primaryColor,
                ),
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
                  hintText: AppLocalizations.of(context)
                      .translate("label_newpassword"),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _showLoginButton(ProfileBloc auth) {
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
                        AppLocalizations.of(context).translate("label_save"),
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
    print("validateAndSubmit  $_oldPassword and $_password");
    if (validateAndSave()) {
      try {
        lastEvent = ChangePasswordEvent(_oldPassword, _password);
        auth.add(lastEvent);
        setState(() {});
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  void _printOldPasswordValue() {
    print("Email text field: ${oldPasswordInputController.text}");
    loginBloc.oldPasswordChanged(
        ErrorGen(isError: false, value: oldPasswordInputController.text));
  }

  void _printPasswordValue() {
    print("Password text field: ${pwdInputController.text}");
    loginBloc.passwordChanged(
        ErrorGen(isError: false, value: pwdInputController.text));
  }

  void displayErrorInEmailValue(String value) {
    loginBloc.oldPasswordChanged(ErrorGen(isError: true, value: value));
  }

  void displayErrorInPasswordValue(String value) {
    loginBloc.passwordChanged(ErrorGen(isError: true, value: value));
  }

  void retryCall() {
    if (lastEvent != null) {
      auth.add(lastEvent);
    }
  }

  void showDialogForChangePassword(String message) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) =>
          PasswordResetDialog("Reset Password", true, message),
    ).then((approvedBy) {
      print("we got approved $approvedBy");
      Navigator.of(context).pop();
    });
  }
}
