import 'package:logger/logger.dart';

final logger = Logger(
  printer: PrettyPrinter(
    methodCount: 2, // 스택 트레이스 메서드 수
    errorMethodCount: 8, // 에러 시 스택 트레이스 메서드 수
    lineLength: 120, // 출력 라인 길이
    colors: true, // 컬러 사용 여부
    printEmojis: true, // 이모지 출력 여부
  ),
);
