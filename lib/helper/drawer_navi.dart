import 'package:do_an/screen/cate_screen.dart';
import 'package:do_an/screen/home_screen.dart';
import 'package:do_an/screen/todos_by_category.dart';
import 'package:do_an/service/cate_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:do_an/provider/google_sign_in.dart';
import 'package:provider/provider.dart';

class DrawerNavigation extends StatefulWidget {
  @override
  _DrawerNavigationState createState() => _DrawerNavigationState();
}

class _DrawerNavigationState extends State<DrawerNavigation> {
  List<Widget> _categoryList = List<Widget>();

  CateService _cateService = CateService();

  @override
  initState() {
    super.initState();
    getAllCate();
  }

  getAllCate() async {
    var categories = await _cateService.readCategories();

    categories.forEach((cate) {
      setState(() {
        _categoryList.add(InkWell(
          onTap: () => Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => new TodosByCategory(category: cate['name'],))),
          child: ListTile(
            title: Text(cate['name']),
          ),
        ));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Container(
      child: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(
                    user.photoURL),
              ),
              accountName: Text(user.displayName),
              accountEmail: Text(user.email),
              decoration: BoxDecoration(color: Colors.blue),
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Log-out'),
              onTap: () {
                final provider =
                Provider.of<GoogleSignInProvider>(context, listen: false);
                provider.logout();
              }
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => HomeScreen())),
            ),
            ListTile(
              leading: Icon(Icons.category),
              title: Text('Category'),
              onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => CategoryScreen())),
            ),
            Divider(),
            Column(
              children: _categoryList,
            ),
          ],
        ),
      ),
    );
  }
}
