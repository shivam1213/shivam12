import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:urbanmed/constant.dart';
import 'package:urbanmed/dealdashboard.dart';
import 'package:urbanmed/retailerforgotpassword.dart';
import 'package:urbanmed/retailregister.dart';

class RetailLogin extends StatefulWidget {
  final uid;
  RetailLogin(this.uid);  //RetailLogin({Key key,this.retailer}) : super(key: key);
  //String retailer;
  @override
  Login createState() => Login();
}

class Login extends State<RetailLogin> {

  final _formKey = GlobalKey<FormState>();

  TextEditingController emailInputController;
  TextEditingController passwordInputController;

  String error = '';
  bool loading = false;

  // text field state
  String email = '';
  String password = '';

  @override
  initState() {
    emailInputController = new TextEditingController();
    passwordInputController = new TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFFff4060),
        elevation: 0.0,
        title: Text('Welcome to UrbanMed'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'Email'),
                validator: (val) => val.isEmpty ? 'Enter an email' : null,
                controller: emailInputController,
                onChanged: (val) {
                  setState(() => email = val);
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                obscureText: true,
                decoration: textInputDecoration.copyWith(hintText: 'Password'),
                validator: (val) =>
                val.length < 6
                    ? 'Enter a password 6+ chars long'
                    : null,
                controller: passwordInputController,
                onChanged: (val) {
                  setState(() => password = val);
                },
              ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(child: Text('Forgot Password ?',),
                    onPressed: () =>
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => Forgetpassword()),
                        ),
                  ),
                ],),
              RaisedButton(
                  color: Colors.cyan,
                  child: Text(
                    'Log In',
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      setState(() => loading = true);
                      // dynamic retailer = await _auth.retailerlogin(email, password);
                      FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                          email: emailInputController.text,
                          password: passwordInputController.text)
                          .then((currentUser) =>
                          FirebaseFirestore.instance
                              .collection("Retailer")
                              .doc(currentUser.user.uid)
                              .get()
                              .then((_) =>
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      Ddashboard(),),)
                          ).catchError((onError) {
                            print("sucess");
                          })
                              .catchError((err) => print(err)))
                          .catchError((err) => print(err));
                    }
                    else {
                      print('error');
                    }
                  }
              ),
              SizedBox(height: 12.0),
              Text(
                error,
                style: TextStyle(color: Colors.red, fontSize: 14.0),
              ),
              SizedBox(height: 12.0),
              new GestureDetector(
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => Retailregister(),
                  ));
                },
                child: new Text("New to UrbanMed !! Click here"),
              )

            ],
          ),
        ),
      ),
    );
  }
}
