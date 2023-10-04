import 'dart:convert';

import 'package:blog_explorer/models/blog_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BlogProvider with ChangeNotifier {
  List<Blog> _blogs = [];
  List<Blog> get blogs => _blogs;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  Set<String> _favouriteBlogIds = Set<String>();

  void setLoading(bool status) {
    _isLoading = status;
    notifyListeners();
  }

  bool isFavouriteBlog(String blogId) {
    return _favouriteBlogIds.contains(blogId);
  }

  void toggleFavourite(String blogId) {
    print("Size before toggle ${_favouriteBlogIds.length}");
    if (_favouriteBlogIds.contains(blogId)) {
      _favouriteBlogIds.remove(blogId);
    } else {
      _favouriteBlogIds.add(blogId);
    }
    print("Size after toggle ${_favouriteBlogIds.length}");
    notifyListeners();
  }

  void setFavourite() {}

  Future fetchBlogs() async {
    const String url = 'https://intent-kit-16.hasura.app/api/rest/blogs';
    const String adminSecret =
        '32qR4KmXOIpsGPQKMqEJHGJS27G5s7HdSKO3gdtQd2kv5e852SiYwWNfxkZOBuQ6';

    try {
      final response = await http.get(Uri.parse(url), headers: {
        'x-hasura-admin-secret': adminSecret,
      });
      if (response.statusCode == 200) {
        print('Response data: ${response.body}');

        final Map<String, dynamic> blogData = json.decode(response.body);

        // print("BlogData : ${blogData['blogs']}");

        _blogs = blogData['blogs']
            .map<Blog>((blogItem) => Blog(
                title: blogItem['title'],
                blogId: blogItem['id'],
                image: blogItem['image_url']))
            .toList();

        print(_blogs);

        notifyListeners();
      } else {
        print('Request failed with status code: ${response.statusCode}');
        print('Response data***************: ${response.body}');
      }
    } catch (exc) {
      print('Exception occured-----:$exc ');
    }
  }
}
