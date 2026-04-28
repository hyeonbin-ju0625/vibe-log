# AIDE
 
> AI 기반 감정 일기 앱 — 오늘의 감정을 기록하면, AI가 공감하고 조언해준다.
 
**AIDE** = **A**I + **D**iary + **E**motion
 
---
 
## 프로젝트 개요
 
| 항목 | 내용 |
|------|------|
| 프로젝트명 | AIDE |
| 유형 | 모바일 앱 |
| 개발자 | 주현빈 |
| 기간 | 2026년 (7주) |
| AI API | Gemini API (Google AI Studio) |
 
---
 
## 핵심 기능
 
- 감정 입력 — 텍스트 또는 이모지로 오늘의 감정 기록
- AI 응답 — 감정에 맞는 공감 메시지 + 짧은 조언 제공
- 일기 저장 — 날짜별 히스토리 조회
---
 
## 기술 스택
 
| 분류 | 기술 |
|------|------|
| 프레임워크 | Flutter |
| AI API | Gemini API |
| 형상관리 | Git + GitHub |
| 문서 | Markdown |
 
---
 
## 디렉토리 구조
 
```
aide/
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
git clone https://github.com/{username}/aide.git
 
# 환경변수 설정
cp .env.example .env
# .env 파일에 Gemini API 키 입력
```
 
---
 
## 관련 문서
 
- [AUTHORING.주현빈.md](./AUTHORING.주현빈.md) — AI Agent 활용 기법 정리
