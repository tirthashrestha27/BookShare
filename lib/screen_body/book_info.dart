import 'package:bool_chain_v2/screen_body/top_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:bool_chain_v2/data/books.dart';
import 'package:bool_chain_v2/screen_body/navigation_sidebar.dart';

class BookInfo extends StatelessWidget {
  final int index;
  BookInfo({this.index});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: Drawer(child: Navigation()),
        body: CustomScrollView(
          slivers: [
            TopAppBar1(),
            SliverFillRemaining(
              hasScrollBody: true,
              child: Column(
                children: [
                  Flexible(
                    child: Stack(
                      children: [
                        Hero(
                          tag: index,
                          child: Container(
                            height: 300,
                            width: double.infinity,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage('images/test.jpg'),
                                    fit: BoxFit.scaleDown),
                                color: Colors.teal[100 * (1 % 9)],
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(15),
                                  bottomRight: Radius.circular(15),
                                )),
                          ),
                        ),
                        Positioned(
                            left: 18,
                            top: 1,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Icon(
                                Icons.arrow_back,
                                size: 20,
                              ),
                            ))
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [Text('${books[index]}')],
                      ),
                    ),
                  ),
                  SizedBox(height: 50)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class BookInfo extends StatelessWidget {
//   final int index;
//   BookInfo({this.index});
//   @override
//   Widget build(BuildContext context) {
//     return SliverFillRemaining(
//       hasScrollBody: true,
//       child: Column(
//         children: [
//           Flexible(
//             child: Stack(
//               children: [
//                 Hero(
//                   tag: index,
//                   child: Container(
//                     height: 300,
//                     width: double.infinity,
//                     alignment: Alignment.center,
//                     decoration: BoxDecoration(
//                         image: DecorationImage(
//                             image: AssetImage('images/test.jpg'),
//                             fit: BoxFit.scaleDown),
//                         color: Colors.teal[100 * (1 % 9)],
//                         borderRadius: BorderRadius.only(
//                           bottomLeft: Radius.circular(15),
//                           bottomRight: Radius.circular(15),
//                         )),
//                   ),
//                 ),
//                 Positioned(
//                     left: 18,
//                     top: 1,
//                     child: GestureDetector(
//                       onTap: () {
//                         Navigator.of(context).pop();
//                       },
//                       child: Icon(
//                         Icons.arrow_back,
//                         size: 20,
//                       ),
//                     ))
//               ],
//             ),
//           ),
//           Expanded(
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.white,
//               ),
//               child: Column(
//                 children: [Text('${books[index]}')],
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }

// // import 'package:swipe_gesture_recognizer/swipe_gesture_recognizer.dart';
// // import 'dart:math';
// // import 'package:bool_chain_v2/screen_body/top_app_bar.dart';
// // import 'package:bool_chain_v2/screen_body/home.dart';
// // import 'package:bool_chain_v2/screen_body/navigation_sidebar.dart';

// // class BookInfo extends StatefulWidget {
// //   @override
// //   _BookInfoState createState() => _BookInfoState();
// // }

// // class _BookInfoState extends State<BookInfo>
// //     with SingleTickerProviderStateMixin {
// //   int selectedIndex = 0;
// //   AnimationController animationController;

// //   @override
// //   void initState() {
// //     super.initState();
// //     animationController = AnimationController(
// //       vsync: this,
// //       duration: Duration(milliseconds: 350),
// //     );
// //   }

// //   Widget chooseScreenBody() {
// //     switch (selectedIndex) {
// //       case 4:
// //         {
// //           return BookInfo();
// //         }
// //         break;
// //       case 5:
// //         {
// //           return BookInfo();
// //         }
// //         break;
// //       default:
// //         {
// //           return Home();
// //         }
// //         break;
// //     }
// //   }

// //   @override
// //   void dispose() {
// //     animationController.dispose();
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Colors.black,
// //       body: AnimatedBuilder(
// //         animation: animationController,
// //         builder: (context, _) {
// //           return Stack(
// //             children: <Widget>[
// //               Container(
// //                 height: double.infinity,
// //                 width: double.infinity,
// //                 color: Colors.white,
// //               ),
// //               Positioned(
// //                   right: 0,
// //                   bottom: 90,
// //                   child: AnimatedContainer(
// //                     duration: Duration(milliseconds: 5),
// //                     child: Image.asset(
// //                       'images/back.png',
// //                       width: (animationController.value == 1) ? 60 : 0,
// //                     ),
// //                   )),
// //               Transform.translate(
// //                 offset: Offset(225 * (animationController.value - 1), 0),
// //                 child: Transform(
// //                   transform: Matrix4.identity()
// //                     ..setEntry(3, 2, 0.001)
// //                     ..rotateY(pi / 2 * (1 - animationController.value)),
// //                   alignment: Alignment.centerRight,
// //                   child: GestureDetector(
// //                     onTap: () {},
// //                     child: SwipeGestureRecognizer(
// //                       onSwipeLeft: () => animationController.reverse(),
// //                       child: Navigation(
// //                         animationController: animationController,
// //                         selectedIndex: selectedIndex,
// //                         call: (newIndex) {
// //                           selectedIndex = newIndex;
// //                           setState(() {
// //                             print(selectedIndex);
// //                           });
// //                         },
// //                       ), //navigationContainer(),
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //               Transform.translate(
// //                 offset: Offset(225 * animationController.value, 0),
// //                 child: Transform(
// //                   transform: Matrix4.identity()
// //                     ..setEntry(3, 2, 0.001)
// //                     ..rotateY(-pi / 2 * animationController.value),
// //                   alignment: Alignment.centerLeft,
// //                   child: Container(
// //                     color: Colors.white70,
// //                     child: SwipeGestureRecognizer(
// //                       onSwipeLeft: () => animationController.reverse(),
// //                       onSwipeRight: () => animationController.forward(),
// //                       child: CustomScrollView(
// //                         slivers: <Widget>[
// //                           TopAppBar(animationController: animationController),
// //                           BookIn(),
// //                           //  Home(),
// //                           // BookInfo(),
// //                         ],
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           );
// //         },
// //       ),
// //     );
// //   }
// // }
