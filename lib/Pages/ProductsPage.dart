
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomdemo/Pages/LoginPage.dart';

import 'package:ecomdemo/add_to_cart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';


import '../Auth.dart';


class ProductsPage extends StatefulWidget {
  ProductsPage({Key? key}) : super(key: key);

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final user = FirebaseAuth.instance.currentUser;
 



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      drawer: Drawer(
        backgroundColor: Color.fromARGB(255, 64, 63, 63),
        child: Column(
          children: [
           UserAccountsDrawerHeader(
             decoration: BoxDecoration(
               color:  Colors.red[800]
             ),
             currentAccountPicture: CircleAvatar(
               backgroundImage: NetworkImage(user!.photoURL.toString()),
             ),
             accountName: Text( user!.displayName.toString()), 
             accountEmail: Text( user!.email.toString())
             ),
             ListTile(
               onTap: (){
                 Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AddToCart()));
               },
               title: Text('Cart',style: TextStyle(color: Colors.white)),
               trailing: Icon(CupertinoIcons.cart,color: Colors.white,),
             ),
             ListTile(
               onTap: () {
                 showDialog(
                   context: context, builder: (context){
                     return AlertDialog(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  title: const Text("Rate Us",style: TextStyle(color: Colors.brown),),
                  content: Container(
                    width: 300,
                    height: 100,
                    child: 
                        Text('This Feature will be added Soon...')
                  ),
                  actions: <Widget>[
                    TextButton(
                        onPressed: () {
                         
                          Navigator.of(context).pop();
                        },
                        child: const Text("Ok",style: TextStyle(color: Colors.red),))
                  ],
                );
                   }
                   );
               },
               title: Text('Rate Us',style: TextStyle(color: Colors.white)),
               trailing: Icon(Icons.star,color: Colors.white,),
             ),
             ListTile(
                onTap: () {
                 showDialog(
                   context: context, builder: (context){
                     return AlertDialog(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  title: const Text("Contact Us",style: TextStyle(color: Colors.brown),),
                  content: Container(
                    width: 300,
                    height: 100,
                    child: 
                        Text('This Feature will be added Soon...')
                  ),
                  actions: <Widget>[
                    TextButton(
                        onPressed: () {
                         
                          Navigator.of(context).pop();
                        },
                        child: const Text("Ok",style: TextStyle(color: Colors.red),))
                  ],
                );
                   }
                   );
               },
               title: Text('Contact Us',style: TextStyle(color: Colors.white),),
               trailing: Icon(Icons.call,color: Colors.white,),
             ),
             ListTile(
               onTap: (){
                 final provider = Provider.of<Auth>(context,listen: false);
                 provider.signOut().then((value) => Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>LogInPage()), (route) => false));
               },
               title: Text('Logout',style: TextStyle(color: Colors.white)),
               trailing: Icon(Icons.logout_sharp,color: Colors.red,)
             )
          ],
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color.fromARGB(0, 233, 134, 134),
        actions: [
          IconButton(onPressed: (){
            final provider = Provider.of<Auth>(context,listen: false);
            provider.signOut().then((value) => Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>LogInPage()), (route) => false));
          }, icon: Icon(Icons.logout,color: Colors.redAccent,))
        ],
        title: Text('Welcome ${user!.displayName}'.toString(),style: TextStyle(color: Colors.white70,fontSize: 20,fontWeight: FontWeight.bold,fontFamily: GoogleFonts.poppins().toString())),
      ),
      backgroundColor: Color.fromARGB(255, 64, 63, 63),
      body: Center(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('Products').snapshots(),
          builder: (context, snapshot) {
          
            if (snapshot.hasError) {
              return Text('Something went wrong');
            } else if (snapshot.hasData || snapshot.data != null) {
                final data = snapshot.requireData;
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: data.size,
                    itemBuilder: (BuildContext context, int index) {
                      return  InkWell(
                       onTap: (){
                         Navigator.of(context).push(
                                                      MaterialPageRoute(builder: (context){
                                                        return Scaffold(                                                    
                                                          body: SafeArea(
                                                            child: Center(
                                                              child: Column(
                                                                children: [
                                                                  Spacer(),
                                                                  Padding(
                                                                    padding: const EdgeInsets.all(16.0),
                                                                    child: Expanded(child: Text(data.docs[index]['Title'],style: TextStyle(color: Colors.redAccent,fontWeight: FontWeight.bold,fontSize: 25))),
                                                                  ),
                                                                   Spacer(),
                                                                    Text('Rating:${data.docs[index]['rating']}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                                                                  Spacer(),
                                                                  Container(
                                                                    height: 300,
                                                                    width: 300,
                                                                    child: Hero(
                                                                      tag: Key(data.docs[index]['Image']),
                                                                      child: Image.network(data.docs[index]['Image']))),
                                                                    Spacer(),
                                                                    Text('RS.${data.docs[index]['Price']}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30),),
                                                                   
                                                                    Spacer(),
                                                                  Padding(
                                                                    padding: const EdgeInsets.all(20.0),
                                                                    child: Text(
                                                                      
                                                                        'Description: ${data.docs[index]['description']}',
                                                                        maxLines: 8,
                                                                        ),
                                                                    ),

                                                                  Spacer(),
                                                                  MaterialButton(
                                                                    color: Colors.redAccent,
                                                                    minWidth: MediaQuery.of(context).size.width,
                                                                    onPressed: (){
                                                                      final provider = Provider.of<Auth>(context,listen: false);
                                                         DocumentReference documentReference = FirebaseFirestore.instance.collection(provider.googleSignIn.currentUser!.email).doc();
                                                        Map<String,dynamic> add = {
                                                          'Title':data.docs[index]['Title'].toString(),
                                                          'Price':data.docs[index]['Price'].toString(),
                                                          'Image':data.docs[index]['Image'].toString()
                                                        };
                                                        documentReference.set(add).then((value) => Scaffold.of(context).showSnackBar(
                                                            SnackBar(
                                                              content: Text('${data.docs[index]['Title']} is added to cart...')
                                                              )
                                                              )
                                                        );
    
                                                                                                              
                                                                    },
                                                                    child: Text('Add To Cart'),),
                                                                  
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      })
                                                    );
                       },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                          child: Card(
                            color: Colors.white,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 100,
                                      width: 120,
                                     child: Hero(
                                       tag: Key(data.docs[index]['Image']),
                                       child: Image.network(data.docs[index]['Image']))
                                        ),
                
                                    SizedBox(width: 5,),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(data.docs[index]['Title'],style: TextStyle(color: Colors.red,fontSize: 20,fontWeight: FontWeight.bold,fontFamily: GoogleFonts.poppins.toString()),maxLines: 2,overflow: TextOverflow.ellipsis  ,),
                                            SizedBox(height: 10,),
                                            Text('Rs.${data.docs[index]['Price'].toString()}',style: TextStyle(color: Colors.black,fontSize: 17,fontWeight: FontWeight.bold,fontFamily: GoogleFonts.poppins.toString())),
                                            SizedBox(height: 10,), 
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                 Text('Rating: ${data.docs[index]['rating']}'),
                                                IconButton(
                                                  color: Colors.red,
                                                  onPressed: (){
                                                       final provider = Provider.of<Auth>(context,listen: false);
                                                         DocumentReference documentReference = FirebaseFirestore.instance.collection(provider.googleSignIn.currentUser!.email).doc();
                                                        Map<String,dynamic> add = {
                                                          'Title':data.docs[index]['Title'].toString(),
                                                          'Price':data.docs[index]['Price'].toString(),
                                                          'Image':data.docs[index]['Image'].toString()
                                                        };
                                                        documentReference.set(add).then((value) => Scaffold.of(context).showSnackBar(
                                                            SnackBar(
                                                              content: Text('${data.docs[index]['Title']} is added to cart...')
                                                              )
                                                              )
                                                          );
                                                  }, icon: Icon(CupertinoIcons.cart_badge_plus),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            
                          ),
                        ),
                      );
                    }),
              );
            }
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.red,
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddToCart() ));
        },
        child: Icon(CupertinoIcons.cart),
      ),
    );
  }
}
Color MyColor(){
  return Color.fromARGB(255, math.Random().nextInt(256), math.Random().nextInt(256), math.Random().nextInt(256));
}