import './clubs/club_class.dart';

class User {
  String name;
  String email;
  String id;
  bool isAdmin;
  List<UClub> adminof;
  bool isSuperAdmin;
  List<UClub> superAdminOf;
  bool isSSAdmin;

  User({
    this.name,
    this.email,
    this.id,
    this.isAdmin,
    this.adminof,
    this.isSuperAdmin,
    this.superAdminOf,
    this.isSSAdmin = false,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    // print("ADMINOF LENGTH: ${json["adminOf"].length}");
    bool iA = (json["adminOf"].length + json["superAdminOf"].length > 0) ? true : false;
    bool iSA = (json["superAdminOf"].length > 0) ? true:false;
    // bool iSA = false;
    List<UClub> adminof = List<UClub>();
    for (int i = 0; i < json["adminOf"].length; i++) {
      adminof.add(UClub.fromJson(json["adminOf"][i]));
    }
    List<UClub> superadminof = List<UClub>();
    for (int i = 0; i<json["superAdminOf"].length; i++){
      adminof.add(UClub.fromJson(json["superAdminOf"][i]));
      superadminof.add(UClub.fromJson(json["superAdminOf"][i]));
    }
    return User(
      name: json["name"],
      email: json["email"],
      id: json["_id"],
      isAdmin: iA,
      isSuperAdmin: iSA,
      adminof: adminof,
      superAdminOf: superadminof,
    );
  }
}

// User currentUser = User('DummyUser', true, [], true, []);
class UClub extends Club {
  String clubName;
  String id;

  UClub({this.clubName, this.id});

  factory UClub.fromJson(Map<String, dynamic> json) {
    return UClub(
      clubName: json["name"],
      id: json["_id"],
    );
  }
}

class Admin extends User {
  String name;
  String email;
  String id;

  Admin({this.name, this.email, this.id});

  factory Admin.fromJson(Map<String, dynamic> json){
    String name = (json.containsKey("name")) ? json["name"] : "Test ${json["email"]}";
    return Admin(
      name: name,
      email: json["email"],
      id: json["_id"]
    );
  }
}