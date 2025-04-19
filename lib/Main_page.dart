//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_projects/Login.dart';
import 'Firebase_auth.dart';
import 'roundRobin.dart';
import 'fcfs.dart';
import 'priotity_pre.dart';
import 'nonprePriority.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("AlgoScheduler"),
          backgroundColor: Colors.purple,
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async {
                await AuthService().signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignInScreen(),
                  ),
                  (route) => false,
                );
              },
            ),
          ]),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            buildButton(context, "Round Robin", RoundRobinPage()),
            SizedBox(height: 20),
            buildButton(context, "First Come First Serve", FCFSPage()),
            SizedBox(height: 20),
            buildButton(context, "Priority(Non Premptive)", nonPrePriority()),
            SizedBox(height: 20),
            buildButton(context, "Priority(Premptive)", PriorityPrePage()),
          ],
        ),
      ),
    );
  }
}
Widget buildButton(BuildContext context,String text,Widget page){
  return ElevatedButton(
    style:ElevatedButton.styleFrom(
      backgroundColor: Colors.purple[100],
      padding:EdgeInsets.symmetric(horizontal: 40,vertical:15),
      shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    onPressed:(){
      Navigator.push(
        context,
        MaterialPageRoute(builder:(context)=>page),);
    }, 
    child:Text(
      text,
      style:TextStyle(fontSize: 18,color:Colors.purple[900]),

    ), );
}


