import 'package:geolocator/geolocator.dart';

class Users {
  Position position;
  String userId, userName, userProfilePicture, userBio, userAddress, userEmail;
  List<String> userHonor;
  double userRating;
  List<String> userBooks;
  Users(
      {this.userAddress,
      this.userBio,
      this.userBooks,
      this.userEmail,
      this.userId,
      this.position,
      this.userName,
      this.userHonor,
      this.userProfilePicture,
      this.userRating = 50});
}
