# 2주차 과제 - 첫 Flutter 실행 증거 묶음

- 제출자: [학생 이름] (학번: [학번])
- 제출 기한: 3주차 수업 시작 전
- GitHub 저장소: https://github.com/[username]/week2_first_app

---

## 1. 개발환경 체크리스트

- [x] `git --version` 실행 확인 (`git version 2.40.0`)
- [x] `flutter --version` 실행 확인 (`Flutter 3.19.0`)
- [x] `flutter doctor -v` 실행 및 Android 개발 필수 항목 확인
- [x] `flutter devices` 실행 대상 확인 (`Pixel 6 Pro (emulator)` - `emulator-5554`)

### `flutter doctor -v` 실행 및 결과
```bash
$ flutter doctor -v
[✓] Flutter (Channel stable, 3.19.0, on macOS 14.2.1 23C71 darwin-arm64)
[✓] Android toolchain - develop for Android devices (Android SDK version 34.0.0)
[✓] Chrome - develop for the web
[!] Android Studio (not installed)
    • Android Studio is required to debug & run Flutter code on Android unless using VS Code.
[✓] VS Code (version 1.86.0)
[✓] Connected device (2 available)

! 경고 관련 판단 및 조치:
VS Code를 주요 IDE로 사용하고 있으므로 Android Studio 미설치 경고는 금일 Android 에뮬레이터 실행에 영향을 주지 않음을 확인했습니다.
```

---

## 2. 첫 앱 실행 증거

- **프로젝트 이름**: `week2_first_app`
- **실행 명령**: `flutter run -d emulator-5554`
- **실행 대상 (Device)**: Android Emulator (Pixel 6 Pro API 34 / `emulator-5554`)
- **실행 시각**: 2026-10-19 14:30:00 KST
- **바꾼 문구**: `"안녕하세요, [홍길동]의 첫 Flutter 앱입니다!"`

> 📷 **앱 실행 캡처 이미지**: `./evidence/flutter_app_run.png` 참고

---

## 3. GitHub 저장소 및 첫 commit

- **저장소 링크**: https://github.com/[username]/week2_first_app
- **Commit ID**: `a1b2c3d4e5f67890`
- **Commit Message**: `chore: verify first Flutter run`

---

## 4. 학습기록

| 항목 | 작성 내용 |
|---|---|
| **목표** | Android 에뮬레이터 환경에서 수정된 문구가 출력되는 Flutter 앱을 정상 실행하고 기록하고자 했습니다. |
| **관찰** | `flutter doctor` 실행 시 Android toolchain 정상 동작을 확인했으나 에뮬레이터 연결 미확인 상태를 관찰했습니다. |
| **원인** | 에뮬레이터가 사전에 기동되지 않아 `flutter devices` 목록에 감지되지 않았던 것이 원인이었습니다. |
| **행동** | Android Virtual Device(AVD)를 먼저 실행한 후 `flutter run -d emulator-5554` 명령어로 재실행했습니다. |
| **결과** | 에뮬레이터 화면에 "안녕하세요, [홍길동]의 첫 Flutter 앱입니다!" 문구가 정상적으로 출력되었습니다. |
| **다음** | 3주차 수업 전 위젯 구조(StatelessWidget vs StatefulWidget)의 기초 개념을 추가 검토할 예정입니다. |
