import 'dart:math';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:hello_world/Pages/main_pages/object_page.dart';
import 'package:provider/provider.dart';
import '../../components/expense.dart';
import '../../components/object.dart';
import '../../provider/data_provider.dart';
import 'package:hello_world/Pages/profile_pages/profile_page.dart';
import 'package:hello_world/Pages/main_pages/navigation_page.dart';

import '../add_from_pages/add_from_community_page.dart';
import '../group_member_pages/add_member_page.dart';
import '../group_member_pages/community_info_page.dart';
import '../logs_notification_pages/logs_notification.dart';
import 'no_internet_page.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({Key? key, required this.creatorTuple}) : super(key: key);
  final String creatorTuple;

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {

  // int clickedObject = 0;
  String objectName = '';
  TextEditingController searchController = TextEditingController();
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
        return Scaffold(
          appBar: AppBar(
          leading: Container(
            width: 50,
            child: IconButton(
              icon: const Icon(Icons.menu, size: 30,),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NavigationPage()),
                );
              },
            ),
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
          ),
          actions:  [
            Container(
                margin: const EdgeInsets.all(5),
                padding: const EdgeInsets.all(1),
                child: GestureDetector(
                  onTap: ()  async{
                    List<String> notification= await providerCommunity.getNotification(widget.creatorTuple);

                    // ignore: use_build_context_synchronously
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LogsNotification(creatorTuple: widget.creatorTuple,notification: notification,),
                      ),
                    );
                  },
                  child: const Icon(Icons.notifications, size: 25,),
                )
            ),
            Container(
                margin: const EdgeInsets.all(5),
                padding: const EdgeInsets.all(1),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CommunityInfo(creatorTuple: widget.creatorTuple,),
                      ),
                    );
                  },
                  child: const Icon(Icons.group, size: 30,),
                )
            ),
            Container(
                margin: const EdgeInsets.all(5),
                padding: const EdgeInsets.all(1),
                child: GestureDetector(
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
                      margin: const EdgeInsets.all(5),
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
            )
          ],
        ),
        body: Consumer<DataProvider>(
          builder: (context, objectDataProvider, child) {
            return Container(
              child: SingleChildScrollView(
                  child:
                  Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 100,
                        width: 300,
                        margin: const EdgeInsets.only(left: 30, right: 30, top: 20, bottom: 20),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.green,
                            width: 2,
                          ),
                          color: Colors.green.shade50,
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10,
                              spreadRadius: 1,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    height: 50,
                                    width: 50,
                                    child: FloatingActionButton(
                                      heroTag: "BTN-5",
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => AddMembers(creatorTuple: widget.creatorTuple),
                                          ),
                                        );
                                      },
                                      child: const Icon(Icons.person_add),
                                    ),
                                  ),
                                  const Text(
                                    "Add Member",
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    height: 50,
                                    width: 50,
                                    child: FloatingActionButton(
                                      heroTag: "BTN-6",
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => AddFromCommunityPage(selectedPage: 0, creatorTuple: widget.creatorTuple)
                                          ),
                                        );
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.all(5),
                                        child:  Row(
                                          children: const [
                                            Text("+"),
                                            Icon(Icons.grid_view),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Text(
                                    "Add Object",
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    height: 50,
                                    width: 50,
                                    child: FloatingActionButton(
                                      heroTag: "BTN-7",
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => AddFromCommunityPage(selectedPage: 1, creatorTuple: widget.creatorTuple),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.all(8),
                                        child:  Row(
                                          children: const [
                                            Text("+"),
                                            Icon(Icons.currency_rupee_outlined),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Text(
                                    "Add Expense",
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 30, right: 30, bottom: 10),
                        child:
                        TextField(
                          controller: searchController,
                          decoration: const InputDecoration(
                            hintText: "Search",
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(25.0)),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              // clickedObject = 0;
                              objectName = "";
                            });
                          },
                        ),
                      ),
                      DefaultTabController(
                          length: 2,
                          child: Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(left: 30, right: 30, bottom: 10),
                                child: TabBar(
                                  labelColor: Colors.black,
                                  unselectedLabelColor: Colors.grey,
                                  indicatorColor: Colors.green,
                                  tabs: const [
                                    Tab(
                                      icon: Icon(Icons.grid_view),
                                    ),
                                    Tab(
                                      icon: Icon(Icons.list),
                                    ),
                                  ],
                                ),
                              ),
                            Container(
                                height: 300 + max<int>((objectDataProvider.objectUnresolvedExpenseMap[widget.creatorTuple]!["Misc"]!.length + 1), (objectDataProvider.communityObjectMap[widget.creatorTuple]!.length)) * 80.0,
                                child:
                                TabBarView(
                                  children: [
                                    SingleChildScrollView(
                                        child:
                                        Container(
                                          child:
                                          Container(
                                            child:
                                            Wrap(
                                              alignment: WrapAlignment.center,
                                                children: (objectDataProvider.communityObjectMap[widget.creatorTuple]!.length > 1) ?
                                                List.of(objectDataProvider.communityObjectMap[widget.creatorTuple]!.map((e) {
                                                  if(!e.toLowerCase().contains(searchController.text.toLowerCase().trim())) {
                                                    return SizedBox(height: 0,);
                                                  }
                                                  if(e == "Misc") {
                                                    return SizedBox(height: 0,);
                                                  }
                                                  return GestureDetector(
                                                      onTap: () {
                                                        setState(() {

                                                          objectName = e;
                                                        });
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) => ObjectPage(objectName: objectName, creatorTuple: widget.creatorTuple),
                                                          ),
                                                        );
                                                      },
                                                      child: Column (
                                                        children: [

                                                          AnimatedContainer(
                                                            width: 176,
                                                            height: 150,
                                                            margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 5),
                                                            padding: const EdgeInsets.only(left: 10.0),
                                                            decoration: BoxDecoration(
                                                              color: Colors.white,
                                                              border: Border.all(
                                                                color: Colors.green,
                                                                width: 1.0,
                                                              ),
                                                              borderRadius: BorderRadius.circular(20.0),

                                                            ),
                                                            duration: const Duration(milliseconds: 250),
                                                            curve: Curves.easeInOut,
                                                            child: Object(
                                                              name: e,
                                                              creatorTuple: widget.creatorTuple,
                                                            ),
                                                          ),
                                                          // Text(e),
                                                        ],
                                                      )
                                                  );
                                                }))
                                                    :
                                                [
                                                  Container(
                                                    margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
                                                    child: const Text(
                                                      "Hey there! Add your first object in this community using the Add Object button above!",
                                                      style: TextStyle(
                                                        fontSize: 30,
                                                        // fontWeight: FontWeight.bold,
                                                      )
                                                    ),
                                                  )
                                                ]
                                              // )
                                              // ),
                                              // ),
                                            ),
                                          ),
                                      ),
                                    ),
                                      Column(
                                        children: [
                                          Text(
                                            "Miscellaneous Expenses",
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 10,),
                                          Column(
                                              children: List.of(miscExpenses(objectDataProvider, searchController)),
                                            ),
                                          // ),
                                          if(miscExpenses(objectDataProvider, searchController).isEmpty)
                                            Column(
                                              children: [
                                                Container(
                                                  margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                                                  child:
                                                    Text(
                                                      "Hey there! Add your first miscellaneous expense in this community using the Add Expense button above and selecting the Misc object!",
                                                      style: TextStyle(fontSize: 30,)
                                                      ),
                                                )
                                              ],
                                            ),
                                        ],
                                      )
                                    ],
                                  )
                              )
                            ],
                          )
                      ),

                      SizedBox(height: 10,),
                    ],
                  )
              ),
            );
          },
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.green.withOpacity(0),
          elevation: 0,
          shape: CircularNotchedRectangle(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              SizedBox(width: 16.0),
              Padding(
                padding: const EdgeInsets.only(right: 8.0,bottom: 8),
                child: FloatingActionButton(
                  heroTag: "BTN-8",
                  onPressed: () async {
                    DataProvider dataProvider =
                    Provider.of<DataProvider>(context, listen: false);
                    const snackbar1 = SnackBar(content: Text("Refreshing..."), duration: Duration(seconds: 4),);
                    ScaffoldMessenger.of(context).showSnackBar(snackbar1);
                    await dataProvider.getCommunityDetails(widget.creatorTuple);
                  },
                  child: Icon(Icons.sync),
                ),
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      );
    }

  Stream<bool> get connectivityStream =>
      Connectivity().onConnectivityChanged.map((ConnectivityResult result) {
        return result != ConnectivityResult.none;
      });

  Iterable<Widget> miscExpenses(DataProvider objectDataProvider, TextEditingController searchController) {
    Iterable<Widget> miscExpenses =  objectDataProvider.objectUnresolvedExpenseMap[widget.creatorTuple]!["Misc"] as Iterable<Widget>;
    if(miscExpenses == null) {
      return [];
    }
    for(int i=0;i<miscExpenses.length;i++)
    {
      Expense expense = miscExpenses.elementAt(i) as Expense;
      if(!expense.description.toLowerCase().contains(searchController.text.toLowerCase().trim())) {
        miscExpenses = miscExpenses.where((element) => element != expense);
      }
    }
    return miscExpenses;
  }
}

