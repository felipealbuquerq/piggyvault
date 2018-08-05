import 'package:flutter/material.dart';
import 'package:piggy_flutter/bloc/user_bloc.dart';
import 'package:piggy_flutter/model/user.dart';
import 'package:piggy_flutter/providers/user_provider.dart';
import 'package:piggy_flutter/ui/page/category/category_list.dart';
import 'package:piggy_flutter/ui/page/home/home.dart';
import 'package:piggy_flutter/ui/page/login/login_page.dart';
import 'package:piggy_flutter/ui/widgets/about_tile.dart';

class CommonDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final UserBloc userBloc = UserProvider.of(context);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          drawerHeader(userBloc),
          ListTile(
            title: Text(
              "Home",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18.0),
            ),
            leading: Icon(
              Icons.home,
              color: Colors.blue,
            ),
            onTap: (() => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                )),
          ),
//          new ListTile(
//            title: Text(
//              "Accounts",
//              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18.0),
//            ),
//            leading: Icon(
//              Icons.account_balance_wallet,
//              color: Colors.green,
//            ),
//          ),
          ListTile(
            title: Text(
              "Categories",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18.0),
            ),
            leading: Icon(
              Icons.category,
              color: Colors.cyan,
            ),
            onTap: (() => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CategoryListPage()),
                )),
          ),
          Divider(),
          ListTile(
            title: Text(
              "Logout",
            ),
            leading: Icon(
              Icons.exit_to_app,
              color: Colors.red,
            ),
            onTap: (() {
              userBloc.logout().then((done) => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  ));
            }),
          ),
          Divider(),
          MyAboutTile()
        ],
      ),
    );
  }

  Widget drawerHeader(UserBloc userBloc) {
    return StreamBuilder<User>(
      stream: userBloc.user,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return UserAccountsDrawerHeader(
            accountName: Text(
              '${snapshot.data.name} ${snapshot.data.surname}',
            ),
            accountEmail: Text(
              snapshot.data.emailAddress,
            ),
            currentAccountPicture: new CircleAvatar(
//              backgroundImage: new AssetImage(UIData.pkImage),
                ),
          );
        } else {
          return DrawerHeader(child: Text('User not logged in'),);
        }
      },
    );
  }
}
