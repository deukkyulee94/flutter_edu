import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../service/user_service.dart';

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final Color gray = const Color.fromRGBO(217, 217, 217, 1);
  final Color white = const Color.fromRGBO(255, 255, 255, 1);
  final Color green = const Color.fromRGBO(106, 202, 124, 1);

  void _showAlert(bool status, String message) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: white,
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
                color: gray,
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
                                filled: true, // 배경색 활성화
                                fillColor: white, // 배경색 지정
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10), // 둥근 테두리
                                ),
                                // 비활성 상태 테두리 색
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: white),
                                ),
                                // 포커스 상태 테두리 색
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: white),
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
                                fillColor: white, // 배경색 지정
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10), // 둥근 테두리
                                ),
                                // 비활성 상태 테두리 색
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: white),
                                ),
                                // 포커스 상태 테두리 색
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: white),
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
                                backgroundColor: white,
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
                    color: green,
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
