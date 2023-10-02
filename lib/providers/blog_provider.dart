import 'package:blog_explorer/models/Blog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BlogProvider with ChangeNotifier {
  List<Blog> _blogs = [];
  List<Blog> get blogs => _blogs;

  void fetchBlogs() async {
    const String url = 'https://intent-kit-16.hasura.app/api/rest/blogs';
    const String adminSecret =
        '32qR4KmXOIpsGPQKMqEJHGJS27G5s7HdSKO3gdtQd2kv5e852SiYwWNfxkZOBuQ6';

    try {
      final response = await http.get(Uri.parse(url), headers: {
        'x-hasura-admin-secret': adminSecret,
      });
      if (response.statusCode == 200) {
        print('Response data: ${response.body}');
      } else {
        print('Request failed with status code: ${response.statusCode}');
        print('Response data***************: ${response.body}');
      }
    } catch (exc) {
      print('Exception occured-----:$exc ');
    }
  }
}
