import 'package:ecomdemo/Pages/ProductsPage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../Auth.dart';

class LogInPage extends StatelessWidget {
  const LogInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 64, 63, 63),
      appBar: AppBar(
        centerTitle: true,
        title: Text("SignIn",style: TextStyle(color: Colors.white),),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  onPrimary: Colors.black,
                  primary: Colors.white
                ),
                onPressed: (){
                  final provider = Provider.of<Auth>(context,listen: false);
                  provider.signInWithGoogle().then((value) => Navigator.of(context).
                    pushAndRemoveUntil(MaterialPageRoute(builder: (context) => ProductsPage()), (route) => false));
                }, 
                icon: Icon(FontAwesomeIcons.google,color: Colors.red,), 
                label: Text('Signin with Google')
              )
            ],
          ),
        ),
      ),
    );
  }
}