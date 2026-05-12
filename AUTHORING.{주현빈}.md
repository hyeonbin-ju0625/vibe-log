# AUTHORING.주현빈.md
 
> TR 프로젝트에서 사용한 AI Agent 활용 기법 및 개인 노하우 정리
 
---
 
## 1. 사용 도구
 
| 도구 | 용도 |
|------|------|
| Claude (claude.ai) | 기획, 설계, 코드 생성, 문서 작성 |
| Claude API | 앱 내 AI 응답 (여행 일정 생성) |
| Google Maps Flutter Plugin | 지도 시각화, 장소 마커 표시, 동선 렌더링 |
| Google Geocoding API | 장소명 → 위도/경도 좌표 변환 |
| GitHub | 형상관리, 문서 버전 관리 |
 
---
 
## 2. 프로젝트 개요
 
| 항목 | 내용 |
|------|------|
| 프로젝트명 | TR |
| 사용 언어 | Dart |
| 프레임워크 | Flutter |
| 핵심 기능 | 목적지·기간·예산 입력 → AI 일정 자동 생성 → 카드형 UI + 지도 시각화 |
| 사용 API | Claude API, Google Maps Flutter Plugin, Google Geocoding API |
 
---
 
## 3. AI Agent 활용 방식
 
### 기획 단계
- 주제 선정 및 기능 범위 결정을 Claude와 대화하며 결정
- 요구사항 문서 초안을 Claude로 생성 후 직접 검토 및 수정
### 설계 단계
- Flutter 앱 아키텍처 및 디렉토리 구조 설계를 Claude에게 초안 요청
- 직접 이해하고 설명할 수 있는 수준으로 검토 후 확정
### 구현 단계
- 기능별 Dart 코드 생성을 Claude에게 요청
- 생성된 코드를 직접 읽고 동작 원리 파악 후 사용
---
 
## 4. 프롬프트 패턴
 
### 기능 구현 요청 시
```
[기능명]을 구현해줘.
- 사용 언어/프레임워크: Dart / Flutter
- 조건: {조건}
- 출력 형태: {형태}
```
 
### Claude API 연동 요청 시
```
Flutter에서 Claude API를 호출하는 [기능명]을 구현해줘.
- 입력: {사용자 입력값}
- 원하는 응답 형식: JSON / 텍스트
- 조건: {조건}
```
 
### 문서 생성 요청 시
```
[문서명]을 작성해줘.
- 대상 독자: {대상}
- 포함할 내용: {내용}
- 형식: Markdown
```
 
---
 
## 5. 실패 사례 및 교훈
 
| 상황 | 문제 | 해결 |
|------|------|------|
| (작성 예정) | | |
 
---
 
## 6. LLM Wiki — 개인 노하우
 
- (프로젝트 진행하며 지속 업데이트)
---
 
## 7. 참고 자료
 
- [Claude Docs](https://docs.claude.com)
- [Claude API Reference](https://docs.anthropic.com/en/api/getting-started)
- [Flutter 공식 문서](https://docs.flutter.dev)
- [Dart 공식 문서](https://dart.dev/guides)
- [google_maps_flutter 패키지](https://pub.dev/packages/google_maps_flutter)
- [Google Geocoding API](https://developers.google.com/maps/documentation/geocoding)
