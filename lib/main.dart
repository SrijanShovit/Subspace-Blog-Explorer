import 'package:blog_explorer/providers/blog_provider.dart';
import 'package:blog_explorer/screens/blog_list_screen.dart';
// import 'package:blog_explorer/screens/blog_list_screen.dart';
import 'package:blog_explorer/widgets/blog_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<BlogProvider>(create: (_) => BlogProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        home: ChangeNotifierProvider(
          create: (_) => BlogProvider(),
          child: const BlogListScreen(),
        ),
      ),
    );
  }
}
