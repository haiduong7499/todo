import 'package:do_an/screen/cate_screen.dart';
import 'package:do_an/screen/home_screen.dart';
import 'package:do_an/service/cate_service.dart';
import 'package:flutter/material.dart';

class DrawerNavigation extends StatefulWidget {
  @override
  _DrawerNavigationState createState() => _DrawerNavigationState();
}

class _DrawerNavigationState extends State<DrawerNavigation> {
  List<Widget> _categoryList = List<Widget>();

  CateService _cateService = CateService();

  @override
  initState(){
    super.initState();
    getAllCate();
  }

  getAllCate() async {
    var categories = await _cateService.readCategories();

    categories.forEach((cate) {
      setState(() {
        _categoryList.add(ListTile(
          title: Text(cate['name']),
        ));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://scontent-sin6-3.xx.fbcdn.net/v/t1.6435-9/184692966_572489580396420_4251421025968430501_n.jpg?_nc_cat=104&ccb=1-3&_nc_sid=09cbfe&_nc_ohc=ft_NY9RmNEUAX9h0ug4&_nc_ht=scontent-sin6-3.xx&oh=75085e41f9ed809acca90a372e9ebe18&oe=60E278E3'),
              ),
              accountName: Text('Nguyen Dang Hai Duong'),
              accountEmail: Text('haiduong7499@gmail.com'),
              decoration: BoxDecoration(color: Colors.blue),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => HomeScreen())),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Category'),
              onTap: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => CategoryScreen())),
            ),
            Divider(),
            Column(
              children: _categoryList,
            )
          ],
        ),
      ),
    );
  }
}
