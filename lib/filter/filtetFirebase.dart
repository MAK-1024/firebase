import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FilterFirebase extends StatefulWidget {
  const FilterFirebase({super.key});

  @override
  State<FilterFirebase> createState() => _FilterFirebaseState();
}

class _FilterFirebaseState extends State<FilterFirebase> {

  List<QueryDocumentSnapshot> data = [];


  getData() async {

    CollectionReference users = FirebaseFirestore.instance.collection('users');

    QuerySnapshot usersData = await users.orderBy('name', descending: false).get();

    usersData.docs.forEach((element){
    data.add(element);
    });

    setState(() {

    });
  }


  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1, mainAxisExtent: 100),
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20,),
              Card(
               child: ListTile(
               subtitle: Text("age : ${data[index]['age']}" , style: TextStyle(fontWeight: FontWeight.bold),),
                 title: Text("${data[index]['name']}", style: TextStyle(fontWeight: FontWeight.bold , fontSize: 18)),
                ),

              )
            ],

          );
        }),
    );
  }
}
