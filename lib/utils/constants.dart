// ignore_for_file: constant_identifier_names

class AppConstants {
  static const String API_URL = "http://codajobs-admin.beamcoda.com";
  static const String STATIC_WEB_URL = "https://codajobs.beamcoda.com";
  static const String CONTACT_EMAIL = "contact@beamcoda.com";
  static const String CURRENCY_PREFIX = "\$";

  // Notifications
  static const String SAVE_NOTIFICATION_DEVICE =
      "/api/notifications/user/device";

  // User
  static const String USER_LOGIN = "/api/user/auth/login";
  static const String USER_REGISTER = "/api/user/register";
  static const String USER_LOGOUT = "/api/user/auth/logout";
  static const String USER_DETAILS = "/api/user/auth/details";
  static const String USER_SKILLS = "/api/skills/user";
  static const String USER_RESUMES = "/api/resume/user";
  static const String USER_NOTIFICATION_SETTINGS = "/api/notifications/user";
  static const String USER_NOTIFICATION_SAVE_SETTINGS =
      "/api/notifications/user/setting";
  static const String USER_DELETE_URL = "/api/user/delete";
  static const String USER_SAVE_PROFILE = "/api/user/update";

  // Upload urls
  static const String UPLOAD_IMG_URL = "/api/file/upload-image";
  static const String UPLOAD_IMG_DIRECTORY = "/img/uploads";
  static const String UPLOAD_DOC_URL = "/api/file/upload-doc";
  static const String UPLOAD_DOC_DIRECTORY = "/docs/uploads";

  // Jobs
  static const String JOB_POSTS = "/api/jobs/list";
  static const String JOB_HOMEPAGE_POSTS = "/api/jobs/home";
  static const String PARTNER_JOBS = "/api/jobs/partner";
  static const String CAGEGORY_JOBS = "/api/jobs/category";
  static const String JOBS_APPLIED = "/api/job-applications/jobs/applied";
  static const String JOBS_SAVED = "/api/jobs-saved";
  static const String JOBS_SAVED_REMOVE = "/api/jobs-saved/delete";
  static const String JOBS_RETRIEVAL = "/api/jobs/user";
  static const String JOBS_SHORTLIST_COUNT =
      "/api/job-applications/shortlist-count";
  static const String JOBS_SHORTLIST_TOGGLE_READ_STATUS =
      "/api/job-applications/shortlist/toggle";
  static const String JOBS_SHORTLISTED =
      "/api/job-applications/jobs/shortlisted";

  // Job Applications
  static const String APPLY_FOR_JOB = "/api/job-applications";

  // Skills
  static const String SKILLS_INDEX = "/api/skills/autocomplete";

  // Categories
  static const String CATEGORIES_INDEX = "/api/categories/all";

  // Partners
  static const String PARTNERS_INDEX = "/api/partner/list";

  // Resume
  static const String RESUME_CREATE_URL = "/api/resume/new";
  static const String RESUME_DELETE_URL = "/api/resume/delete";

  // Blog Posts
  static const String BLOGPOSTS_INDEX = "/api/blogposts/all";
  static const String BLOGPOSTS_FEATURED_INDEX = "/api/blogposts/featured";
}
