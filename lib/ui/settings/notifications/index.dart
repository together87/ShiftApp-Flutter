import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../../components/main/drawer.dart';
import '../../../components/main/switch.dart';
import '../../../data/auth.dart';
import '../../../types/navigation.dart';
import '../../../types/notification_settings.dart';
import '../../../utils/constants.dart';
import '../../theme_data/fonts.dart';
import '../index.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  late NotificationSettings settings;

  Future<NotificationSettings> loadNotificationsSettings(
      BuildContext ctx) async {
    final userProvider = Provider.of<AuthProvider>(ctx, listen: false);
    String? token = await userProvider.getToken();
    final userId = userProvider.user.id;
    final Uri url = Uri.parse(
        "${AppConstants.API_URL}${AppConstants.USER_NOTIFICATION_SETTINGS}/$userId");
    final response = await http.get(url, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      settings = NotificationSettings.fromJson(data['data']);

      return settings;
    } else {
      throw Exception('Problem loading notification settings.');
    }
  }

  Future<void> saveNotificationSettings(
      BuildContext ctx, String objectKey) async {
    late NotificationSettings saveSettings;
    final userProvider = Provider.of<AuthProvider>(ctx, listen: false);
    String? token = await userProvider.getToken();
    final userId = userProvider.user.id;
    final Uri url = Uri.parse(
        "${AppConstants.API_URL}${AppConstants.USER_NOTIFICATION_SAVE_SETTINGS}");
    if (objectKey == 'shortlist') {
      saveSettings = NotificationSettings(
          shortListNotification:
              (settings.shortListNotification) ? false : true,
          inactivityNotification: settings.inactivityNotification);
    } else if (objectKey == 'inactivity') {
      saveSettings = NotificationSettings(
          shortListNotification: settings.inactivityNotification,
          inactivityNotification:
              (settings.inactivityNotification) ? false : true);
    }
    final response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(
        {
          'user_id': userId.toString(),
          'shortlisted_notification':
              (saveSettings.shortListNotification == true) ? "1" : "0",
          'inactivity_notification':
              (saveSettings.inactivityNotification == true) ? "1" : "0",
        },
      ),
    );
    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Problem saving notification settings.');
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
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
        child: FutureBuilder<NotificationSettings>(
          future: loadNotificationsSettings(context),
          builder: (context, future) {
            if (!future.hasData) {
              return Container();
            } else {
              final NotificationSettings? settings = future.data;
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                color: const Color.fromRGBO(248, 248, 248, 1.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    const SizedBox(height: 15.0),
                    SizedBox(
                      width: 130.0,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const SettingsPage(),
                            ),
                          );
                        },
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.chevron_left,
                                color: Colors.black54,
                              ),
                              const SizedBox(width: 5.0),
                              Text(
                                "Go Back",
                                style: GoogleFonts.dmSans(
                                  textStyle: FontThemeData.btnText,
                                  color: Colors.black,
                                ),
                              ),
                            ]),
                      ),
                    ),
                    const SizedBox(height: 15.0),
                    SizedBox(
                      width: width - 40.0,
                      child: Text(
                        "I want to receive notifications when...",
                        style: GoogleFonts.dmSans(
                            textStyle: FontThemeData.sectionTitles),
                      ),
                    ),
                    const SizedBox(height: 30.0),
                    // Job Selected Alert
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: width - 100.0,
                          child: Text(
                            "When i get selected for a job",
                            style: GoogleFonts.dmSans(
                                textStyle:
                                    FontThemeData.settingsListItemSecondary),
                          ),
                        ),
                        SizedBox(
                          height: 30.0,
                          child: CustomToggleSwitch(
                            key: UniqueKey(),
                            value: settings!.shortListNotification,
                            onChange: () {
                              saveNotificationSettings(context, 'shortlist');
                              loadNotificationsSettings(context);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    // Usage Inactivity Alert
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: width - 100.0,
                          child: Text(
                            "When i haven't been active for a while",
                            style: GoogleFonts.dmSans(
                                textStyle:
                                    FontThemeData.settingsListItemSecondary),
                          ),
                        ),
                        SizedBox(
                          height: 30.0,
                          child: CustomToggleSwitch(
                            key: UniqueKey(),
                            value: settings.inactivityNotification,
                            onChange: () {
                              saveNotificationSettings(context, 'inactivity');
                              loadNotificationsSettings(context);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
