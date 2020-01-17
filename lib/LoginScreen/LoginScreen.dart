import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => new _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Form(
                  key: _formKey,
                  child: Column(
                    verticalDirection: VerticalDirection.down,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(48.0),
                          child: Image(
                            width: 100.0,
                            height: 100.0,
                            image: AssetImage("images/color samples-01.png"),
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          "Vendor Login",
                          style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 34.0),
                        ),
                      ),
                      Center(
                          child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Text(
                          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy",
                          style: TextStyle(fontSize: 16.0),
                        ),
                      )),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                              hintText: 'Enter your email',
                              border: OutlineInputBorder(

                                  //  borderRadius: BorderRadius.circular(32)
                                  ),
                              fillColor: Colors.black),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter valid email';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        //  elevation: 20.0,
                        child: TextFormField(
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                            hintText: 'Enter your email',
                            border: OutlineInputBorder(
                                // borderRadius: BorderRadius.circular(32)
                                ),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please entern valid password';
                            }
                          },
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 200.0),
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                // borderRadius: new BorderRadius.circular(18.0),
                                side: BorderSide(color: Colors.white)),
                            elevation: 5.0,
                            color: Color(0xff01A0C7),
                            // onPressed: (){
                            //   Navigator.push(context, MaterialPageRoute(builder: (context) => Homepage()),
                            //   );
                            // },
                            child: Text("Forget Password?",
                                style: TextStyle(
                                    fontFamily: 'Montserrat', fontSize: 14.0)),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FloatingActionButton(
                              // color: Color(0xff01A0C7),

                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  // Process data.
                                }
                              },
                              tooltip: 'Increment',
                              child: Icon(Icons.add),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
