import 'dart:developer';

import 'package:al_quran_tafsir_and_audio/src/auth/auth_controller/auth_controller.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:toastification/toastification.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthController authController = Get.find<AuthController>();

  bool isLoggingAsync = false;
  bool isSigningAsync = false;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    log(authController.loggedInUser.value?.email.toString() ?? '');
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Gap(20),
                  IconButton(
                    padding: EdgeInsets.zero,
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.grey.withValues(alpha: 0.1),
                    ),
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      size: 18,
                    ),
                  ),
                  const Gap(10),
                  Text(
                    'Welcome'.tr,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Gap(5),
                  Text('Get the best experience by logging in'.tr),
                  Text(
                    'why_should_logged'.tr,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const Gap(20),
                  Text(
                    'Email'.tr,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: '${'type your email'.tr}...',
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (EmailValidator.validate(value ?? '')) {
                        return null;
                      } else {
                        return 'Please enter a valid email'.tr;
                      }
                    },
                  ),
                  const Gap(10),
                  Text(
                    'Password'.tr,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      hintText: '${'type your password'.tr}...',
                    ),
                    obscureText: true,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value!.length >= 6) {
                        return null;
                      } else {
                        return 'Password must be at least 6 characters'.tr;
                      }
                    },
                  ),
                  const Gap(20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (!formKey.currentState!.validate()) {
                          return;
                        }
                        setState(() {
                          isLoggingAsync = true;
                        });
                        String? error = await authController.login(
                          emailController.text,
                          passwordController.text,
                        );

                        setState(() {
                          isLoggingAsync = false;
                        });

                        if (error != null) {
                          toastification.show(
                            context: context,
                            title: Text('Login unsuccessful'.tr),
                            description: Text(error),
                            type: ToastificationType.error,
                            autoCloseDuration: const Duration(seconds: 5),
                          );
                        } else {
                          toastification.show(
                            context: context,
                            title: Text('Login successful'.tr),
                            description:
                                Text('You have successfully logged in'.tr),
                            type: ToastificationType.success,
                            autoCloseDuration: const Duration(seconds: 3),
                          );
                          Get.back();
                        }
                      },
                      child: isLoggingAsync
                          ? const Padding(
                              padding: EdgeInsets.all(3.0),
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : Text('Login'.tr),
                    ),
                  ),
                  const Gap(5),
                  Center(
                      child: Text(
                    'Or'.tr,
                    style: TextStyle(color: Colors.grey.shade600),
                  )),
                  const Gap(5),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () async {
                        if (!formKey.currentState!.validate()) {
                          return;
                        }
                        setState(() {
                          isSigningAsync = true;
                        });
                        String? error = await authController.register(
                          emailController.text,
                          passwordController.text,
                        );

                        setState(() {
                          isSigningAsync = false;
                        });

                        if (error != null) {
                          toastification.show(
                            context: context,
                            title: Text('Login unsuccessful'.tr),
                            description: Text(error),
                            type: ToastificationType.error,
                            autoCloseDuration: const Duration(seconds: 5),
                          );
                        } else {
                          toastification.show(
                            context: context,
                            title: Text('Login successful'.tr),
                            description:
                                Text('You have successfully logged in'.tr),
                            type: ToastificationType.success,
                            autoCloseDuration: const Duration(seconds: 3),
                          );
                          Get.back();
                        }
                      },
                      child: isSigningAsync
                          ? const Padding(
                              padding: EdgeInsets.all(3.0),
                              child: CircularProgressIndicator(
                                color: Colors.green,
                              ),
                            )
                          : Text('Signup then login'.tr),
                    ),
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
