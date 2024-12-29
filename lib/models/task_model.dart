import 'dart:convert';

class TaskModel {
  TaskModel({
    required this.id,
    required this.userId,
    required this.categoryId,
    required this.title,
    required this.description,
    required this.reminder,
    required this.startDate,
    required this.endDate,
    required this.repeat,
    required this.toDoList,
    required this.toDoListStatus,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  int userId;
  int categoryId;
  String title;
  String description;
  String reminder;
  String startDate;
  String endDate;
  String repeat;
  List<String> toDoList;
  List<bool> toDoListStatus;
  DateTime createdAt;
  DateTime updatedAt;

  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
        id: json["id"] ?? 0,
        userId: json["user_id"] ?? 0,
        categoryId: json["category_id"] ?? 0,
        title: json["title"] ?? "",
        description: json["description"] ?? "",
        reminder: json["reminder"] ?? "",
        startDate: json["start_date"] ?? "",
        endDate: json["end_date"] ?? "",
        repeat: json["repeat"] ?? "",
        toDoList: (json["to_do_list"] as String)
            .replaceAll('[', '')
            .replaceAll(']', '')
            .replaceAll('"', '')
            .replaceAll('\\', '')
            .split(','),
        toDoListStatus: (json["to_do_list_status"] as String)
            .split(',')
            .map((status) => status == 'true')
            .toList(),
        // toDoList: (json["to_do_list"] as List<dynamic>).cast<String>(),
        // toDoListStatus: (json["to_do_list_status"] as List<dynamic>)
        //     .map((status) => status == true)
        //     .toList(),
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
        "start_date": startDate,
        "end_date": endDate,
        "repeat": repeat,
        'to_do_list': jsonEncode(toDoList),
        'to_do_list_status': jsonEncode(toDoListStatus),
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
