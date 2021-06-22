class AppUser {
  final String? uid;
  AppUser({this.uid});
}

class UserData {
  final String? uid;
  final String? name;
  final String? sugars;
  final int? strength;

  UserData({this.name, this.strength, this.sugars, this.uid});
}
