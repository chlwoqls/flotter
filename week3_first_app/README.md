# 3주차 과제 — StudyGoal 추가·완료 전환

## 포함 파일
- `lib/main.dart`: 학습 목표 추가, 빈 입력 검사, 완료 상태 전환
- `FEATURE_CONTEXT.md`: 사용자 스토리, 기능 범위, 수용조건, Git 기록
- `evidence/`: 실제 실행 캡처를 저장할 폴더

## 적용 방법
강의 중 만든 `week03_goal_lab` 저장소를 먼저 열고 `git status`로 현재 작업 상태를 확인한다. 기존 파일을 백업한 다음 `lib/main.dart`를 적용하고 `FEATURE_CONTEXT.md`를 프로젝트 루트에 복사한다. 과제 지침에 있는 `03주차_실습.md`의 `_addGoal`과 `_toggleGoal` 구현을 먼저 확인하고, 수업 코드와 다른 부분이 있으면 강의 자료를 우선한다.

## 실행 및 확인
프로젝트 루트에서 실행한다.

```bash
flutter pub get
flutter run
flutter analyze
git status
git log -1 --oneline
```

앱에서 다음 세 가지를 직접 확인한다.
1. 유효한 목표를 입력하면 목록에 추가되는지
2. 빈 값이나 공백만 입력하면 오류가 표시되고 추가되지 않는지
3. 체크박스를 누르면 완료 상태가 바뀌는지

실제 화면 캡처를 `evidence` 폴더에 저장하고 파일명을 `FEATURE_CONTEXT.md`의 증거 파일명과 맞춘다. `flutter analyze` 출력과 실제 커밋 ID도 기록한다.

## GitHub 제출 예시
현재 브랜치와 변경 사항을 확인한 뒤 필요한 파일만 커밋한다.

```bash
git add lib/main.dart FEATURE_CONTEXT.md
git commit -m "feat: implement StudyGoal acceptance criteria"
git push
```

실제 실행하지 않은 테스트나 캡처를 완료한 것으로 표시하지 않는다. GitHub에 올리기 전 원격 저장소 주소가 본인 저장소인지 확인한다.
