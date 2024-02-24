import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../components/draggable_item.dart';
import '../../../../data/blog.dart';
import '../../../../ui/blog/index.dart';
import '../../../theme_data/fonts.dart';
import '../../sections/blog/item.dart';

class HomeBlog extends StatefulWidget {
  const HomeBlog({super.key});

  @override
  State<HomeBlog> createState() => _HomeBlog();
}

class _HomeBlog extends State<HomeBlog> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final blogProvider = Provider.of<BlogProvider>(context, listen: false);
      await blogProvider.loadBlogPost(context);
    });
  }

  ValueNotifier<Swipe> swipeNotifier = ValueNotifier(Swipe.none);

  @override
  Widget build(BuildContext context) {
    final blogProvider = Provider.of<BlogProvider>(context);
    const borderBlue = Color.fromRGBO(78, 115, 248, 1.0);
    return Column(
      children: [
        Text(
          "Blog",
          style: GoogleFonts.dmSans(textStyle: FontThemeData.sectionTitles),
        ),
        const SizedBox(height: 15.0),
        SizedBox(
          height: 150.0,
          child: Stack(
            children: [
              ValueListenableBuilder(
                valueListenable: swipeNotifier,
                builder: (context, swipe, _) => Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: blogProvider.blogPosts.isEmpty
                      // Prints if no blog posts exists
                      ? [const Text("No articles available.")]
                      : List.generate(
                          blogProvider.blogPosts.length,
                          growable: true,
                          (index) {
                            return DraggableItem(
                              widget: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: HomeBlogItem(
                                    post: blogProvider.blogPosts[index]),
                              ),
                              index: index,
                              swipeNotifier: swipeNotifier,
                            );
                          },
                        ),
                ),
              ),
              Positioned(
                left: 0,
                child: DragTarget<int>(
                  builder: (
                    context,
                    accepted,
                    rejected,
                  ) {
                    return IgnorePointer(
                      child: Container(
                        width: 20.0,
                        height: 700.0,
                        color: Colors.transparent,
                      ),
                    );
                  },
                  onAccept: (index) {
                    setState(() {
                      blogProvider.blogPosts.removeAt(index);
                    });
                  },
                ),
              ),
              Positioned(
                right: 0,
                child: DragTarget<int>(
                  builder: (
                    context,
                    accepted,
                    rejected,
                  ) {
                    return IgnorePointer(
                      child: Container(
                        width: 20.0,
                        height: 700.0,
                        color: Colors.transparent,
                      ),
                    );
                  },
                  onAccept: (index) {
                    setState(() {
                      blogProvider.blogPosts.removeAt(index);
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15.0),
        SizedBox(
          width: 200.0,
          child: OutlinedButton.icon(
            icon: const Icon(Icons.more),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const BlogPage(),
                ),
              );
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: borderBlue, width: 1),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            label: const Text("View all posts"),
          ),
        ),
        const SizedBox(height: 15.0),
      ],
    );
  }
}
