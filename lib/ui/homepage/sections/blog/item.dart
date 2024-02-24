import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../types/blogpost.dart';
import '../../../../ui/post/index.dart';

class HomeBlogItem extends StatefulWidget {
  final BlogPost post;
  const HomeBlogItem({super.key, required this.post});

  @override
  State<HomeBlogItem> createState() => _HomeBlogItemState();
}

class _HomeBlogItemState extends State<HomeBlogItem> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PostPage(
              key: UniqueKey(),
              blogPost: widget.post,
            ),
          ),
        );
      },
      child: Container(
        width: width,
        height: 150.0,
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
                color: Color.fromRGBO(18, 17, 39, 0.05),
                offset: Offset(0, 20),
                blurRadius: 50.0,
                spreadRadius: 0.0),
          ],
          borderRadius: BorderRadius.circular(20.0),
          color: Colors.white,
        ),
        clipBehavior: Clip.none,
        child: Row(
          children: <Widget>[
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20.0),
                bottomLeft: Radius.circular(20.0),
              ),
              child: Image(
                width: 120.0,
                height: 150.0,
                fit: BoxFit.cover,
                image: NetworkImage(widget.post.image,
                    headers: {'Keep-Alive': 'timeout=5, max=1000'}),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 15.0,
                  horizontal: 10.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Flexible(
                      child: Text(
                        widget.post.title,
                        style: GoogleFonts.dmSans(
                          textStyle: const TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      children: <Widget>[
                        // Flexible(
                        //   child: Text(
                        //     "Alex Mira",
                        //     style: GoogleFonts.dmSans(
                        //       textStyle: const TextStyle(
                        //           fontSize: 10, fontWeight: FontWeight.w700),
                        //       color: const Color.fromRGBO(115, 115, 115, 1.0),
                        //     ),
                        //   ),
                        // ),
                        // const Padding(
                        //   padding: EdgeInsets.symmetric(horizontal: 5.0),
                        //   child: Icon(
                        //     Icons.circle,
                        //     size: 5.0,
                        //     color: Color.fromRGBO(115, 115, 115, 1.0),
                        //   ),
                        // ),
                        Flexible(
                          child: Text(
                            DateFormat("d MMMM y").format(
                              DateFormat("dd-mm-yyyy hh:mm:ss")
                                  .parse(widget.post.date),
                            ),
                            style: GoogleFonts.dmSans(
                              textStyle: const TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.w700),
                              color: const Color.fromRGBO(115, 115, 115, 1.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      widget.post.excerpt,
                      style: GoogleFonts.dmSans(
                        textStyle: const TextStyle(
                            fontSize: 11, fontWeight: FontWeight.w700),
                        color: const Color.fromRGBO(115, 115, 115, 1.0),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
