import 'package:blog_explorer/providers/blog_provider.dart';
import 'package:blog_explorer/screens/blog_detail_screen.dart';
import 'package:blog_explorer/widgets/blog_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BlogListScreen extends StatelessWidget {
  const BlogListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final blogProvider = Provider.of<BlogProvider>(context);
    print("Blog Length: ${blogProvider.blogs.length}");

    return Scaffold(
      appBar: AppBar(
        title: const Text('Blog Explorer'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: blogProvider.fetchBlogs(),
        builder: (context, snapshot) {
          // if (snapshot.connectionState == ConnectionState.waiting) {
          //   return const Center(
          //     child: CircularProgressIndicator(),
          //   );
          // }
          // blogProvider.setLoading(true);
          // while (blogProvider.isLoading) {
          //   return const Center(
          //     child: CircularProgressIndicator(),
          //   );
          // }
          // blogProvider.setLoading(false);
          if (snapshot.hasError) {
            return const Center(
              child: Text('Error loading blogs'),
            );
          } else {
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
        },
      ),
    );
  }
}
