import 'package:flutter/material.dart';
import 'package:flutter_chat_app/auth_service.dart';
import 'package:flutter_chat_app/login.dart';
import 'package:provider/provider.dart';

class Register extends StatefulWidget {
  Register({Key? key, this.onTap}) : super(key: key);
  final void Function()? onTap;

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  void signup() async {
    if(password.text != confirmPassword.text){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Passwords do not match'),));
    }
    final authService = Provider.of<AuthService>(context, listen: false);

    try {
      await authService.signUpWithEmailAndPassword(email.text, password.text);
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20,),
                TextFormField(
                  controller: email,
                    decoration: const InputDecoration(
                        hintText: "Email",
                        hintStyle: TextStyle(
                            fontSize: 15,
                            color: Colors.grey
                        )
                    )
                ),
                const SizedBox(height: 20,),
                TextFormField(
                  controller: password,
                  obscureText: true,
                  decoration: const InputDecoration(
                        hintText: "Password",
                        hintStyle: TextStyle(
                            fontSize: 15,
                            color: Colors.grey
                        )
                    )
                ),
                const SizedBox(height: 20,),
                TextFormField(
                  controller: confirmPassword,
                  obscureText: true,
                  decoration: const InputDecoration(
                        hintText: "Confirm Password",
                        hintStyle: TextStyle(
                            fontSize: 15,
                            color: Colors.grey
                        )
                    )
                ),
                const SizedBox(height: 20,),
                GestureDetector(
                  onTap: (){
                    signup();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(100)
                    ),
                    child: const Center(
                      child: Text(
                        "Register",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white
                        )
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));

                    },
                    child: Text(
                        "Login Instead",
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.blue
                        )
                    ),
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
