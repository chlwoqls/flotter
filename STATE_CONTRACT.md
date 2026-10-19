# 상태 계약 및 이벤트 흐름

## 1. 기능
화면의 할 일 완료 상태를 버튼 입력으로 변경한다. 완료하기를 누르면 완료 상태가 되고, 완료 취소를 누르면 미완료 상태로 돌아간다.

## 2. 상태 계약

| 구분 | 이름 | 정의 |
|---|---|---|
| 원본 상태 | `_isCompleted` | 완료 여부를 저장하는 `bool`; 초기값은 `false` |
| 계산값 | `_statusText` | `_isCompleted`가 `true`이면 `완료`, 아니면 `미완료` |
| 계산값 | `_statusIcon` | 상태에 따라 완료 아이콘 또는 빈 원 아이콘 |
| 계산값 | `statusColor` | 상태에 따라 초록색 또는 회청색 |

계산 가능한 표시값은 별도 상태로 저장하지 않고 원본 상태에서 계산한다. 상태 소유자는 `TaskStatusPage`의 `_TaskStatusPageState`이다.

## 3. 이벤트 → 상태 → UI 흐름

```text
사용자가 버튼을 누름
        ↓
_toggleStatus() 실행
        ↓
setState 안에서 _isCompleted 값 반전
        ↓
Flutter가 build()를 다시 실행
        ↓
텍스트·아이콘·색상·버튼 문구 갱신
```

## 4. 원복
완료 상태에서 같은 버튼을 다시 누르면 `_isCompleted`가 `true`에서 `false`로 바뀌고, 화면도 미완료 상태로 돌아온다.
