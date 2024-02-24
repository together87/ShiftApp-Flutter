import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../types/blogpost.dart';
import '../utils/constants.dart';
import 'auth.dart';

class BlogProvider extends ChangeNotifier {
  final List<BlogPost> _blogPosts = <BlogPost>[];
  final List<BlogPost> _featuredBlogPosts = <BlogPost>[];

  List<BlogPost> get blogPosts => _blogPosts;
  List<BlogPost> get featuredBlogPosts => _featuredBlogPosts;

  Future<void> loadBlogPost(BuildContext ctx) async {
    String? token =
        await Provider.of<AuthProvider>(ctx, listen: false).getToken();
    final Uri postsUrl =
        Uri.parse("${AppConstants.API_URL}${AppConstants.BLOGPOSTS_INDEX}");
    final response = await http.get(postsUrl, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      _blogPosts.clear();
      data["posts"].forEach(
        (blogPost) => {
          _blogPosts.add(
            BlogPost.fromJson(blogPost),
          ),
        },
      );
    } else {
      throw Exception('Problem loading blog posts.');
    }

    // Retrieve featured posts
    final Uri featuredPostsUrl = Uri.parse(
        "${AppConstants.API_URL}${AppConstants.BLOGPOSTS_FEATURED_INDEX}");
    final featuredResponse = await http.get(featuredPostsUrl, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });
    if (featuredResponse.statusCode == 200) {
      Map<String, dynamic> data = json.decode(featuredResponse.body);
      _featuredBlogPosts.clear();
      data["data"].forEach(
        (blogPost) => {
          _featuredBlogPosts.add(
            BlogPost.fromJson(blogPost),
          ),
        },
      );
    } else {
      throw Exception('Problem loading featured blog posts.');
    }

    notifyListeners();
    return;
  }
}
