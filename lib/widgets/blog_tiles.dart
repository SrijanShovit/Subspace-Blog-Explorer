import 'package:blog_explorer/providers/blog_provider.dart';
import 'package:blog_explorer/screens/blog_detail_screen.dart';
import 'package:blog_explorer/widgets/blog_card.dart';
import 'package:flutter/material.dart';

class BlogTiles extends StatelessWidget {
  const BlogTiles({
    super.key,
    required this.blogProvider,
  });

  final BlogProvider blogProvider;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: blogProvider.blogs.length,
      itemBuilder: (context, index) {
        final currBlog = blogProvider.blogs[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            child: BlogCard(
              imageUrl: currBlog.image,
              title: currBlog.title,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailedBlogScreen(
                    currBlog: currBlog,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
