class UserModel {
  UserModel({
    required this.id,
    required this.nameUser,
    required this.emailUser,
    required this.professionUser,
    required this.noHpUser,
    required this.gambarUser,
    required this.passwordUser,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String nameUser;
  String emailUser;
  String professionUser;
  String noHpUser;
  String gambarUser;
  String passwordUser;
  DateTime createdAt;
  DateTime updatedAt;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"] ?? 0,
        nameUser: json["name"] ?? "",
        emailUser: json["email"] ?? "",
        professionUser: json["profession"] ?? "",
        noHpUser: json["no_hp"] ?? "",
        gambarUser: json["gambar"] ?? "",
        passwordUser: json["password"] ?? "",
        createdAt: DateTime.parse(
            json["created_at"] ?? DateTime.now().toIso8601String()),
        updatedAt: DateTime.parse(
            json["updated_at"] ?? DateTime.now().toIso8601String()),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": nameUser,
        "email": emailUser,
        "profession": professionUser,
        "no_hp": noHpUser,
        "gambar": gambarUser,
        "password": passwordUser,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
