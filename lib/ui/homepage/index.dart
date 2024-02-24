import 'package:flutter/material.dart';

import './sections/blog/index.dart';
import './sections/categories/index.dart';
import './sections/companies/index.dart';
import './sections/jobs/index.dart';
import './sections/welcome.dart';
import '../../components/main/drawer.dart';
import '../../types/navigation.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
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
      drawer: PageDrawer(key: UniqueKey(), page: PAGES.home),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: Container(
          color: const Color.fromRGBO(248, 248, 248, 1.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const <Widget>[
              SizedBox(height: 10.0),
              WelcomeHomeSection(),
              SizedBox(height: 10.0),
              JobCategoriesList(),
              SizedBox(height: 10.0),
              CompaniesList(),
              SizedBox(height: 10.0),
              HomeBlog(),
              SizedBox(height: 10.0),
              ExploreJobs(),
            ],
          ),
        ),
      ),
    );
  }
}
