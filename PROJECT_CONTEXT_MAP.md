# 프로젝트 컨텍스트 지도

> 제출 전 실제 저장소의 경로와 파일 구성이 아래 설명과 일치하는지 확인한다. 이 자료는 제공된 예제 앱 기준이다.

```text
lib/main.dart
 ├─ StateAssignmentApp
 │   └─ MaterialApp / 테마 / 시작 화면
 └─ TaskStatusPage
     └─ _TaskStatusPageState
         ├─ 원본 상태: _isCompleted
         ├─ 이벤트: _toggleStatus()
         ├─ 계산값: _statusText, _statusIcon
         └─ UI: 상태 텍스트, 아이콘, 완료/취소 버튼
```

## 연결 관계

- **파일:** `lib/main.dart`
- **화면:** `TaskStatusPage`
- **상태 소유자:** `_TaskStatusPageState`
- **원본 데이터:** `_isCompleted`
- **사용자 이벤트:** `FilledButton.onPressed`
- **상태 변경:** `_toggleStatus()`의 `setState`
- **화면 갱신:** `build()`가 상태에 맞는 텍스트·아이콘·색상·버튼 문구를 표시
- **검증:** 초기 화면, 완료 화면, 원복 화면 및 `flutter analyze`

## 다음 수정 때 다시 읽을 자료
1. `lib/main.dart` — 실제 상태와 UI 구현
2. `STATE_CONTRACT.md` — 원본 상태와 계산값의 규칙
3. `CONTEXT_PACKET.md` — 목표, 제약, 인수 조건
4. `PROMPT_COMPARISON.md` — AI 요청별 실제 관찰 결과
