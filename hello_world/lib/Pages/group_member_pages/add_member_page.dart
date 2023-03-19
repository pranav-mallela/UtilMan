import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../provider/data_provider.dart';

class AddMembers extends StatefulWidget {
  const AddMembers({Key? key}) : super(key: key);

  @override
  State<AddMembers> createState() => _AddMemberState();
}

class _AddMemberState extends State<AddMembers> {
  List<Contact>? _contacts;
  bool _permissionDenied = false;
  var selectedContacts = [];

  @override
  void initState() {
    super.initState();
    _fetchContacts();
  }

  Future _fetchContacts() async {
    if (await Permission.contacts.request().isGranted) {
      setState(() => _permissionDenied = false);
      final contacts = await FlutterContacts.getContacts(withProperties: true);
      setState(() => _contacts = contacts);
    }
    else {
      setState(() => _permissionDenied = true);
    }
  }

  @override
  Widget build(BuildContext context) {

    if(_contacts == null) return Center(child: CircularProgressIndicator(),);
    // else print("contacts: $_contacts");
    final providerCommunity = Provider.of<DataProvider>(context, listen: true);
    List<Contact> contactsOnPlatform = [];
    for (var i = 0; i < _contacts!.length; i++) {
      for( var j = 0; j < providerCommunity.allUserPhones.length; j++){
        if(_contacts![i].phones.isNotEmpty){
          String phone = _contacts![i].phones.first.number.toString().replaceAll(' ', '');
          if(phone.startsWith('+91')) {
            phone = phone.substring(3);
          }
          _contacts![i].phones.first.number = phone;
          if(phone == providerCommunity.allUserPhones[j].toString()) {
            contactsOnPlatform.add(_contacts![i]);
          }
        }
      }
    }
    // print("on platform: $contactsOnPlatform");


    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Members'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: _body(contactsOnPlatform),
    );
  }

  Widget _body(contactsOnPlatform) {
    if (_permissionDenied) return Center(child: Text('Permission denied'));
    if (contactsOnPlatform == null) return Center(child: CircularProgressIndicator());
    return Container(
      child: Column(
        children: [
          Container(
            height: selectedContacts.isEmpty ? 0 : 100,
            child:
              ListView(
                scrollDirection: Axis.horizontal,
                children: List.of(
                  selectedContacts.map(
                    (contact) => Container(
                      margin: const EdgeInsets.all(0.0),
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        radius: 30,
                        child: Text(contact.name.first, style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis,),
                      ),
                    ),
                  ),
                ),
              ),
          ),
          Expanded(
            child:
              ListView.builder(
                itemCount: contactsOnPlatform!.length,
                itemBuilder: (context, i) => ListTile(
                    leading: CircleAvatar(
                      child: Text(contactsOnPlatform![i].displayName[0]),
                    ),
                    title: Text(contactsOnPlatform![i].displayName),
                    subtitle: Text(contactsOnPlatform![i].phones.length > 0 ? contactsOnPlatform![i].phones.first.number : '(none)'),
                    trailing: Checkbox(
                      value: selectedContacts.contains(contactsOnPlatform![i]),
                      onChanged: (value) {
                        if (value == true) {
                          setState(() {
                            selectedContacts.add(contactsOnPlatform![i]);
                          });
                        } else {
                          setState(() {
                            selectedContacts.remove(contactsOnPlatform![i]);
                          });
                        }
                      },
                    ),
                  )
            )
          ),
          Container(
            margin: const EdgeInsets.all(10.0),
            child:
              FloatingActionButton.extended(
                onPressed: () {
                  Navigator.pop(context, selectedContacts);
                },
                label: Row(
                  children: const [
                    Text("Add Members"),
                  ],
                )
              ),
          ),
        ]
      ),
    );
  }
}
