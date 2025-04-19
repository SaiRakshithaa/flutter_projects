import 'package:flutter/material.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'Firebase_auth.dart';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController emailController=TextEditingController();
  final TextEditingController passwordController=TextEditingController();
  final TextEditingController usernameController=TextEditingController();
  String errorMessage="";
  void signUp() async{
    String email=emailController.text.trim();
    String password=passwordController.text.trim();

    String? error =await AuthService().signUp(email,password);
    if(error==null)
    {
      Navigator.pop(context);

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
        body: SingleChildScrollView(
          child: Container(
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
                height: 450,
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
                      "Sign Up",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold,color:Colors.purple),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        labelText: "Username",
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
                         signUp();
                         if(errorMessage==null)
                          Navigator.pop(context);
                        
                      },
                      style:ElevatedButton.styleFrom(backgroundColor:Colors.purple[700]),
                      child:Text("Sign Up",style:TextStyle(color:Colors.white)),
                    ),
                    SizedBox(height:10),
                    GestureDetector(
                      onTap:(){
                       
                        Navigator.pop(context);
                          
                      },
                       
                      child:RichText(
                        text:TextSpan(
                          text:"Already have an account? ",
                          style: TextStyle(color:Colors.black),
                          children: [
                            TextSpan(
                              text:"Sign In",
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
        ),
    );
  }
}
