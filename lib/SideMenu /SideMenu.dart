import 'package:flutter/material.dart';
import 'AboutPage.dart';
import 'Model/menu_item.dart';



class SideMenu extends StatefulWidget{
@override
  _SideMenu createState() {
    return _SideMenu();
  }}


class _SideMenu extends State<SideMenu>{
      Widget _appBarTitle;
    Color _appBarBackgroundColor;
    MenuItem _selectedMenuItem;
    List<MenuItem> _menuItems;
    List<Widget> _menuOptionWidgets = [];

 
 initState() {
    super.initState();

    _menuItems = createMenuItems();
    _selectedMenuItem = _menuItems.first;
    _appBarTitle = new Text(_menuItems.first.title);
    _appBarBackgroundColor = _menuItems.first.color;
  }


  _getMenuItemWidget(MenuItem menuItem)
  {
    return menuItem.func();   
  }

  
  _onSelectItem(MenuItem menuItem) {
    setState(() {
      _selectedMenuItem = menuItem;
      _appBarTitle = new Text(menuItem.title);
      _appBarBackgroundColor = menuItem.color;
    });
    Navigator.of(context).pop(); // close side menu
  }

 @override
  Widget build(BuildContext context) {

    _menuOptionWidgets = [];
    for (var menuItem in _menuItems){
      _menuOptionWidgets.add(
        new Container(
          decoration: new BoxDecoration(
            color: menuItem
          ),
        )
      )
    }
    // TODO: implement build
    // return null;
  }

}

// class _SideMenu extends State<SideMenu>{
  
//   @override
//   Widget build(BuildContext context) {
//     return new Scaffold(
//       appBar: new AppBar(title: new Text('Sidemenu')),
//       drawer: new Drawer(
//         child: ListView(
//           children: <Widget>[
//             new UserAccountsDrawerHeader(
//               accountName: new Text('Raj'),
//               accountEmail: new Text('testemail@test.com'),
//               currentAccountPicture: new CircleAvatar(
//                 backgroundImage: new NetworkImage('http://i.pravatar.cc/300'),
//               ),
//             ),
//             new ListTile(
//               title: new Text('About Page'),
              
//               onTap: () {
//                 Navigator.of(context).pop();
//                 Navigator.push(
//                     context,
//                     new MaterialPageRoute(
//                         builder: (BuildContext context) => new AboutPage()));
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


