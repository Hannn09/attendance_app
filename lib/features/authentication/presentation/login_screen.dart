import 'package:attendance_cnn_app/utils/themes.dart';
import 'package:attendance_cnn_app/widget/labeled_text_field.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight:
                    MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top,
              ),
              child: Padding(
                padding: EdgeInsetsGeometry.symmetric(
                  horizontal: 35,
                  vertical: 25,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: .center,
                    children: [
                      Image.asset('assets/logo_app.png', width: 80),
                      const SizedBox(height: 30),
                      Text(
                        'Welcome Back !',
                        style: boldTextStyle.copyWith(
                          fontSize: 28,
                          color: blackColor,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Sign in to Pinus Attendance',
                        textAlign: TextAlign.center,
                        style: regularTextStyle.copyWith(
                          fontSize: 16,
                          color: blackColor.withValues(alpha: 0.5),
                        ),
                      ),
                      SizedBox(height: 35),
                      LabeledTextField(
                        label: 'Email',
                        hint: 'Enter Email',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'The email field is required';
                          }

                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      LabeledTextField(
                        label: 'Password',
                        hint: 'Enter Password',
                        controller: _passwordController,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'The password field is required';
                          }
                          return null;
                        },
                        isObsecure: _isPasswordVisible,
                        decoration: textFieldDecoration.copyWith(
                          hintText: 'Enter Password',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                          hintStyle: hintTextStyle,
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 20, top: 40),
                        height: 55,
                        child: ElevatedButton(
                          onPressed: () {
                            // if (_formKey.currentState!.validate()) {
                            //   debugPrint('Login');
                            // }
                            context.go('/home');
                          },
                          style: primaryButtonStyle,
                          child: Text(
                            'Sign In',
                            style: boldTextStyle.copyWith(color: whiteColor),
                          ),
                        ),
                      ),

                      GestureDetector(
                        onTap: () => context.go('/home/admin'),
                        child: Text(
                          'Login as Admin',
                          style: mediumTextStyle.copyWith(color: primaryColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
