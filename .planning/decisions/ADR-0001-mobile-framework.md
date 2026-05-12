# ADR-0001: 모바일 프레임워크 선택
 
- 상태: Accepted
- 날짜: 2026-05-12
- 결정자: 주현빈
## 배경
 
TR 앱을 Android/iOS 모두 지원하는 모바일 앱으로 개발해야 한다.
어떤 프레임워크를 선택할지 결정이 필요하다.
 
## 고려한 대안
 
### 대안 A: Flutter
- 장점:
  - Android/iOS 하나의 코드베이스로 동시 지원
  - 자체 렌더링 엔진으로 네이티브에 가까운 성능
  - Android/iOS UI 일관성 보장
  - Google Maps Flutter 플러그인 공식 지원
  - Google 공식 지원으로 Firebase, Maps 연동 자연스러움
- 단점:
  - Dart 언어 학습 필요
  - React Native보다 커뮤니티 레퍼런스 적음
### 대안 B: React Native
- 장점:
  - JavaScript 기반으로 진입장벽 낮음
  - 커뮤니티 크고 레퍼런스 많음
- 단점:
  - JavaScript Bridge 방식으로 Flutter보다 성능 낮음
  - Android/iOS UI가 다르게 보일 수 있음
  - Google Maps 연동이 상대적으로 복잡함
### 대안 C: Android Native (Kotlin)
- 장점:
  - Android 최적 성능
  - Google Maps 네이티브 연동
- 단점:
  - Android 전용 — iOS 미지원
  - 개발 범위가 플랫폼 하나로 제한됨
## 결정
 
Flutter를 선택한다.
 
## 이유
 
- Android/iOS 동시 지원이 필요한데 코드베이스는 하나로 유지하고 싶음
- Google Maps Flutter 플러그인이 공식 지원되어 TR의 핵심 기능인 지도 시각화 연동에 유리함
- 자체 렌더링 엔진으로 성능과 UI 일관성 모두 확보 가능
## 결과 (예상되는 영향)
 
긍정:
- 하나의 코드로 Android/iOS 모두 배포 가능
- Google Maps 연동 구현이 수월함
- UI가 플랫폼 관계없이 일관되게 표시됨
부정 / 제약:
- Dart 언어 학습 곡선 존재
- React Native보다 레퍼런스가 적어 문제 해결에 시간이 걸릴 수 있음
## 후속 작업
 
- [ ] Flutter 개발 환경 세팅
- [ ] google_maps_flutter 패키지 설치 확인
- [ ] Android 에뮬레이터 "Hello World" 실행 확인
