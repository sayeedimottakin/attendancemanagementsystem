import 'package:flutter/material.dart';
import 'package:attendance_management_system/button_widget.dart';
import 'package:attendance_management_system/constants.dart';
import 'package:attendance_management_system/methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RemoveUser extends StatefulWidget {
  static String id = 'remove_user';
  @override
  _RemoveUserState createState() => _RemoveUserState();
}

class _RemoveUserState extends State<RemoveUser> {
  String id;
  String password;
  String type;
  String selectedClass;
  TextEditingController _idController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Digital Attendance System'),
        backgroundColor: kAppBarBackgroundColor,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            shrinkWrap: true,
            children: [
              TextField(
                controller: _idController,
                onChanged: (value){
                  id = value;
                },
                decoration: kTextDecoration.copyWith(
                    hintText: 'ID'
                ),
              ),
              TextField(
                controller: _passwordController,
                obscureText: true,
                onChanged: (value){
                  password = value;
                },
                decoration: kTextDecoration.copyWith(
                    hintText: 'Password'
                ),
              ),
              Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: ButtonWidget(
                    buttonLabel: 'Remove',
                    onPressed: () async{
                      _auth.signOut();
                      try{
                        final user = await _auth.signInWithEmailAndPassword(email: '$id@email.com', password: password);
                        if(user!=null){
                          // print(_auth.currentUser);
                          var data = await _firestore.collection('users').doc(id).get();
                          if(data.exists && data.data().isNotEmpty){
                            type = data.data()['type'];
                            if(type == 'student'){
                              selectedClass = data.data()['class'];
                              await _firestore.collection('users').doc(id).delete().then((value){
                                print('Student Deleted From User');
                              });
                              await _firestore.collection('studentList').doc(selectedClass).update({
                                'id': FieldValue.arrayRemove([id]),
                              }).then((value){
                                print('Student  Deleted from StudentList');
                              });
                              for(var month in months){
                                try{
                                  await _firestore.collection('Attendance').doc(month).collection(selectedClass).doc(id).delete().then((value){
                                    print('Student Deleted from Attendance of $month');
                                  });
                                } catch(e){
                                  print("Error");
                                }
                              }
                            }
                            else if(type == 'teacher'){
                              await _firestore.collection('users').doc(id).delete().then((value){print("Teacher deleted from user");});
                            }
                          }
                          _auth.currentUser.delete();
                        }
                        await _auth.signInWithEmailAndPassword(email: 'admin@email.com', password: '123456').then((value){print('Admin re-login successful');});
                        print(_auth.currentUser);
                      }catch(e){
                        print("Erorr on login");
                      }
                    },

                  ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
