import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../types/job_post_compact.dart';
import '../../../ui/job/index.dart';
import '../../../ui/theme_data/fonts.dart';

class JobPost extends StatelessWidget {
  final JobPostCompact jobPost;
  const JobPost({required Key key, required this.jobPost}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
      ),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => JobPage(key: UniqueKey(), id: jobPost.id),
          ),
        );
      },
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              border: Border.all(
                width: 1,
                style: BorderStyle.solid,
                color: const Color.fromRGBO(216, 216, 216, 1.0),
              ),
            ),
            child: Image(
              width: 80.0,
              height: 80.0,
              fit: BoxFit.cover,
              image: NetworkImage(jobPost.image,
                  headers: {'Keep-Alive': 'timeout=5, max=1000'}),
            ),
          ),
          const SizedBox(width: 10.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 180.0,
                child: Text(
                  jobPost.title,
                  style: GoogleFonts.dmSans(
                    textStyle: FontThemeData.jobItemName,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              const SizedBox(height: 5.0),
              Text(
                jobPost.companyName,
                style: GoogleFonts.dmSans(
                  textStyle: FontThemeData.jobItemCompanyName,
                ),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 5.0),
              Text(
                jobPost.jobTypeAndLocation,
                style: GoogleFonts.dmSans(
                  textStyle: FontThemeData.jobItemTypeAndLocation,
                ),
                textAlign: TextAlign.left,
              ),
            ],
          ),
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: Text(
              jobPost.salaryInfo,
              softWrap: true,
              style: GoogleFonts.dmSans(
                textStyle: FontThemeData.jobItemSalary,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
