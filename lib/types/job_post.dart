import '../utils/constants.dart';

class JobPost {
  const JobPost({
    required this.id,
    required this.image,
    required this.title,
    required this.companyName,
    required this.jobTypeAndLocation,
    required this.salaryInfo,
  });
  final int id;
  final String image;
  final String title;
  final String companyName;
  final String jobTypeAndLocation;
  final String salaryInfo;
  factory JobPost.fromJson(Map<String, dynamic> json) {
    return JobPost(
      id: json['id'],
      image: json['partner']['profile_picture'],
      title: json['title'],
      companyName: json['partner']['display_name'],
      jobTypeAndLocation:
          "${json['job_type']['name']} - ${json['city']}, ${json['country']}",
      salaryInfo: json['no_pay_range'] == 1
          ? 'N/A'
          : '${AppConstants.CURRENCY_PREFIX}${json['min_salary_range']} - ${AppConstants.CURRENCY_PREFIX}${json['max_salary_range']} / Annual',
    );
  }
}
