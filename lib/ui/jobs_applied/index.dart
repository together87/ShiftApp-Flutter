import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../components/main/drawer.dart';
import '../../components/shared/jobs/job_post_applied.dart';
import '../../data/job.dart';
import '../../types/navigation.dart';
import '../../ui/theme_data/fonts.dart';

class JobsAppliedFor extends StatefulWidget {
  const JobsAppliedFor({super.key});

  @override
  State<JobsAppliedFor> createState() => _JobsAppliedForState();
}

class _JobsAppliedForState extends State<JobsAppliedFor> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final jobProvider = Provider.of<JobProvider>(context, listen: false);
      await jobProvider.loadJobsApplied(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final jobProvider = Provider.of<JobProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
          child: Image(
            width: 85.0,
            image: AssetImage('assets/images/logo.png'),
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color.fromRGBO(248, 248, 248, 1.0),
        shadowColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      drawer: PageDrawer(key: UniqueKey(), page: PAGES.applications),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          color: const Color.fromRGBO(248, 248, 248, 1.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 15.0),
              Text(
                "Job Applications",
                style:
                    GoogleFonts.dmSans(textStyle: FontThemeData.sectionTitles),
              ),
              const SizedBox(height: 15.0),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: jobProvider.jobsApplied.length,
                  itemBuilder: (_, i) {
                    return JobPostAppliedItem(
                        key: UniqueKey(), jobPost: jobProvider.jobsApplied[i]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
