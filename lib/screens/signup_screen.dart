import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/screens/login_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/widgets/text_field_input.dart';

import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_layout_screen.dart';
import '../responsive/web_screen_layout.dart';
import '../utils/utils.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });

    String res = await AuthMethods().signUpUser(
      email: _emailController.text,
      password: _passwordController.text,
      username: _usernameController.text,
      bio: _bioController.text,
      file: _image!,
    );

    setState(() {
      _isLoading = false;
    });
    if (res != 'success') {
      // ignore: use_build_context_synchronously
      showSnackBar(res, context);
    } else {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
                mobileScreenLayout: MobileScreenLayout(),
                webScreenLayout: WebScreenLayout(),
              )));
    }
  }

  void navigateToLogin() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(flex: 2, child: Container()),
              // svg image
              SvgPicture.asset(
                "assets/ic_instagram.svg",
                color: primaryColor,
                height: 64,
              ),
              const SizedBox(height: 64),
              //circular widget to accept and show our selected file
              Stack(
                children: [
                  _image != null
                      ? CircleAvatar(
                          radius: 64,
                          backgroundImage: MemoryImage(_image!),
                        )
                      : const CircleAvatar(
                          radius: 64,
                          backgroundImage: NetworkImage(
                              'data:image/png;base64,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'),
                        ),
                  Positioned(
                      bottom: -10,
                      left: 80,
                      child: IconButton(
                          onPressed: selectImage,
                          icon: const Icon(Icons.add_a_photo)))
                ],
              ),
              const SizedBox(height: 20),
              // text field input for username
              TextFieldInput(
                  textEditingController: _usernameController,
                  hintText: "Enter your username",
                  textInputType: TextInputType.text),
              const SizedBox(height: 20),
              // text field input for email
              TextFieldInput(
                  textEditingController: _emailController,
                  hintText: "Enter your email",
                  textInputType: TextInputType.emailAddress),
              const SizedBox(height: 20),
              // text field input for password
              TextFieldInput(
                textEditingController: _passwordController,
                hintText: "Enter your password",
                textInputType: TextInputType.text,
                isPass: true,
              ),
              //text field for bio
              const SizedBox(height: 20),
              TextFieldInput(
                  textEditingController: _bioController,
                  hintText: "Enter your bio",
                  textInputType: TextInputType.text),
              const SizedBox(height: 20),
              // button login
              InkWell(
                onTap: signUpUser,
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4))),
                    color: blueColor,
                  ),
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: primaryColor,
                          ),
                        )
                      : const Text("Sign up"),
                ),
              ),
              const SizedBox(height: 20),
              Flexible(flex: 2, child: Container()),
              // transioting to login
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: const Text("Dont have an account?"),
                  ),
                  GestureDetector(
                    onTap: navigateToLogin,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text(
                        "Login",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
