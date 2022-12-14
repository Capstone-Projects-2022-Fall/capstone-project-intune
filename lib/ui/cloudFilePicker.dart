import 'dart:typed_data';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:capstone_project_intune/pitch_detector.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_audio_capture/flutter_audio_capture.dart';
import 'package:pitchupdart/instrument_type.dart';
import 'package:pitchupdart/pitch_handler.dart';
import 'package:xml/xml.dart';
import 'package:capstone_project_intune/musicXML/parser.dart';
import 'package:capstone_project_intune/musicXML/data.dart';
import 'package:capstone_project_intune/notes/music-line.dart';
import 'package:capstone_project_intune/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
// import 'com.google.firebase.storage.ktx.component1';


class CloudFilePicker extends StatelessWidget {
  const CloudFilePicker({Key? key}) : super(key: key);
// This widget is the root
// of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "ListView.builder",
        theme: ThemeData(primarySwatch: Colors.green),
        debugShowCheckedModeBanner: false,
        // home : new ListViewBuilder(),  NO Need To Use Unnecessary New Keyword
        home: ListViewBuilder());
  }
}

class ListViewBuilder extends StatelessWidget {
   ListViewBuilder({Key? key}) : super(key: key);

  final auth = FirebaseAuth.instance; // Get instance of Firebase Auth
  final storageRef = FirebaseStorage.instance.ref(); // Get instance of Firebase Storage

  Future<List<String>> getFilesFromStorage() async
   {
      final user = auth.currentUser; // Get User
      var fileList = <String>[]; // Create List of File Names
      // var _value = Future<List>;

      if (user == null){return fileList;} // If No User, null safety
      else
        {
          final userID = user.uid; // Get UserID which is folder name
          print("Current UserID is: ${user.uid}");

          final fileRef = storageRef.child("MusicXMLFiles").child(userID); // get folder
          print("fileRef is: ${fileRef.name}");

          var futureList = await fileRef.listAll(); // list all files under user

          if (futureList.items.isEmpty){
            print("no files found!!!!!!!!!!!!!!!!!!!");
            return fileList;
          }
          else {
            for (var item in futureList.items)
              {
                fileList.add(item.name); // Add file name to list of file names
                print(item.name);
              }
            // fileList.add(futureList);
            return fileList; // Return list of file names
          }
        }
   }
/*
   Widget filesWidget(){
    var filesLists = getFilesFromStorage();

     return FutureBuilder<List>(
       future: getFilesFromStorage(),
       builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) { return Center(child: CircularProgressIndicator()); }
          else { return Container( child: ListView.builder(
              itemCount: snapshot.data!,
              itemBuilder: (context, index)
              {
                return Text('${filesLists[index].title}');
              }
            )
          );
          }
       }
     );

   }
*/
  @override
  Widget build(BuildContext context) {

    var filesLists = getFilesFromStorage();

      return Scaffold(
        appBar: AppBar(title: const Text("Select File")),
        body: FutureBuilder<List<String>>(
            future: getFilesFromStorage(),
            builder: (context, future) {
              if (!future.hasData) { return Center(child: CircularProgressIndicator()); }
              else { // call to DB has data
                  var listOfFiles = future.data; // get list of files
                  if (listOfFiles != null) { // has files
                    return ListView.builder(
                        itemCount: listOfFiles.length!,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(listOfFiles[index]), // display file name
                          );
                        }
                    );
                  }
                  else
                  {
                    return Center(child: const Text('No Files Found')); // no files
                  }
              }
            }
          )
        );
    }
  }

