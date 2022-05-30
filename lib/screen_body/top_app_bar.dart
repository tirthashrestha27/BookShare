import 'package:bool_chain_v2/screens/chat.dart';
import 'package:bool_chain_v2/screens/everyBook.dart';
import 'package:bool_chain_v2/services/ad_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// import 'package:bool_chain_v2/data/books.dart';
var book;
List<DocumentSnapshot> documentList;
List f = new List();
List g = new List();
var p = new Map();

class TopAppBar1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.blue,
      elevation: 1.0,
      pinned: true,
      floating: true,
      snap: true,
      title: Row(
        children: <Widget>[
          Text(
            'Book Share',
            style: TextStyle(fontSize: 20.0),
          ),
          Flexible(child: SizedBox(width: double.infinity)),
          IconButton(
            icon: Icon(Icons.search),
            tooltip: 'Search',
            onPressed: () async {
              documentList =
                  (await Firestore.instance.collection('books').getDocuments())
                      .documents;
              documentList.asMap().forEach((key, value) {
                f.add(value.data['bookName']);
                g.add(value.documentID);
              });
              for (int i = 0; i < f.length; i++) {
                p[f[i]] = g[i];
              }
              showSearch(context: context, delegate: Search());
            },
          ),
          IconButton(
            icon: Icon(Icons.chat_bubble_outline),
            tooltip: 'Chat Room',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Chat()),
              ).then((value) => AdManager.show());
            },
          ),
        ],
      ),
      bottom: TabBar(
        tabs: <Widget>[
          Tab(text: "Home"),
          Tab(
            text: "Sponsor",
          )
        ],
      ),
    );
  }
}

// class TopAppBar2 extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return SliverAppBar(
//       elevation: 1.0,
//       pinned: false,
//       floating: true,
//       snap: false,
//       title: Row(
//         children: <Widget>[
//           Text(
//             'Book Share',
//             style: TextStyle(fontSize: 20.0),
//           ),
//           Flexible(child: SizedBox(width: double.infinity)),
//           IconButton(
//             icon: Icon(Icons.search),
//             tooltip: 'Search',
//             onPressed: () {
//               showSearch(context: context, delegate: Search());
//             },
//           ),
//           GestureDetector(
//             onTap: () {
//               print('safal');
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => Chat()),
//               );
//             },
//             child: Icon(Icons.chat_bubble),
//           ),
//         ],
//       ),
//     );
//   }
// }

//Search Operations Below
// for optimization purpose for furthur dev
// searchByName(String searchField) async {
//   documentList = (await Firestore.instance
//           .collection('books')
//           .where('search', isEqualTo: searchField.substring(0, 1).toUpperCase())
//           .getDocuments())
//       .documents;
//   documentList.asMap().forEach((key, value) {
//     f.add(value.data['bookName']);
//   });
// }

class Search extends SearchDelegate<String> {
  final history = new List();
  var tempSearchStore = [];

  var queryResultSet = [];

  @override
  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme =
        Theme.of(context).copyWith(primaryColor: Colors.lightBlue);
    assert(theme != null);
    return theme;
  }

  @override
  //to display after search text
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
          }),
    ];
  }

  @override
  //to display before search
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  //to do after search is done
  Widget buildResults(BuildContext context) {
    final suggestionList = (query.isEmpty
            ? history
            : f.toSet().toList().where((element) =>
                element.toLowerCase().startsWith(query.toLowerCase())))
        .toList();
    print(p[query]);
    if (suggestionList.isEmpty || !suggestionList.contains(query)) {
      return Center(child: Text('Book not found'));
    }
    return ListView.builder(
      itemBuilder: (context, index) {
        return ListTile(
          onTap: () {
            print(p[query]);
            print('sagal');
            close(context, null);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => EverybookInfo(p[query]),
              ),
            );
            // print(suggestionId[index]);
          },
          leading: Icon(Icons.book),
          title: RichText(
              text: TextSpan(
            text: query,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontStyle: FontStyle.italic,
                fontSize: 20),
          )),
        );
      },
      itemCount: suggestionList.length,
    );
    // return ListView.builder(
    //   itemBuilder: (context, index) => ListTile(
    //     onTap: () {},
    //     leading: Icon(Icons.book),
    //     title: RichText(
    //         text: TextSpan(
    //       text: query,
    //       style: TextStyle(
    //           fontWeight: FontWeight.bold,
    //           color: Colors.black,
    //           fontStyle: FontStyle.italic,
    //           fontSize: 20),
    //     )),
    //   ),
    //   itemCount: suggestionList.length,
    // );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    var suggestionList = new List();
    suggestionList = (query.isEmpty
            ? history
            : f.toSet().toList().where((element) =>
                element.toLowerCase().startsWith(query.toLowerCase())))
        .toList();

    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        onTap: () {
          query = suggestionList[index];
          showResults(context);
        },
        title: RichText(
            text: TextSpan(
                text: suggestionList[index].substring(0, query.length),
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                children: [
              TextSpan(
                  text: suggestionList[index].substring(query.length),
                  style: TextStyle(color: Colors.grey))
            ])),
      ),
      itemCount: suggestionList.length,
    );
  }
}

//to provide suggestion for faster search
//   Widget buildSuggestions(BuildContext context) {
//     final suggestionList = query.isEmpty
//         ? history
//         : books
//             .where((element) =>
//                 element.toLowerCase().startsWith(query.toLowerCase()))
//             .toList();
//     return ListView.builder(
//       itemBuilder: (context, index) => ListTile(
//         onTap: () {
//           query = suggestionList[index];
//           showResults(context);
//         },
//         leading: Icon(Icons.book),
//         title: RichText(
//             text: TextSpan(
//                 text: suggestionList[index].substring(0, query.length),
//                 style:
//                     TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
//                 children: [
//               TextSpan(
//                   text: suggestionList[index].substring(query.length),
//                   style: TextStyle(color: Colors.grey))
//             ])),
//       ),
//       itemCount: suggestionList.length,
//     );
//   }
// }
// if (query.length == 0) {
//   queryResultSet = [];
//   tempSearchStore = [];
// }

// if (queryResultSet.length == 0 && query.length == 1) {
//   SearchService().searchByName(query).then((QuerySnapshot docs) {
//     for (int i = 0; i < (docs.documents.length) ; ++i) {
//       queryResultSet.add(docs.documents[i].data);
//       // suggestionList.add(docs.documents[i].data['bookName']);

//     }
//   });
// } else {
//   tempSearchStore = [];
//   queryResultSet.forEach((element) {
//     if (element['bookName'].toLowerCase().startsWith(query.toLowerCase())) {
//       tempSearchStore.add(element['bookName']);
//       print(element['bookName']);
//     }
//   });
// }
// final suggestionList = tempSearchStore;
// print(suggestionList.length);
