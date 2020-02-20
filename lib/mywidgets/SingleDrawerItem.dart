import 'package:flutter/material.dart';
import 'package:klik_deals/ApiBloc/models/DrawerItem.dart';

typedef ClickCallback = void Function(int index);

class SingleDrawerItem1 extends StatelessWidget {
  final int currentIndex;
  final DrawerItem item;
  final ClickCallback onClicked;
  final int selectedIndex;

  SingleDrawerItem1({
    Key key,
    this.item,
    this.onClicked,
    this.currentIndex,
    this.selectedIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        color: currentIndex == selectedIndex ? Theme.of(context).primaryColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Container(
            // color: this.selectedIndex == this.currentIndex ? Theme.of(context).primaryColor: Colors.white,
            child: SizedBox(
              height: 56,
              child: new Row(children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: SizedBox(
                      height: 20,
                      width: 20,
                      // child: Image.asset('assets/images/home_menu.png')
                      child: getImage()),
                                      ),
                                      // InkWell(
                                      // child: new Text('HOME'),
                                      // child:
                                      new Text(item.title,
                                      style: TextStyle(
                                        color: currentIndex != selectedIndex ? Theme.of(context).primaryColor: Colors.white,
                                      ),),
                                    ]),
                                  ),
                                ),
                              ),
                            ),
                            onTap: () {
                              // Navigator.pop(context);
                              // _goToHome();
                              onClicked(currentIndex);
                            },
                          );
                        }
                      
                        getImage() {
                          if(selectedIndex == currentIndex){
return Image.asset(item.selecteImage);
                          }else{
                          return Image.asset(item.imagePath);
                          }
                        }
}
