import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../types/category.dart';
import '../types/job_post.dart';
import '../types/job_post_compact.dart';
import '../types/job_post_shortlist.dart';
import '../types/partner.dart';
import '../utils/constants.dart';
import 'auth.dart';

class JobProvider extends ChangeNotifier {
  final List<Category> _categories = <Category>[];
  final List<Partner> _partners = <Partner>[];
  final List<JobPostCompact> _jobPosts = <JobPostCompact>[];
  final List<JobPost> _jobsApplied = <JobPost>[];
  final List<JobPost> _jobsSaved = <JobPost>[];
  late int _jobsShortlistUnreadCount;
  final List<JobPostShortlist> _jobsShortlisted = <JobPostShortlist>[];

  List<Category> get categories => _categories;
  List<Partner> get partners => _partners;
  List<JobPostCompact> get jobPosts => _jobPosts;
  List<JobPost> get jobsApplied => _jobsApplied;
  List<JobPost> get jobsSaved => _jobsSaved;
  int get jobsShortListUnreadCount => _jobsShortlistUnreadCount;
  List<JobPostShortlist> get jobsShortlisted => _jobsShortlisted;

  Future<void> loadCategories(BuildContext ctx) async {
    String? token =
        await Provider.of<AuthProvider>(ctx, listen: false).getToken();
    final Uri url =
        Uri.parse("${AppConstants.API_URL}${AppConstants.CATEGORIES_INDEX}");
    final response = await http.get(url, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      _categories.clear();
      data["data"].forEach(
        (category) => {
          _categories.add(
            Category.fromJson(category),
          ),
        },
      );

      notifyListeners();
      return;
    } else {
      throw Exception('Problem loading categories.');
    }
  }

  Future<void> loadPartners(BuildContext ctx) async {
    String? token =
        await Provider.of<AuthProvider>(ctx, listen: false).getToken();
    final Uri url =
        Uri.parse("${AppConstants.API_URL}${AppConstants.PARTNERS_INDEX}");
    final response = await http.get(url, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      _partners.clear();
      data["data"].forEach(
        (partner) => {
          _partners.add(
            Partner.fromJson(partner),
          ),
        },
      );

      notifyListeners();
      return;
    } else {
      throw Exception('Problem loading partners.');
    }
  }

  Future<void> loadHomePageJobs(BuildContext ctx) async {
    String? token =
        await Provider.of<AuthProvider>(ctx, listen: false).getToken();
    final Uri url =
        Uri.parse("${AppConstants.API_URL}${AppConstants.JOB_HOMEPAGE_POSTS}");
    final response = await http.get(url, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      _jobPosts.clear();
      data["data"]["data"].forEach(
        (jobpost) => {
          _jobPosts.add(
            JobPostCompact.fromJson(jobpost),
          ),
        },
      );

      notifyListeners();
      return;
    } else {
      throw Exception('Problem loading jobs.');
    }
  }

  Future<void> loadJobs(BuildContext ctx) async {
    String? token =
        await Provider.of<AuthProvider>(ctx, listen: false).getToken();
    final Uri url =
        Uri.parse("${AppConstants.API_URL}${AppConstants.JOB_POSTS}");
    final response = await http.get(url, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      _jobPosts.clear();
      data["data"].forEach(
        (jobpost) => {
          _jobPosts.add(
            JobPostCompact.fromJson(jobpost),
          ),
        },
      );

      notifyListeners();
      return;
    } else {
      throw Exception('Problem loading jobs.');
    }
  }

  Future<void> loadJobsApplied(BuildContext ctx) async {
    final userProvider = Provider.of<AuthProvider>(ctx, listen: false);
    String? token = await userProvider.getToken();
    final userId = userProvider.user.id;
    final Uri url = Uri.parse(
        "${AppConstants.API_URL}${AppConstants.JOBS_APPLIED}?user_id=$userId");
    final response = await http.get(url, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      _jobsApplied.clear();
      data["data"].forEach(
        (jobpost) => {
          _jobsApplied.add(
            JobPost.fromJson(jobpost['job_post']),
          ),
        },
      );

      notifyListeners();
      return;
    } else {
      throw Exception('Problem loading applied for jobs.');
    }
  }

  Future<void> loadJobsSaved(BuildContext ctx) async {
    final userProvider = Provider.of<AuthProvider>(ctx, listen: false);
    String? token = await userProvider.getToken();
    final userId = userProvider.user.id;
    final Uri url =
        Uri.parse("${AppConstants.API_URL}${AppConstants.JOBS_SAVED}/$userId");
    final response = await http.get(url, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      _jobsSaved.clear();
      data["data"].forEach(
        (jobpost) => {
          _jobsSaved.add(
            JobPost.fromJson(jobpost['job_post']),
          ),
        },
      );

      notifyListeners();
      return;
    } else {
      throw Exception('Problem loading saved jobs.');
    }
  }

  Future<void> loadJobsShortlistCount(BuildContext ctx) async {
    final userProvider = Provider.of<AuthProvider>(ctx, listen: false);
    String? token = await userProvider.getToken();
    final userId = userProvider.user.id;
    final Uri url = Uri.parse(
        "${AppConstants.API_URL}${AppConstants.JOBS_SHORTLIST_COUNT}?user_id=$userId");
    final response = await http.get(url, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      _jobsShortlistUnreadCount = data["data"];

      notifyListeners();
      return;
    } else {
      throw Exception('Problem loading shortlisted jobs count.');
    }
  }

  Future<void> loadJobsShortlisted(BuildContext ctx) async {
    final userProvider = Provider.of<AuthProvider>(ctx, listen: false);
    String? token = await userProvider.getToken();
    final userId = userProvider.user.id;
    final Uri url = Uri.parse(
        "${AppConstants.API_URL}${AppConstants.JOBS_SHORTLISTED}?user_id=$userId");
    final response = await http.get(url, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      _jobsShortlisted.clear();
      data["data"].forEach(
        (jobpost) => {
          _jobsShortlisted.add(
            JobPostShortlist.fromJson(jobpost),
          ),
        },
      );

      notifyListeners();
      return;
    } else {
      throw Exception('Problem loading shortlisted jobs.');
    }
  }

  Future<void> toggleShortlistReadStatus(BuildContext ctx, id) async {
    final userProvider = Provider.of<AuthProvider>(ctx, listen: false);
    String? token = await userProvider.getToken();
    final Uri url = Uri.parse(
        "${AppConstants.API_URL}${AppConstants.JOBS_SHORTLIST_TOGGLE_READ_STATUS}/$id");
    final response = await http.get(url, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });
    if (response.statusCode == 200) {
      // ignore: use_build_context_synchronously
      await loadJobsShortlisted(ctx);
      // ignore: use_build_context_synchronously
      await loadJobsShortlistCount(ctx);

      notifyListeners();
      return;
    } else {
      throw Exception('Problem changing job application read status.');
    }
  }
}
