import 'package:blog_explorer/providers/blog_provider.dart';
import 'package:blog_explorer/screens/blog_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BlogListScreen extends StatelessWidget {
  const BlogListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final blogProvider = Provider.of<BlogProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Blog Explorer'),
      ),
      body: FutureBuilder(
        future: blogProvider.fetchBlogs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Error loading blogs'),
            );
          } else {
            return ListView.builder(
              itemCount: blogProvider.blogs.length,
              itemBuilder: (context, index) {
                final currBlog = blogProvider.blogs[index];
                return ListTile(
                  title: Text(currBlog.title),
                  leading: Image.network(currBlog.image),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DetailedBlogScreen(currBlog: currBlog),
                        ));
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
