import 'dart:async';

import 'package:blog_explorer/models/blog_model.dart';
import 'package:blog_explorer/providers/blog_provider.dart';
import 'package:blog_explorer/screens/blog_detail_screen.dart';
import 'package:blog_explorer/screens/fav_blog_screen.dart';
import 'package:blog_explorer/widgets/blog_card.dart';
import 'package:blog_explorer/widgets/blog_tiles.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class BlogListScreen extends StatelessWidget {
  const BlogListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final blogProvider = Provider.of<BlogProvider>(context);

    print("Blog Length: ${blogProvider.blogs.length}");

    return Scaffold(
      appBar: AppBar(title: const Text('Blog Explorer'), actions: [
        IconButton(
          icon: const Icon(Icons.favorite),
          onPressed: () {
            List<Blog> favBlogs = blogProvider.fetchFavouriteBlogs();
            print("# fav blogs ${favBlogs.length}");
            // Future.delayed(Duration(seconds: 20));
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FavouriteBlogsScreen(favBlogs: favBlogs),
              ),
            );
          },
        ),
      ]),
      body: RefreshIndicator(
        onRefresh: () async {
          blogProvider.fetchBlogs();
          await Future.delayed(Duration.zero);
          return Future.value();
        },
        child: FutureBuilder(
            future: blogProvider.fetchBlogs(),
            builder: (context, snapshot) {
              // print("connection status^^^^^^^^^^^: $_connectionStatus");
              // print(
              // "snapshot******** ${snapshot.connectionState} ${snapshot.hasData}");
              if (snapshot.hasData) {
                if (blogProvider.blogs.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "No data!!/nPlease check your connection.",
                      ),
                    ),
                  );
                } else {
                  return BlogTiles(blogProvider: blogProvider);
                }
              } else {
                return const Center(
                  child: SizedBox(
                    height: 100,
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Fetching blogs for you!!',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          CircularProgressIndicator(),
                        ],
                      ),
                    ),
                  ),
                );
              }
            }),
      ),
    );
  }
}
