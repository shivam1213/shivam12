import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medical/loading.dart';

class MedicineData extends StatefulWidget {

  @override
  Data createState() => Data();
}

class Data extends State<MedicineData> {
  var firebaseUser = FirebaseAuth.instance.currentUser;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Your Data'),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Retailer')
              .doc(firebaseUser.uid)
              .collection('Shopdata')
              .doc(firebaseUser.uid)
              .collection('Productdata')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: Loading());
            } else {
              return new ListView(
                  children: snapshot.data.docs.map((DocumentSnapshot document) {
                return Card(
                   child: ListTile(
                 title: Text(document.data()['productname']),
                   ),
                );
              }).toList());
            }
          }),
    );
  }
}
