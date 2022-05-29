import 'package:ecomdemo/Auth.dart';
import 'package:ecomdemo/Pages/DetailPage.dart';
import 'package:ecomdemo/Pages/LoginPage.dart';
import 'package:ecomdemo/Pages/ProductsPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context)=>Auth() ,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
       useMaterial3: true,
          primarySwatch: Colors.red
        ),
        home: Home()
      ),
    );
  }
}
class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){
          return Center(
          child: CircularProgressIndicator(),
        );
        }
        else if(snapshot.hasData){
          return LogInPage();
        }
        else if(snapshot.hasError){
          return Center(child: Text("Something Went Wrong"),);
        }
        else{
          return LogInPage();
        }
        
      }
    );
  }
}