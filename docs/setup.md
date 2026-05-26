# TR 앱 개발 환경 설정

새 사람이 이 문서만 보고 5분 안에 실행할 수 있어야 한다.

## 필요한 도구

| 도구 | 버전 | 다운로드 |
|---|---|---|
| Flutter | 3.32.1 이상 | https://flutter.dev |
| Android Studio | Panda 4 이상 | https://developer.android.com/studio |
| Git | 최신 | https://git-scm.com |

## 설치 순서

### 1. 저장소 클론
```bash
git clone https://github.com/hyeonbin-ju0625/vibe-log.git
cd vibe-log
```

### 2. 의존성 설치
```bash
flutter pub get
```

### 3. 환경 변수 설정
```bash
cp .env.example .env
```
`.env` 파일을 열고 아래 키 입력:
CLAUDE_API_KEY=your_claude_api_key
GOOGLE_MAPS_API_KEY=your_google_maps_api_key

### 4. 실행
```bash
# 크롬으로 실행
flutter run -d chrome

# 안드로이드 에뮬레이터로 실행
flutter run -d android
```

## 문제 해결 FAQ

**Q. flutter 명령어를 찾을 수 없어요**
A. Flutter SDK 경로를 환경변수 PATH에 추가하세요. `C:\flutter\bin`

**Q. Android SDK를 찾을 수 없어요**
A. Android Studio 설치 후 `flutter doctor --android-licenses` 실행

**Q. 에뮬레이터가 안 켜져요**
A. Android Studio > Device Manager에서 에뮬레이터 새로 만들기

**Q. pub get이 실패해요**
A. 네트워크 확인 후 `flutter clean` 후 다시 시도

**Q. API 키 오류가 나요**
A. `.env` 파일이 있는지, 키가 올바른지 확인