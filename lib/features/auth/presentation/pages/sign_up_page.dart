import 'package:flutter/material.dart';
import 'package:ui_one/features/auth/presentation/components/buttons.dart';
import 'package:ui_one/features/auth/presentation/validator/auth_validator.dart';
import 'package:ui_one/service._locator.dart';

class SignUpPage extends StatefulWidget {
  static const String id = "sign_up_page";

  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _signUpGlobalKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordRetryController = TextEditingController();
  bool passwordSee = true;
  bool passwordSee2 = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
          child: Form(
            key: _signUpGlobalKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),

                // Back Icon Button
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.chevron_left,
                    size: 30,
                  ),
                ),
                const SizedBox(height: 30),
                const Row(
                  children: [
                    SizedBox(width: 10),
                    Text(
                      "Register",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Column(
                  children: [
                    // Email Input -------------------------------------
                    TextFormField(
                      controller: emailController,
                      validator: AuthValidator.isEmailValid,
                      decoration: const InputDecoration(
                          hintText: "Email addresss",
                          ),
                    ),

                    // User name Input -------------------------------------
                    const SizedBox(height: 30),
                    TextFormField(
                      controller: nameController,
                      validator: AuthValidator.isNameValid,
                      decoration: const InputDecoration(
                        hintText: "User name",
                       
                      ),
                    ),

                    // Password Input -------------------------------------
                    const SizedBox(height: 30),
                    TextFormField(
                      controller: passwordController,
                      obscureText: passwordSee,
                      validator: AuthValidator.isPasswordValid,
                      decoration: InputDecoration(
                        hintText: "Create password",
                    
                        suffixIcon: GestureDetector(
                          onTap: () {
                            passwordSee = !passwordSee;
                            setState(() {});
                          },
                          child: Icon(
                            passwordSee
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                        ),
                      ),
                    ),

                    // Retry Password Input -------------------------------------
                    const SizedBox(height: 30),
                    TextFormField(
                      controller: passwordRetryController,
                      obscureText: passwordSee2,
                      validator: AuthValidator.isPasswordValid,
                      decoration: InputDecoration(
                        hintText: "Confirm password",
                    
                        suffixIcon: GestureDetector(
                          onTap: () {
                            passwordSee2 = !passwordSee2;
                            setState(() {});
                          },
                          child: Icon(
                            passwordSee2
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),
                    // Sign Up for Button ----------------------------------
                    MyButtonTwo(
                      text: "Next",
                      onPressed: signUpButton,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // when the button is pressed
  Future<void> signUpButton() async { // Añade async aquí
  if (_signUpGlobalKey.currentState!.validate()) {
    try {
      final Map<String, String> message = await authController.registration( // Añade await aquí
        nameController.text.trim(),
        emailController.text.trim(),
        passwordController.text.trim(),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message["message"]!),
          margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * .9),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 5),
          shape: const StadiumBorder(),
          dismissDirection: DismissDirection.horizontal,
          showCloseIcon: true,
        ),
      );
    } catch (e) {
      print("Error: ${e.toString()}");
      // Maneja el error aquí si es necesario
    }
  }
}


  // textController exits when finished
  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    passwordRetryController.dispose();
    super.dispose();
  }
}
