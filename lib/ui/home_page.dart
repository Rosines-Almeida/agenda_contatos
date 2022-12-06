import 'package:agenda_contatos/helpers/contact_helper.dart';
import 'package:agenda_contatos/ui/contact_page.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
 ContactHelper helper = ContactHelper();
 late List<Contact> contactsList = [];

  @override
  void initState() {
    super.initState();

    helper.getAllContacts().then((list) {
      setState(() {
           contactsList = list;
      });
   
    });

    // Contact c = Contact();
    // c.name = 'nina';
    // c.email = 'nina';
    // c.phone = '5505';
    // c.img = 'testeNina';

    // helper.saveContact(c);

    // helper.getAllContacts().then((list){
    //   var  lista = list; 
    //   print('l $lista');
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( 
        title: const Text('Contatos'),
        backgroundColor: Colors.pink[600],
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: (){ 
          _showContactPage();
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.pink[600],
      ),
      body: ListView.builder(
        itemCount: contactsList.length,
        itemBuilder: (context, index){
          return _contactCard(context, index);
        }
        
        )
    );
  }

Widget _contactCard(BuildContext context, int index){
  return GestureDetector(
    onTap: (){
      _showContactPage(contact: contactsList[index]);
    },
      child: Card(
        child: Padding(
           padding: const EdgeInsets.all(10),
           child: Row(
            children:[ 
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: AssetImage("images/person.jpg"),
                    ), 
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10), 
                child: Column(
                  children: [
                    Text(
                      contactsList[index].name ?? ''
                    ),
                     Text(
                      contactsList[index].email ?? ''
                    ),
                     Text(
                      contactsList[index].phone ?? ''
                    ),
                  ],
                ),
                ) 
            ]
             ),
           )
        ,
        ),
  );
  
  }

  void _showContactPage({Contact ? contact}) async {
    final recContact = await Navigator.push(context, MaterialPageRoute(builder: (context)=>ContactPage(contact: contact))
    );
    print(recContact);
    if(recContact !=null){
      if(contact !=null){
        await helper.updateContact(recContact);
      }else{
        await helper.saveContact(recContact);
      }
      _getAllContact();
    }
  }

  void _getAllContact(){
 
    helper.getAllContacts().then((list) { 
      setState(() {
        contactsList = list;
      });
    });
  }

}

  
