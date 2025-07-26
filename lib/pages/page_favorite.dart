import 'package:flutter/material.dart';
import 'package:flutter_book_example/pages/page_book_detail.dart';
import 'package:flutter_book_example/provider/provider_favorite.dart';
import 'package:flutter_book_example/widgets/card_grid.dart';
import 'package:flutter_book_example/widgets/constant.dart';
import 'package:provider/provider.dart';

class PageFavorite extends StatefulWidget {
  const PageFavorite({super.key});

  @override
  State<PageFavorite> createState() => _PageFavoriteState();
}

class _PageFavoriteState extends State<PageFavorite> {
  @override
  Widget build(BuildContext context) {
    final favorite = Provider.of<FavoriteProvider>(context);
    final orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        title: const Text("Favorilerim"),
      ),
      body: favorite.favoriteBooks.isEmpty
          ? const Center(child: Text("Henüz favori kitap yok."))
          : GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: orientation == Orientation.portrait ? 2 : 3,
                childAspectRatio: 0.45,
              ),
              itemCount: favorite.favoriteBooks.length,
              itemBuilder: (context, index) {
                var book = favorite.favoriteBooks[index];
                return Center(
                  child: CardGridBook(
                    fetchedbook: book,
                    fClick: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PageBook(fetchedBook: book),
                        ),
                      );
                    },
                    isFavorited: true,
                    onFavorite: () {
                      setState(() {
                        favorite.toggleBookFavorite(book);
                      });
                    },
                  ),
                );
              },
            ),
    );
  }
}
