/// Resume Data Type Definition
class Resume {
  const Resume({
    required this.id,
    required this.userId,
    required this.fileName,
    required this.docType,
    required this.downloadUrl,
    required this.isShared,
  });
  final int id;
  final int userId;
  final String fileName;
  final String docType;
  final String downloadUrl;
  final bool isShared;

  factory Resume.fromJson(Map<String, dynamic> json) {
    return Resume(
      id: json['id'],
      userId: json['user_id'],
      fileName: json['file_name'],
      docType: json['doc_type'],
      downloadUrl: json['download_url'],
      isShared: (json['is_shared'] == 1) ? true : false,
    );
  }
}
