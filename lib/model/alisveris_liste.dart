/* Code by avdisx */
class ALISVERISLISTEM {
  int id;
  String malzeme;
  String miktar;

  ALISVERISLISTEM({this.malzeme, this.miktar});
  ALISVERISLISTEM.withID({this.id, this.malzeme, this.miktar});

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["id"] = id;
    map["malzeme"] = malzeme;
    map["miktar"] = miktar;
    return map;
  }

  ALISVERISLISTEM.fromMap(Map<String, dynamic> map) {
    this.id = map["id"];
    this.malzeme = map["malzeme"];
    this.miktar = map["miktar"];
  }
}
