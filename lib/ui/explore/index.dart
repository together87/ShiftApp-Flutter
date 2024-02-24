import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../components/main/drawer.dart';
import '../../components/shared/jobs/job_post.dart';
import '../../data/job.dart';
import '../../types/navigation.dart';
import '../../ui/theme_data/fonts.dart';

class Explore extends StatefulWidget {
  const Explore({super.key});

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  @override
  void initState() {
    super.initState();
    final jobProvider = Provider.of<JobProvider>(context, listen: false);
    jobProvider.loadJobs(context);
  }

  @override
  Widget build(BuildContext context) {
    final jobProvider = Provider.of<JobProvider>(context);
    double height = MediaQuery.of(context).size.height;
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
      drawer: PageDrawer(key: UniqueKey(), page: PAGES.explore),
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          color: const Color.fromRGBO(248, 248, 248, 1.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              const SizedBox(height: 15.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Explore Jobs",
                    style: GoogleFonts.dmSans(
                        textStyle: FontThemeData.sectionTitles),
                  ),
                ],
              ),
              const SizedBox(height: 15.0),
              SizedBox(
                height: height,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 150.0),
                  child: ListView.builder(
                    // Removes scroll overflow glow (material design)
                    physics: const BouncingScrollPhysics(),
                    itemCount: jobProvider.jobPosts.length,
                    itemBuilder: (_, i) {
                      final now = DateTime.now();
                      final date = DateFormat('yyyy-M-dd hh:mm:ss')
                          .parse(jobProvider.jobPosts[i].expirationDate);
                      final bool isAhead = now.difference(date).isNegative;
                      return (isAhead)
                          ? JobPost(
                              key: UniqueKey(),
                              jobPost: jobProvider.jobPosts[i])
                          : const SizedBox();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
