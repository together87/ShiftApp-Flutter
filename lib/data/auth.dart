import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../types/register_user.dart';
import '../types/resume.dart';
import '../types/skill.dart';
import '../types/user.dart';
import '../utils/constants.dart';

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  late User _user;
  final List<Skill> _skills = <Skill>[];
  final List<Resume> _resumes = <Resume>[];
  final List<Skill> _allSkills = <Skill>[];

  bool get isAuthenticated => _isAuthenticated;
  User get user => _user;
  List<Skill> get skills => _skills;
  List<Skill> get allSkills => _allSkills;
  List<Resume> get resumes => _resumes;

  Future<bool> checkLogin(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final auth = prefs.getBool('auth');

    if (auth == null) {
      return false;
    }

    if (auth) {
      return true;
    } else {
      return false;
    }
  }

  Future<String> login(String email, String password) async {
    final Uri uri =
        Uri.parse('${AppConstants.API_URL}${AppConstants.USER_LOGIN}');
    final response = await http.post(uri, body: {
      'email': email,
      'password': password,
      'device_name': await getDeviceId(),
    }, headers: {
      'Accept': 'application/json',
    });

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      String token = data['data']['token'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('auth', true);
      await saveToken(token);
      _isAuthenticated = true;

      final userDetails = await http.get(
          Uri.parse('${AppConstants.API_URL}${AppConstants.USER_DETAILS}'),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token'
          });

      if (userDetails.statusCode == 200) {
        Map<String, dynamic> userDetailsJson = json.decode(userDetails.body);
        _user = User.fromJson(userDetailsJson["data"]);
      }

      String? fcmToken = await FirebaseMessaging.instance.getToken();

      final Uri uri = Uri.parse(
          '${AppConstants.API_URL}${AppConstants.SAVE_NOTIFICATION_DEVICE}');
      final fcmTokenresponse = await http.post(uri, body: {
        'user_id': user.id.toString(),
        'device_key': fcmToken,
      }, headers: {
        'Accept': 'application/json',
      });

      if (fcmTokenresponse.statusCode != 200) {
        return 'Failed to Save Device Information, please try again.';
      }

      notifyListeners();
      return '';
    }

    if (response.statusCode != 200) {
      return json.decode(response.body)['message'];
    }

    return '';
  }

  Future<bool> register(RegisterUser user) async {
    final Uri uri =
        Uri.parse('${AppConstants.API_URL}${AppConstants.USER_REGISTER}');
    final response = await http.post(uri, body: {
      'email': user.email,
      'password': user.password,
      'password_confirmation': user.passwordConfirmation,
      'img_url': '${AppConstants.API_URL}/img/logo.png',
      'first_name': user.firstName,
      'last_name': user.lastName,
      'date_of_birth': DateFormat('yyyy-MM-dd')
          .format(DateFormat('MMMM d, yyyy').parse(user.dateOfBirth)),
      'profession': user.profession,
      'short_bio': user.bio,
    }, headers: {
      'Accept': 'application/json',
    });

    if (response.statusCode == 201) {
      return true;
    }

    if (response.statusCode == 422) {
      return false;
    }

    return false;
  }

  Future<bool> getUserDetails() async {
    String? token = await getToken();
    final userDetails = await http.get(
        Uri.parse('${AppConstants.API_URL}${AppConstants.USER_DETAILS}'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        });

    if (userDetails.statusCode == 200) {
      Map<String, dynamic> userDetailsJson = json.decode(userDetails.body);
      _user = User.fromJson(userDetailsJson["data"]);

      return true;
    }

    notifyListeners();
    return false;
  }

  Future<void> loadUserMetaInfo() async {
    String? token = await getToken();
    final Uri skillsUrl = Uri.parse(
        "${AppConstants.API_URL}${AppConstants.USER_SKILLS}/${user.id}");
    final skillsResponse = await http.get(skillsUrl, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });
    if (skillsResponse.statusCode == 200) {
      Map<String, dynamic> data = json.decode(skillsResponse.body);
      _skills.clear();
      data["data"].forEach(
        (skill) => {
          _skills.add(
            Skill.fromJson(skill),
          ),
        },
      );
    } else {
      throw Exception('Problem loading skills for user.');
    }

    final Uri resumeUrl = Uri.parse(
        "${AppConstants.API_URL}${AppConstants.USER_RESUMES}/${user.id}");
    final resumeResponse = await http.get(resumeUrl, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });
    if (resumeResponse.statusCode == 200) {
      Map<String, dynamic> data = json.decode(resumeResponse.body);
      _resumes.clear();
      data["data"].forEach(
        (resume) => {
          _resumes.add(
            Resume.fromJson(resume),
          ),
        },
      );
    } else {
      throw Exception('Problem loading resumes for user.');
    }

    notifyListeners();
    return;
  }

  Future<void> loadSkills() async {
    String? token = await getToken();
    final Uri skillsUrl =
        Uri.parse("${AppConstants.API_URL}${AppConstants.SKILLS_INDEX}");
    final skillsResponse = await http.get(skillsUrl, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });
    if (skillsResponse.statusCode == 200) {
      Map<String, dynamic> data = json.decode(skillsResponse.body);
      _allSkills.clear();
      data["data"].forEach(
        (skill) => {
          _allSkills.add(
            Skill.fromJson(skill),
          ),
        },
      );
    } else {
      throw Exception('Problem loading skills list from database.');
    }

    notifyListeners();
    return;
  }

  addSkillToList(Skill skill) async {
    _skills.add(skill);
    notifyListeners();
  }

  removeSkillFromList(Skill skill) async {
    _skills.remove(skill);
    notifyListeners();
  }

  getDeviceId() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo build = await deviceInfoPlugin.androidInfo;
        return build.id;
      } else if (Platform.isIOS) {
        IosDeviceInfo data = await deviceInfoPlugin.iosInfo;
        return data.identifierForVendor;
      }
    } on PlatformException {
      // ignore: avoid_print
      print('Failed to get platform version');
    }
  }

  saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return token;
  }

  logout() async {
    String? token = await getToken();
    final Uri logout =
        Uri.parse("${AppConstants.API_URL}${AppConstants.USER_LOGOUT}");
    final logoutResponse = await http.get(logout, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });

    if (logoutResponse.statusCode == 200) {
      _isAuthenticated = false;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    } else {
      throw Exception("Couldn't log out.");
    }
  }
}
