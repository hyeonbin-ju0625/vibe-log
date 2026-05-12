# TR
AI 기반 여행 플래너 앱 — 목적지와 기간을 입력하면, AI가 최적의 여행 일정을 짜준다.
 
TR = Travel Route
 
---
 
## 프로젝트 개요
 
| 항목 | 내용 |
|------|------|
| 프로젝트명 | TR |
| 유형 | 모바일 앱 |
| 개발자 | 주현빈 |
| 기간 | 2026년 (7주) |
| AI API | Claude API (Anthropic) |
 
---
 
## 핵심 기능
 
- **일정 입력** — 목적지, 기간, 예산을 입력
- **AI 일정 생성** — 동선이 최적화된 여행 일정 자동 생성
- **지도 시각화** — 일정별 장소를 지도에 마커로 표시
- **일정 저장** — 생성된 일정 히스토리 조회
---
 
## 기술 스택
 
| 분류 | 기술 |
|------|------|
| 프레임워크 | Flutter |
| 언어 | Dart |
| AI API | Claude API |
| 지도 | Google Maps Flutter Plugin / Google Geocoding API |
| 형상관리 | Git + GitHub |
| 문서 | Markdown |
 
---
 
## 디렉토리 구조
 
```
tr/
├── lib/              # 앱 소스코드
├── docs/             # 설계 문서
├── .env.example      # 환경변수 예시 (API 키 미포함)
├── AUTHORING.주현빈.md
└── README.md
```
 
---
 
## 시작하기
 
```bash
# 저장소 클론
git clone https://github.com/{username}/tr.git
 
# 환경변수 설정
cp .env.example .env
# .env 파일에 Claude API 키 및 Google Maps API 키 입력
```
 
---
 
## 관련 문서
 
- [AUTHORING.주현빈.md](./AUTHORING.주현빈.md) — AI Agent 활용 기법 정리
