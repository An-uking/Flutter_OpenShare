class User {
  String name;
  String hashURL;
  User({this.name, this.hashURL});
  User.fromJson(Map<String, dynamic> json)
      : this.name = json['name'],
        this.hashURL = json['hashURL'];
  String toListString() {
    return this.name + "@" + this.hashURL;
  }

  User.formString(String str) {
    if (str=="") return;
    List<String> strArr = str.split("@");
    this.name = strArr[0];
    this.hashURL = strArr[1];
  }
}

class CombObj{
  User user;
  String errTxt;
  CombObj({this.user,this.errTxt});
}