import 'package:bool_chain_v2/screens/home_screen.dart';
import 'package:bool_chain_v2/screens/log_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:bool_chain_v2/services/firebase_auth_service.dart';

class InitialLoadingScreen extends StatefulWidget {
  static const String id = 'initial_loading_screen';
  @override
  _InitialLoadingScreenState createState() => _InitialLoadingScreenState();
}

class _InitialLoadingScreenState extends State<InitialLoadingScreen> {
  // FirebaseAuthService doublecheck = FirebaseAuthService();
  Future<bool> isLoggedIN() async {
    if (await FirebaseAuth.instance.currentUser() != null) {
      return true;
    } else
      return false;
  }

  bool doubleCheck;
  bool check;
  @override
  void initState() {
    super.initState();
    timeDilation = 0.5;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blue,
        child: Center(
          child: TweenAnimationBuilder(
            duration: Duration(milliseconds: 2000),
            tween: Tween<double>(begin: 0, end: 1),
            curve: Curves.bounceIn,
            builder: (context, value, child) {
              return Center(
                child: Hero(
                  tag: 'lofo',
                  child: Text(
                    'Book Share',
                    style: TextStyle(
                        inherit: false,
                        fontSize: 30 * value,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              );
            },
            onEnd: () async {
              check = await isLoggedIN();
              if (check == true) {
                print('logged in');
                Navigator.of(context).pushReplacement(PageRouteBuilder(
                  transitionDuration: Duration(milliseconds: 800),
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      HomeScreen(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, _) {
                    return ScaleTransition(
                      scale: animation,
                      alignment: Alignment.center,
                      child: _,
                    );
                  },
                ));
              } else {
                Navigator.of(context).pushReplacement(PageRouteBuilder(
                  transitionDuration: Duration(milliseconds: 800),
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      LogInPage(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, _) {
                    return ScaleTransition(
                      scale: animation,
                      alignment: Alignment.center,
                      child: _,
                    );
                  },
                ));
              }
            },
          ),
        ),
      ),
    );
  }
}
