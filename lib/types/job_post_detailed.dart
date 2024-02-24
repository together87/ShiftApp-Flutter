import '../utils/constants.dart';

class JobPostDetailed {
  JobPostDetailed({
    required this.id,
    required this.hasApplied,
    required this.isSelected,
    required this.isSaved,
    required this.image,
    required this.title,
    required this.companyName,
    required this.companySize,
    required this.deadlineDate,
    required this.jobCategory,
    required this.isRemote,
    required this.jobLocation,
    required this.jobType,
    required this.desc,
    required this.payRangeExists,
    this.minPayRange = '',
    this.maxPayRange = '',
    required this.skills,
  });
  final int id;
  final bool hasApplied;
  final bool isSelected;
  final bool isSaved;
  final String image;
  final String title;
  final String companyName;
  final String companySize;
  final String deadlineDate;
  final String jobCategory;
  final bool isRemote;
  final String jobLocation;
  final String jobType;
  final String desc;
  final bool payRangeExists;
  String minPayRange;
  String maxPayRange;
  final List<dynamic> skills;
  factory JobPostDetailed.fromJson(Map<String, dynamic> json) {
    return JobPostDetailed(
      id: json['job']['id'],
      hasApplied: json['has_applied'],
      isSelected: json['shortlisted'],
      isSaved: json['saved'],
      image: json['job']['partner']['profile_picture'],
      title: json['job']['title'],
      companyName: json['job']['partner']['display_name'],
      companySize: json['job']['partner']['company_size'],
      deadlineDate: json['job']['expiration'],
      jobCategory: json['job']['category']['name'],
      isRemote: (json['job']['remote_position'] == 1) ? true : false,
      jobLocation: (json['job']['remote_position'] == 0)
          ? json['job']['city'] + ', ' + json['job']['country']
          : '',
      jobType: json['job']['job_type']['name'],
      desc: json['job']['desc'],
      payRangeExists: (json['job']['no_pay_range'] == 1) ? false : true,
      minPayRange:
          '${AppConstants.CURRENCY_PREFIX}${json['job']['min_salary_range']}',
      maxPayRange:
          '${AppConstants.CURRENCY_PREFIX}${json['job']['max_salary_range']}',
      skills: json['job']['skills'].map((item) => item['name']).toList(),
    );
  }
}
