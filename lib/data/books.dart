class Book {
  String bookAuthor, bookName, image, bookDescription, bookOwner, currentHolder;
  List<String> genres;
  double bookRating;
  bool bookAvailable;
  int price;
  Book({
    this.bookAvailable,
    this.image,
    this.bookName,
    this.bookAuthor,
    this.bookRating = 0,
    this.genres,
    this.bookDescription,
    this.bookOwner,
    this.currentHolder,
    this.price,
  });
}
// Future<void> addRestaurant(Book book) {
//   final restaurants = Firestore.instance.collection('books');
//   return restaurants.add({
// 'image': book.bookAuthor,
// 'bookName': book.bookName,
// 'bookAuthor': book.bookAuthor,
// 'bookRating': book.bookRating,
// 'catergory': book.genres,
// 'numRating': book.numRating,
//   });
// }

final books = [
  'Nepal',
  'India',
  'Corona',
  'PaniPuri',
  'Apple',
  'Dota',
  'Beta',
  'Earth',
  'Dog',
  'Game',
  'Flutter',
  'Tirthe ko Prem katha',
  'Blank kanda',
  'Cancer Pidit',
  'Haku ko jawani',
  'Sajish ko Invoker Sumiya bhanda babal'
];
