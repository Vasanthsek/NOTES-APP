import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class EditTask extends StatefulWidget {
  var title, description, uid, time;
  EditTask({
    Key? key,
    required this.title,
    required this.description,
    required this.uid,
    required this.time,
  }) : super(key: key);

  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  TextEditingController titleController = TextEditingController(text: "");
  TextEditingController descriptionController = TextEditingController(text: "");

  updatetasktofirebase() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    String uid = user!.uid;
    var time = DateTime.now();
    await FirebaseFirestore.instance
        .collection('tasks')
        .doc(widget.uid)
        .collection('mytasks')
        .doc(widget.time)
        .update({
      'title': titleController.text,
      'description': descriptionController.text,
    });
    Fluttertoast.showToast(msg: 'Task edited');
  }

  @override
  void initState() {
    titleController = TextEditingController(text: widget.title);
    descriptionController = TextEditingController(text: widget.description);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Task')),
      body: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                child: TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                      labelText: 'Enter Title', border: OutlineInputBorder()),
                ),
              ),
              const SizedBox(height: 15),
              Container(
                child: TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                      labelText: 'Enter Description',
                      border: OutlineInputBorder()),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ButtonStyle(backgroundColor:
                        MaterialStateProperty.all(Theme.of(context).primaryColor),),
                    child: Text(
                      'Update Task',
                      style: GoogleFonts.roboto(fontSize: 18),
                    ),
                    onPressed: () {
                      updatetasktofirebase();
                      // Navigator.pop(context);
                    },
                  ))
            ],
          )),
    );
  }
}
