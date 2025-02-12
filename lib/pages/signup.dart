import 'package:flutter/material.dart';
import 'package:flutter_edu/common/common_colors.dart';
import 'package:go_router/go_router.dart';
import '../service/user_service.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  void _showAlert(bool status, String message) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: CommonColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        content: Text(status ? '$message\n로그인 페이지로 이동합니다.' : message),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (status) {
                context.push('/signin');
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
    String name = '';
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
                color: CommonColors.green,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Column(
                  children: [
                    SizedBox(height: 150),
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
                          Text('이름'),
                          SizedBox(
                            height: 50,
                            width: 250,
                            child: TextField(
                              onChanged: (value) => name = value,
                              decoration: InputDecoration(
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
                                Response res = await UserApiService().signup(User(
                                  email: email,
                                  name: name,
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
                                '회원가입',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 320, top: 30),
                      child: Text(
                        '회원가입',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Transform.translate(
              offset: Offset(0, -600),
              child: GestureDetector(
                onTap: () => context.push('/signin'),
                child: Container(
                  width: 500,
                  height: 100,
                  decoration: BoxDecoration(
                    color: CommonColors.gray,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    child: Text(
                      '로그인',
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
