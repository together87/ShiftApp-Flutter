import 'package:flutter/material.dart';

abstract class FontThemeData {
  static const Color grey700 = Color.fromRGBO(51, 65, 85, 1.0);
  static const Color teal = Color.fromRGBO(16, 185, 129, 1.0);

  // Common Components
  static const TextStyle inputLabel = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w700,
    color: Color.fromRGBO(100, 116, 139, 1.0),
  );

  static const TextStyle jobItemName = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    color: grey700,
  );

  static const TextStyle jobItemCompanyName = TextStyle(
    fontSize: 10.0,
    fontWeight: FontWeight.w400,
    color: Color.fromRGBO(59, 130, 246, 1.0),
  );

  static const TextStyle jobItemTypeAndLocation = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w400,
    color: Color.fromRGBO(80, 80, 80, 1.0),
  );

  static const TextStyle jobItemSalary = TextStyle(
    fontSize: 13.0,
    fontWeight: FontWeight.w700,
    color: grey700,
  );

  static const TextStyle jobItemMomentsAgo = TextStyle(
    fontSize: 10.0,
    fontWeight: FontWeight.w700,
    color: grey700,
  );

  static const TextStyle notificationMsgText = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w400,
    color: teal,
  );

  static const TextStyle notificationMsgTextBold = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w700,
    color: teal,
  );

  /// Login Page
  static const TextStyle authHeading =
      TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black);

  static const TextStyle btnText =
      TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.white);

  static const TextStyle btnBlackText =
      TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black);

  static const TextStyle authBtnFB =
      TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.white);

  static const TextStyle authBtnGoogle =
      TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black);

  /// Menu
  static const TextStyle menuItem = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: Color.fromRGBO(125, 123, 123, 1.0),
  );

  static const TextStyle menuItemActive = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: Color.fromRGBO(93, 216, 171, 1.0),
  );

  static const TextStyle menuItemNotifications = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  );

  /// Homepage
  static const TextStyle welcomeTitle =
      TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white);

  static const TextStyle welcomeOccupation =
      TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.white);

  static const TextStyle sectionTitles =
      TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.black);

  static const TextStyle categoryName =
      TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.white);

  static const TextStyle companyName =
      TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white);

  static const TextStyle companyEmpCount = TextStyle(
    fontSize: 8,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.italic,
    color: Colors.white,
  );

  /// Job Page
  static const TextStyle jobPostCompanyName =
      TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: grey700);

  static const TextStyle jobPostSecondHeading =
      TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: grey700);

  static const TextStyle jobPostSecondHeadingBold =
      TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: grey700);

  static const TextStyle jobPostThirdHeading =
      TextStyle(fontSize: 10, fontWeight: FontWeight.w400, color: grey700);

  static const TextStyle jobPostEmployeeCount = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.italic,
      color: grey700);

  static const TextStyle jobPostName =
      TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: grey700);

  static const TextStyle jobPostDeadlineDate =
      TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: grey700);

  static const TextStyle jobPostAttributesTitle =
      TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: grey700);

  static const TextStyle jobPostAttributesText =
      TextStyle(fontSize: 11, fontWeight: FontWeight.w400, color: grey700);

  static const TextStyle jobPostText =
      TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: grey700);

  static const TextStyle jobPostSalaryRangeTitle =
      TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: grey700);

  static const TextStyle jobPostSalaryRangeText =
      TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black);

  /// Blog Page
  static const TextStyle blogFeaturedTitle =
      TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white);

  static const TextStyle blogFeaturedAuthorName =
      TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.white);

  static const TextStyle blogPostTitle = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w700,
      color: Color.fromRGBO(26, 26, 26, 1.0));

  static const TextStyle blogPostAuthor = TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w700,
      color: Color.fromRGBO(115, 115, 115, 1.0));

  static const TextStyle blogPostDate = TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w700,
      color: Color.fromRGBO(149, 149, 149, 1.0));

  static const TextStyle blogPostPageTitle =
      TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.black);

  static const TextStyle blogPostPageAuthor = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w700,
      color: Color.fromRGBO(115, 115, 115, 1.0));

  static const TextStyle blogPostPageDate = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w700,
      color: Color.fromRGBO(149, 149, 149, 1.0));

  static const TextStyle blogPostPageText = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Color.fromRGBO(149, 149, 149, 1.0));

  /// Profile Page
  static const TextStyle profilePagePrimaryTitle =
      TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: grey700);

  static const TextStyle profilePageSecondaryTitle =
      TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: grey700);

  static const TextStyle profilePageOccupation =
      TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: grey700);

  static const TextStyle profilePageLocation = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: grey700,
      fontStyle: FontStyle.italic);

  static const TextStyle profilePageHintTxt = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.italic,
      color: grey700);

  static const TextStyle profilePageTxt = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Color.fromRGBO(149, 149, 149, 1.0));

  static const TextStyle resumeTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: Colors.black,
  );

  static TextStyle resumeDocType = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.italic,
    color: Colors.black.withOpacity(0.6),
  );

  /// Settings Page
  static const TextStyle settingsListItem =
      TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: grey700);

  static const TextStyle settingsListItemPrimary =
      TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: grey700);

  static const TextStyle settingsListItemSecondary =
      TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: grey700);

  static const TextStyle settingsFontSizeXl =
      TextStyle(fontSize: 24, fontWeight: FontWeight.w100, color: grey700);

  static const TextStyle settingsFontSizeL =
      TextStyle(fontSize: 20, fontWeight: FontWeight.w100, color: grey700);

  static const TextStyle settingsFontSizeM =
      TextStyle(fontSize: 16, fontWeight: FontWeight.w100, color: grey700);

  static const TextStyle settingsFontSizeXlBold =
      TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.black);

  static const TextStyle settingsFontSizeLBold =
      TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.black);

  static const TextStyle settingsFontSizeMBold =
      TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black);

  static const TextStyle settingsText =
      TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black);
}
