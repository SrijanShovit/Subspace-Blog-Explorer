import 'package:blog_explorer/models/blog_model.dart';
import 'package:blog_explorer/providers/blog_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailedBlogScreen extends StatelessWidget {
  final Blog currBlog;
  const DetailedBlogScreen({super.key, required this.currBlog});

  @override
  Widget build(BuildContext context) {
    final blogProvider = Provider.of<BlogProvider>(context);
    final titleString = currBlog.title.length > 20
        ? '${currBlog.title.substring(0, 20)}...'
        : currBlog.title;

    return Scaffold(
      appBar: AppBar(
        title: Text(titleString),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Image.network(
                currBlog.image,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: IconButton(
                  onPressed: () {
                    blogProvider.toggleFavourite(currBlog.blogId);
                  },
                  icon: Icon(
                      blogProvider.isFavouriteBlog(currBlog.blogId)
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: blogProvider.isFavouriteBlog(currBlog.blogId)
                          ? Colors.red
                          : Colors.white,
                      size: 30),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              currBlog.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
