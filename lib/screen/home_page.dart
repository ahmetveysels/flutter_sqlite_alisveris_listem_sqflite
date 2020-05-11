import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sqlite_example_avdisx/model/alisveris_liste.dart';
import 'package:flutter_sqlite_example_avdisx/utils/database_helper.dart';

/* Code by avdisx */
class HOMEPAGE extends StatefulWidget {
  @override
  _HOMEPAGEState createState() => _HOMEPAGEState();
}

class _HOMEPAGEState extends State<HOMEPAGE> {
  String malzeme = "", miktar = "", butonAdi = "Ekle";
  int id;
  var _formKey = new GlobalKey<FormState>();
  List<ALISVERISLISTEM> tumMalzemeler = [];
  TextEditingController ctrlMiktar, ctrlMalzeme;
  DatabaseHelper _databaseHelper = new DatabaseHelper();
  @override
  void initState() {
    super.initState();
    ctrlMalzeme = new TextEditingController(text: malzeme);
    ctrlMiktar = new TextEditingController(text: miktar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("Alışveriş Listem by avdisx"),
      ),
      body: Container(
        margin: EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: ctrlMalzeme,
                    maxLength: 30,
                    // initialValue: malzeme,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: "Malzeme",
                      contentPadding: EdgeInsets.all(15),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                    validator: (value) {
                      if (value.length < 3) {
                        return "En az 3 harf";
                      }
                    },
                    onSaved: (deger) => malzeme = deger.toUpperCase(),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    controller: ctrlMiktar,
                    maxLength: 30,
                    keyboardType: TextInputType.text,
                    //initialValue: miktar,
                    decoration: InputDecoration(
                      labelText: "Miktar",
                      contentPadding: EdgeInsets.all(15),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                    validator: (value) {
                      if (value.length < 1) {
                        return "En az 1 harf";
                      }
                    },
                    onSaved: (deger) => miktar = deger.toUpperCase(),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  RaisedButton(
                      child: Text("$butonAdi"),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          print(malzeme + " " + miktar);
                          if (butonAdi == "Ekle") {
                            _databaseHelper
                                .malzemeEkle(ALISVERISLISTEM(
                                    malzeme: malzeme, miktar: miktar))
                                .then((value) {
                              if (value > 0) {
                                _formKey.currentState.reset();
                                snackbarGoster("Malzeme Eklendi");
                                setState(() {});
                              }
                            });
                          } else if (butonAdi == "Güncelle") {
                            _databaseHelper
                                .malzemeGuncelle(ALISVERISLISTEM.withID(
                                    id: id, malzeme: malzeme, miktar: miktar))
                                .then((value) {
                              if (value > 0) {
                                snackbarGoster("Malzeme Güncellendi.");
                                setState(() {
                                  ctrlMalzeme.clear();
                                  ctrlMiktar.clear();
                                  butonAdi = "Ekle";
                                });
                              }
                            });
                          }
                        }
                      }),
                ],
              ),
            ),
            Container(
              color: Colors.black,
              height: 2,
              margin: EdgeInsets.all(5),
            ),
            Expanded(
              child: FutureBuilder(
                  future: _databaseHelper.malzemelerinListesi(),
                  builder: (context, sonuc) {
                    if (sonuc.hasData) {
                      tumMalzemeler = sonuc.data;
                      return ListView.builder(
                          itemCount: tumMalzemeler.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.teal.shade300.withOpacity(0.4),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: ListTile(
                                onTap: () {
                                  setState(() {
                                    id = tumMalzemeler[index].id;
                                    /* malzeme = tumMalzemeler[index].malzeme;
                                    miktar = tumMalzemeler[index].miktar; */
                                    ctrlMalzeme.text =
                                        tumMalzemeler[index].malzeme.toString();
                                    ctrlMiktar.text =
                                        tumMalzemeler[index].miktar.toString();
                                    butonAdi = "Güncelle";
                                    print(malzeme);
                                  });
                                },
                                title: Text(tumMalzemeler[index].malzeme),
                                subtitle: Text(tumMalzemeler[index].miktar),
                                trailing: IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () async {
                                    // silme kodu
                                    var sonuc = await _databaseHelper
                                        .malzemeSil(tumMalzemeler[index].id);
                                    if (sonuc > 0) {
                                      snackbarGoster("Kayıt Silindi");
                                      setState(() {});
                                    }
                                  },
                                ),
                              ),
                            );
                          });
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
            ),
            Center(
              child: Text(
                "Code by avdisx\nGitHub: avdisx",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void snackbarGoster(String mesaj) {
    Flushbar(
      flushbarPosition: FlushbarPosition.BOTTOM,
      margin: EdgeInsets.all(8),
      borderRadius: 15,
      backgroundGradient: LinearGradient(
        colors: [Colors.lightBlueAccent, Colors.green],
      ),
      backgroundColor: Colors.red,
      boxShadows: [
        BoxShadow(
          color: Colors.blue[800],
          offset: Offset(0.0, 2.0),
          blurRadius: 3.0,
        )
      ],
      message: mesaj,
      icon: Icon(
        Icons.done_all,
        size: 28.0,
        color: Colors.white,
      ),
      duration: Duration(seconds: 3),
    )..show(context);
  }
}
