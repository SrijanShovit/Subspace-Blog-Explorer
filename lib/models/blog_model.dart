class Blog {
  final String title;
  final String image;
  final String blogId;
  bool isFavourite;

  Blog({required this.title, required this.image,required this.blogId, this.isFavourite = false});
}
