import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klik_deals/ApiBloc/ApiBloc_bloc.dart';
import 'package:klik_deals/ApiBloc/ApiBloc_event.dart';
import 'package:klik_deals/ApiBloc/ApiBloc_state.dart';
import 'package:klik_deals/HomeScreen/home.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

ProgressDialog pr;
var token = "";
SharedPreferences sharedPreferences;

class LoginForm extends StatefulWidget {
  @override
  State<LoginForm> createState() => _LoginFormState();
  
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

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailInputController;
  TextEditingController pwdInputController;
  bool _isLoading;
  String _email;
  String _password;
  String _errorMessage;
  ApiBlocBloc auth;

  @override
  void initState() {
    emailInputController = new TextEditingController();
    pwdInputController = new TextEditingController();
    _isLoading = false;
    _errorMessage = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    pr.style(
      message: 'Please wait...',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progress: 0.0,
      maxProgress: 100.0,
      progressTextStyle: TextStyle(
          color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
    );

    auth = BlocProvider.of<ApiBlocBloc>(context);
    return BlocListener<ApiBlocBloc, ApiBlocState>(
      listener: (context, state) {
        if (state is ApiErrorState) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text('error occurred'),
              backgroundColor: Colors.red,
            ),
          );
        }else if(state is LoginApiFetchedState){
          token = state.loginResponse.token.toString();
            _onSetOnShredPrefe(token);
           _goToHomePage();
        }
      },
      child:  BlocBuilder<ApiBlocBloc, ApiBlocState>(
        bloc: auth,
        builder: (BuildContext context,
            ApiBlocState currentState,) {
          if (currentState is LoginApiFetchedState) {
            // pr.hide();
            print("Login successfully ${currentState.loginResponse.token
                    .toString()}");
            // token = currentState.loginResponse.token.toString();
            // _onSetOnShredPrefe(token);
            // _goToHomePage();
          } else if (currentState is ApiFetchingState) {
            // pr.show();
          } else if (currentState is ApiErrorState) {
            // pr.hide();
            _onWidgetDidBuild(() {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text('Please check email and password.'),
                  backgroundColor: Colors.red,
                ),
              );
            });
          }
          return Scaffold(body: _showForm());
        })
    );
  }


  Widget _showForm() {
    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
                colorFilter: new ColorFilter.mode(
                    Colors.black.withOpacity(0.05), BlendMode.dstATop),
                image: AssetImage('assets/images/mountains.jpg'),
                fit: BoxFit.cover)),
        child: SingleChildScrollView(
            child: new Form(
                key: _formKey,
                child: new Column(
                  children: <Widget>[
                    _showLogo(),
                    _showEmailLabel(),
                    _showEmailTextField(),
                    _showDivider(),
                    _showPasswordLabel(),
                    _showPasswordTextField(),
                    _showDivider(),
                    _showLoginButton(auth),
                    _showErrorMessage(),
                    _showCircularProgress()
                  ],))));
  }

  Widget _showCircularProgress() {
    // if (_isLoading) {
    //   return Center(child: CircularProgressIndicator());
    // }
    // return Container(
    //   height: 0.0,
    //   width: 0.0,
    // );
    return Container();
  }

  Widget _showLogo() {
    return Container(
      padding: EdgeInsets.all(120.0),
      child: Center(
        child: new Image(
          image: new AssetImage('assets/images/wds-logo.png'),
          height: 50,
          width: MediaQuery
              .of(context)
              .size
              .width,
        ),
      ),
    );
  }

  Widget _showEmailLabel() {
    return new Row(
      children: <Widget>[
        new Expanded(
          child: new Padding(
            padding: const EdgeInsets.only(left: 40.0),
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
      width: MediaQuery
          .of(context)
          .size
          .width,
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
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    autofocus: false,
                    initialValue: "testing.webdesksolution@gmail.com",
                    validator: emailValidator,
                    onSaved: (value) => _email = value.trim(),
                    obscureText: false,
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(
                      icon: Icon(
                        Icons.alternate_email,
                        color: Colors.grey,
                      ),
                      border: InputBorder.none,
                      hintText: "youremail@abc.com",
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              )
          ),
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
      width: MediaQuery
          .of(context)
          .size
          .width,
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
              initialValue: "testing@321",
              onSaved: (value) => _password = value.trim(),
              autofocus: false,
              obscureText: _obscureText,
              textAlign: TextAlign.left,
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
              )
          )
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
      width: MediaQuery
          .of(context)
          .size
          .width,
      margin: const EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0),
      alignment: Alignment.center,
      child: new Row(
        children: <Widget>[
          new Expanded(
            child: new FlatButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              color: Color.fromRGBO(74, 172, 215, 1),
              onPressed: () {
                pr.show();
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
    setState(() {
      sharedPreferences.setString("token", token);
      sharedPreferences.commit();
    });
  }
}
