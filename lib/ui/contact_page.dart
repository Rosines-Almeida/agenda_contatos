 
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
  late Contact? _editedContact;
  final nameControler = TextEditingController();
  final emailControler = TextEditingController();
  final phoneControler = TextEditingController();
 
final _nameFocus = FocusNode();
  @override
  void initState() {
    super.initState();
    if (widget.contact == null) {
      _editedContact = Contact();
    } else {
      _editedContact = Contact.fromMap(widget.contact!.toMap());
      emailControler.text = _editedContact!.email!;
      nameControler.text= _editedContact!.name!;
      phoneControler.text = _editedContact!.phone!; 
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
       onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.pink[600],
          title: Text(_editedContact!.name ?? ' Novo contato'),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
              if( _editedContact!.name !=null && _editedContact!.name!.isNotEmpty){
                print(context);
                Navigator.pop(context, _editedContact);
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
                onTap: (){
                  print('camera');
                      ImagePicker()
                       .getImage(
                        source: ImageSource.camera ,  
                        maxWidth: 1800,
                        maxHeight: 1800,
                        )
                      .then((file) { 
                        if (file == null) { 
                      return;
                    }
                       setState(() {
                           _editedContact!.img = file.path;
                       });
                      });
                },
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image:  _editedContact!.img != null
                             ? FileImage(File(_editedContact!.img!)) 
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
                    _editedContact!.name = text;
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
                setState(() {
                    _editedContact!.email = text;
                });
              
                 _userEdited = true;
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
                 _userEdited = true;
                 setState(() {
                    _editedContact!.phone = text;
                 });
                   
                  }
            )
            ],
    
          ),
        ),
      ),
    );
  }

  Future <bool> _requestPop(){
    if(_userEdited){
      showDialog(context: context, 
        builder: (builder){
        return  AlertDialog(
        title: Text('Descartar aletraçao'),
        content: Text('Se sair as aletrações serãoperdidas.'),
        actions: [
          FloatingActionButton(
            child: Text('cancelar'),
            onPressed: (){
              Navigator.pop(context);
            }
          ),
             FloatingActionButton(
            child: Text('Sim'),
            onPressed: (){
               Navigator.pop(context);
              Navigator.pop(context); 
            }
          ),
        ],
      );
        }
      );
      return Future.value(false);
    }
    else{
      return Future.value(true);
    }

  }


}
