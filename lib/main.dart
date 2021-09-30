import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Declare Importations for the program

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DataFromAPI(),
    );
  }
}

//initialize the main function


//This is the DataFromAPI class that is declared in the "home:" of MaterialApp()
//It's a Stateful widget

class DataFromAPI extends StatefulWidget {
  const DataFromAPI({Key? key}) : super(key: key);

  @override
  _DataFromAPIState createState() => _DataFromAPIState();
}

class _DataFromAPIState extends State<DataFromAPI> {

  List<User> users = [];
  //The out to be expected is a list

  void getUserData() async{
    // The getUserData() is the function that is holding the http.get to hold the URI (the Json file)

    try{
      /*NEVER FORGET: Always use the Try Catch for th async and await so the app
      doesn't break, it will always throw an exeception instead of blowing up*/
      var response =
      await http.get(Uri.parse("http://jsonplaceholder.typicode.com/users"));


      // Note: the dynamic attached to the list means that the list can be Of any value.
      List<dynamic> jsonData = [];
      jsonData = jsonDecode(response.body);
      /* The jsonDecode means that the Document called is its actual format but
      * for you to see it, the code has to be converted .toString. (Check below)*/
      print(jsonData.toString());

      /*these next 3 lines mean that they're calling each values from the list*/
      jsonData.forEach((e){
          User user = User.fromJson(e);
          users.add(user);
      });

      setState((){});
      print(users.length);
      // for (var u in jsonData){
      //   User user = User.fromJson(u);
      //   users.add(user);
      //   print(users.length);
      //   //print("aaaa: " + u);
      // }

      // return users;
    }catch(e){
      print(e.toString());
    }

  }

  @override
  void initState(){
      super.initState();
      getUserData();
  }


  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('User Data'),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Card(
        child: users.length == 0 ? Container(
            width: 30,
            height: 30,
            child: Center(child: CircularProgressIndicator())) : ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, int i){

              User user = users[i];
          return new ListTile(
            title: Text(user.name),
            subtitle: Text(user.userName),
            trailing: Text(user.email),
          );
        })
      ),
      )
    );
  }
}


// if (null != snapshot.data!){
//   return Container(child: Center(child: CircularProgressIndicator() ,),);
// }else {
//   return ListView.builder(
//     itemCount: snapshot.data ?? snapshot.data!.length,
//     itemBuilder: (context, int i){
//   return new ListTile(
//     title: Text(snapshot.data[i].name),
//     subtitle: Text(snapshot.data[i].userName),
//     trailing: Text(snapshot.data[i].email),
//   );
// });
// }

class User{
  final String name;
  final String email;
  final String userName;

  User({
    required this.name,
    required this.email,
    required this.userName,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] == null ? ""  : json['name'],
      email: json['email'] == null ? ""  : json['email'],
      userName: json['username'] == null ? ""  : json['username'],
    );
  }
}
