import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../data/job.dart';
import '../../../types/job_post_shortlist.dart';
import '../../../ui/job/index.dart';
import '../../../ui/theme_data/fonts.dart';

class JobPostShortlistedItem extends StatelessWidget {
  final bool isRead;
  final JobPostShortlist jobPost;
  const JobPostShortlistedItem(
      {required Key key, required this.jobPost, required this.isRead})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final jobProvider = Provider.of<JobProvider>(context);
    return TextButton(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
      ),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => JobPage(key: UniqueKey(), id: 2),
          ),
        );
      },
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              jobProvider.toggleShortlistReadStatus(context, jobPost.id);
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(
                (isRead) ? Icons.mark_chat_read : Icons.mark_chat_unread,
                color: (isRead)
                    ? const Color.fromRGBO(21, 192, 182, 1.0)
                    : const Color.fromRGBO(0, 0, 0, 0.4),
              ),
            ),
          ),
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
              DateFormat("d MMMM y").format(
                DateFormat("dd-mm-yyyy hh:mm:ss")
                    .parse(jobPost.shortlistedDate),
              ),
              softWrap: true,
              style: GoogleFonts.dmSans(
                textStyle: FontThemeData.jobItemMomentsAgo,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
