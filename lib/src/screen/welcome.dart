import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hostapp/src/screen/onboardScreen.dart';
import 'package:hostapp/src/screen/sign_in.dart';

class WelcomeScreen extends StatefulWidget {
  final String email;

  // List list;
  WelcomeScreen({this.email});
  @override
  _WelcomeScreenState createState() => new _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  var email;

  void initState() {
    super.initState();
    //_getId();
provider();

  }

  void dispose() {
    super.dispose();
  }
Future<void> provider() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
        final FirebaseUser user1 = await auth.currentUser();
        print("providerData");
       // print(user1.providerData.length);
         print(user1.providerId);
}
  void signOut() async {
    //.... code for signOut
    
    //print();
    //await FirebaseAuth.instance.signOut().whenComplete(() => update());
      final FirebaseAuth auth = FirebaseAuth.instance;
        final FirebaseUser user1 = await auth.currentUser();
        print("providerData");
        //print(user1.providerData);
         print(user1.providerId);
        // print(user1.)
         /*
         for(int i=0; i<user1.providerData.length;i++){

         }
         
         if(user1.providerId == 'firebase' ){
           print("inside if");
           await FirebaseAuth.instance.signOut().whenComplete(() => update());
         }
         else{
           print("inside else");
           await googleSignIn.signOut().whenComplete(() => update());
         }*/
         await FirebaseAuth.instance.signOut().whenComplete(() => update());
     await googleSignIn.signOut().whenComplete(() => update());
  }
  void update() async {
var did;

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      //return iosDeviceInfo.identifierForVendor; // unique ID on iOS
      print("DeviceId for iOS " + did);
      did = iosDeviceInfo.identifierForVendor;
    } else {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      did = androidDeviceInfo.androidId;
      print("DeviceId for android " + did);
           }
    //after signout remove the DeviceId value to null
    print("widget.email"+"${widget.email}");
    var email= "${widget.email}".toLowerCase();
      print("email"+email);
    Firestore.instance.collection('device').document(did).setData(
      {
       // 'email': "${widget.email}".toLowerCase(),
       'email':email.toString(),
        'DeviceId': "",
      },
    ).whenComplete(() => navigate());
  }

  navigate() {
    print("inside navigate");
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return OnboardScreen();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     /* appBar: new AppBar(
        elevation: 0.1,
        backgroundColor: Colors.white,
        actions: <Widget>[
          Stack(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10.0),
                child: InkResponse(
                  child: Icon(
                    Icons.power_settings_new,
                    color: Colors.black,
                    size: 36.0,
                  ),
                  onTap: () {
                    signOut();
                  },
                ),
              ),
            ],
          )
        ],
      ),*/
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: false,
      body: /*new Container(
    
          child: new Center(
            
              child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              "welcome to Guest app ${widget.email}",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
         ],
      ))),*/
          new Container(
    
          child: new Center(
            
              child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              "Sign In Complete!",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 30.0),
            ),
          ),
         SizedBox(
                   
                  height: 30.0,),
             SizedBox(
                  width: 150.0,
                  height: 60.0,
                  child: Container(
                    color: Colors.black,
                    child: RaisedButton(
                      onPressed: () {
                      signOut();
                      },
                      child: const Text(
                        'Log out',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(2))),
                      color: Colors.white12,
                    ),
                  ),
                ),
         ],
      ))),
    );
  }
}
