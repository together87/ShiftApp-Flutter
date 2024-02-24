import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../ui/jobs_category/index.dart';
import '../../../theme_data/fonts.dart';

class JobCategoryItem extends StatelessWidget {
  final int id;
  final String name;
  final String icon;

  const JobCategoryItem(
      {required Key key,
      required this.id,
      required this.name,
      required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => JobsCategory(
              id: id,
              key: UniqueKey(),
              name: name,
            ),
          ),
        );
      },
      child: Container(
        width: 100.0,
        margin: const EdgeInsets.only(right: 15.0),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(0, 0, 0, 0.75),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
              width: 50.0,
              height: 50.0,
              image: NetworkImage(icon),
            ),
            const SizedBox(height: 2.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: Text(
                name,
                textAlign: TextAlign.center,
                style:
                    GoogleFonts.dmSans(textStyle: FontThemeData.categoryName),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
