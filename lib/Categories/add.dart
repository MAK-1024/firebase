

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_project/core/utils/app_routing.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AddCate extends StatefulWidget {
  const AddCate({super.key});

  @override
  State<AddCate> createState() => _AddCateState();
}

class _AddCateState extends State<AddCate> {

  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  final namelCont = TextEditingController();








  @override
  void dispose() {
    namelCont.dispose();
    super.dispose();
  }





  CollectionReference Cates = FirebaseFirestore.instance.collection('Categories');

  Future<void> addCate() async {

   if(globalKey.currentState!.validate())
     {
       try{
         DocumentReference response = await Cates.add({'name': namelCont.text, 'id' : FirebaseAuth.instance.currentUser!.uid});
         namelCont.clear();
         AwesomeDialog(
           context: context,
           dialogType: DialogType.success,
           animType: AnimType.rightSlide,
           title: 'Success',
           desc: 'Added Successfully ',
         ).show().then((value) {
           GoRouter.of(context).replace(AppRouter.KHome);
         });



       }catch(e){
     AwesomeDialog(
     context: context,
     dialogType: DialogType.error,
     animType: AnimType.rightSlide,
     title: 'Error',
     desc: 'Failed to add Category ',
     ).show();
       }
     }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Category'),
      ),



      body: Form(
        key: globalKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                controller: namelCont,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  hintText: 'Section',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter section';
                  }
                  return null;
                },
              ),
            ),


            ElevatedButton(
              onPressed: () async
              {
                addCate();
              },
              child: Text('Add'),
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                minimumSize: MaterialStateProperty.all(Size(230, 50)),
                backgroundColor: MaterialStateProperty.all<Color>(Colors.brown),
              ),
            ),


          ],
        ),
      ),
    );
  }
}
