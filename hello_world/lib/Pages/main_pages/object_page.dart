//create a page for an object.dart that consists of two screens in two separate tabs; namely Expenses and Services
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:hello_world/Pages/add_from_pages/add_from_object_page.dart';
import 'package:hello_world/Pages/profile_pages/profile_page.dart';
import 'package:hello_world/screens/objects_screens/object_expense.dart';
import 'package:hello_world/Pages/main_pages/navigation_page.dart';

import '../../provider/data_provider.dart';
import 'package:provider/provider.dart';

import 'no_internet_page.dart';

class ObjectPage extends StatefulWidget {
  final String creatorTuple;
  final String objectName;
  const ObjectPage({Key? key, required this.objectName, required this.creatorTuple}) : super(key: key);

  @override
  State<ObjectPage> createState() => _ObjectPageState();
}

class _ObjectPageState extends State<ObjectPage> {
  @override
  Widget build(BuildContext context) {
    final providerCommunity = Provider.of<DataProvider>(context, listen: false);
    return StreamBuilder<bool>(
      stream: connectivityStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!) {
            return buildScaffold(providerCommunity);
          } else {
            return const NoInternetPage();
          }
        } else {
          return buildScaffold(providerCommunity);
        }
      }
    );
  }
    buildScaffold(providerCommunity) {
      return
        Scaffold(
        appBar: AppBar(
          elevation: 1,
            leading: IconButton(
              icon: const Icon(Icons.menu, size: 30.0),
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NavigationPage()),
                );
              },
            ),
            title: Row(
              children: <Widget>[
                Image.asset(
                  '${providerCommunity.extractCommunityImagePathByName(widget.creatorTuple)}',
                  width: 40,
                  height: 40,
                ),
                SizedBox(width: 10),
                Flexible(child: Text((widget.creatorTuple).split(":")[0], overflow: TextOverflow.ellipsis,)),
              ],
            ) ,
            actions: [
              Container(
                margin: const EdgeInsets.all(5),
                padding: const EdgeInsets.all(1),
              ),
              GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfilePage(),
                      ),
                    );
                  },
                  child:
                  Container(
                    margin: const EdgeInsets.all(8),
                    // padding: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        color: Colors.white,
                        width: 1,
                      ),
                    ),
                        child: CircleAvatar(
                        radius: 15,
                        // radius: kSpacingUnit.w * 10,
                        child: Text("${providerCommunity.user?.username[0]}",style: TextStyle(fontSize: 20),),
                        ),
                  )
              )
            ],
            bottom: PreferredSize(
                preferredSize: Size.fromHeight(48.0),
                child: Container(
                  margin: EdgeInsets.only(left: 90),
                  child: Column(
                      children:[
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: 13.0,),
                              child: Text('↳ ',
                                style: TextStyle(
                                  fontSize: 30.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 10.0,top: 3),
                              child: Image.asset(
                                '${providerCommunity.extractObjectImagePathByName(widget.objectName)}',
                                width: 40,
                                height: 40,
                              ),
                            ),

                            Text(' ${widget.objectName}',
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ]
                  ),
                )
            ),
          ),
        body: DefaultTabController(
          length: 1,
          child: Builder(
            builder: (BuildContext tabContext) =>
              Scaffold(
                appBar: PreferredSize(
                  preferredSize: const Size.fromHeight(50.0),
                  child: AppBar(
                    elevation: 0,
                    bottom: const TabBar(
                    tabs: [
                      Tab(icon: Icon(Icons.currency_rupee_outlined),),
                    ],
                    indicatorColor: Colors.white,
                  ),
                ),
                ),
                body: TabBarView(
                  children: [
                    ObjectExpenseScreen(objectName: widget.objectName,communityName: widget.creatorTuple,),
                  ],
                ),
                bottomNavigationBar: BottomAppBar(
                  color: Colors.green.shade50,
                  elevation: 0,
                  shape: CircularNotchedRectangle(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      SizedBox(width: 16.0,),
                      Padding(
                        padding: const EdgeInsets.only(right: 95.0,bottom: 8),
                        child: FloatingActionButton(
                          heroTag: "BTN-15",
                          onPressed: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddFromObjectPage(selectedPage: 0, creatorTuple: widget.creatorTuple, objectName: widget.objectName),
                              ),
                            );
                          },
                          child: Icon(Icons.add),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0,bottom: 8),
                      child: FloatingActionButton(
                        heroTag: "BTN-16",
                        onPressed: () async {
                          DataProvider dataProvider =
                          Provider.of<DataProvider>(context, listen: false);
                          const snackbar1 = SnackBar(content: Text("Refreshing..."), duration: Duration(seconds: 10),);
                          ScaffoldMessenger.of(context).showSnackBar(snackbar1);
                          await dataProvider.getObjectDetails(widget.creatorTuple, widget.objectName);
                          ScaffoldMessenger.of(context).removeCurrentSnackBar();
                        },
                        child: Icon(Icons.sync),
                      ),
                      ),
                    ],
                  ),
                ),
                floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
              )
          ),
        ),
      );
    }

  Stream<bool> get connectivityStream =>
      Connectivity().onConnectivityChanged.map((ConnectivityResult result) {
        return result != ConnectivityResult.none;
      });
}
