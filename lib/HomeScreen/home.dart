import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


var token = "";
SharedPreferences sharedPreferences;

class HomeScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new _HomePage();
}

class _HomePage extends State<HomeScreen> {


  @override
  Widget build(BuildContext context) {
    return new ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(20.0),
        children: List.generate(choices.length, (index) {
          return Center(
            child: listDetails(choice: choices[index], item: choices[index]),
          );
        }));
    // TODO: implement build
    // return null;
  }

  @override
  void initState() {
    getToken();
  }

  getToken() async {
    sharedPreferences = await SharedPreferences.getInstance();
    token = sharedPreferences.getString("token");
    print("Home Page :: We got Token $token");
  }
}
class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}

const choices = [
  const Choice(
      title:
          'This is a Car, because its a car. So, it\'s a car. This is a Car, because its a car.',
      icon: Icons.directions_car),
  const Choice(
      title:
          'This is a Car, because its a car. So, it\'s a car. This is a Car, because its a car.',
      icon: Icons.directions_car),
];

class listDetails extends StatelessWidget {

  final Choice choice;
  final VoidCallback onTap;
  final Choice item;
  final bool selected;

  const listDetails(
      {Key key, this.choice, this.onTap, this.item, this.selected = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.display1;
    if (selected)
      textStyle = textStyle.copyWith(color: Colors.lightGreenAccent[400]);
    return Card(
          color: Colors.white,
          child: Row(
              children: <Widget>[
                new Container( 
                  padding: const EdgeInsets.all(8.0),
                  alignment: Alignment.topLeft,
                  child: Icon(choice.icon, size:80.0, color: textStyle.color,)),
                new Expanded( 
                  child: new Container( 
                  padding: const EdgeInsets.all(10.0),
                  alignment: Alignment.topLeft,
                  child:                    
                    Text(choice.title, style: null, textAlign: TextAlign.left, maxLines: 5,),
                  )
                ),
            ],
           crossAxisAlignment: CrossAxisAlignment.start,
          )
    );
  }
}
