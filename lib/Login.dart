import 'package:flutter/material.dart';
import 'Signup.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'Firebase_auth.dart';
import 'Main_page.dart';
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  
  final TextEditingController emailController=TextEditingController();
  final TextEditingController passwordController=TextEditingController();
  String errorMessage="";
  void login() async{
    String email=emailController.text.trim();
    String password=passwordController.text.trim();
    

    String? error=await AuthService().signIn(email,password);
    if(error==null)
    {
     Navigator.push(context, MaterialPageRoute(builder: (context)=>MainPage()));

    }else
    {
      setState(() {
        errorMessage=error;
      });
      
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('AlgoScheduler',style:TextStyle(
            color:Colors.white,
          ),),
          backgroundColor: Colors.purple,
          centerTitle: true,
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple[100]!, Colors.purple[400]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        
        child: Center(
          //child: Text('This is the first time guyyys!'),
          child: Padding(
            padding:EdgeInsets.symmetric(vertical: 30),
            child: Container(
              padding: EdgeInsets.all(25),
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 12,
                    color: Colors.black26,
                    spreadRadius: 3,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "LOGIN",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold,color:Colors.purple),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller:emailController,
                    decoration: InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Password",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height:10),
                  if(errorMessage.isNotEmpty)
                    Text(errorMessage,style:TextStyle(color:Colors.red)),
                  SizedBox(height:10),
                  ElevatedButton(
                    onPressed:(){
                      //Navigator.push(
                        //context,MaterialPageRoute(builder:(context)=>MainPage())
                      //);
                      login();
                    },
                    style:ElevatedButton.styleFrom(backgroundColor:Colors.purple[700]),
                    child:Text("Login",style:TextStyle(color:Colors.white)),
                  ),
                  SizedBox(height:10),
                  GestureDetector(
                    onTap:(){
                      Navigator.push(
                        context,MaterialPageRoute(builder: (context)=>SignUpScreen()),);
                    },
                    child:RichText(
                      text:TextSpan(
                        text:"Don't have an account? ",
                        style: TextStyle(color:Colors.black),
                        children: [
                          TextSpan(
                            text:"Sign up",
                            style:TextStyle(
                              color:Colors.blue,
                              fontWeight:FontWeight.bold,
                            ),
                          ),
                        ],
                      ) ,)
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      );
  }
}
