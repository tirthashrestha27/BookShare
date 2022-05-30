import 'package:bool_chain_v2/data/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bool_chain_v2/data/books.dart';

class FireStoreService {
  bool isLoggedIN() {
    if (FirebaseAuth.instance.currentUser() != null)
      return true;
    else
      return false;
  }

  Future<void> addBook(Book book) async {
    if (isLoggedIN()) {
      final docRef = Firestore.instance.collection('books');
      print(book.bookName);
      docRef.add({
        'available': book.bookAvailable,
        'bookOwner': book.bookOwner,
        'image': book.image,
        'bookName': book.bookName,
        'bookAuthor': book.bookAuthor,
        'bookRating': book.bookRating,
        'genres': book.genres,
        'time': FieldValue.serverTimestamp(),
        "bookDescription": book.bookDescription,
        'search': book.bookName.substring(0, 1).toUpperCase()
      });
    }
  }

  Future<void> addUser(Users user) async {
    if (isLoggedIN()) {
      final docRef =
          Firestore.instance.collection('users').document("${user.userId}");
      print(user.userId);

      docRef.setData({
        'image': user.userProfilePicture,
        'userName': user.userName,
        'userGeoCode':
            GeoPoint(user.position.latitude, user.position.longitude),
        'userRating': user.userRating,
        'time': FieldValue.serverTimestamp(),
        'userBio': user.userBio,
        'userAddress': user.userAddress,
        'userId': user.userId,
      });
    }
  }
}
