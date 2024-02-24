import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../components/main/drawer.dart';
import '../../../data/auth.dart';
import '../../../types/navigation.dart';
import '../../../types/skill.dart';
import '../../../utils/constants.dart';
import '../../theme_data/fonts.dart';
import '../../theme_data/inputs.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  File image = File('');
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.loadSkills();
    });
  }

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        image = File(pickedFile.path);
      } else {
        throw Exception('No image selected.');
      }
    });
  }

  Future<Widget> buildImage() async {
    bool exists = await image.exists();
    if (!exists) {
      return const Padding(
        padding: EdgeInsets.fromLTRB(1, 1, 1, 1),
        child: Icon(
          Icons.add,
          color: Colors.grey,
        ),
      );
    } else {
      return Text(image.path);
    }
  }

  Future<String> uploadImage(File img) async {
    final userProvider = Provider.of<AuthProvider>(context, listen: false);
    String? token = await userProvider.getToken();
    Map<String, String> headers = {
      'Content-Type': 'multipart/form-data',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var request = http.MultipartRequest('POST',
        Uri.parse("${AppConstants.API_URL}${AppConstants.UPLOAD_IMG_URL}"))
      ..headers.addAll(headers)
      ..files.add(await http.MultipartFile.fromPath('image', img.path));
    var response = await request.send();
    if (response.statusCode == 200) {
      final responseString = await response.stream.bytesToString();
      Map<String, dynamic> data = json.decode(responseString);
      return data['data']['file_name'];
    } else {
      throw Exception('Couldn\'t upload the profile picture.');
    }
  }

  Future<void> saveSettings(BuildContext ctx) async {
    final userProvider = Provider.of<AuthProvider>(ctx, listen: false);
    String? token = await userProvider.getToken();
    late String imgUrl;

    if (image.path != '') {
      String res = await uploadImage(image);
      imgUrl =
          "${AppConstants.API_URL}${AppConstants.UPLOAD_IMG_DIRECTORY}/$res";
    }

    final userId = userProvider.user.id;
    final Uri url = Uri.parse(
        "${AppConstants.API_URL}${AppConstants.USER_SAVE_PROFILE}/$userId");
    final response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode({
        'img_url': (image.path == '') ? userProvider.user.img : imgUrl,
        'first_name': userProvider.user.firstName,
        'last_name': userProvider.user.lastName,
        'profession': userProvider.user.profession,
        'short_bio': userProvider.user.bio,
      }),
    );
    if (response.statusCode == 200) {
      String skillsList =
          userProvider.skills.map((skill) => skill.id).toString();
      skillsList = skillsList.substring(1, skillsList.length - 1);

      final Uri skillsUrl = Uri.parse(
          "${AppConstants.API_URL}${AppConstants.USER_SKILLS}/$userId");
      final skillsResponse = await http.post(
        skillsUrl,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({'skills': skillsList}),
      );

      if (skillsResponse.statusCode == 200) {
        await userProvider.getUserDetails();
        // ignore: use_build_context_synchronously
        Navigator.of(ctx).pop();
        return;
      } else {
        throw Exception("Couldn't update user skills.");
      }
    } else {
      throw Exception("Couldn't update user profile.");
    }
  }

  showAlertSkillList(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Remove skills on list
    Future<List<Skill>> loadListAfterClear() async {
      final List<Skill> skillList = authProvider.allSkills;
      for (var item in authProvider.skills) {
        skillList.removeWhere((element) => element.id == item.id);
      }
      return skillList;
    }

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Center(child: Text("Add Skill to Profile")),
      titleTextStyle:
          GoogleFonts.dmSans(textStyle: FontThemeData.jobPostSecondHeadingBold),
      actions: [
        SizedBox(
          width: 250.0,
          height: 180.0,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 200.0,
                child: FutureBuilder<List<Skill>>(
                  future: loadListAfterClear(),
                  builder: (context, future) {
                    if (!future.hasData) {
                      return const Text('No Skills Found.');
                    } else {
                      List<Skill>? skills = future.data;
                      if (skills!.isEmpty) {
                        return const Text('No Skills Found.');
                      }
                      return ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: skills.length,
                        shrinkWrap: true,
                        itemBuilder: (_, i) {
                          return Center(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal.shade400,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(2.0),
                                ),
                              ),
                              child: Text(skills[i].name,
                                  style: GoogleFonts.dmSans()),
                              onPressed: () {
                                authProvider.addSkillToList(skills[i]);
                                authProvider.loadSkills();
                                Navigator.of(context).pop();
                              },
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10.0),
              Row(
                children: <Widget>[
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
                    child: GestureDetector(
                      onTap: () async {
                        await getImage();
                      },
                      child: (image.path == '')
                          ? Image(
                              width: 20.0,
                              image: NetworkImage(authProvider.user.img,
                                  headers: {
                                    'Keep-Alive': 'timeout=5, max=1000'
                                  }),
                            )
                          : Image(
                              width: 20.0,
                              image: FileImage(image),
                            ),
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
                          child: Text("Profile Picture",
                              style: GoogleFonts.dmSans(
                                  textStyle:
                                      FontThemeData.profilePagePrimaryTitle)),
                        ),
                        const SizedBox(height: 5.0),
                        SizedBox(
                          width: width - 150.0,
                          child: Text(
                              "Tap the picture to upload a new image here.",
                              style: GoogleFonts.dmSans(
                                  textStyle: FontThemeData.profilePageHintTxt)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10.0),
                  Text(
                    "Personal",
                    style: GoogleFonts.dmSans(
                        textStyle: FontThemeData.profilePageSecondaryTitle),
                  ),
                  const SizedBox(height: 10.0),
                  // First Name Field
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 10.0,
                      bottom: 10.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "First name",
                          style: GoogleFonts.dmSans(
                              textStyle: FontThemeData.inputLabel),
                        ),
                        TextFormField(
                          style: const TextStyle(
                            color: Colors.black,
                            decorationColor: Colors.black,
                          ),
                          keyboardType: TextInputType.name,
                          initialValue: authProvider.user.firstName,
                          onChanged: (value) {
                            authProvider.user.firstName = value;
                          },
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 5.0),
                            filled: true,
                            fillColor: Colors.white,
                            hintStyle: const TextStyle(
                                color: Colors.grey, fontSize: 15.0),
                            enabledBorder: InputsThemeData.inputForm,
                            focusedBorder: InputsThemeData.inputFormSelected,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Last Name Field
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 10.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Last name",
                          style: GoogleFonts.dmSans(
                              textStyle: FontThemeData.inputLabel),
                        ),
                        TextFormField(
                          style: const TextStyle(
                            color: Colors.black,
                            decorationColor: Colors.black,
                          ),
                          keyboardType: TextInputType.name,
                          initialValue: authProvider.user.lastName,
                          onChanged: (value) {
                            authProvider.user.lastName = value;
                          },
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 5.0),
                            filled: true,
                            fillColor: Colors.white,
                            hintStyle: const TextStyle(
                                color: Colors.grey, fontSize: 15.0),
                            enabledBorder: InputsThemeData.inputForm,
                            focusedBorder: InputsThemeData.inputFormSelected,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Profession Field
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 10.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Profession",
                          style: GoogleFonts.dmSans(
                              textStyle: FontThemeData.inputLabel),
                        ),
                        TextFormField(
                          style: const TextStyle(
                            color: Colors.black,
                            decorationColor: Colors.black,
                          ),
                          keyboardType: TextInputType.name,
                          initialValue: authProvider.user.profession,
                          onChanged: (value) {
                            authProvider.user.profession = value;
                          },
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 5.0),
                            filled: true,
                            fillColor: Colors.white,
                            hintStyle: const TextStyle(
                                color: Colors.grey, fontSize: 15.0),
                            enabledBorder: InputsThemeData.inputForm,
                            focusedBorder: InputsThemeData.inputFormSelected,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Short Bio Field
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Bio",
                        style: GoogleFonts.dmSans(
                            textStyle: FontThemeData.inputLabel),
                      ),
                      TextFormField(
                        initialValue: authProvider.user.bio,
                        onChanged: (value) {
                          authProvider.user.bio = value;
                        },
                        maxLines: 10,
                        maxLength: 500,
                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: InputsThemeData.inputForm,
                          focusedBorder: InputsThemeData.inputFormSelected,
                          isDense: true,
                        ),
                        enableSuggestions: true,
                      ),
                    ],
                  ),
                  // Skills
                  const SizedBox(height: 20.0),
                  Text(
                    "Skills",
                    style: GoogleFonts.dmSans(
                        textStyle: FontThemeData.profilePageSecondaryTitle),
                  ),
                  const SizedBox(height: 10.0),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      width: width,
                      constraints: const BoxConstraints(minHeight: 60.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color.fromRGBO(203, 213, 225, 1.0),
                        ),
                        color: Colors.white,
                      ),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: SizedBox(
                        width: width,
                        child: Wrap(
                          spacing: 10.0,
                          direction: Axis.horizontal,
                          children: [
                            (authProvider.skills.isNotEmpty)
                                ? Container(
                                    width: width - 40.0,
                                    constraints: const BoxConstraints(
                                        minHeight: 60.0, maxHeight: 200.0),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10.0),
                                    child: ListView.builder(
                                      itemCount: authProvider.skills.length,
                                      shrinkWrap: true,
                                      itemBuilder: (_, i) {
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8.0),
                                          child: ElevatedButton(
                                            onPressed: () {},
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color.fromRGBO(
                                                      93, 216, 171, 1.0),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  authProvider.skills[i].name,
                                                  softWrap: true,
                                                  style: GoogleFonts.dmSans(
                                                      textStyle: FontThemeData
                                                          .btnBlackText),
                                                ),
                                                const SizedBox(width: 8.0),
                                                GestureDetector(
                                                  onTap: () {
                                                    authProvider
                                                        .removeSkillFromList(
                                                            authProvider
                                                                .skills[i]);
                                                    authProvider.loadSkills();
                                                  },
                                                  child: const Icon(
                                                    Icons.close,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                : const Text("No Skills Added"),
                            Center(
                              child: IconButton(
                                onPressed: () {
                                  showAlertSkillList(context);
                                },
                                icon: const Icon(Icons.add),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 100.0),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        width: width,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              width: 2.0,
              color: Colors.black.withOpacity(0.25),
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0, right: 20.0, bottom: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(21, 192, 182, 1.0),
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 25.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      10.0,
                    ),
                  ),
                ),
                onPressed: () {
                  saveSettings(context);
                },
                child: Row(
                  children: [
                    const Icon(Icons.save_outlined, size: 15.0),
                    const SizedBox(width: 5.0),
                    Text(
                      "SAVE",
                      style:
                          GoogleFonts.dmSans(textStyle: FontThemeData.btnText),
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
