import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import './item.dart';
import '../../../../data/job.dart';
import '../../../theme_data/fonts.dart';

class CompaniesList extends StatefulWidget {
  const CompaniesList({super.key});

  @override
  State<CompaniesList> createState() => _CompaniesListState();
}

class _CompaniesListState extends State<CompaniesList> {
  @override
  void initState() {
    super.initState();
    final jobProvider = Provider.of<JobProvider>(context, listen: false);
    jobProvider.loadPartners(context);
  }

  @override
  Widget build(BuildContext context) {
    final jobProvider = Provider.of<JobProvider>(context);
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Container(
        transform: Matrix4.translationValues(20.0, 0.0, 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Companies",
              style: GoogleFonts.dmSans(textStyle: FontThemeData.sectionTitles),
            ),
            const SizedBox(height: 15.0),
            SizedBox(
              height: 120.0,
              child: ListView.builder(
                clipBehavior: Clip.none,
                scrollDirection: Axis.horizontal,
                itemCount: jobProvider.partners.length,
                itemBuilder: (_, i) {
                  return CompanyListItem(
                      key: UniqueKey(),
                      id: jobProvider.partners[i].id,
                      img: jobProvider.partners[i].img,
                      name: jobProvider.partners[i].name,
                      empCount: jobProvider.partners[i].empCount);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
