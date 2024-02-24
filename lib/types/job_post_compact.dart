import '../utils/constants.dart';

class JobPostCompact {
  const JobPostCompact(
      {required this.id,
      required this.image,
      required this.title,
      required this.companyName,
      required this.jobTypeAndLocation,
      required this.salaryInfo,
      required this.expirationDate,
      required this.isPublished});
  final int id;
  final String image;
  final String title;
  final String companyName;
  final String jobTypeAndLocation;
  final String salaryInfo;
  final String expirationDate;
  final bool isPublished;
  factory JobPostCompact.fromJson(Map<String, dynamic> json) {
    return JobPostCompact(
      id: json['id'],
      image: json['partner']['img_url'],
      title: json['job_title'],
      companyName: json['partner']['short_name'],
      jobTypeAndLocation:
          "${json['jobtype']['name']} - ${json['city']}, ${json['country']}",
      salaryInfo: json['no_pay_range'] == 1
          ? 'N/A'
          : '${AppConstants.CURRENCY_PREFIX}${json['min_salary_range']} - ${AppConstants.CURRENCY_PREFIX}${json['max_salary_range']} / Annual',
      expirationDate: json['expiration_date'],
      isPublished: (json['is_published'] == 1) ? true : false,
    );
  }
}
