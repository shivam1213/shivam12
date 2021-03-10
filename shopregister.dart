import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:urbanmed/constant.dart';
import 'package:urbanmed/loading.dart';
import 'package:urbanmed/retailerLogin.dart';
import 'package:urbanmed/retailregister.dart';

// ignore: must_be_immutable
class ShopRegister extends StatefulWidget {
  final uid;

  ShopRegister(this.uid);

  //ShopRegister({Key key, this.retailer}) : super(key: key);
  // String retailer;

  @override
  Shop createState() => Shop();
}

class Shop extends State<ShopRegister> {
  var firebaseUser = FirebaseAuth.instance.currentUser;
  String error = '';
  bool loading = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  //final Authentication _auth = Authentication();
  final _formKey = GlobalKey<FormState>();
  final shopnameInputController = new TextEditingController();
  final addressInputController = new TextEditingController();

  // ignore: non_constant_identifier_names
  final contactInputController = new TextEditingController();

  // ignore: non_constant_identifier_names
  final timingsInputController = new TextEditingController();
  final pincodeInputController = new TextEditingController();
  final pharmacynoInputController = new TextEditingController();

  //final addressLatitudeandLongitudeInputController= new TextEditingController();

  TextEditingController yes = TextEditingController();
  final shopdatabase =
  FirebaseDatabase.instance.reference().child("Retailer").child("Shopdata");
  String shopname = '';
  String address = '';

  // location ni code
  var addressLatitudeandLongitude = '';
  Position position;

  // ignore: non_constant_identifier_names
  String contact = '';

  // ignore: non_constant_identifier_names
  String timings = '';
  String pincode = '';
  String pharmacyno = '';

  Future<String> createAlertDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
                "Press Yes When You Are Currently At Your Shop Inorder to Get the Proper Location "),
            actions: <Widget>[
              ElevatedButton(
                child: Text('Yes'),
                onPressed: () {
                  Navigator.of(context).pop(
                      addressLatitudeandLongitude.toString());
                },
              )
            ],
          );
        });
  }


  // location mate no code
  void getcurrentLocation() async {
    Position currentPosition = await Geolocator()
        .getCurrentPosition();
    setState(() {
      position = currentPosition;
    });
  }

  @override
  void initState() {
    super.initState();
    getcurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        title: Text('Register your Shop'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0),
              TextFormField(
                decoration:
                textInputDecoration.copyWith(hintText: 'Shop Name'),
                validator: (val) =>
                val.isEmpty ? 'Enter your Shop Name' : null,
                controller: shopnameInputController,
                onChanged: (val) {
                  setState(() => shopname = val);
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                  decoration: textInputDecoration.copyWith(
                      hintText: 'Shop Address'),
                  validator: (val) =>
                  val.isEmpty ? 'Enter the Shop Address ' : null,
                  controller: addressInputController,
                  onChanged: (val) {
                    setState(() => address = val);
                  }),
              SizedBox(height: 20.0),
              TextFormField(
                  decoration:
                  textInputDecoration.copyWith(hintText: 'Contact'),
                  validator: (val) =>
                  val.isEmpty
                      ? 'Enter your Shop Contact Number'
                      : null,
                  controller: contactInputController,
                  onChanged: (val) {
                    setState(() => contact = val);
                  }),
              SizedBox(height: 20.0),
              TextFormField(
                decoration:
                textInputDecoration.copyWith(hintText: 'Timings'),
                validator: (val) =>
                val.isEmpty ? 'Enter your Shop Timings' : null,
                controller: timingsInputController,
                onChanged: (val) {
                  setState(() => timings = val);
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: textInputDecoration.copyWith(
                    hintText: ' Shop Area Pincode'),
                validator: (val) =>
                val.isEmpty ? 'Enter your Shop Area Pincode' : null,
                controller: pincodeInputController,
                onChanged: (val) {
                  setState(() => pincode = val);
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: textInputDecoration.copyWith(
                    hintText: ' Shop Pharmacist Number'),
                validator: (val) =>
                val.isEmpty ? 'Enter your Pharmacist Number' : null,
                controller: pharmacynoInputController,
                onChanged: (val) {
                  setState(() => pharmacyno = val);
                },
              ),
              SizedBox(height: 20.0),
              Text(
                'Back to Dashboard',
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height:20),
              RaisedButton(
                  color: Colors.pink[400],
                  child: Text(
                    'Register Shop',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed:() async {
                    if (_formKey.currentState.validate()) {
                      Map<String, dynamic> data = {
                        'shopname': shopnameInputController.text,
                        'address': addressInputController.text,
                        'contact': contactInputController.text,
                        'timings': timingsInputController.text,
                        'pincode': pincodeInputController.text,
                        'pharmacyno': pharmacynoInputController.text,
                        'Longitude': position.longitude,
                        'Latitude': position.latitude,
                        'Address': position.hashCode
                      };
                      FirebaseFirestore.instance
                          .collection('Retailer')
                          .doc(firebaseUser.uid)
                          .collection('Shopdata')
                          .doc(firebaseUser.uid)
                          .collection("ProductData")
                          .add(data);
                      print(data);

                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => RetailLogin(firebaseUser.uid),
                        ),
                      );
                      //  cloud no code
                      FirebaseFirestore.instance
                          .collection('Retailer')
                          .doc(firebaseUser.uid)
                          .collection("Shopdata")
                          .add(
                        {
                          'shopname': shopnameInputController.text,
                          'address': addressInputController.text,
                          'contact': contactInputController.text,
                          'timings': timingsInputController.text,
                          'pincode': pincodeInputController.text,
                          'pharmacyno': pharmacynoInputController.text,
                          'Longitude': position.longitude,
                          'Latitude': position.latitude,
                          'Address': position.hashCode
                        },
                      ).then((_) {
                        SetOptions(merge: true);
                        shopnameInputController.clear();
                        addressInputController.clear();
                        contactInputController.clear();
                        timingsInputController.clear();
                        pincodeInputController.clear();
                        pharmacynoInputController.clear();
                      }).catchError((onError) {
                        print("sucess");
                      });
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) =>
                              RetailLogin(firebaseUser.uid), //(User),
                        ),
                      );
                    } else {}

                    /// database mate no codee
                    shopdatabase.push().update({
                      "shopname": shopnameInputController.text,
                      "address": addressInputController.text,
                      "contact": contactInputController.text,
                      "timings": timingsInputController.text,
                      "pincode": pincodeInputController.text,
                      "pharmacyno": pharmacynoInputController.text,
                      'Longitude': position.longitude,
                      'Latitude': position.latitude
                    }).then((_) {
                      shopnameInputController.clear();
                      addressInputController.clear();
                      contactInputController.clear();
                      timingsInputController.clear();
                      pincodeInputController.clear();
                      pharmacynoInputController.clear();
                    }).catchError((onError) {});
                  }),
              SizedBox(height: 12.0),
              RaisedButton(
                color: Colors.pink[400],
                child: Text(
                  'Back to Dashboard',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => Retailregister(), //User),
                  ));
                },
              ),
              Text(
                error,
                style: TextStyle(color: Colors.red, fontSize: 14.0),
              )
            ],
          ),
        ),
      ),
    );
  }
}
