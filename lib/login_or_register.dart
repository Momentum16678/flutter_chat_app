import 'package:flutter/material.dart';
import 'package:flutter_chat_app/login.dart';
import 'package:flutter_chat_app/register.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({Key? key}) : super(key: key);

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {

  bool showLoginPage = true;

  togglePages(){
   setState(() {
     showLoginPage = !showLoginPage;
   });
  }

  @override
  Widget build(BuildContext context) {
    if(showLoginPage) {
      return Login(onTap: togglePages());
    } else {
      return Register(onTap: togglePages());
    }
  }
}
