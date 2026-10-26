# Week 04 Widget Lab — 제출 자료

## 포함 파일
- `lib/main.dart`: 상호작용이 있는 학습 목록 화면
- `WIDGET_SELECTION.md`: 위젯 선택표
- `DECISION_EVIDENCE.md`: 공식 문서와 선택 이유
- `EXECUTION_EVIDENCE.md`: AC1~AC3, 분석 결과, 커밋 기록 양식

## 적용 방법
기존 `week04_widget_lab` 프로젝트를 사용한다면 먼저 `git status`로 작업 상태를 확인하고 백업한 뒤 `lib/main.dart`를 적용한다. 문서 파일은 프로젝트 루트에 복사한다. 다른 프로젝트에 적용할 경우 실제 저장소와 경로를 과제 정보에 맞게 수정한다.

## 실행 및 검증
프로젝트 루트에서 실행한다.
```bash
flutter pub get
flutter run
flutter analyze
git status
git log -1 --oneline
```
앱을 직접 확인하고 초기 화면, 체크박스 변경 화면, 추가/원복 화면을 캡처한다. 실제 `flutter analyze` 출력과 커밋 ID를 `EXECUTION_EVIDENCE.md`에 기록한다.

## GitHub 제출 예시
검토 후 필요한 파일을 커밋한다.
```bash
git add .
git commit -m "feat: complete week 4 widget lab"
git push
```
실제 실행하지 않은 테스트 결과나 화면 캡처를 완료한 것으로 기재하지 않는다.
