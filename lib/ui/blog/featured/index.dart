import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../types/blogpost.dart';
import '../../../ui/post/index.dart';
import '../../theme_data/fonts.dart';

class FeaturedPost extends StatelessWidget {
  final BlogPost blogPost;
  const FeaturedPost({required Key key, required this.blogPost})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, right: 20.0),
      child: SizedBox(
        width: 200.0,
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    PostPage(key: UniqueKey(), blogPost: blogPost),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.25)),
              ],
              image: DecorationImage(
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.25), BlendMode.darken),
                image: NetworkImage(blogPost.image,
                    headers: {'Keep-Alive': 'timeout=5, max=1000'}),
              ),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 30.0, horizontal: 25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      blogPost.title,
                      style: GoogleFonts.dmSans(
                          textStyle: FontThemeData.blogFeaturedTitle),
                    ),
                  ),
                  const SizedBox(height: 15.0),
                  // Row(
                  //   children: [
                  //     const CircleAvatar(
                  //       radius: 12.0,
                  //       backgroundImage: AssetImage('assets/images/logo.png'),
                  //     ),
                  //     const SizedBox(width: 8.0),
                  //     Text(
                  //       "Marie-Ann",
                  //       style: GoogleFonts.dmSans(
                  //           textStyle: FontThemeData.blogFeaturedTitle),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
