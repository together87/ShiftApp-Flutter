class NotificationSettings {
  const NotificationSettings(
      {required this.shortListNotification,
      required this.inactivityNotification});
  final bool shortListNotification;
  final bool inactivityNotification;
  factory NotificationSettings.fromJson(Map<String, dynamic> json) {
    return NotificationSettings(
      shortListNotification:
          (json['shortlisted_notification'] == 0) ? false : true,
      inactivityNotification:
          (json['inactivity_notification'] == 0) ? false : true,
    );
  }
}
