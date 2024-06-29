import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_workspace/shared/components/components.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../databasehelper/databasehelper.dart';

class Singup extends StatefulWidget {
  @override
  State<Singup> createState() => _SingupState();
}

class _SingupState extends State<Singup> {
  var codecontroller = TextEditingController();
  var passwordcontroller = TextEditingController();
  var namecontroller = TextEditingController();
  var FormKey = GlobalKey<FormState>();

  bool ispassword = true;
  IconData suffixicon = Icons.visibility;

  // Save username and password
  _saveCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', namecontroller.text);
    await prefs.setString('password', passwordcontroller.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Nurse Call System',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        height: double.infinity,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: FormKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0),
                    child: Center(
                      child: Image(
                        image: AssetImage("assets/images/Nurse.png"),
                        width: 200,
                        height: 200,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      "Create new account",
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ),
                  defaultTextFormField(
                    controller: namecontroller,
                    type: TextInputType.text,
                    ispassword: false,
                    validate: (value) {
                      if (value!.isEmpty) {
                        return "Username must be filled";
                      }
                      return null;
                    },
                    label: "Username",
                    prefixicon: Icons.person,
                  ),
                  SizedBox(height: 20),
                  defaultTextFormField(
                    controller: passwordcontroller,
                    type: TextInputType.phone,
                    validate: (value) {
                      if (value!.isEmpty) {
                        return "Password must be filled";
                      } else if (value.length < 8) {
                        return "Password must be at least 8 characters";
                      }
                      return null;
                    },
                    ispassword: ispassword,
                    suffixicon: suffixicon,
                    showpassword: () {
                      if (suffixicon == Icons.visibility)
                        suffixicon = Icons.visibility_off;
                      else
                        suffixicon = Icons.visibility;
                      ispassword = !ispassword;
                      setState(() {});
                    },
                    label: "Password",
                    prefixicon: Icons.lock,
                  ),
                  SizedBox(height: 20),
                  defaultTextFormField(
                    ispassword: false,
                    controller: codecontroller,
                    type: TextInputType.text,
                    validate: (value) {
                      if (value!.isEmpty) {
                        return "Code must be filled";
                      }
                      if (value != "1234") {
                        return "Code is incorrect";
                      }
                      return null;
                    },
                    label: "Hospital code",
                    prefixicon: Icons.qr_code,
                  ),
                  SizedBox(height: 20),
                  defaultbutton(
                    function: () async {
                      if (FormKey.currentState!.validate()) {
                        bool userExists =
                        await DatabaseHelper().userExists(namecontroller.text);
                        if (userExists) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Username already exists"),
                          ));
                        } else {
                          await DatabaseHelper().insertUser(
                            namecontroller.text,
                            passwordcontroller.text,
                          );
                          _saveCredentials();
                          Navigator.pop(context);
                        }
                      }
                    },
                    text: "Sign Up",
                    height: 65,
                    textcolor: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
