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

    return Scaffold(
      appBar: AppBar(
        title: Text(currBlog.title),
      ),
      body:Column(
        children: [
          Image.network(currBlog.image),
          Text(currBlog.title),
          
        ],
      ),
    );
  }
}
