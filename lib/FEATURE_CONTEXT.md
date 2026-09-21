//20260915
# Flutter 과제 - 첫 번째 프로젝트 구현

## 1. 프로젝트 개요
* 프로젝트명: week2_first_app
* 목적: Flutter 개발 환경 구축 확인 및 기본 프로젝트 구조 이해

## 2. 구현 및 확인 내용
* Flutter 기본 카운터 앱(Counter App) 동작 확인
* `lib/main.dart` 파일 구조 파악 및 실행 테스트 완료
* Git 환경 설정 및 GitHub 저장소(`chlwoqls/flotter`) 연동 완료

## 3. 실행 방법
* 터미널에서 `flutter run` 명령어 입력 후 에뮬레이터 또는 기기에서 구동 확인

//20260922
# Feature Context: Study Goal Manager

## 1. 사용자 목표 (User Goal)
- 앱프로그래밍을 배우는 학생으로서 오늘의 학습 목표를 등록하고 완료 상태를 관리한다.

## 2. 사용자 스토리 (User Story)
- 앱프로그래밍을 배우는 학생으로서 나는 오늘의 학습 목표를 등록하고 완료 표시하고 싶다. 그래서 남은 학습 항목을 바로 확인할 수 있다.

## 3. 수용 조건 (Acceptance Criteria)

### AC1: 정상 입력 (Valid Input)
- **Given**: 목표 입력란에 올바른 텍스트가 입력되어 있을 때
- **When**: 사용자가 추가 버튼을 누르면
- **Then**: 목록에 새로운 학습 목표가 추가된다.

### AC2: 공백 입력 (Empty Input)
- **Given**: 목표 입력란이 비어 있거나 공백만 있을 때[cite: 3]
- **When**: 사용자가 추가 버튼을 누르면[cite: 3]
- **Then**: 목록은 추가되지 않고 "목표를 입력하세요" 오류 문구가 표시된다[cite: 3].

### AC3: 완료 상태 전환 (Complete Toggle)
- **Given**: 등록된 학습 목표 항목이 화면에 있을 때[cite: 3]
- **When**: 사용자가 해당 목표의 체크박스(완료 버튼)를 누르면[cite: 3]
- **Then**: 해당 목표의 상태가 완료(취소선 또는 완료 표시)로 전환된다[cite: 3].