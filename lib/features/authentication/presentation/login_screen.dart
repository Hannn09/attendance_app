import 'package:attendance_cnn_app/features/authentication/presentation/providers/auth_notifier.dart';
import 'package:attendance_cnn_app/utils/themes.dart';
import 'package:attendance_cnn_app/widget/labeled_text_field.dart';
import 'package:attendance_cnn_app/widget/loading_state_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = true;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    ref.listen(authNotifierProvider, (previous, next) {
      next.whenOrNull(
        error: (error, stackTrace) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: const Duration(seconds: 2),
              content: Text(
                error.toString(),
                style: regularTextStyle.copyWith(color: whiteColor),
              ),
              backgroundColor: redColor,
            ),
          );
        },
        data: (data) {
          final role = data?.role?.toLowerCase();

          if (role == 'admin') {
            context.go('/home/admin');
          } else {
            context.go('/home');
          }
        },
      );
    });
    return Scaffold(
      backgroundColor: whiteColor,
      body: Stack(
        children: [
          SafeArea(
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
                            label: 'Username',
                            hint: 'Enter Username',
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
                                if (_formKey.currentState!.validate()) {
                                  ref
                                      .read(authNotifierProvider.notifier)
                                      .login(
                                        _emailController.text.trim(),
                                        _passwordController.text.trim(),
                                      );
                                }
                                // context.go('/home');
                              },
                              style: primaryButtonStyle,
                              child: Text(
                                'Sign In',
                                style: boldTextStyle.copyWith(
                                  color: whiteColor,
                                ),
                              ),
                            ),
                          ),

                          // GestureDetector(
                          //   onTap: () => context.go('/home/admin'),
                          //   child: Text(
                          //     'Login as Admin',
                          //     style: mediumTextStyle.copyWith(
                          //       color: primaryColor,
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (authState.isLoading)
            const Positioned.fill(child: LoadingStateWidget()),
        ],
      ),
    );
  }
}
