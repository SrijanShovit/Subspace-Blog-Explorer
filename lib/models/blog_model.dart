import 'package:hive/hive.dart';
part 'blog_model.g.dart';

@HiveType(typeId: 1)
class Blog {
  @HiveField(0)
  final String title;
  @HiveField(1)
  final String image;
  @HiveField(2)
  final String blogId;
  @HiveField(3)
  bool isFavourite;

  Blog(
      {required this.title,
      required this.image,
      required this.blogId,
      this.isFavourite = false});
}
