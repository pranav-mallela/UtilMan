import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/data_provider.dart';


class ObjectExpenseScreen extends StatefulWidget {
  const ObjectExpenseScreen({Key? key, required this.objectName,required this.communityName}) : super(key: key);
  final String objectName;
  final String communityName;

  @override
  State<ObjectExpenseScreen> createState() => _ObjectExpenseScreenState();
}

class _ObjectExpenseScreenState extends State<ObjectExpenseScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (context, objectDataProvider, child) {
        
        if( objectDataProvider.objectUnresolvedExpenseMap[widget.communityName]![widget.objectName] == null || objectDataProvider.objectUnresolvedExpenseMap[widget.communityName]![widget.objectName]!.isEmpty){
          return Container(padding: EdgeInsets.symmetric(horizontal: 30, vertical: 150),child: Text("Hey there! Add your first expense in this object by tapping the + button below!",style: TextStyle(fontSize: 30),));
        } 

        return SingleChildScrollView(
          child:
            Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: List.of(objectDataProvider.objectUnresolvedExpenseMap[widget.communityName]![widget.objectName] as Iterable<Widget>)
                )
        );
              // Container (
              //   padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
              //   child: const Align(
              //     alignment: Alignment.centerLeft,
              //     // child: Text(
              //     //   "Resolved Expenses",
              //     //   style: TextStyle(
              //     //     fontSize: 20,
              //     //     fontWeight: FontWeight.normal,
              //     //   ),
              //     // ),
              //   ),
              // ),
            // ]
        // );
      },
    );
  }
}
