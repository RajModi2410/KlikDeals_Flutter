import 'package:flutter/material.dart';

class CouponList extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    final title = "ListView List ";
    return new ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(20.0),
        children: List.generate(choices.length, (index) {
                return Center(
                  child: listDetails(choice: choices[index], item: choices[index]),
                );
            })
    );
    // TODO: implement build
    // return null;
  }

}

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}


const choices =  [
const Choice(title: 'This is a Car, because its a car. So, it\'s a car. This is a Car, because its a car.', icon: Icons.directions_car),
const Choice(title: 'This is a Car, because its a car. So, it\'s a car. This is a Car, because its a car.', icon: Icons.directions_car),  
];



class listDetails extends StatelessWidget{
  // const listDetails(
    
  // )

  final Choice choice;
  final VoidCallback onTap;
  final Choice item;
  final bool selected;

  const listDetails({Key key, this.choice, this.onTap, this.item, this.selected = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.display1;
    if (selected)
    textStyle = textStyle.copyWith(color: Colors.lightGreenAccent[400]);
    return Card(
      color: Colors.white,
      child: Row(
        children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(choice.icon),
              ),
        Flexible(
                  child: new Container(
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.topLeft,
              child: Text(choice.title,textAlign: TextAlign.left,maxLines: 5, style: TextStyle(),),
          ),
        )
      ],
      crossAxisAlignment: CrossAxisAlignment.center,
      ),
    );
  }

}

