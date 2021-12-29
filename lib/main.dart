// @dart=2.9
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sp_login_uygulamasi/anasayfa.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  Future<bool> oturumKontrol() async{

    var sp = await SharedPreferences.getInstance();

    String spKullaniciAdi = sp.getString("kullaniciadi") ?? "kullanıcı adı yok";
    String spSifre = sp.getString("sifre") ?? "şifre yok";

    if(spKullaniciAdi == "admin" && spSifre == "123"){
     return true;
    }else{
      return false;
    }

  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  FutureBuilder<bool>(
        future: oturumKontrol(),
        builder: (context,snapshot){
          if(snapshot.hasData){
            bool gecisIzni = snapshot.data;
            return gecisIzni ? Anasayfa() : LoginEkrani();
          }else{
            return Container();
          }
        },
      ),
    );
  }
}

class LoginEkrani extends StatefulWidget {


  @override
  State<LoginEkrani> createState() => _LoginEkraniState();
}

class _LoginEkraniState extends State<LoginEkrani> {

  var tfKullaniciAdi = TextEditingController();
  var tfSifre = TextEditingController();

  var scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> girisKontrol() async{
    var ka = tfKullaniciAdi.text;
    var s = tfSifre.text;

    if(ka == "admin" && s == "123"){
    var sp = await SharedPreferences.getInstance();

    sp.setString("kullaniciadi", ka);
    sp.setString("sifre", s);

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Anasayfa()));
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Giriş hatalı"),

          action: SnackBarAction(
        label: "Giriş hatalı",
        onPressed: () {

        },
          ),
        ),
      );
    }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Login Ekranı"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: tfKullaniciAdi,
                decoration: const InputDecoration(
                  hintText: "Kullanıcı Adı"
                ),
              ),
              TextField(
                obscureText: true,
                controller: tfSifre,
                decoration: const InputDecoration(
                  hintText: "Şifre"
                ),
              ),
              ElevatedButton(
                  onPressed: (){

                    girisKontrol();
                  },
                  child: Text("Giriş Yap"),
              ),

            ],
          ),
        ),
      ),

    );
  }
}
