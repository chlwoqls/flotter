# 4주차 과제 — 위젯 선택표

## 화면 개요
오늘의 학습 목록과 완료 진행 상황을 한 화면에서 확인한다. 체크박스를 누르면 완료 상태가 바뀌고, 추가 버튼을 누르면 새 항목이 추가된다.

| 만들 기능 | 위젯 범주 | 선택한 위젯 | 선택 이유 |
|---|---|---|---|
| 화면 기본 구조 | 화면 구조 | `Scaffold` | 앱 바와 본문 영역을 구성한다. |
| 제목과 초기화 | 화면 구조/동작 | `AppBar`, `IconButton` | 제목과 초기화 동작을 제공한다. |
| 진행 상황 | 보여 주기 | `Text`, `Icon`, `LinearProgressIndicator` | 완료 개수와 비율을 보여 준다. |
| 요약 영역 배치 | 배치 | `Row`, `Column`, `Expanded` | 아이콘과 설명을 가로로, 설명을 세로로 배치한다. |
| 학습 목록 | 배치/동작 | `ListView.separated`, `CheckboxListTile` | 스크롤 목록과 체크 입력을 제공한다. |
| 항목 추가 | 동작 | `FilledButton` | 버튼 입력으로 새 항목을 추가한다. |
| 상태 원복 | 동작 | `OutlinedButton` | 모든 항목을 미완료로 바꾼다. |
| 콘텐츠 묶기 | 시각적 구성 | `Card`, `Padding` | 관련 내용을 묶고 간격을 준다. |

## 상태와 동작
- 상태 소유자: `_WidgetLabPageState`
- 원본 데이터: `_items` 목록과 각 `StudyItem.isDone`
- 체크 이벤트: `_toggleItem`
- 추가 이벤트: `_addItem`
- 원복 이벤트: `_resetItems`
- 진행률은 `_completedCount / _items.length`로 계산하며 별도 상태로 중복 저장하지 않는다.
