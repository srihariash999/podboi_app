import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podboi/Controllers/login_register_controller.dart';
import 'package:podboi/Shared/text_field_widget.dart';
import 'package:podboi/UI/login_register/register.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.12,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Text(
                " Hello,",
                style: TextStyle(
                  fontSize: 40.0,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Segoe',
                  color: Colors.black,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Text(
                " Welcome back!",
                style: TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Segoe',
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(
              height: 18.0,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 18.0, vertical: 16.0),
              child: TextFieldWidget(
                controller: _emailController,
                label: "Email",
                hint: "Enter your email",
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 18.0, vertical: 16.0),
              child: TextFieldWidget(
                controller: _passwordController,
                label: "Password",
                hint: "Enter your password",
                obscureText: true,
              ),
            ),
            SizedBox(
              height: 28.0,
            ),
            Center(
              child: Consumer(
                builder: (context, ref, child) {
                  bool _loading = ref.watch(
                    loginRegisterController.select(
                      (value) => value.isLoading,
                    ),
                  );
                  if (_loading) {
                    return Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                            backgroundColor:
                                Color(0xFF120D31).withOpacity(0.85),
                            padding: EdgeInsets.symmetric(
                              horizontal: 64.0,
                              vertical: 16.0,
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0))),
                        child: Text(
                          ".........",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  }
                  return TextButton(
                    onPressed: () {
                      ref.read(loginRegisterController.notifier).userLogin(
                          email: _emailController.text.trim(),
                          password: _passwordController.text.trim());
                    },
                    style: TextButton.styleFrom(
                        backgroundColor: Color(0xFF120D31).withOpacity(0.85),
                        padding: EdgeInsets.symmetric(
                          horizontal: 64.0,
                          vertical: 16.0,
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0))),
                    child: Text(
                      " LOGIN ",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 18.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account? ",
                  style: TextStyle(
                    fontSize: 17.0,
                    fontFamily: "Segoe",
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegisterScreen(),
                      ),
                    );
                  },
                  child: Text(
                    "Sign up",
                    style: TextStyle(
                      fontSize: 16.0,
                      fontFamily: "Segoe",
                      fontWeight: FontWeight.w600,
                      color: Colors.blue[900],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
