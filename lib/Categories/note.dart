import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/utils/app_routing.dart';

class NoteView extends StatefulWidget {

  final String docId;


  const NoteView({super.key, required this.docId});

  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  bool showHint = true;
  bool isLoading = true;
  List<QueryDocumentSnapshot> data = [];
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  final notelCont = TextEditingController();






  Future<void> addNote() async {
    CollectionReference Notes = FirebaseFirestore.instance.collection('Categories').doc(widget.docId).collection('notes');

    DocumentReference response = await Notes.add({'note': notelCont.text, 'id' : FirebaseAuth.instance.currentUser!.uid});
    notelCont.clear();
    Navigator.pop(context);
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.rightSlide,
      title: 'Success',
      desc: 'Added Successfully ',
    ).show().then((value) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => NoteView(docId: widget.docId,)
      ));
    });

    setState(() {

    });

    isLoading = false ;

  }



  getData() async {
    QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection('Categories').doc(widget.docId).collection('notes').get();

    data.addAll(querySnapshot.docs);

    setState(() {

    });

    isLoading = false ;
  }

  void initState()
  {
    getData();
    super.initState();

    setState(() {

    });


    if (showHint) {
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Container(
              alignment: Alignment.center,
              height: 40, // Adjust height as needed
              child: Text('one tap on a note to edit , and double tap to delete it', textAlign: TextAlign.center),
            ),
            duration: Duration(seconds: 2), // Adjust duration as needed
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.symmetric(horizontal: 20), // Adjust horizontal margin as needed
          ),
        );
        setState(() {
          showHint = false; // Set the flag to false to prevent the hint from showing again
        });
      });
    }
  }


  @override
  void dispose() {
   notelCont.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text('Notes'),


        actions: [
          IconButton(onPressed: ()
          {


            showDialog(
              context: context,
              builder: (BuildContext context)
              {
                return AlertDialog(
                  title: Text('Add Note'),
                  content: TextFormField(
                    controller: notelCont,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.brown)
                      ),
                      labelText: 'Enter Note',labelStyle: TextStyle(
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
                      onPressed: () async
                      {
                        await addNote();
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




          }, icon: Icon(Icons.add))
        ],
      ),


      body: isLoading == true
          ? Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Colors.brown,),
          SizedBox(height: 15,),
          Text('Loading....',style: TextStyle(color: Colors.brown)),
        ],
      ))
          : Form(
           key: globalKey,
            child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1, mainAxisExtent: 80),
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index)
        {


            return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20,),
                  Container(
                    width: 350,
                    height: 60,
                    child: GestureDetector(
                      onDoubleTap: ()
                      {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.warning,
                          animType: AnimType.topSlide,
                          title: 'Delete',
                          desc: 'Are you sure you want to delete this Note? ',
                          btnOkOnPress: () async {
                            await FirebaseFirestore.instance
                                .collection('Categories')
                                .doc(widget.docId)
                                .collection('notes')
                                .doc(data[index].id)
                                .delete();
                            Navigator.of(context).pushReplacement(MaterialPageRoute(
                                builder: (context) => NoteView(docId: widget.docId,)
                            ));
                          },
                          btnCancelOnPress: (){},
                        ).show();
                      },
                      onTap: () {

                        TextEditingController noteController = TextEditingController(text: data[index]['note']);

                        showDialog(context: context,
                            builder: (BuildContext context)
                            {
                              return AlertDialog(
                                title: Text('Edit Note'),
                                content: TextFormField(
                                  controller: noteController,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.brown)
                                    ),
                                    labelText: 'New Note',labelStyle: TextStyle(
                                      color: Colors.brown
                                  ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter a Note';
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

                                      try {
                                        await FirebaseFirestore.instance
                                            .collection('Categories')
                                            .doc(widget.docId)
                                            .collection('notes')
                                            .doc(data[index].id)
                                            .update({'note': noteController.text});


                                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                                            builder: (context) => NoteView(docId: widget.docId,)
                                        ));
                                        Navigator.pop(context);
                                      } on Exception catch (e) {
                                        print(e.toString());
                                      }

                                    },
                                    child: Text('Save'),
                                    style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all<Color>(Colors.brown)
                                    ),

                                  ),
                                ],
                              );
                            }
                        );
                      },
                      child: Card(
                          child:Container(child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "${data[index]['note']}",style: TextStyle(fontWeight: FontWeight.w700 , fontSize: 16 , overflow: TextOverflow.clip),
                                ),
                              ),
                              ),

                      ),
                    ),
                  )],

            );

            Row(
              children: [
                IconButton(onPressed: ()
                {
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.warning,
                    animType: AnimType.topSlide,
                    title: 'Delete',
                    desc: 'Are you sure you want to delete this Note? ',
                    btnOkOnPress: () async {
                      await FirebaseFirestore.instance
                          .collection('Categories')
                          .doc(widget.docId)
                          .collection('notes')
                          .doc(data[index].id)
                          .delete();
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => NoteView(docId: widget.docId,)
                      ));
                    },
                    btnCancelOnPress: (){},
                  ).show();
                }, icon: Icon(Icons.delete_forever_outlined)),







//**************************************************************************************************************************************************





                IconButton(onPressed: () {

                  TextEditingController noteController = TextEditingController(text: data[index]['note']);

                  showDialog(context: context,
                      builder: (BuildContext context)
                      {
                        return AlertDialog(
                          title: Text('Edit Note'),
                          content: TextFormField(
                            controller: noteController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.brown)
                              ),
                              labelText: 'New Note',labelStyle: TextStyle(
                                color: Colors.brown
                            ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a Note';
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

                                try {
                                  await FirebaseFirestore.instance
                                      .collection('Categories')
                                      .doc(widget.docId)
                                      .collection('notes')
                                      .doc(data[index].id)
                                      .update({'note': noteController.text});


                                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                                      builder: (context) => NoteView(docId: widget.docId,)
                                  ));
                                  Navigator.pop(context);
                                } on Exception catch (e) {
                                  print(e.toString());
                                }

                              },
                              child: Text('Save'),
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(Colors.brown)
                              ),

                            ),
                          ],
                        );
                      }
                  );
                },


                    icon: Icon(Icons.edit_note)),
              ],
            );

        },

      ),
          ),
    );
  }


}
