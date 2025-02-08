import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'post.dart';

class UpdatePage extends StatefulWidget {
  const UpdatePage(this.post,{super.key});

  final Post post;

  @override
  State<UpdatePage> createState() => _UpdatePageState();
}



class _UpdatePageState extends State<UpdatePage> {
  String updatedword = "";
  Future _updateFirebaseData() async {
    await FirebaseFirestore.instance.collection("posts").doc(widget.post.id).update(
        {
          "name" : "Jetstar",
          "text" : updatedword,
          "updatedAt" : DateTime.now(),
        }
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Update Page"),),
      body: Column(
        children: [
          TextFormField(
            initialValue: widget.post.text,
            onChanged: (value){
              print(value);
              updatedword = value;
              setState(() {

              });
            },
          ),
          ElevatedButton(
            onPressed:updatedword.isEmpty ? null : (){
              //firebaseに値を追加
              _updateFirebaseData();
              Navigator.pop(context);
            },
            child: Text("更新"),
          ),
        ],
      ),
    );
  }
}
