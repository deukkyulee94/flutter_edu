import 'package:flutter/material.dart';
import 'package:flutter_edu/common/common_colors.dart';
import 'package:go_router/go_router.dart';
import '../service/user_service.dart';

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  void _showAlert(bool status, String message) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: CommonColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        content: Text(message),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (status) {
                context.push('/todo');
              }
            },
            child: Text('확인'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String email = '';
    String password = '';
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 500,
              height: 600,
              decoration: BoxDecoration(
                color: CommonColors.gray,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Column(
                  children: [
                    // 로그인
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '로그인',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SizedBox(height: 120),
                    Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('계정'),
                          SizedBox(
                            height: 50,
                            width: 250,
                            child: TextField(
                              onChanged: (value) => email = value,
                              decoration: InputDecoration(
                                hintText: '이메일을 입력해주세요.',
                                filled: true, // 배경색 활성화
                                fillColor: CommonColors.white, // 배경색 지정
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10), // 둥근 테두리
                                ),
                                // 비활성 상태 테두리 색
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: CommonColors.white),
                                ),
                                // 포커스 상태 테두리 색
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: CommonColors.white),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Text('비밀번호'),
                          SizedBox(
                            height: 50,
                            width: 250,
                            child: TextField(
                              onChanged: (value) => password = value,
                              obscureText: true,
                              decoration: InputDecoration(
                                hintText: '비밀번호를 입력해주세요.',
                                filled: true, // 배경색 활성화
                                fillColor: CommonColors.white, // 배경색 지정
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10), // 둥근 테두리
                                ),
                                // 비활성 상태 테두리 색
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: CommonColors.white),
                                ),
                                // 포커스 상태 테두리 색
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: CommonColors.white),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          SizedBox(
                            height: 50,
                            width: 250,
                            child: ElevatedButton(
                              onPressed: () async {
                                Response res = await UserApiService().signin(User(
                                  email: email,
                                  password: password,
                                ));
                                _showAlert(res.status, res.message);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: CommonColors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              child: Text(
                                '로그인',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Transform.translate(
              offset: Offset(0, -100),
              child: GestureDetector(
                onTap: () => context.push('/signup'),
                child: Container(
                  width: 500,
                  height: 100,
                  decoration: BoxDecoration(
                    color: CommonColors.green,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    child: Text(
                      '회원가입',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
