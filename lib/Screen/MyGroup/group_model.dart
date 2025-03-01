class GroupData {
  final int id;
  final String name;
  final String courseTitle;

  GroupData({required this.id, required this.name, required this.courseTitle});

  factory GroupData.fromJson(Map<String, dynamic> json) {
    return GroupData(
      id: json["id"] ?? 0,
      name: json["name"] ?? "Unnamed Group",
      courseTitle: json["course"]?["title"] ?? "No Course Assigned",
    );
  }
}
