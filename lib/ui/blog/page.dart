import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import './post/index.dart';
import '../../data/blog.dart';
import '../../ui/blog/featured/index.dart';
import '../../ui/theme_data/fonts.dart';

class BlogSection extends StatefulWidget {
  const BlogSection({super.key});

  @override
  State<BlogSection> createState() => _BlogSectionState();
}

class _BlogSectionState extends State<BlogSection> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final blogProvider = Provider.of<BlogProvider>(context, listen: false);
      await blogProvider.loadBlogPost(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final blogProvider = Provider.of<BlogProvider>(context);
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        color: const Color.fromRGBO(248, 248, 248, 1.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(height: 15.0),
            Text(
              "Blog",
              style: GoogleFonts.dmSans(textStyle: FontThemeData.sectionTitles),
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 15.0),
            // Featured Articles
            Row(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(0.0),
                    backgroundColor: const Color.fromRGBO(248, 248, 248, 1.0),
                    elevation: 0.0,
                  ),
                  onPressed: () {},
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width - 75.0,
                    height: 300.0,
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      clipBehavior: Clip.none,
                      scrollDirection: Axis.horizontal,
                      itemCount: blogProvider.featuredBlogPosts.length,
                      itemBuilder: (_, i) {
                        return FeaturedPost(
                          key: UniqueKey(),
                          blogPost: blogProvider.featuredBlogPosts[i],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            // Post List
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              clipBehavior: Clip.none,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: blogProvider.blogPosts.length,
              itemBuilder: (_, i) {
                return BlogPostTile(
                  key: UniqueKey(),
                  blogPost: blogProvider.blogPosts[i],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
