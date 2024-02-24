import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../components/shared/jobs/job_post.dart';
import '../../../../data/job.dart';
import '../../../../ui/explore/index.dart';
import '../../../theme_data/fonts.dart';

class ExploreJobs extends StatefulWidget {
  const ExploreJobs({super.key});

  @override
  State<ExploreJobs> createState() => _ExploreJobsState();
}

class _ExploreJobsState extends State<ExploreJobs> {
  @override
  void initState() {
    super.initState();
    final jobProvider = Provider.of<JobProvider>(context, listen: false);
    jobProvider.loadHomePageJobs(context);
    jobProvider.loadJobsShortlistCount(context);
  }

  @override
  Widget build(BuildContext context) {
    final jobProvider = Provider.of<JobProvider>(context);
    const borderBlue = Color.fromRGBO(78, 115, 248, 1.0);
    return Container(
      padding: const EdgeInsets.only(top: 10.0, right: 20.0, left: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Explore Jobs",
            style: GoogleFonts.dmSans(textStyle: FontThemeData.sectionTitles),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: jobProvider.jobPosts.length,
              itemBuilder: (_, i) {
                final now = DateTime.now();
                final date = DateFormat('yyyy-M-dd hh:mm:ss')
                    .parse(jobProvider.jobPosts[i].expirationDate);
                final bool isAhead = now.difference(date).isNegative;
                return (isAhead)
                    ? (jobProvider.jobPosts[i].isPublished)
                        ? JobPost(
                            key: UniqueKey(), jobPost: jobProvider.jobPosts[i])
                        : const SizedBox()
                    : const SizedBox();
              },
            ),
          ),
          Center(
            child: SizedBox(
              width: 200.0,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.more),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const Explore(),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: borderBlue, width: 1),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                label: const Text("Explore more jobs"),
              ),
            ),
          ),
          const SizedBox(height: 20.0),
        ],
      ),
    );
  }
}
