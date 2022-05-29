import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomdemo/Auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AddToCart extends StatelessWidget {

 final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    
    int total;
    final instance = FirebaseFirestore.instance.collection(user!.email.toString()).snapshots();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Cart',style: TextStyle(color: Colors.white,fontSize: 20),),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Container(
          color: Colors.redAccent,
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StreamBuilder(
       stream: FirebaseFirestore.instance
                  .collection(user!.email.toString())
                  .snapshots(),
      builder:(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                 if(snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                 } else {
                     total = 0;
                    snapshot.data!.docs.forEach((result) {
                       total += int.parse(result['Price']);
                    });
                    return Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: Text('Total: Rs.${total.toString()}',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),));
                 }}
     ),

     Padding(
       padding: const EdgeInsets.only(right: 16),
       child: ElevatedButton.icon(
         style: ElevatedButton.styleFrom(
           primary: Colors.white,
           elevation: 0
         ),
         onPressed: (){
          showDialog(context: context, builder: (context)=>AlertDialog(content: Text('Buying is not supported yet...'),actions: [TextButton(onPressed: ()=>Navigator.of(context).pop(), child:Text('Ok') )],));
         }, icon: Icon(CupertinoIcons.cart_fill), label: Text('Checkout')),
     )
            ],
          ),
          ),
        ),
      backgroundColor: Color.fromARGB(255, 64, 63, 63),
      body: Column(
        children: [
     StreamBuilder<QuerySnapshot>(
              stream: instance,
              builder: (context, snapshot) {
              
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                } else if (snapshot.hasData || snapshot.data != null) {
                    final data = snapshot.requireData;
                  return Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                           QueryDocumentSnapshot<Object?>? documentSnapshot =
                          snapshot.data?.docs[index];
                          return  Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                            child: Card(
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(width: 10,),
                                        Container(
                                          height: 100,
                                          width: 50,
                                          child: Image.network(documentSnapshot!=null?documentSnapshot['Image']:'')
                                          ),
                                          SizedBox(width: 40,),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                 Text((documentSnapshot != null) ? (documentSnapshot["Title"]):''),
                                                 SizedBox(height: 5,),
                                                 Text('Rs.${documentSnapshot!=null ? documentSnapshot['Price'] : ''}'),
                                              ],
                                            ),
                                          ),
                                           MaterialButton(onPressed: (){
                                              final provider = Provider.of<Auth>(context,listen: false);
                                                       DocumentReference documentReference = FirebaseFirestore.instance.collection(provider.googleSignIn.currentUser!.email).doc(documentSnapshot!.id);
                                                       documentReference.delete();
                                           },child: Icon(Icons.delete,color: Colors.red,),
                                           )
                                      ],
                                    ),
                                    
                                  ],
                                )
                                
                            ),
                          );
                        }),
                      
                  );
                  
                }
                return Text('You have no items in cart');
              },
            ),
        ],
      )
    );
  }
  
}

class total extends StatefulWidget {
  total({Key? key}) : super(key: key);

  @override
  State<total> createState() => _totalState();
}

class _totalState extends State<total> {
  @override
  Widget build(BuildContext context) {
    int total;
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
    body: StreamBuilder(
       stream: FirebaseFirestore.instance
          .collection(user!.email.toString())
          .snapshots(),
      builder:(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
         if(snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
         } else {
             total = 0;
            snapshot.data!.docs.forEach((result) {
               total += int.parse(result['Price']);
            });
            return Text(total.toString());
         }}
     )
    );
  }
}