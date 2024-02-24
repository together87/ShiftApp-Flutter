import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as p;
import 'package:provider/provider.dart';

import '../../../data/auth.dart';
import '../../../utils/constants.dart';
import '../../components/main/drawer.dart';
import '../../types/navigation.dart';
import '../../ui/profile/edit/index.dart';
import '../theme_data/fonts.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.loadUserMetaInfo();
    });
  }

  Future<void> uploadResumeToUser(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    late File doc;
    if (result != null) {
      doc = File(result.files.single.path!);
    } else {
      return;
    }
    // Upload Doc to Database
    // ignore: use_build_context_synchronously
    final userProvider = Provider.of<AuthProvider>(context, listen: false);
    String? token = await userProvider.getToken();
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-Type': 'multipart/form-data',
      'Authorization': 'Bearer $token'
    };
    var request = http.MultipartRequest('POST',
        Uri.parse("${AppConstants.API_URL}${AppConstants.UPLOAD_DOC_URL}"))
      ..headers.addAll(headers)
      ..files.add(await http.MultipartFile.fromPath('doc', doc.path));
    var response = await request.send();
    if (response.statusCode == 200) {
      final responseString = await response.stream.bytesToString();
      Map<String, dynamic> data = json.decode(responseString);
      final Uri saveUrl =
          Uri.parse("${AppConstants.API_URL}${AppConstants.RESUME_CREATE_URL}");
      final saveDocResponse = await http.post(
        saveUrl,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(
          {
            'user_id': userProvider.user.id,
            'file_name': p.basename(doc.path),
            'doc_type': data['data']['ext'],
            'download_url':
                "${AppConstants.API_URL}${AppConstants.UPLOAD_DOC_DIRECTORY}/${data['data']['file_name']}",
            'is_shared': true,
          },
        ),
      );

      if (saveDocResponse.statusCode == 201) {
        await userProvider.loadUserMetaInfo();
        return;
      } else {
        throw Exception('Problem saving document to database');
      }
    } else {
      throw Exception('Problem uploading resume document.');
    }
  }

  Future<void> deleteResumeFromUser(BuildContext context, int id) async {
    final userProvider = Provider.of<AuthProvider>(context, listen: false);
    String? token = await userProvider.getToken();
    final Uri url = Uri.parse(
        "${AppConstants.API_URL}${AppConstants.RESUME_DELETE_URL}/$id");
    final response = await http.get(url, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });

    if (response.statusCode == 200) {
      await userProvider.loadUserMetaInfo();
      return;
    } else {
      throw Exception('Trouble removing the resume from the user');
    }
  }

  openResumeDeleteDialog(BuildContext context, id) {
    // set up the buttons
    Widget consentBtn = ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromRGBO(255, 0, 0, 1.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2.0),
        ),
      ),
      child: Text("Yes, Delete", style: GoogleFonts.dmSans()),
      onPressed: () async {
        await deleteResumeFromUser(context, id)
            .then((value) => Navigator.of(context).pop());
      },
    );
    Widget cancelBtn = TextButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2.0),
            side: const BorderSide(color: Color.fromRGBO(226, 232, 240, 1.0))),
      ),
      child: Text("No, Exit", style: GoogleFonts.dmSans(color: Colors.black)),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Center(
          child: Text("CAUTION!!! You're about to delete a resume")),
      titleTextStyle:
          GoogleFonts.dmSans(textStyle: FontThemeData.jobPostSecondHeadingBold),
      content: Text(
        "Once you delete your resume, you cannot undo it.",
        style: GoogleFonts.dmSans(textStyle: FontThemeData.jobPostText),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            consentBtn,
            const SizedBox(width: 10.0),
            cancelBtn,
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
    final authProvider = Provider.of<AuthProvider>(context);
    double width = MediaQuery.of(context).size.width;
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
      drawer: PageDrawer(key: UniqueKey(), page: PAGES.profile),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          color: const Color.fromRGBO(248, 248, 248, 1.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                child: Image(
                  width: 20.0,
                  image: NetworkImage(authProvider.user.img,
                      headers: {'Keep-Alive': 'timeout=5, max=1000'}),
                ),
              ),
              const SizedBox(width: 10.0),
              SizedBox(
                height: 100.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 5.0),
                    SizedBox(
                      width: width - 150.0,
                      child: Text(authProvider.user.name,
                          style: GoogleFonts.dmSans(
                              textStyle:
                                  FontThemeData.profilePagePrimaryTitle)),
                    ),
                    const SizedBox(height: 5.0),
                    SizedBox(
                      width: width - 150.0,
                      child: Text(authProvider.user.profession,
                          style: GoogleFonts.dmSans(
                              textStyle: FontThemeData.profilePageOccupation)),
                    ),
                  ],
                ),
              ),
            ]),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10.0),
                Text(
                  "About Yourself",
                  style: GoogleFonts.dmSans(
                      textStyle: FontThemeData.profilePageSecondaryTitle),
                ),
                const SizedBox(height: 10.0),
                SizedBox(
                  width: width,
                  child: Text(
                    authProvider.user.bio,
                    style: GoogleFonts.dmSans(
                        textStyle: FontThemeData.profilePageTxt),
                  ),
                ),
                const SizedBox(height: 20.0),
                Text(
                  "Skills",
                  style: GoogleFonts.dmSans(
                      textStyle: FontThemeData.profilePageSecondaryTitle),
                ),
                const SizedBox(height: 10.0),
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  SizedBox(
                    width: width - 40.0,
                    height: 40.0,
                    child: ListView.builder(
                        clipBehavior: Clip.none,
                        scrollDirection: Axis.horizontal,
                        itemCount: authProvider.skills.length,
                        shrinkWrap: true,
                        itemBuilder: (_, i) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 15.0),
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(231, 231, 231, 1.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 5.0,
                                  ),
                                ],
                              ),
                              child: Text(
                                authProvider.skills[i].name,
                                style: GoogleFonts.dmSans(
                                    textStyle: FontThemeData.btnBlackText),
                              ),
                            ),
                          );
                        }),
                  )
                ]),
                const SizedBox(height: 20.0),
                Text(
                  "Resumes",
                  style: GoogleFonts.dmSans(
                      textStyle: FontThemeData.profilePageSecondaryTitle),
                ),
                const SizedBox(height: 10.0),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: width - 100.0,
                      height: 100.0,
                      child: ListView.builder(
                        clipBehavior: Clip.hardEdge,
                        scrollDirection: Axis.horizontal,
                        itemCount: authProvider.resumes.length,
                        shrinkWrap: true,
                        itemBuilder: (_, i) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: GestureDetector(
                              onTap: () {
                                openResumeDeleteDialog(
                                    context, authProvider.resumes[i].id);
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
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        uploadResumeToUser(context);
                      },
                      icon: const Icon(
                        Icons.add_circle,
                        size: 40.0,
                        color: Color.fromRGBO(21, 192, 182, 1.0),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ]),
        ),
      ),
      bottomSheet: SizedBox(
        width: width,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10.0, right: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const EditProfilePage(),
                    ),
                  );
                },
                child: Row(
                  children: [
                    const Icon(Icons.edit, color: Colors.black, size: 15.0),
                    const SizedBox(width: 5.0),
                    Text(
                      "Edit Profile",
                      style: GoogleFonts.dmSans(
                          textStyle: FontThemeData.btnBlackText),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
