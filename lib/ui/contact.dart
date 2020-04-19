import 'dart:io';

import 'package:flutter/material.dart';
import '../helper/contact_helper.dart';
import 'package:image_picker/image_picker.dart';

class ContactPage extends StatefulWidget {
  final Contact contact;

  ContactPage({this.contact});

  @override
  _ContactPage createState()=>_ContactPage();
}

class _ContactPage extends State<ContactPage>{
  Contact _contact = Contact();
  bool _userEdited = false;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nameFocus = FocusNode();

  @override
  void initState() {
    super.initState();

    if (widget.contact != null){
      _contact.name = widget.contact.name;
      _contact.img = widget.contact.img;
      _contact.email = widget.contact.email;
      _contact.phone = widget.contact.phone;
      _contact.id = widget.contact.id;

      _nameController.text = _contact.name;
      _emailController.text = _contact.email;
      _phoneController.text = _contact.phone;
    }
    else {
      _contact = Contact();
    }
  }

  _openImagePicker(ImageSource source){
    ImagePicker.pickImage(source: source).then((file) {
      if (file != null){
        setState(() {
          _contact.img = file.path;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text(_contact.name ?? 'Novo contato'),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.save),
          onPressed: () => _save(context),
          backgroundColor: Colors.red,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              GestureDetector(
                child: Container(
                  height: 140,
                  width: 140,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: _contact.img == null ? AssetImage('images/person.png'):FileImage(File(_contact.img)),
                          fit: BoxFit.cover
                      )
                  ),
                ),
                onTap: (){
                  ImageSource imageSource;

                  showModalBottomSheet(context: context, builder: (context){
                    return BottomSheet(
                      onClosing: (){},
                      builder: (build){
                        return Container(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              FlatButton(
                                child: Text('Galeria'),
                                  onPressed: (){
                                    _openImagePicker(ImageSource.gallery);
                                    Navigator.pop(context);
                                  },
                              ),
                              FlatButton(
                                child: Text('Câmera'),
                                onPressed: (){
                                  _openImagePicker(ImageSource.camera);
                                  Navigator.pop(context);
                                },
                              )
                            ],
                          ),
                        );
                      },
                    );
                  });
                },
              ),
              TextField(
                decoration: InputDecoration(
                    labelText: 'Nome'
                ),
                onChanged: (text){
                  _userEdited = true;
                  setState(() {
                    _contact.name = text;
                  });
                },
                autofocus: true,
                controller: _nameController,
                focusNode: _nameFocus,
              ),
              TextField(
                decoration: InputDecoration(
                    labelText: 'E-mail'
                ),
                onChanged: (text){
                  _userEdited = true;
                  _contact.email = text;
                },
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
              ),
              TextField(
                decoration: InputDecoration(
                    labelText: 'Telefone'
                ),
                onChanged: (text){
                  _userEdited = true;
                  _contact.phone = text;
                },
                keyboardType: TextInputType.phone,
                controller: _phoneController,
              )
            ],
          ),
        ),
      )
    );
  }

  void _save(BuildContext context){
    if (_nameController.text.isNotEmpty){
      Navigator.pop(context, _contact);
    }
    else{
      FocusScope.of(context).requestFocus(_nameFocus);
    }
  }

  Future<bool> _requestPop(){
    if (_userEdited){
      showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text('Deseja mesmo sair sem salvar?'),
            content: Text('As alterações serão perdidas'),
            actions: <Widget>[
              FlatButton(
                child: Text('Cancelar'),
                onPressed: (){
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text('Sim'),
                onPressed: (){
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              )
            ],
          );
        }
      );

      return Future.value(false);
    }
    else {
      return Future.value(true);
    }
  }
}