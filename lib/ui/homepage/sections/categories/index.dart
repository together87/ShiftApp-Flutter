import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import './item.dart';
import '../../../../data/job.dart';
import '../../../theme_data/fonts.dart';

class JobCategoriesList extends StatefulWidget {
  const JobCategoriesList({super.key});

  @override
  State<JobCategoriesList> createState() => _JobCategoriesListState();
}

class _JobCategoriesListState extends State<JobCategoriesList> {
  @override
  void initState() {
    super.initState();
    final jobProvider = Provider.of<JobProvider>(context, listen: false);
    jobProvider.loadCategories(context);
  }

  @override
  Widget build(BuildContext context) {
    final jobProvider = Provider.of<JobProvider>(context);
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, right: 20.0),
      child: Container(
        transform: Matrix4.translationValues(20.0, 0.0, 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Categories",
              style: GoogleFonts.dmSans(textStyle: FontThemeData.sectionTitles),
            ),
            const SizedBox(height: 15.0),
            SizedBox(
              height: 120.0,
              child: ListView.builder(
                clipBehavior: Clip.none,
                scrollDirection: Axis.horizontal,
                itemCount: jobProvider.categories.length,
                itemBuilder: (_, i) {
                  return JobCategoryItem(
                    key: UniqueKey(),
                    id: jobProvider.categories[i].id,
                    name: jobProvider.categories[i].name,
                    icon: jobProvider.categories[i].icon,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
