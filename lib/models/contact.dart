class Contact {
  static const tblContact = 'contacts';
  static const colID = 'id';
  static const colName = 'name';
  static const colMobile = 'mobile';

  Contact({this.id, this.name, this.mobile});

  Contact.fromMap(Map<dynamic, dynamic> map) {
    id = map[colID];
    name = map[colName];
    mobile = map[colMobile];
  }
  int? id;
  String? name;
  String? mobile;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{colName: name, colMobile: mobile};
    if (id != null) map[colID] = id;
    return map;
  }
}
