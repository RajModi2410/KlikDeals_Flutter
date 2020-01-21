import 'package:flutter/material.dart';
import 'package:klik_deals/home.dart';

import 'ProfileScreen/profile.dart';
import 'mywidgets/details.dart';
import 'CouponCode/Coupon.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'This is home page ',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      // home: MyDetailList(),
        home: Profile(),
    // home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  final _formKey = GlobalKey<FormState>();
//  final String title;
  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            // Column is also a layout widget. It takes a list of children and
            // arranges them vertically. By default, it sizes itself to fit its
            // children horizontally, and tries to be as tall as its parent.
            //
            // Invoke "debug painting" (press "p" in the console, choose the
            // "Toggle Debug Paint" action from the Flutter Inspector in Android
            // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
            // to see the wireframe for each widget.
            //
            // Column has various properties to control how it sizes itself and
            // how it positions its children. Here we use mainAxisAlignment to
            // center the children vertically; the main axis here is the vertical
            // axis because Columns are vertical (the cross axis would be
            // horizontal).
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
                      child: Material(
                        elevation: 5.0,
                        shadowColor: Colors.lightGreen,
                        child: Container(
                          color: Colors.white,
                          child: TextFormField(
                            // maxLines: 8,
                            // minLines: 6,
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                              hintText: 'Email Address',
                              // border: OutlineInputBorder(
                              //     borderRadius: BorderRadius.circular(8.0)),
                           
                            ),
                             validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter valid email';
                            }
                            return null;
                          },

                          ),
                        ),
                      ),
                    ),

                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: TextFormField(
                      //     decoration: InputDecoration(
                      //         contentPadding:
                      //             EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      //         hintText: 'Enter your email',
                      //         border: OutlineInputBorder(

                      //             //  borderRadius: BorderRadius.circular(32)
                      //             ),
                      //         fillColor: Colors.black),
                      //     validator: (value) {
                      //       if (value.isEmpty) {
                      //         return 'Please enter valid email';
                      //       }
                      //       return null;
                      //     },
                      //   ),
                      // ),

                      Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Material(
                        elevation: 5.0,
                        shadowColor: Colors.lightGreen,
                        child: Container(
                          color: Colors.white,
                          child: TextFormField(
                            // maxLines: 8,
                            // minLines: 6,
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                              hintText: 'Password',
                              // border: OutlineInputBorder(
                              //     borderRadius: BorderRadius.circular(8.0)),
                           
                            ),
                             validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter valid password';
                            }
                            return null;
                          },

                          ),
                        ),
                      ),
                    ),  



                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   //  elevation: 20.0,
                      //   child: TextFormField(
                      //     decoration: InputDecoration(
                      //       contentPadding:
                      //           EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      //       hintText: 'Enter your email',
                      //       border: OutlineInputBorder(
                      //           // borderRadius: BorderRadius.circular(32)
                      //           ),
                      //     ),
                      //     validator: (value) {
                      //       if (value.isEmpty) {
                      //         return 'Please entern valid password';
                      //       }
                      //     },
                      //   ),
                      // ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 200.0),
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                // borderRadius: new BorderRadius.circular(18.0),
                                side: BorderSide(color: Colors.white)),
                            elevation: 5.0,
                            // color: Colors.white,
                            // onPressed: (){
                            //   Navigator.push(context, MaterialPageRoute(builder: (context) => Homepage()),
                            //   );
                            // },
                            disabledColor: Colors.white,
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
