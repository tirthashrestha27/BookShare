import 'package:bool_chain_v2/services/firestorage.dart';
import 'package:bool_chain_v2/services/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:bool_chain_v2/services/firestore.dart';
import 'package:bool_chain_v2/data/books.dart';
import 'package:bool_chain_v2/services/firebase_auth_service.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class UploadBook extends StatefulWidget {
  @override
  _UploadBookState createState() => _UploadBookState();
}

class _UploadBookState extends State<UploadBook> {
  double rating = 2.5;
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final TextEditingController _author = new TextEditingController();
  final TextEditingController _bookDescription = new TextEditingController();
  final TextEditingController _bookName = new TextEditingController();
  List<String> _colors = <String>[
    'Action and Adventure',
    'Anthology',
    'Biography/Autobiography',
    'Classic',
    'Comic and Graphic Novel',
    'Crime and Detective',
    'Drama',
    'Essay',
    'Fan-fiction',
    'Fable',
    'Fantasy',
    'Historical Fiction',
    'Horror',
    'Humor',
    'Legend',
    'Magical Realism',
    'Memoir',
    'Mystery',
    'Mythology',
    'Narrative Nonfiction',
    'Periodicals',
    'Realistic Fiction',
    'Reference Books',
    'Romance',
    'Satire',
    'Science Fiction',
    'Self-help',
    'Short Story',
    'Speech',
    'Suspence/Thriller',
    'Textbook',
    'Poetry'
  ];

  List<String> _selected = [];
  Book book = Book();
  void _showMyDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Your book has been uploaded.',
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  FirebaseAuthService _authService = FirebaseAuthService();
  FireStorageService _storageService = FireStorageService();
  FireStoreService fireStoreService = FireStoreService();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ImageCapture>(
      create: (context) => ImageCapture(),
      child: new Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.blue,
          title: new Text('Upload Book'),
        ),
        body: SafeArea(
          top: false,
          bottom: false,
          child: Consumer<ImageCapture>(
            builder: (context, image, child) {
              return Form(
                key: _formKey,
                child: Stack(
                  children: [
                    ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      children: <Widget>[
                        SizedBox(
                          height: 50,
                        ),
                        if (image.imageFile == null) ...[
                          Center(child: Text('Please upload book image')),
                        ],
                        if (image.imageFile != null) ...[
                          Image.file(image.imageFile),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.crop),
                                  onPressed: () async {
                                    await image.cropImage();
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.refresh),
                                  onPressed: () {
                                    image.clear();
                                  },
                                ),
                              ])
                        ],
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              icon: Icon(Icons.photo_camera),
                              onPressed: () async {
                                _formKey.currentState.save();

                                print(
                                    '${book.bookName} ${book.bookAuthor} ${book.bookDescription}');
                                await image.pickImage(ImageSource.camera);
                              }, // image.pickImage(ImageSource.camera),
                            ),
                            IconButton(
                              icon: Icon(Icons.photo_library),
                              onPressed: () async {
                                print("fool");
                                print(
                                    '${book.bookName} ${book.bookAuthor} ${book.bookDescription}');

                                await image.pickImage(ImageSource.gallery);
                                print(
                                    '${book.bookName} ${book.bookAuthor} ${book.bookDescription}');
                              },
                            )
                          ],
                        ),
                        TextFormField(
                          controller: _bookName,
                          style: TextStyle(color: Colors.black),
                          decoration: const InputDecoration(
                            icon: const Icon(Icons.book),
                            hintText: 'Book Title',
                            labelText: 'Book Name',
                          ),
                          onChanged: (value) => book.bookName = value,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(100)
                          ],
                          validator: (val) =>
                              val.isEmpty ? 'Name is required' : null,
                        ),
                        new TextFormField(
                          controller: _author,
                          style: TextStyle(color: Colors.black),
                          decoration: const InputDecoration(
                            icon: const Icon(Icons.person),
                            hintText: 'Author name',
                            labelText: 'Author Name',
                          ),
                          onChanged: (value) => book.bookAuthor = value,
                        ),
                        TextFormField(
                          controller: _bookDescription,
                          textAlign: TextAlign.justify,
                          maxLines: null,
                          textInputAction: TextInputAction.done,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            icon: Icon(Icons.person),
                            hintText: 'Short Description',
                            labelText: 'About Book',
                          ),
                          onChanged: (value) => book.bookDescription = value,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(500)
                          ],
                        ),
                        SizedBox(height: 10),
                        Container(child: Text('Genres')),
                        SizedBox(height: 10),
                        Wrap(
                          spacing: 8.0, // gap between adjacent chips
                          runSpacing: 4.0, // gap between lines
                          children: <Widget>[
                            for (var ip in _selected)
                              Container(
                                height: 25,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Colors.blue,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        '  $ip  ',
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                      GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _selected.remove(ip);
                                            });
                                          },
                                          child: Icon(Icons.clear, size: 15)),
                                    ]),
                              ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: PopupMenuButton(
                                  icon: Icon(Icons.add, size: 30),
                                  padding: EdgeInsets.all(0),
                                  onSelected: (String value) {
                                    setState(() {
                                      if (!_selected.contains(value)) {
                                        _selected.add(value);
                                      }
                                    });
                                  },
                                  itemBuilder: (BuildContext context) {
                                    return _colors.map((String choice) {
                                      return PopupMenuItem(
                                        value: choice,
                                        child: Text(choice,
                                            style:
                                                TextStyle(color: Colors.black)),
                                      );
                                    }).toList();
                                  }),
                            ),
                            GestureDetector(
                                child: Icon(Icons.clear),
                                onTap: () {
                                  _selected.clear();
                                  setState(() {});
                                }),
                          ],
                        ),
                        Center(
                          child: RatingBar.builder(
                            initialRating: 3,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (value) {
                              book.bookRating = value;
                              setState(() {
                                rating = value;
                              });
                            },
                          ),
                        ),
                        Text(
                          rating.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        RaisedButton(
                            child: const Text(
                              'Submit',
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 20),
                            ),
                            onPressed: () async {
                              book.genres = _selected;
                              book.bookOwner =
                                  (await _authService.getCurrentUser()).uid;
                              // book.image=
                              if (_formKey.currentState.validate()) {
                                if (image.imageFile != null) {
                                  book.image = await _storageService.upload(
                                      image: image.imageFile,
                                      name: DateTime.now()
                                              .millisecondsSinceEpoch
                                              .toString() +
                                          book.bookOwner
                                              .toString()
                                              .substring(2, 10));
                                  _formKey.currentState.save();
                                  await fireStoreService.addBook(book);

                                  _showMyDialog();

                                  setState(() {
                                    _bookName.clear();
                                    _bookDescription.clear();
                                    _selected.clear();
                                    _author.clear();
                                  });
                                  image.imageFile = null;
                                }
                              }
                            }),
                        SizedBox(
                          height: 50,
                        )
                      ],
                    ),
                    ((image.inProgress)
                        ? Container(
                            color: Colors.white,
                            height: double.infinity,
                            width: double.infinity,
                            child: Center(child: CircularProgressIndicator()),
                          )
                        : Center())
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
