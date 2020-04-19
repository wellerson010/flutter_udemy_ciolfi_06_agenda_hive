import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../helper/contact_helper.dart';
import 'contact.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

enum Order { az, za}

class _HomeState extends State<Home> {
  Widget _contactCard(BuildContext context, Contact contact) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            children: <Widget>[
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: (contact.img != null)
                            ? FileImage(File(contact.img))
                            : AssetImage('images/person.png'),
                        fit: BoxFit.cover
                    )),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(contact.name ?? '',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 22)),
                    Text(contact.email ?? '', style: TextStyle(fontSize: 18)),
                    Text(contact.phone ?? '', style: TextStyle(fontSize: 18)),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      onTap: () {
        _showOptions(context, contact);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contatos'),
        backgroundColor: Colors.red,
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<Order>(
            itemBuilder: (context) => <PopupMenuEntry<Order>>[
              const PopupMenuItem<Order>(
                child: Text('Ordenar de A-Z'),
                value: Order.az
              ),
              const PopupMenuItem<Order>(
                  child: Text('Ordenar de Z-A'),
                  value: Order.za
              )
            ],
            onSelected: (order){},
          )
        ],
      ),
      body: FutureBuilder(
        future: Hive.openBox<Contact>('contact'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ValueListenableBuilder(
              valueListenable: Hive.box<Contact>('contact').listenable(),
              builder: (context, Box<Contact> box, widget) {
                return ListView.builder(
                    itemCount: box.length,
                    itemBuilder: (context, index) {
                      return _contactCard(context, box.get(index));
                    });
              },
            );
          }
          return Center(
            child: Text('Carregando'),
          );
        },
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showContactPage(context);
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Hive.registerAdapter(ContactAdapter());
  }

  void _showContactPage(BuildContext context, {Contact contact}) async {
    final contactReturn = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ContactPage(
              contact: contact,
            )));

    if (contactReturn != null) {
      if (contact != null) {
        contact.img = contactReturn.img;
        contact.phone = contactReturn.phone;
        contact.email = contactReturn.email;
        contact.name = contactReturn.name;

        contact.save();
      } else {
        Hive.box<Contact>('contact').add(contactReturn as Contact);
      }
    }
  }

  void _showOptions(BuildContext context, Contact contact) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
            onClosing: (){},
            builder: (context){
              return Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: FlatButton(
                        child: Text('Ligar', style: TextStyle(color: Colors.red, fontSize: 20),),
                        onPressed: (){
                          launch('tel:${contact.phone}');
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: FlatButton(
                        child: Text('Editar', style: TextStyle(color: Colors.red, fontSize: 20),),
                        onPressed: (){
                          Navigator.pop(context);
                          _showContactPage(context, contact: contact);
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: FlatButton(
                        child: Text('Remover', style: TextStyle(color: Colors.red, fontSize: 20),),
                        onPressed: (){
                          contact.delete();
                          Navigator.pop(context);
                        },
                      ),
                    )

                  ],
                ),
              );
            },
          );
        });
  }
}
