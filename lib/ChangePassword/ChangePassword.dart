import 'package:flutter/material.dart';
import 'package:vendor/ChangePassword/ChangePasswordForm.dart';
import 'package:vendor/myWidgets/HomeMainTab.dart';

import '../AppLocalizations.dart';

typedef ClickCallback = void Function();

class ChangePassword extends StatefulWidget {
  static const String routeName = "/changePassword";
  @override
  State<StatefulWidget> createState() => new _ChangePassword();
}

class _ChangePassword extends State<ChangePassword> with TickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
appBar: AppBar(
          title: Text(
              AppLocalizations.of(context).translate("label_changes"),
              style: Theme.of(context).textTheme.title),
          backgroundColor: Theme.of(context).primaryColor,
        ),      body: ChangePasswordForm(callback: () {
        // Navigator.of(context).pushNamed(HomeMainTab.routeName);
      }),
    );
  }
}
