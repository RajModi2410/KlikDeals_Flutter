import 'dart:wasm';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klik_deals/ApiBloc/ApiBloc_bloc.dart';
import 'package:klik_deals/ApiBloc/ApiBloc_event.dart';
import 'package:klik_deals/ApiBloc/ApiBloc_state.dart';
import 'package:klik_deals/ApiBloc/models/CouponListResponse.dart';
import 'package:shared_preferences/shared_preferences.dart';

var token = "";
SharedPreferences sharedPreferences;

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _HomePage();
}

class _HomePage extends State<HomeScreen> {
  bool _isLoading;
  ApiBlocBloc auth;
  int _perpage = 10;
  var choices;

  @override
  Widget build(BuildContext context) {
    auth = BlocProvider.of<ApiBlocBloc>(context);
    return Scaffold(
      body: BlocListener<ApiBlocBloc, ApiBlocState>(
        listener: (context, state) {
          if (state is ApiErrorState) {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text('error occurred'),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is CouponListFetchedState) {}
        },
        child: BlocBuilder<ApiBlocBloc, ApiBlocState>(
            bloc: auth,
            builder: (BuildContext context,
                ApiBlocState currentState,) {
              if (currentState is ApiFetchingState) {
                print("Home Page :: We are in frtching state.....");
              } else if (currentState is couponApiErrorState) {
                print("Home Page :: We got error.....${currentState.couponlist
                    .errorMessage.error[0]}");
              } else if (currentState is CouponListFetchedState) {
                _couponList(currentState.couponlist.response.data);
              } else if (currentState is ApiEmptyState) {
                print("Home Page :: We got empty data.....");
              }
              return Container();
            }),
      ),
    );
    // return null;
  }

  Widget _couponList(List<Data> data) {
    return new ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(20.0),
        children: List.generate(data.length, (index) {
          return Center(
              child: listDetails(data[index]));
        })
    );
  }

  @override
  void initState() {
    super.initState();
    getToken();
  }

  getToken() async {
    sharedPreferences = await SharedPreferences.getInstance();
    token = sharedPreferences.getString("token");
    if (token.isNotEmpty) {
      getCouponList();
    } else {}
    print("Home Page :: We got Token $token");
  }

  void getCouponList() {
    try {
      auth.add(CouponListEvent(_perpage));
    } catch (e) {
      print("Home Page :: We got error in catch.....${e.toString()}");
    }
  }
}

// ignore: camel_case_types
class listDetails extends StatelessWidget {
  Data data;

  listDetails(this.data);


  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme
        .of(context)
        .textTheme
        .display1;
    /* if (selected)
      textStyle = textStyle.copyWith(color: Colors.lightGreenAccent[400]);*/
    return Card(
        color: Colors.white,
        child: Row(
          children: <Widget>[
            new Container(
                padding: const EdgeInsets.all(8.0),
                alignment: Alignment.topLeft,
                child: Icon(
                  data.,
                  size: 80.0,
                  color: textStyle.color,
                )),
            new Expanded(
                child: new Container(
                  padding: const EdgeInsets.all(10.0),
                  alignment: Alignment.topLeft,
                  child: Text(
                    data.title,
                    style: null,
                    textAlign: TextAlign.left,
                    maxLines: 5,
                  ),
                )),
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ));
  }
}
