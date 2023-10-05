import 'package:blog_explorer/models/blog_model.dart';
import 'package:blog_explorer/providers/blog_provider.dart';
import 'package:blog_explorer/widgets/blog_tiles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavouriteBlogsScreen extends StatelessWidget {
  final List<Blog> favBlogs;
  const FavouriteBlogsScreen({super.key, required this.favBlogs});

  @override
  Widget build(BuildContext context) {
    final blogProvider = Provider.of<BlogProvider>(context);
    return favBlogs.isEmpty
        ? Scaffold(
            appBar: AppBar(
              title: const Text('Your favourite blogs'),
            ),
            body: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "No blogs marked as favourites",
                ),
              ),
            ),
          )
        : BlogTiles(blogProvider: blogProvider);
  }
}
