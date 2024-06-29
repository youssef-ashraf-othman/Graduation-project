import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_workspace/modules/Dash_Board/Dashboard.dart';
import 'package:flutter_workspace/shared/components/components.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Singup/Singup.dart';
import '../databasehelper/databasehelper.dart';

class ThemeNotifier extends ChangeNotifier {
  bool isDarkMode = false;

  ThemeMode get currentTheme => isDarkMode ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    isDarkMode = !isDarkMode;
    notifyListeners();
  }
}

class login extends StatefulWidget {
  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  var passwordcontroller = TextEditingController();
  var namecontroller = TextEditingController();
  var FormKey = GlobalKey<FormState>();

  bool ispassword = true;
  IconData suffixicon = Icons.visibility;

  @override
  void initState() {
    super.initState();
    _loadCredentials();
  }

  // Load saved username and password
  _loadCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    namecontroller.text = prefs.getString('username') ?? '';
    passwordcontroller.text = prefs.getString('password') ?? '';
  }

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
                      "Login",
                      style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
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
                  defaultbutton(
                    function: () async {
                      if (FormKey.currentState!.validate()) {
                        var user = await DatabaseHelper()
                            .getUser(namecontroller.text);
                        if (user != null &&
                            user['password'] == passwordcontroller.text) {
                          _saveCredentials();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NurseCallSystem()),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Invalid username or password"),
                          ));
                        }
                      }
                    },
                    text: "Login",
                    height: 65,
                    textcolor: Colors.white,
                  ),
                  SizedBox(height: 20),
                  defaultbutton(
                    function: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Singup()),
                      );
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