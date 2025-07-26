import 'package:flutter_book_example/features_book/features_book.dart';
import 'package:flutter_book_example/features_book/features_page_info.dart';

class BookResponse {
  final List<Book> books;
  final PageInfo pageInfo;

  BookResponse({required this.books, required this.pageInfo});
}
