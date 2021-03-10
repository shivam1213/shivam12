import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:urbanmed/dealdrawer.dart';

class Ddashboard extends StatefulWidget {
  @override
  Dashboard createState() => Dashboard();
}

class Dashboard extends State<Ddashboard> {
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  Position _currentPosition;
  var distInMeters;

  String currentAddress;

  getDist({var latt, var longg}) async {
    distInMeters = await Geolocator().distanceBetween(
        latt,
        longg,
        _currentPosition.latitude,
        _currentPosition
            .longitude); // lat2 and long2 are global variables with current user's location
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  _getCurrentLocation() {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });

      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        currentAddress =
            "${place.locality}, ${place.postalCode}, ${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }

  Icon cusIcon = Icon(Icons.search);
  Widget cusSearchbar = Text("UrbanMed");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          //InkWell(   if want to give space between search and dots.
          //child: SizedBox(
          //width: 100.0,
          //child: Icon(Icons.search),
          //),
          //),
          IconButton(
            onPressed: () {
              setState(() {
                if (this.cusIcon.icon == Icons.search) {
                  this.cusIcon = Icon(Icons.cancel);
                  this.cusSearchbar = Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    height: 45,
                    margin: EdgeInsets.only(top: 15),
                    padding:
                        EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 4),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(color: Colors.black12, blurRadius: 20)
                        ]),
                    child: TextField(
                      textInputAction: TextInputAction.go,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Hey, Searching Something????"),
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                      ),
                    ),
                  );
                } else {
                  this.cusIcon = Icon(Icons.search);
                  this.cusSearchbar = Text("UrbanMed");
                }
              });
            },
            icon: cusIcon,
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.more_vert),
          ),
        ],
        title: cusSearchbar,
      ),
      drawer: Dealdrawer(),
      floatingActionButton:
          IconButton(icon: Icon(Icons.message), onPressed: () {}),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: BottomAppBar(
          child: Row(
        children: <Widget>[
          Expanded(
            child: SizedBox(
              height: 60.0,
              child: InkWell(
                onTap: () {},
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.group),
                    Text(
                      'Customers',
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: SizedBox(
              height: 60.0,
              child: InkWell(
                onTap: () {},
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.card_travel),
                    Text(
                      'Your Medicine Data',
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      )),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Retailer')
            .doc()
            .collection('Shops')
            .snapshots(),
        builder: (context, snapshots) {
          if (snapshots.connectionState == ConnectionState.active &&
              snapshots.hasData) {
            print(snapshots.data);
            var doc = snapshots.data.docs;
            return ListView.builder(
              itemCount: doc.length,
              itemBuilder: (BuildContext context, int index) {
                DocumentSnapshot doc = snapshots.data.docs[index];
                Map yourdata = doc.data();
                var lat = yourdata["Latitude"];
                var long = yourdata["Longitude"];
                getDist(latt: lat, longg: long);
                print(distInMeters);

/*
Here, you can get latitude and longitude from firebase, using keys,based on your document structure.
Example, var lat=yourdata["latitude"];
var long=yourdata["longitude"];

Now, you can calculate the distance,

getDist(latt:lat,longg:long);

 here lat2 and long2 are current user's latitude and longitude.
print(distInMeters);
*/
                return Text(
                    "please upvote and accept this as the answer if it helped :) ");
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );

    /*FutureBuilder(
        future: DefaultAssetBundle.of(context).loadString("asset/data.json"),
        builder: (context,snapshot) {
          var mydata = json.decode(snapshot.data.toString());
          if (mydata == null) {
            return Center(
              child: Text(
                'Loading',
              ),
            );
          }
          else {
            return Center(
              child: Text(
                mydata[1]["name"],
                style: TextStyle(
                  fontSize: 25.0
                ),
              ),
            );
          }
        },
      ),*/
  }
}
