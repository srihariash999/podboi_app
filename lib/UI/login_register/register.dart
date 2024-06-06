import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:podboi/Shared/text_field_widget.dart';
import 'package:podboi/UI/login_register/login.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({Key? key}) : super(key: key);

  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Theme.of(context).colorScheme.primary,
        statusBarIconBrightness: Theme.of(context).brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark,
        statusBarBrightness: Theme.of(context).brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark,
      ),
      child: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.07,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Text(
                  " We just need a few details !",
                  style: TextStyle(
                    fontSize: 24.0,
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
                  controller: _nameController,
                  label: "Name",
                  hint: "Enter your name",
                ),
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
                child: TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                      backgroundColor: Color(0xFF120D31).withOpacity(0.85),
                      padding: EdgeInsets.symmetric(
                        horizontal: 64.0,
                        vertical: 16.0,
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0))),
                  child: Text(
                    " REGISTER ",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 18.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account? ",
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
                          builder: (context) => LoginScreen(),
                        ),
                      );
                    },
                    child: Text(
                      "Log in",
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
      ),
    );
  }
}
