/// Partner Data Type Definition
class Partner {
  const Partner(
      {required this.id,
      required this.name,
      required this.img,
      required this.empCount});
  final int id;
  final String name;
  final String img;
  final String empCount;

  factory Partner.fromJson(Map<String, dynamic> json) {
    return Partner(
      id: json['id'],
      name: json['short_name'],
      img: json['img_url'],
      empCount: json['employee_count'],
    );
  }
}
