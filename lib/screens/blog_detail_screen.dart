import 'dart:io';

import 'package:blog_explorer/helper/image_cache_helper.dart';
import 'package:blog_explorer/models/blog_model.dart';
import 'package:blog_explorer/providers/blog_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:flutter/services.dart';

class DetailedBlogScreen extends StatefulWidget {
  final Blog currBlog;
  const DetailedBlogScreen({super.key, required this.currBlog});

  @override
  State<DetailedBlogScreen> createState() => _DetailedBlogScreenState();
}

class _DetailedBlogScreenState extends State<DetailedBlogScreen> {
  ConnectivityResult _connectionStatus = ConnectivityResult.none;

  final Connectivity _connectivity = Connectivity();

  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print('Could not check connectivity status: $e');
      return;
    }

    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    final blogProvider = Provider.of<BlogProvider>(context);
    // blogProvider.openBox();
    final titleString = widget.currBlog.title.length > 20
        ? '${widget.currBlog.title.substring(0, 20)}...'
        : widget.currBlog.title;
    // final ImageCacheHelper cacheHelper = ImageCacheHelper();

    return Scaffold(
      appBar: AppBar(
        title: Text(titleString),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _connectionStatus == ConnectivityResult.none
              ? const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "No image data.",
                    ),
                  ),
                )
              // ? FutureBuilder(
              //     future: cacheHelper.getImage(widget.currBlog.image),
              //     builder: (context, snapshot) {
              //       if (snapshot.connectionState == ConnectionState.waiting) {
              //         return const Center(
              //           child: CircularProgressIndicator(),
              //         );
              //       } else if (snapshot.hasError) {
              //         return const Padding(
              //           padding: EdgeInsets.all(8.0),
              //           child: Align(
              //             alignment: Alignment.center,
              //             child: Text(
              //               "Could not fetch image.",
              //             ),
              //           ),
              //         );
              //       } else if (snapshot.hasData) {
              //         final cachedImagePath = snapshot.data;
              //         if (cachedImagePath != null) {
              //           return Image.file(File(cachedImagePath));
              //         } else {
              //           return const Padding(
              //             padding: EdgeInsets.all(8.0),
              //             child: Align(
              //               alignment: Alignment.center,
              //               child: Text(
              //                 "Image not available",
              //               ),
              //             ),
              //           );
              //         }
              //       } else {
              //         return const Padding(
              //           padding: EdgeInsets.all(8.0),
              //           child: Align(
              //             alignment: Alignment.center,
              //             child: Text(
              //               "No image data.",
              //             ),
              //           ),
              //         );
              //       }
              //     },
              //   )
              // const Padding(
              //     padding: EdgeInsets.all(8.0),
              //     child: Align(
              //       alignment: Alignment.center,
              //       child: Text(
              //         "Could not fetch image.\n Please check your connection!!",
              //       ),
              //     ),
              //   )
              : Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Image.network(
                      widget.currBlog.image,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: IconButton(
                        onPressed: () {
                          blogProvider.toggleFavourite(widget.currBlog.blogId);
                        },
                        icon: Icon(
                            blogProvider.isFavouriteBlog(widget.currBlog.blogId)
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: blogProvider
                                    .isFavouriteBlog(widget.currBlog.blogId)
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
              widget.currBlog.title,
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
