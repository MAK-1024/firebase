import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_project/auth/presentation/views/login_view.dart';
import 'package:firebase_project/core/utils/assets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'Categories/note.dart';
import 'auth/presentation/views/register_view.dart';
import 'core/utils/app_routing.dart';

class HomePAge extends StatefulWidget {
  // final String docid;
  const HomePAge({super.key});

  @override
  State<HomePAge> createState() => _HomePAgeState();
}

class _HomePAgeState extends State<HomePAge> {


bool isLoading = true;

 final name = TextEditingController();

  List<QueryDocumentSnapshot> data = [];

  getData() async {
    QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection('Categories').where('id' , isEqualTo : FirebaseAuth.instance.currentUser!.uid).get();
    
    data.addAll(querySnapshot.docs);

    setState(() {

    });

    isLoading = false ;
  }




final _formKey = GlobalKey<FormState>();

  void NavigateHome() {
    GoRouter.of(context).pushReplacement(AppRouter.KLogin);
  }

void NavigateNote() {

}




  @override
  void dispose() {
    name.dispose();
    super.dispose();
  }

  void initState()
  {
    getData();
    super.initState();

    setState(() {

    });
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(

      floatingActionButton: FloatingActionButton(
        onPressed: ()
        {
          GoRouter.of(context).push(AppRouter.KAddCate);
        },
        child: Icon(Icons.add_circle_outline),
        backgroundColor: Colors.brown,
      ),


      appBar: AppBar(
        title: Text('HomePage'),
        actions: [
          IconButton(
          onPressed: () async{

            GoogleSignIn googleSignIn = GoogleSignIn();
            googleSignIn.disconnect();

            await FirebaseAuth.instance.signOut();
            NavigateHome();
          }, icon: Icon(Icons.logout),
          ),
        ],
      ),


          body: isLoading == true
          ? Center(child: Form(
            key: _formKey,
            child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
            CircularProgressIndicator(color: Colors.brown,),
         SizedBox(height: 15,),
            Text('Loading....',style: TextStyle(color: Colors.brown)),
        ],
      ),
          ))
          : GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisExtent: 234),
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index)
        {

             return GestureDetector(
               onTap: (){
                 Navigator.of(context).push(MaterialPageRoute(
                     builder: (context) => NoteView(docId: data[index].id,)
                 ));
               },
               child: Card(
                  child: Column(
                    children: [
                      Container(
                          padding : EdgeInsets.all(15),
                          child: Image.network('https://th.bing.com/th/id/OIP.YPLMuyPayVmEl8K9Y4Z-EwHaE8?rs=1&pid=ImgDetMain',height: 130,)),
                      Text("${data[index]['name']}",style: TextStyle(fontWeight: FontWeight.bold),),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(onPressed: ()
                          {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.warning,
                              animType: AnimType.topSlide,
                              title: 'Delete',
                              desc: 'Are you sure you want to delete this category? ',
                              btnOkOnPress: () async {
                                await FirebaseFirestore.instance.collection('Categories').doc(data[index].id).delete();
                                GoRouter.of(context).pushReplacement(AppRouter.KHome);
                              },
                              btnCancelOnPress: (){},
                            ).show();
                          },
                              icon: Icon(Icons.delete)),


                          IconButton(onPressed: ()
                          {
                            TextEditingController nameController = TextEditingController(text: data[index]['name']);

                            showDialog(
                               context: context,
                               builder: (BuildContext context)
                           {
                             return AlertDialog(
                               title: Text('Edit Category'),
                               content: TextFormField(
                                 controller: nameController,
                                 decoration: InputDecoration(
                                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(8),
                                   ),
                                   focusedBorder: OutlineInputBorder(
                                     borderSide: BorderSide(color: Colors.brown)
                                   ),
                                   labelText: 'New Name',labelStyle: TextStyle(
                                   color: Colors.brown
                                 ),
                                 ),
                                 validator: (value) {
                                   if (value == null || value.isEmpty) {
                                     return 'Please enter a name';
                                   }
                                   return null;
                                 },
                               ),
                               actions: [
                                 TextButton(
                                   onPressed: () {
                                     // Dismiss the dialog without saving changes
                                     Navigator.pop(context);
                                   },
                                   child: Text('Cancel',style: TextStyle(color: Colors.black),),
                                 ),
                                 ElevatedButton(
                                   onPressed: () async{

                                        DocumentReference docRef =
                                        FirebaseFirestore.instance.collection('Categories').doc(data[index].id);

                                        // Update the 'name' field with the new value from the TextFormField
                                        await docRef.update({'name': nameController.text});

                                        GoRouter.of(context).pushReplacement(AppRouter.KHome);
                                        Navigator.pop(context);

                                   },
                                   child: Text('Save'),
                                   style: ButtonStyle(
                                     backgroundColor: MaterialStateProperty.all<Color>(Colors.brown)
                                   ),

                                 ),
                               ],
                             );
                           },
                           );
                          },
                              icon: Icon(Icons.edit)),
                        ],
                      )
                    ],
                  ),
                ),
             );



        },

      ),

    );
  }
}
