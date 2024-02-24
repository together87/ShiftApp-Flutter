import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../ui/jobs_partner/index.dart';
import '../../../theme_data/fonts.dart';

class CompanyListItem extends StatelessWidget {
  final int id;
  final String img;
  final String name;
  final String empCount;

  const CompanyListItem({
    required Key key,
    required this.id,
    required this.img,
    required this.name,
    required this.empCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => JobsPartner(
              id: id,
              key: UniqueKey(),
              name: name,
            ),
          ),
        );
      },
      child: Container(
        width: 100.0,
        margin: const EdgeInsets.only(right: 15.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
              width: 50.0,
              height: 50.0,
              image: NetworkImage(img),
            ),
            const SizedBox(height: 2.0),
            Container(
              width: 100.0,
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.black,
              ),
              child: Column(
                children: [
                  Text(
                    name,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.dmSans(
                        textStyle: FontThemeData.companyName),
                  ),
                  Text(
                    empCount,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.dmSans(
                        textStyle: FontThemeData.companyEmpCount),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
