class DailyTaskModel {
  DailyTaskModel({
    required this.id,
    required this.userId,
    required this.categoryId,
    required this.title,
    required this.description,
    required this.reminder,
    required this.repeat,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  int userId;
  int categoryId;
  String title;
  String description;
  String reminder;
  String repeat;
  String status;
  DateTime createdAt;
  DateTime updatedAt;

  factory DailyTaskModel.fromJson(Map<String, dynamic> json) => DailyTaskModel(
        id: json["id"] ?? 0,
        userId: json["user_id"] ?? 0,
        categoryId: json["category_id"] ?? 0,
        title: json["title"] ?? "",
        description: json["description"] ?? "",
        reminder: json["reminder"] ?? "",
        repeat: json["repeat"] ?? "",
        status: json["status"] ?? "",
        createdAt: DateTime.parse(
            json["created_at"] ?? DateTime.now().toIso8601String()),
        updatedAt: DateTime.parse(
            json["updated_at"] ?? DateTime.now().toIso8601String()),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "category_id": categoryId,
        "title": title,
        "description": description,
        "reminder": reminder,
        "repeat": repeat,
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
