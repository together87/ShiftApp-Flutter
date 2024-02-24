import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../components/main/drawer.dart';
import '../../data/auth.dart';
import '../../types/job_post_detailed.dart';
import '../../types/navigation.dart';
import '../../types/resume.dart';
import '../../ui/theme_data/fonts.dart';
import '../../utils/constants.dart';

class JobPage extends StatefulWidget {
  final int id;
  const JobPage({required Key key, required this.id}) : super(key: key);

  @override
  State<JobPage> createState() => _JobPageState();
}

class _JobPageState extends State<JobPage> {
  JobPostDetailed jobPost = JobPostDetailed(
    id: 0,
    hasApplied: false,
    isSelected: false,
    isSaved: false,
    image: '',
    title: '',
    companyName: '',
    companySize: '',
    deadlineDate: '',
    jobCategory: '',
    isRemote: false,
    jobLocation: '',
    jobType: '',
    desc: '',
    payRangeExists: true,
    skills: [],
  );

  Future<void> initJob(BuildContext ctx) async {
    final userProvider = Provider.of<AuthProvider>(ctx, listen: false);
    String? token = await userProvider.getToken();
    final userId = userProvider.user.id;
    final Uri url = Uri.parse(
        "${AppConstants.API_URL}${AppConstants.JOBS_RETRIEVAL}?job_id=${widget.id}&user_id=$userId");
    final response = await http.get(url, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        jobPost = JobPostDetailed.fromJson(data["data"]);
      });

      return;
    } else {
      throw Exception('Problem loading job information.');
    }
  }

  Future<void> saveJob(BuildContext context) async {
    final userProvider = Provider.of<AuthProvider>(context, listen: false);
    String? token = await userProvider.getToken();
    final userId = userProvider.user.id;
    final Uri url =
        Uri.parse("${AppConstants.API_URL}${AppConstants.JOBS_SAVED}");
    final String currTime =
        DateFormat('yyyy-MM-dd hh:mm:ss').format(DateTime.now()).toString();
    final response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(
          {'job_id': jobPost.id, 'user_id': userId, 'saved_time': currTime}),
    );

    if (response.statusCode == 201) {
      // ignore: use_build_context_synchronously
      await initJob(context);
      return;
    } else {
      throw Exception('Couldn\'t save the job post.');
    }
  }

  Future<void> deleteSavedJob(BuildContext context) async {
    final userProvider = Provider.of<AuthProvider>(context, listen: false);
    String? token = await userProvider.getToken();
    final userId = userProvider.user.id;
    final Uri url = Uri.parse(
        "${AppConstants.API_URL}${AppConstants.JOBS_SAVED_REMOVE}/$userId/${widget.id}");
    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      // ignore: use_build_context_synchronously
      await initJob(context);
      return;
    } else {
      throw Exception('Couldn\'t remove job post from the saved list.');
    }
  }

  Future<void> applyJob(BuildContext context, id) async {
    final userProvider = Provider.of<AuthProvider>(context, listen: false);
    String? token = await userProvider.getToken();
    final userId = userProvider.user.id;
    final Uri url =
        Uri.parse("${AppConstants.API_URL}${AppConstants.APPLY_FOR_JOB}");
    final String currTime =
        DateFormat('yyyy-MM-dd hh:mm:ss').format(DateTime.now()).toString();
    final response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode({
        'job_id': jobPost.id,
        'user_id': userId,
        'resume_id': id,
        'applied_time': currTime,
        'is_shortlisted': false,
        'selected_time': currTime,
        'is_read': false,
        'read_receipt_time': currTime,
      }),
    );

    if (response.statusCode == 201) {
      return;
    } else {
      throw Exception('Couldn\'t apply for the job post.');
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await initJob(context);
      // ignore: use_build_context_synchronously
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.loadUserMetaInfo();
    });
  }

  showAlertResumeList(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Remove skills on list
    Future<List<Resume>> loadListAfterClear() async {
      final List<Resume> resumeList = authProvider.resumes;
      return resumeList;
    }

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Center(child: Text("Select Your Preferred Resume")),
      titleTextStyle:
          GoogleFonts.dmSans(textStyle: FontThemeData.jobPostSecondHeadingBold),
      actions: [
        SizedBox(
          width: 250.0,
          height: 120.0,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 200.0,
                child: FutureBuilder<List<Resume>>(
                  future: loadListAfterClear(),
                  builder: (context, future) {
                    if (!future.hasData) {
                      return const Text(
                          'No Resumes Found, Please upload a Resume.');
                    } else {
                      List<Resume>? resumes = future.data;
                      if (resumes!.isEmpty) {
                        return const Text(
                            'No Resumes Found, Please upload a Resume.');
                      }
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: resumes.length,
                        shrinkWrap: true,
                        itemBuilder: (_, i) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                right: 10.0, bottom: 20.0),
                            child: GestureDetector(
                              onTap: () {
                                applyJob(context, resumes[i].id).then(
                                  (value) => {
                                    initJob(context),
                                    Navigator.of(context).pop(),
                                  },
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 15.0),
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromRGBO(231, 231, 231, 1.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 5.0,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.file_open,
                                      color: Colors.black.withOpacity(0.5),
                                    ),
                                    const SizedBox(height: 5.0),
                                    SizedBox(
                                      width: 80.0,
                                      child: Text(
                                        authProvider.resumes[i].fileName,
                                        style: GoogleFonts.dmSans(
                                            textStyle:
                                                FontThemeData.resumeTitle),
                                        softWrap: true,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(height: 5.0),
                                    SizedBox(
                                      width: 80.0,
                                      child: Text(
                                        authProvider.resumes[i].docType,
                                        style: GoogleFonts.dmSans(
                                            textStyle:
                                                FontThemeData.resumeDocType),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (context) {
        return alert;
      },
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget consentBtn = ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromRGBO(93, 216, 171, 1.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2.0),
        ),
      ),
      child: Text("Yes, Understood", style: GoogleFonts.dmSans()),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget contactUsBtn = TextButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2.0),
            side: const BorderSide(color: Color.fromRGBO(226, 232, 240, 1.0))),
      ),
      child: Text("Contact us", style: GoogleFonts.dmSans(color: Colors.black)),
      onPressed: () {
        launchUrl(Uri.parse("${AppConstants.STATIC_WEB_URL}/contact-us"));
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Center(
          child: Text((jobPost.isSelected) ? "Congrats" : "Job Applied")),
      titleTextStyle:
          GoogleFonts.dmSans(textStyle: FontThemeData.jobPostSecondHeadingBold),
      content: Text(
        (jobPost.isSelected)
            ? "You’ve been selected for the role of ${jobPost.title} for ${jobPost.companyName}. ${jobPost.companyName}, will get in touch with you soon and provide you with more information on how to move forward. \n \n If you’re not contacted by ${jobPost.companyName}, please reach out to ${AppConstants.CONTACT_EMAIL} or click the button below."
            : "You’ve applied for this job post, once ${jobPost.companyName} has shortlisted you for the role, you'll be notified. If you have any further queries, please reach out to ${AppConstants.CONTACT_EMAIL} or click the button below.",
        style: GoogleFonts.dmSans(textStyle: FontThemeData.jobPostText),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            consentBtn,
            const SizedBox(width: 10.0),
            contactUsBtn,
          ],
        ),
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double attributeContainer = 50.0;
    double attributeContainerText = attributeContainer + 10.0;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(248, 248, 248, 1.0),
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
      drawer: PageDrawer(key: UniqueKey(), page: PAGES.none),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          color: const Color.fromRGBO(248, 248, 248, 1.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              (jobPost.isSelected)
                  ? ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                        backgroundColor:
                            const Color.fromRGBO(209, 250, 229, 1.0),
                        elevation: 0,
                      ),
                      onPressed: () {
                        showAlertDialog(context);
                      },
                      child: SizedBox(
                        width: width,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.circle_notifications_outlined,
                              size: 15.0,
                              color: Color.fromRGBO(16, 185, 129, 1.0),
                            ),
                            const SizedBox(width: 10.0),
                            SizedBox(
                              width: width * 0.5,
                              child: Text(
                                "Congrats, You’ve been selected as a candidate.",
                                style: GoogleFonts.dmSans(
                                    textStyle:
                                        FontThemeData.notificationMsgText),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Text(
                              "What Now?",
                              style: GoogleFonts.dmSans(
                                  textStyle:
                                      FontThemeData.notificationMsgTextBold),
                              textAlign: TextAlign.left,
                            ),
                            const Icon(
                              Icons.close,
                              size: 20.0,
                              color: Color.fromRGBO(16, 185, 129, 1.0),
                            ),
                          ],
                        ),
                      ),
                    )
                  : const SizedBox(),
              const SizedBox(height: 10.0),
              Row(children: <Widget>[
                Container(
                  width: 100.0,
                  height: 100.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(
                      width: 1,
                      style: BorderStyle.solid,
                      color: const Color.fromRGBO(216, 216, 216, 1.0),
                    ),
                    color: Colors.white,
                  ),
                  child: (jobPost.image == '')
                      ? const Image(
                          width: 20.0,
                          image: AssetImage('assets/images/logo.png'))
                      : Image(
                          width: 20.0,
                          image: NetworkImage(jobPost.image),
                        ),
                ),
                const SizedBox(width: 10.0),
                SizedBox(
                  height: 100.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(height: 5.0),
                      Text(jobPost.companyName,
                          style: GoogleFonts.dmSans(
                              textStyle: FontThemeData.jobPostCompanyName)),
                      const SizedBox(height: 5.0),
                      (jobPost.jobLocation.isNotEmpty)
                          ? Text(jobPost.jobLocation,
                              style: GoogleFonts.dmSans(
                                  textStyle:
                                      FontThemeData.jobPostSecondHeading))
                          : const SizedBox(),
                      const SizedBox(height: 5.0),
                      Text("1 - 10 Employees",
                          style: GoogleFonts.dmSans(
                              textStyle: FontThemeData.jobPostEmployeeCount))
                    ],
                  ),
                ),
              ]),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Is Looking for a",
                            style: GoogleFonts.raleway(
                                textStyle: FontThemeData.jobPostSecondHeading)),
                        const SizedBox(height: 5.0),
                        SizedBox(
                          width: width - 200.0,
                          child: Text(jobPost.title,
                              softWrap: true,
                              style: GoogleFonts.dmSans(
                                  textStyle: FontThemeData.jobPostName)),
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text("Application Deadline",
                            style: GoogleFonts.raleway(
                                textStyle: FontThemeData.jobPostThirdHeading)),
                        const SizedBox(height: 5.0),
                        Text(
                            (jobPost.deadlineDate != '')
                                ? DateFormat("d MMMM y").format(
                                    DateFormat("yyyy-mm-dd hh:mm:ss")
                                        .parse(jobPost.deadlineDate),
                                  )
                                : 'N/A',
                            style: GoogleFonts.dmSans(
                                textStyle: FontThemeData.jobPostDeadlineDate))
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: <Widget>[
                        Text("INDUSTRY",
                            style: GoogleFonts.dmSans(
                                textStyle:
                                    FontThemeData.jobPostAttributesTitle)),
                        const SizedBox(height: 5.0),
                        Image(
                          width: attributeContainer,
                          height: attributeContainer,
                          image: const AssetImage("assets/icons/industry.png"),
                        ),
                        const SizedBox(height: 5.0),
                        SizedBox(
                          width: attributeContainerText,
                          child: Text(
                            jobPost.jobCategory,
                            style: GoogleFonts.dmSans(
                                textStyle: FontThemeData.jobPostAttributesText),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    (jobPost.isRemote == false)
                        ? Column(
                            children: <Widget>[
                              Text("LOCATION",
                                  style: GoogleFonts.dmSans(
                                      textStyle: FontThemeData
                                          .jobPostAttributesTitle)),
                              const SizedBox(height: 5.0),
                              Image(
                                width: attributeContainer,
                                height: attributeContainer,
                                image: const AssetImage(
                                    "assets/icons/location.png"),
                              ),
                              const SizedBox(height: 10.0),
                              Text(jobPost.jobLocation,
                                  style: GoogleFonts.dmSans(
                                      textStyle:
                                          FontThemeData.jobPostAttributesText)),
                            ],
                          )
                        : const SizedBox(),
                    Column(
                      children: <Widget>[
                        Text("JOB TYPE",
                            style: GoogleFonts.dmSans(
                                textStyle:
                                    FontThemeData.jobPostAttributesTitle)),
                        const SizedBox(height: 5.0),
                        Image(
                          width: attributeContainer,
                          height: attributeContainer,
                          image: const AssetImage("assets/icons/job-type.png"),
                        ),
                        const SizedBox(height: 10.0),
                        Text(jobPost.jobType,
                            style: GoogleFonts.dmSans(
                                textStyle:
                                    FontThemeData.jobPostAttributesText)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10.0),
              Text(
                jobPost.desc,
                style: GoogleFonts.dmSans(textStyle: FontThemeData.jobPostText),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 10.0),
              (jobPost.skills.isNotEmpty)
                  ? Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 5.0),
                      child: Text(
                        "Skills",
                        style: GoogleFonts.raleway(
                            textStyle: FontThemeData.jobPostSecondHeadingBold),
                        textAlign: TextAlign.start,
                      ),
                    )
                  : const SizedBox(),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: width - 40.0,
                    height: 40.0,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      clipBehavior: Clip.none,
                      itemCount: jobPost.skills.length,
                      shrinkWrap: true,
                      itemBuilder: (_, i) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromRGBO(231, 231, 231, 1.0),
                            ),
                            child: Text(
                              jobPost.skills[i],
                              style: GoogleFonts.dmSans(
                                  textStyle: FontThemeData.btnBlackText),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              // EOF Padding to support BottomSheet Overflow
              const SizedBox(height: 100.0),
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        width: width,
        height: 80.0,
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            width: 1,
            style: BorderStyle.solid,
            color: const Color.fromRGBO(216, 216, 216, 1.0),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            (jobPost.payRangeExists)
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10.0),
                      Text("Salary Range",
                          style: GoogleFonts.raleway(
                              textStyle:
                                  FontThemeData.jobPostSalaryRangeTitle)),
                      const SizedBox(height: 2.0),
                      Text(
                          "${jobPost.minPayRange} - ${jobPost.maxPayRange} / Annual",
                          style: GoogleFonts.dmSans(
                              textStyle: FontThemeData.jobPostSalaryRangeText))
                    ],
                  )
                : const SizedBox(),
            Row(
              children: [
                (jobPost.hasApplied)
                    ? ElevatedButton(
                        onPressed: () {
                          showAlertDialog(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade400,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              10.0,
                            ),
                          ),
                        ),
                        child: const Text("APPLIED"),
                      )
                    : ElevatedButton(
                        onPressed: () {
                          showAlertResumeList(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromRGBO(21, 192, 182, 1.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              10.0,
                            ),
                          ),
                        ),
                        child: const Text("APPLY NOW"),
                      ),
                (jobPost.isSaved)
                    ? IconButton(
                        onPressed: () {
                          deleteSavedJob(context);
                        },
                        icon: const Icon(
                          Icons.bookmark,
                          size: 30.0,
                          color: Colors.black,
                        ),
                      )
                    : IconButton(
                        onPressed: () {
                          saveJob(context);
                        },
                        icon: const Icon(
                          Icons.bookmark_outline,
                          size: 30.0,
                          color: Colors.black,
                        ),
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
