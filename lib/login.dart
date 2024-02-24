import 'package:flutter/material.dart';
import 'package:flutter_chat_app/auth_service.dart';
import 'package:flutter_chat_app/register.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  Login({Key? key, this.onTap}) : super(key: key);
  final void Function()? onTap;

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  void signIn() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    try {
      await authService.signInWithEmailAndPassword(email.text, password.text);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                    controller: email,
                    decoration: const InputDecoration(
                        hintText: "Email",
                        hintStyle: TextStyle(fontSize: 15, color: Colors.grey))),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                    controller: password,
                    obscureText: true,
                    decoration: const InputDecoration(
                        hintText: "Password",
                        hintStyle: TextStyle(fontSize: 15, color: Colors.grey))),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    signIn();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(100)),
                    child: const Center(
                      child: Text("Login",
                          style: TextStyle(fontSize: 15, color: Colors.white)),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Register()));

                        },
                        child: Text("Register New Account",
                            style: TextStyle(fontSize: 15, color: Colors.blue)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
