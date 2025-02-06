import 'package:flutter/material.dart';
import 'package:flutter_edu/widgets/custom_text_form_field.dart';
import '../service/user_service.dart';

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  static const Color customGray = Color.fromRGBO(217, 217, 217, 1);
  static const Color customGreen = Color.fromRGBO(106, 202, 124, 1);

  void _showAlert(String message) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        content: Text(message),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('확인'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return Scaffold(
      body: Center(
        child: Container(
          width: 500,
          height: 600,
          decoration: BoxDecoration(
            color: customGray,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 20,
                ),
                child: Text(
                  '로그인',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(
                width: 250,
                child: Column(
                  children: [
                    CustomTextFormField(
                      validator: (s) => (s!.isNotEmpty) ? null : "계정을 입력하세요",
                      contorller: emailController,
                      lableText: "계정",
                    ),
                    SizedBox(height: 20),
                    CustomTextFormField(
                      validator: (s) => (s!.isNotEmpty) ? null : "비밀번호를 입력하세요",
                      contorller: passwordController,
                      lableText: "비밀번호",
                      obscureText: true,
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      height: 50,
                      width: 250,
                      child: ElevatedButton(
                        onPressed: () async {
                          Response res = await UserApiService().signin(User(
                            email: emailController.text,
                            password: passwordController.text,
                          ));
                          _showAlert(res.message);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          fixedSize: Size.infinite,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: Text('로그인'),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 500,
                height: 100,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => Signin())),
                  // .push(MaterialPageRoute(builder: (context) => Signup())),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: customGreen,
                    foregroundColor: Colors.black,
                    alignment: Alignment.centerLeft,
                    textStyle: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text('회원가입'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
