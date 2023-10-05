import 'dart:convert';

import 'package:blog_explorer/models/blog_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class BlogProvider with ChangeNotifier {
  List<Blog> _blogs = [];
  List<Blog> get blogs => _blogs;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  Set<String> _favouriteBlogIds = {};
  late Box box;
  int cnt = 0;

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

  List<Blog> fetchFavouriteBlogs() {
    print('Total fav blogs ${_favouriteBlogIds.length}');
    return _blogs
        .where((blog) => _favouriteBlogIds.contains(blog.blogId))
        .toList();
  }

  Future openBox() async {
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    box = await Hive.openBox('cached_blogs');
    return;
  }

  Future<bool> fetchBlogs() async {
    await openBox();
    const String url = 'https://intent-kit-16.hasura.app/api/rest/blogs';
    const String adminSecret =
        '32qR4KmXOIpsGPQKMqEJHGJS27G5s7HdSKO3gdtQd2kv5e852SiYwWNfxkZOBuQ6';

    try {
      final response = await http.get(Uri.parse(url), headers: {
        'x-hasura-admin-secret': adminSecret,
      });
      if (response.statusCode == 200) {
        print('Response data: ${response.body}');

        final Map<String, dynamic> blogData = jsonDecode(response.body);
        // json.decode(response.body);
        // print("BlogData--------------------->: $blogData");
        List<dynamic> blogList = blogData['blogs'];

        // print("BlogList======================>: $blogList");

        //caching done
        await setBlogsInCache(blogList);

        //get data from cached db
        List<Blog> blogListFromMap = box
            .toMap()
            .values
            .toList()
            .map<Blog>((blogItem) => Blog(
                title: blogItem['title'],
                blogId: blogItem['id'],
                image: blogItem['image_url']))
            .toList();

        if (blogListFromMap.isNotEmpty) {
          _blogs = blogListFromMap;
        }

        // avoid for infinite api call :
        // notifyListeners();
      } else {
        print('Request failed with status code: ${response.statusCode}');
        print('Response data***************: ${response.body}');
      }
    } catch (exc) {
      print('Exception occured-----:$exc ');
    }

    //necessary to return for updation of snapshot connection state
    return Future.value(true);
  }

  Future setBlogsInCache(List<dynamic> blogList) async {
    await box.clear();
    for (var blogItem in blogList) {
      box.add(blogItem);
    }
  }
}
