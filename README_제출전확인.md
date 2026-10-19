# 5주차 과제 제출 전 확인

## 포함된 파일
- `lib/main.dart` — 완료/미완료 상태 예제
- `STATE_CONTRACT.md` — 상태 계약과 이벤트 흐름
- `PROJECT_CONTEXT_MAP.md` — 프로젝트 컨텍스트 지도
- `CONTEXT_PACKET.md` — 목표, 근거, 제약, 인수 조건, 검증
- `PROMPT_COMPARISON.md` — 요청 A/B 비교 실험 양식

## 실행 방법
이 파일들을 기존 Flutter 프로젝트에 복사하거나 새 Flutter 프로젝트에 해당 파일을 배치한다. 새 프로젝트라면 프로젝트 루트에서 다음을 실행한다.

```bat
flutter pub get
flutter run
flutter analyze
git status
git add .
git commit -m "feat: document state and task context"
```

## 반드시 직접 해야 하는 것
1. 앱 실행 후 초기·변경·원복 화면을 실제 캡처한다.
2. `flutter analyze`를 실행하고 실제 결과를 기록한다.
3. 요청 A와 B를 AI 도구에 각각 입력하고 응답을 같은 기준으로 비교한다.
4. 개인 GitHub 저장소에 올리고 저장소 링크를 제출한다.
5. 기존 프로젝트에 넣는 경우 문서의 경로와 설명을 실제 코드에 맞게 고친다.

실제 실행하지 않은 화면 캡처나 분석 성공 결과, AI 비교 결과를 만들어서 제출하지 않는다.
