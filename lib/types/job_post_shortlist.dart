class JobPostShortlist {
  const JobPostShortlist(
      {required this.id,
      required this.postId,
      required this.image,
      required this.title,
      required this.companyName,
      required this.jobTypeAndLocation,
      required this.shortlistedDate,
      required this.status});
  final int id;
  final int postId;
  final String image;
  final String title;
  final String companyName;
  final String jobTypeAndLocation;
  final String shortlistedDate;
  final bool status;
  factory JobPostShortlist.fromJson(Map<String, dynamic> json) {
    return JobPostShortlist(
      id: json['id'],
      postId: json['job_post']['id'],
      image: json['job_post']['partner']['profile_picture'],
      title: json['job_post']['title'],
      companyName: json['job_post']['partner']['display_name'],
      jobTypeAndLocation:
          "${json['job_post']['job_type']['name']} - ${json['job_post']['city']}, ${json['job_post']['country']}",
      shortlistedDate: json['shortlisted_time'],
      status: (json['read'] == 1) ? true : false,
    );
  }
}
