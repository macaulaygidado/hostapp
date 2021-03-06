import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:hostapp/src/service/AppleSignInAvailable.dart';
import 'package:hostapp/src/service/AuthService.dart';
import 'package:hostapp/src/service/auth_bloc.dart';
import 'package:hostapp/src/service/auth_bloc_provider.dart';
import 'package:hostapp/src/service/repository.dart';
import 'package:provider/provider.dart';
import 'welcome.dart';
import 'sign_in.dart';
import 'login_page.dart';

class CreatenewaccountScreen extends StatefulWidget {
  @override
  _CreatenewaccountScreenState createState() => new _CreatenewaccountScreenState();
}
//class _WelcomeScreenState extends State<WelcomeScreen> {}

class _CreatenewaccountScreenState extends State<CreatenewaccountScreen> {
   final _repository = Repository();
  AuthBloc _bloc;
  Locale _myLocale;
  FirebaseUser user;
  var existingemail;
  bool signupcheck = false;
  TextEditingController textemail = new TextEditingController();
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc = AuthBlocProvider.of(context);
    this.initDynamicLinks();
    _myLocale = Localizations.localeOf(context);
  }

  void initState() {
    // this.getsavedata();

    /*Timer.run(() {
      try {
        InternetAddress.lookup('google.com').then((result) {
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            print('connected');
          } else {
            _showDialog(); // show dialog
          }
        }).catchError((error) {
          _showDialog(); // show dialog
        });
      } on SocketException catch (_) {
        _showDialog();
        print('not connected'); // show dialog
      }
    });*/
    super.initState();
  }

  void initDynamicLinks() async {
    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;

    if (deepLink != null) {
      /// Change status to a loading state, so user would not get confused even for a second.
      _bloc.changeAuthStatus(AuthStatus.isLoading);
      _bloc
          .signInWIthEmailLink(
              await _bloc.getUserEmailFromStorage(), deepLink.toString())
          .whenComplete(() => _authCompleted());
    }
  }

  void _authCompleted() async {
    // _authCompleted function is used to
    var email = await _bloc.getUserEmailFromStorage();

    print("email" + email.toLowerCase());
    Firestore.instance
        .collection("users")
        .where("email", isEqualTo: email.toLowerCase())
        .getDocuments()
        .then((string) {
      print('Firestore response111: , ${string.documents.length}');
      string.documents.forEach(
        (doc) => print("data available"),
      );
      if (string.documents.length == 0) {
        print("email not avilable new user");
        //email not avilable new user
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => LoginPage(
                      existingemail: email.toString().toLowerCase(),
                    )));
      } else {
        print("email  already exists");
//Existing user  already exists
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => WelcomeScreen(
                      email: email.toString().toLowerCase(),
                    )));
      }
    });
  }

/*getsavedata() async {

  SharedPreferences sharedPreferences;
    print("inside getCredential function");

    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
    var name = sharedPreferences.getString("name");
    var lastname  = sharedPreferences.getString("lastname");
    var phone = sharedPreferences.getString("phone");
     var  email= sharedPreferences.getString("email").toLowerCase();
      
    print("name" + name);
    print("lastname" + lastname);
    print("phone" + phone);
    print("email" + email);
//          sharedPreferences.clear();
    });
  }*/
      /// Function start for handling apple signup
  Future<void> _signInWithApple(BuildContext context) async {

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final user = await authService.signInWithApple(
          requestEmail: true, requestFullName: true);
      print('uid: ${user.uid}');
    } catch (e) {
      print(e);
    }
  }
// Function end for handling apple signup

  void _authCompletedgoogle() async {
    //_authCompletedgoogle function is used to navigate the user after google signup
    // var email = user.email;
    print("email" + email);
    var email1 = email;
    print("emailllllll1111111" + email1);
    Firestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .getDocuments()
        .then((string) {
      print('Firestore response111: , ${string.documents.length}');
      string.documents.forEach(
        (doc) => print("data available"),
      );
      if (string.documents.length == 0) {
        print("email not avilable");
        //new user
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => LoginPage(
                      existingemail: email.toString(),
                    )));
      } else {
        print("email  alreadyexists");
        //existing user
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => WelcomeScreen(
                      email: email.toString(),
                    )));
      }
    });
  }

  void init() {
    existingemail = "";
    super.initState();
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// start declaration  for handling apple signup

    final appleSignInAvailable =
        Provider.of<AppleSignInAvailable>(context, listen: false);

    /// end declaration  for handling apple signup
    print("appleSignInAvailable" + appleSignInAvailable.toString());
    print(appleSignInAvailable.toString());
    return Scaffold(
      body: Container(
      padding: EdgeInsets.all(32),
      child: SingleChildScrollView(
        child: Column(
         // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            StreamBuilder(
                stream: _bloc.authStatus,
                builder: (context, snapshot) {
                  switch (snapshot.data) {
                    case (AuthStatus.emailAuth):
                      return _authForm(true);
                      break;
                    case (AuthStatus.phoneAuth):
                      return _authForm(false);
                      break;
                    case (AuthStatus.emailLinkSent):
                      return Container(
                        child: Column(
                       //   mainAxisAlignment: MainAxisAlignment.center,
                       //   crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            // Center(

                            /*Text(
                              Constants.sentEmail,
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),*/
                            SizedBox(
                              height: 200.0,
                            ),
                            SizedBox(
                              height: 100.0,
                              width: 100.0,
                              child: CircularProgressIndicator(
                                  //valueColor: AlwaysStoppedAnimation(Color(0xff6839ed)),
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.black),
                                  strokeWidth: 5.0),
                            ),
                            SizedBox(
                              height: 50.0,
                            ),

                            Center(
                              child: Text(
                                "We have emailed a special link to ${textemail.text} click the link to confirm your address and get started.",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13.0,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text("Wrong email? Please re-enter your address."),
                          ],
                        ),
                      );
                      break;
                    case (AuthStatus.isLoading):
                      return Center(child: CircularProgressIndicator());
                      break;
                    default:
                      // By default we will show the email auth form
                      return _authForm(true);
                      break;
                  }
                })
          ],
        ),
      ),
    )
    );
  }

  Widget _authForm(bool isEmail) {
    return StreamBuilder(
        stream: isEmail ? _bloc.email : _bloc.phone,
        builder: (context, snapshot) {
          return StreamBuilder<FirebaseUser>(
              stream: FirebaseAuth.instance.onAuthStateChanged,
              builder: (context, snapshot2) {
                if (snapshot2.connectionState == ConnectionState.active) {
                  user = snapshot2.data;
                }

                return SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        _emailInputField(snapshot.error),
                        SizedBox(
                          height: 32.0,
                        ),
                        SizedBox(
                          width: 300.0,
                          height: 60.0,
                          child: RaisedButton(
                            onPressed: () async {
                              var did;
                              //...Start code block to check connected device is android or iOS
                              DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
                              if (Theme.of(context).platform ==
                                  TargetPlatform.iOS) {
                                IosDeviceInfo iosDeviceInfo =
                                    await deviceInfo.iosInfo;
                                // unique ID on iOS
                                did = iosDeviceInfo.identifierForVendor;
                                print("DeviceId for ios" + did);
                              } else {
                                AndroidDeviceInfo androidDeviceInfo =
                                    await deviceInfo.androidInfo;
                                did = androidDeviceInfo.androidId;
                                // unique ID on android
                                print("DeviceId for android" + did);
                              }
                              //...End code block to check connected device is android or iOS
                              print("DeviceId" + did);
                              print("textemail" + textemail.text.toLowerCase());
                              //... code for check email id is already available in the device table
                              Firestore.instance
                                  .collection("device")
                                  .where("email",
                                      isEqualTo: textemail.text.toLowerCase())
                                  .getDocuments()
                                  .then((email) {
                                print(
                                    'Firestore length: , ${email.documents.length}');
                                email.documents.forEach((doc) =>
                                    //... code for check DeviceId is already available in the device table
                                    Firestore.instance
                                        .collection("device")
                                        .where("DeviceId",
                                            isEqualTo: doc.documentID)
                                        .getDocuments()
                                        .then((string) {
                                      string.documents.forEach(
                                        (doc) => print(string.documents.length),
                                      );
                                      if (did == doc.data['DeviceId']) {
                                        // DeviceId was same so sent mail
                                        print("same device send mail");
                                        if (snapshot.hasData) {
                                          var currentemail = snapshot.data;
                                          print(currentemail);
                                          existingemail = snapshot2.data;
                                          if (existingemail == null) {
                                            print(
                                                "Not an existingemail first time login");
                                            _authenticateUserWithEmail();
                                          } else {
                                            print("existingemail");
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        WelcomeScreen(
                                                          email: existingemail
                                                              .email,
                                                        )));
                                          }
                                        }
                                      } else if (doc.data['DeviceId'] == "") {
                                        //....user signout form the device
                                        print("user signout form the device");
                                        print("doc.data['DeviceId']" +
                                            doc.data['DeviceId']);
                                        print(did);
                                        //....update the device id in device table
                                        Firestore.instance.runTransaction(
                                          (Transaction transaction) async {
                                            Firestore.instance
                                                .collection('device')
                                                .document(did)
                                                .setData(
                                              {
                                                'email': textemail.text
                                                    .toLowerCase(),
                                                'DeviceId': did,
                                              },
                                            );
                                          },
                                        );
                                        if (snapshot.hasData) {
                                          var currentemail = snapshot.data;
                                          print(currentemail);
                                          existingemail = snapshot2.data;
                                          if (existingemail == null) {
                                            print(
                                                "Not an existingemail first time login");
                                            _authenticateUserWithEmail();
                                          } else {
                                            print("existingemail");
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        WelcomeScreen(
                                                          email: existingemail
                                                              .email,
                                                        )));
                                          }
                                        }
                                      } else {
                                        print("Email is already signIn");
                                        //Email is already signIn dont allow to signup
                                        setState(() {
                                          signupcheck = true;
                                          //set the signupcheck flag true to display the error message
                                        });
                                      }
                                    }));
                                if (email.documents.length == 0) {
                                  //new user allow to sent an email
                                  print("new user allow to sent an email");
                                  if (snapshot.hasData) {
                                    var currentemail = snapshot.data;
                                    print(currentemail);
                                    existingemail = snapshot2.data;
                                    if (existingemail == null) {
                                      print(
                                          "Not an existingemail first time login");
                                      _authenticateUserWithEmail();
                                    } else {
                                      print("existingemail");
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  WelcomeScreen(
                                                    email: existingemail.email,
                                                  )));
                                    }
                                  }
                                }
                              });
                            },
                            child: const Text(
                              'Create your account',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12))),
                            color: Colors.white12,
                          ),
                        ),
                        Center(
                          child: Text(
                            'OR',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 25.0),
                          ),
                        ),
                        SizedBox(
                          width: 300.0,
                          height: 60.0,
                          child: RaisedButton(
                            onPressed: () async {
                              signInWithGoogle().whenComplete(() async {
                                //_authCompletedgoogle();

                                var did;
                                //...Start code block to check connected device is android or iOS
                                DeviceInfoPlugin deviceInfo =
                                    DeviceInfoPlugin();
                                if (Theme.of(context).platform ==
                                    TargetPlatform.iOS) {
                                  IosDeviceInfo iosDeviceInfo =
                                      await deviceInfo.iosInfo;
                                  // unique ID on iOS
                                  did = iosDeviceInfo.identifierForVendor;
                                  print("DeviceId for ios" + did);
                                } else {
                                  AndroidDeviceInfo androidDeviceInfo =
                                      await deviceInfo.androidInfo;
                                  did = androidDeviceInfo.androidId;
                                  // unique ID on android
                                  print("DeviceId for android" + did);
                                }
                                //...End code block to check connected device is android or iOS
                                print("DeviceId" + did);
                                print("hai email " + email);
                                //... code for check email id is already available in the device table
                                Firestore.instance
                                    .collection("device")
                                    .where("email",
                                        isEqualTo: email.toLowerCase())
                                    .getDocuments()
                                    .then((email) {
                                  print(
                                      'Firestore length: , ${email.documents.length}');
                                  email.documents.forEach((doc) =>
                                      //... code for check DeviceId is already available in the device table
                                      Firestore.instance
                                          .collection("device")
                                          .where("DeviceId",
                                              isEqualTo: doc.documentID)
                                          .getDocuments()
                                          .then((string) async {
                                        string.documents.forEach(
                                          (doc) =>
                                              print(string.documents.length),
                                        );
                                        if (did == doc.data['DeviceId']) {
                                          // DeviceId was same so sent mail
                                          print(
                                              "same device so allow to log in");
                                          print("email for login" +
                                              email.toString());

                                          _authCompletedgoogle();
                                        } else if (doc.data['DeviceId'] == "") {
                                          //....user signout form the device
                                          print("user signout form the device");
                                          print("doc.data['DeviceId']" +
                                              doc.data['DeviceId']);

                                          //print();
                                          //....update the device id in device table
                                          final FirebaseAuth auth =
                                              FirebaseAuth.instance;

                                          final FirebaseUser user1 =
                                              await auth.currentUser();

                                          print("user1.email" + user1.email);
                                          Firestore.instance.runTransaction(
                                            (Transaction transaction) async {
                                              Firestore.instance
                                                  .collection('device')
                                                  .document(did)
                                                  .setData(
                                                {
                                                  'email': user1.email
                                                      .toLowerCase()
                                                      .toString(),
                                                  'DeviceId': did,
                                                },
                                              );
                                            },
                                          );
                                          _authCompletedgoogle();
                                        } else {
                                          print("Email is already signIn");
                                          //Email is already signIn dont allow to signup
                                          setState(() {
                                            signupcheck = true;
                                            //set the signupcheck flag true to display the error message
                                          });
                                        }
                                      }));
                                  if (email.documents.length == 0) {
                                    //new user allow to sent an email
                                    print("new user allow to login");
                                    signInWithGoogle().whenComplete(() {
                                      _authCompletedgoogle();
                                      // print("hai"+email);
                                    });
                                  }
                                });
                              });

                              /*
                               signInWithGoogle().whenComplete(() {
                                //_authCompletedgoogle();
                               print("hai"+email);
                               
                              }); */
                            },
                            child: const Text(
                              'With Google',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12))),
                            color: Colors.white12,
                          ),
                        ),
                        SizedBox(
                          height: 32.0,
                        ),
                        SizedBox(
                          width: 300.0,
                          height: 60.0,
                          child: RaisedButton(
                            onPressed: () {
                              //function call for apple sign up
                              _signInWithApple(context);
                              //function call for apple sign up
                            },
                            child: const Text(
                              'with apple',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12))),
                            color: Colors.white12,
                          ),
                        ),
                        SizedBox(
                          height: 32.0,
                        ),
                      
                      ]),
                );
                //);
              });
        });
  }

  /// The method takes in an [error] message from our validator.

  Widget _emailInputField(String error) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            //SizedBox(height: 32),
         
            SizedBox(height: 32),
            SizedBox(
              width: 32.0,
                          child: Text(
                 "Let's get started",
                style: TextStyle(color: Colors.black, fontSize: 30.0),
              ),
            ),
             SizedBox(height: 32),
            SizedBox(
              width: 32.0,
                          child: Text(
                    "First create your account.",
                    style: TextStyle(color: Colors.black, fontSize: 15.0),
                  ),
            ),
            SizedBox(height: 32),
            Align(
              alignment: Alignment(-.85, 0),
              child: Container(
                child: Text(
                  "What Email address?",
                  style: TextStyle(color: Colors.black, fontSize: 15.0),
                ),
              ),
            ),
            SizedBox(height: 32),
            Align(
              alignment: Alignment(-.100, 0),
              child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width - 100,
                decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: new BorderRadius.circular(12.0)),
                child: TextField(
                  onChanged: _bloc.changeEmail,
                  controller: textemail,
                  keyboardType: TextInputType.emailAddress,
                  autofocus: false,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    errorText: error,
                    contentPadding: EdgeInsets.all(20),
                  ),
                ),
              ),
            ),

            SizedBox(height: 10),
            Visibility(
              child: Text(
                "You are already logged in. Please sign out of your other device first",
                style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 12.0),
              ),
              visible: signupcheck,
            ),
            SizedBox(
              height: 30.0,
            ),
            
          ],
        ),
      ),
    );
  }

  void _authenticateUserWithEmail() {
    _bloc.sendSignInWithEmailLink().whenComplete(() => _bloc
        .storeUserEmail()
        .whenComplete(() => _bloc.changeAuthStatus(AuthStatus.emailLinkSent)));
  }

  _showSnackBar(String error) {
    final snackBar = SnackBar(content: Text(error));
    Scaffold.of(context).showSnackBar(snackBar);
  }
  //To create a new account after sending signin mail to the user

}
