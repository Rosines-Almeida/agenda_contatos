 
import 'dart:io'; 
import "package:flutter/material.dart";
import '../helpers/contact_helper.dart';
import 'package:image_picker/image_picker.dart';

class ContactPage extends StatefulWidget {
  // const ContactPage({Key? key}) : super(key: key);
  
  final Contact? contact;


  const ContactPage({ this.contact});

 

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  bool _userEdited = false;
  late Contact _editedContact;
   late TextEditingController emailControler = TextEditingController();
  late TextEditingController nameControler = TextEditingController();
  late TextEditingController phoneControler = TextEditingController();
final _nameFocus = FocusNode();
  @override
  void initState() {
    super.initState();
    if (widget.contact == null) {
      _editedContact = Contact();
    } else {
      _editedContact = Contact.fromMap(widget.contact!.toMap());
      emailControler = _editedContact.email as TextEditingController;
      nameControler = _editedContact.name as TextEditingController;
      phoneControler = _editedContact.phone as TextEditingController;

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink[600],
        title: Text(_editedContact.name ?? ' Novo contato'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
            if( _editedContact.name !=null){
              Navigator.pop(context);
            }else{
              FocusScope.of(context).requestFocus(_nameFocus);
            }
        },
        child: Icon(Icons.save),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [ 
            GestureDetector( 
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image:  _editedContact.img != null
                           ? FileImage(File(_editedContact.img!)) 
                              : const AssetImage("images/person.jpg") 
                                as ImageProvider,
                    ), 
                ),
              ),
          ),
          TextField( 
            focusNode: _nameFocus,
            controller: nameControler,
            decoration: InputDecoration(labelText: 'Nome'),
            onChanged: (text){
                _userEdited = true;
                setState(() {
                  _editedContact.name = text;
                });
            },

          ),
          TextField(
            controller:  emailControler,
            decoration: InputDecoration(
              labelText: 'Email',
              labelStyle: TextStyle( color: Colors.pink[900], ),
              suffixIcon: Icon( Icons.email),
              hintStyle: TextStyle(color: Colors.pink[800])
              ),
            onChanged: (text){
              _editedContact.email = text;
            },
            style: TextStyle( 
              color: Colors.blue[900],

            ),
            
            textAlign: TextAlign.start,
            keyboardType: TextInputType.emailAddress,
          ),
          TextField( 
            controller: phoneControler,
            decoration: InputDecoration(
                labelText: 'Phone', 
            ),
             onChanged:(text){
                  _editedContact.phone = text;
                }
          )
          ],

        ),
      ),
    );
  }
}
