import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ImageCacheHelper {
  final Box<String> _imageBox = Hive.box<String>('image_cache');

  Future<String?> getImage(String url) async {
    //Checking if image already cached
    if (_imageBox.containsKey(url)) {
      return _imageBox.get(url);
    }

    //fetch img and cache it
    final networkImage = NetworkImage(url);
    final completer = Completer<String>();

    networkImage.resolve(ImageConfiguration.empty).addListener(
      ImageStreamListener((info, _)async {
      final file = info.image as FileImage;
      final path = file.file.path;
      _imageBox.put(url, path);
      completer.complete(path);
    }));
    
    return completer.future;
  }
}
