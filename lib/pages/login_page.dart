import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wallet_app_ui/pages/signup_page.dart';

import '../resources/auth_methods.dart';
import '../widgets/already_have_an_account.dart';
import '../widgets/rounded_input_field_widget.dart';
import 'home_page.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({
    Key? key,
  }) : super(key: key);

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  bool _obsecureText = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 180,
              height: 100,
            ),
            Container(
              width: size.width - 90,
              height: size.height * 0.3,
              child: SvgPicture.asset(
                "assets/loginimage.svg",
                height: size.height * 0.45,
                width: 50,
              ),
            ),
            RoundedInputField(
              textEditingController: _emailController,
              hintText: 'Email',
              icon: Icons.person,
              onChanged: (String value) {},
            ),
            RoundedInputField(
              textEditingController: _phoneNumberController,
              hintText: 'Phone#',
              icon: Icons.phone,
              onChanged: (String value) {},
            ),
            TextFieldContainer(
              child: TextField(
                controller: _passwordController,
                obscureText: _obsecureText,
                decoration: InputDecoration(
                  hintText: 'Password',
                  fillColor: Colors.green[50],
                  icon: Icon(
                    Icons.lock,
                    color: Colors.black,
                  ),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {});
                    },
                    child: Icon(
                      _obsecureText ? Icons.visibility : Icons.visibility_off,
                      color: Colors.black,
                    ),
                  ),
                  //border: InputBorder.none
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 100, vertical: 10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0, backgroundColor: Colors.lightGreenAccent[400],
                  shape: const StadiumBorder(),
                  maximumSize: const Size(double.infinity, 50),
                  minimumSize: const Size(double.infinity, 50),
                  //padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  textStyle:
                      TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                onPressed: () async {
                  String res = await AuthMethods().loginUser(
                    email: _emailController.text,
                    password: _passwordController.text,
                  );
                  if (res == "Success") {
                    _clearFields();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return HomePage();
                        },
                      ),
                    );
                  } else {
                    final snackBar = SnackBar(
                      content: const Text('User Not Found!'),
                      action: SnackBarAction(
                        label: 'OK',
                        onPressed: () {
                          // Some code to undo the change.
                        },
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                }, // async {

                // },
                child: Text(
                  "Login".toUpperCase(),
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            AlreadyHaveAnAccountCheck(
              login: true,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return SignUpPage();
                    },
                  ),
                );
              },
            ),
            SizedBox(
              height: 50,
            ), //For Allignment of Layout
          ],
        ),
      ),
    );
  }

  void _clearFields() {
    _emailController.text = "";
    _passwordController.text = "";
  }
}
