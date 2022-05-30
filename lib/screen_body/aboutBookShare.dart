import 'package:animated_text_kit/animated_text_kit.dart';
import 'dart:ui';
import 'package:flutter/material.dart';

class AboutApp extends StatefulWidget {
  @override
  _AboutAppState createState() => _AboutAppState();
}

class _AboutAppState extends State<AboutApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "About Book Share",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Container(
            height: MediaQuery.of(context).size.height * 1 / 2,
            width: MediaQuery.of(context).size.width - 30,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Made with ",
                      style: TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 42),
                    ),
                    Icon(
                      Icons.favorite,
                      size: 42,
                      color: Colors.red,
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
                TyperAnimatedTextKit(
                  text: [" Flutter ", " and Dart "],
                  textStyle: TextStyle(fontSize: 50.0),
                  textAlign: TextAlign.start,
                  alignment: Alignment.center,
                  speed: Duration(milliseconds: 300),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  "For Book Lovers",
                  style: TextStyle(fontSize: 42, fontWeight: FontWeight.normal),
                ),
              ],
            )),
      ),
    );
  }
}
