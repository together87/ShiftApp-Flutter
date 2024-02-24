import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../data/auth.dart';
import '../../data/job.dart';
import '../../types/navigation.dart';
import '../../ui/authentication/login.dart';
import '../../ui/blog/index.dart';
import '../../ui/explore/index.dart';
import '../../ui/homepage/index.dart';
import '../../ui/jobs_applied/index.dart';
import '../../ui/profile/index.dart';
import '../../ui/saved_jobs/index.dart';
import '../../ui/selected_applications/index.dart';
import '../../ui/settings/index.dart';
import '../../ui/theme_data/fonts.dart';

class PageDrawer extends StatefulWidget {
  final PAGES page;
  const PageDrawer({required Key key, required this.page}) : super(key: key);

  @override
  State<PageDrawer> createState() => _PageDrawerState();
}

class _PageDrawerState extends State<PageDrawer> {
  get page => widget.page;

  @override
  Widget build(BuildContext context) {
    final jobProvider = Provider.of<JobProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    return SizedBox(
      width: 250.0,
      child: Drawer(
        key: UniqueKey(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: ListView(children: <Widget>[
            const SizedBox(height: 15.0),
            const SizedBox(
              width: 50.0,
              height: 50.0,
              child: Image(
                fit: BoxFit.contain,
                image: AssetImage('assets/images/logo.png'),
                alignment: Alignment.centerLeft,
              ),
            ),
            const SizedBox(height: 20.0),
            ListTile(
              leading: Icon(
                Icons.home,
                color: (page == PAGES.home)
                    ? const Color.fromRGBO(93, 216, 171, 1.0)
                    : const Color.fromRGBO(125, 123, 123, 1.0),
              ),
              title: Text(
                "Home",
                style: GoogleFonts.dmSans(
                  textStyle: (page == PAGES.home)
                      ? FontThemeData.menuItemActive
                      : FontThemeData.menuItem,
                ),
              ),
              tileColor: (page == PAGES.home)
                  ? const Color.fromRGBO(0, 244, 230, 0.1)
                  : Colors.transparent,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const HomePage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.explore,
                color: (page == PAGES.explore)
                    ? const Color.fromRGBO(93, 216, 171, 1.0)
                    : const Color.fromRGBO(125, 123, 123, 1.0),
              ),
              title: Text(
                "Explore",
                style: GoogleFonts.dmSans(
                  textStyle: (page == PAGES.explore)
                      ? FontThemeData.menuItemActive
                      : FontThemeData.menuItem,
                ),
              ),
              tileColor: (page == PAGES.explore)
                  ? const Color.fromRGBO(0, 244, 230, 0.1)
                  : Colors.transparent,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const Explore(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.fact_check_outlined,
                color: (page == PAGES.applications)
                    ? const Color.fromRGBO(93, 216, 171, 1.0)
                    : const Color.fromRGBO(125, 123, 123, 1.0),
              ),
              title: Text(
                "Applications",
                style: GoogleFonts.dmSans(
                  textStyle: (page == PAGES.applications)
                      ? FontThemeData.menuItemActive
                      : FontThemeData.menuItem,
                ),
              ),
              tileColor: (page == PAGES.applications)
                  ? const Color.fromRGBO(0, 244, 230, 0.1)
                  : Colors.transparent,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const JobsAppliedFor(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.check_box_outlined,
                color: (page == PAGES.selected)
                    ? const Color.fromRGBO(93, 216, 171, 1.0)
                    : const Color.fromRGBO(125, 123, 123, 1.0),
              ),
              title: Text(
                "Selected",
                style: GoogleFonts.dmSans(
                  textStyle: (page == PAGES.selected)
                      ? FontThemeData.menuItemActive
                      : FontThemeData.menuItem,
                ),
              ),
              trailing: (jobProvider.jobsShortListUnreadCount > 0)
                  ? ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        backgroundColor:
                            const Color.fromRGBO(93, 216, 171, 1.0),
                      ),
                      onPressed: () {},
                      child: Text(
                        (jobProvider.jobsShortListUnreadCount > 999)
                            ? "999+"
                            : jobProvider.jobsShortListUnreadCount.toString(),
                        style: GoogleFonts.dmSans(
                            textStyle: FontThemeData.menuItemNotifications),
                      ),
                    )
                  : const SizedBox(),
              tileColor: (page == PAGES.selected)
                  ? const Color.fromRGBO(0, 244, 230, 0.1)
                  : Colors.transparent,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const SelectedApplications(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.bookmark_outline,
                color: (page == PAGES.savedJobs)
                    ? const Color.fromRGBO(93, 216, 171, 1.0)
                    : const Color.fromRGBO(125, 123, 123, 1.0),
              ),
              title: Text(
                "Saved Jobs",
                style: GoogleFonts.dmSans(
                  textStyle: (page == PAGES.savedJobs)
                      ? FontThemeData.menuItemActive
                      : FontThemeData.menuItem,
                ),
              ),
              tileColor: (page == PAGES.savedJobs)
                  ? const Color.fromRGBO(0, 244, 230, 0.1)
                  : Colors.transparent,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const SavedJobs(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.drive_file_rename_outline_outlined,
                color: (page == PAGES.blog)
                    ? const Color.fromRGBO(93, 216, 171, 1.0)
                    : const Color.fromRGBO(125, 123, 123, 1.0),
              ),
              title: Text(
                "Blog",
                style: GoogleFonts.dmSans(
                  textStyle: (page == PAGES.blog)
                      ? FontThemeData.menuItemActive
                      : FontThemeData.menuItem,
                ),
              ),
              tileColor: (page == PAGES.blog)
                  ? const Color.fromRGBO(0, 244, 230, 0.1)
                  : Colors.transparent,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const BlogPage(),
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: Icon(
                Icons.person_outline,
                color: (page == PAGES.profile)
                    ? const Color.fromRGBO(93, 216, 171, 1.0)
                    : const Color.fromRGBO(125, 123, 123, 1.0),
              ),
              title: Text(
                "Profile",
                style: GoogleFonts.dmSans(
                  textStyle: (page == PAGES.profile)
                      ? FontThemeData.menuItemActive
                      : FontThemeData.menuItem,
                ),
              ),
              tileColor: (page == PAGES.profile)
                  ? const Color.fromRGBO(0, 244, 230, 0.1)
                  : Colors.transparent,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ProfilePage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.settings,
                color: (page == PAGES.settings)
                    ? const Color.fromRGBO(93, 216, 171, 1.0)
                    : const Color.fromRGBO(125, 123, 123, 1.0),
              ),
              title: Text(
                "Settings",
                style: GoogleFonts.dmSans(
                  textStyle: (page == PAGES.settings)
                      ? FontThemeData.menuItemActive
                      : FontThemeData.menuItem,
                ),
              ),
              tileColor: (widget.page == PAGES.settings)
                  ? const Color.fromRGBO(0, 244, 230, 0.1)
                  : Colors.transparent,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const SettingsPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.logout,
                color: (page == PAGES.settings)
                    ? const Color.fromRGBO(93, 216, 171, 1.0)
                    : const Color.fromRGBO(125, 123, 123, 1.0),
              ),
              title: Text(
                "Logout",
                style: GoogleFonts.dmSans(
                  textStyle: (page == PAGES.settings)
                      ? FontThemeData.menuItemActive
                      : FontThemeData.menuItem,
                ),
              ),
              tileColor: (widget.page == PAGES.settings)
                  ? const Color.fromRGBO(0, 244, 230, 0.1)
                  : Colors.transparent,
              onTap: () {
                authProvider.logout();
                Navigator.of(context).pop();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ),
                    (route) => false);
              },
            ),
          ]),
        ),
      ),
    );
  }
}
