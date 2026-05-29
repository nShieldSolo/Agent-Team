# Changelog

Mọi thay đổi đáng chú ý của repo **Agent Team** (workflow **Làm Mướn Team** / `lammuon-team`) được ghi tại đây.

Định dạng dựa trên [Keep a Changelog](https://keepachangelog.com/vi/1.1.0/).

## [Unreleased]

---

## [0.2.2] - 2026-05-29

### Added

- Agent **`lammuon-tester-team`** (alias `tester-team`) cho luồng QA-only: `BA -> Tester`.
- Router hỗ trợ **Tester Team**: BA đọc hiểu tính năng/AC, Tester viết scenario detail theo `templates/Detail.md`, merge `templates/Test Summary.md`, rồi mới viết/chạy Unit Test/E2E.

### Changed

- Cập nhật `lammuon-team`, `lammuon-router`, README và Codex skill để nhận diện Tester Team, không kéo Senior Dev vào task test-only.

---

## [0.2.0] - 2026-05-29

### Added

- File `VERSION` (semver, single source of truth).
- Banner ASCII **LÀM MƯỚN TEAM** khi gọi `/lammuon-team` — in **một lần mỗi session**; kèm dòng `v0.2.0` dưới tên team.
- File `CHANGELOG.md`.

### Changed

- Đổi tên hiển thị **lammuon team** / **lammuon-team** → **Làm Mướn Team** (in đậm) trên toàn bộ agents, rules, README và Codex skill.
- Giữ nguyên định danh kỹ thuật: `name: lammuon-team`, slash `/lammuon-team`, tên file `lammuon-*.md(c)`.
- Greeting mẫu: *Em là team **Làm Mướn** (v0.2.0)*.

---

## [2026-05-29]

### Added

- Agent router **`lammuon-team`** (orchestrator Small / Medium / Large Team).
- Script cài đặt Windows: `scripts/install.ps1`.
- Hướng dẫn cài Cursor + Codex trong `README.md`.
- Quy tắc **Tester tự chạy test** (bắt buộc):
  - UI/flow → Playwright MCP `user-playwright`
  - API → `curl` (Shell)
  - DB → MCP read-first (`user-mssql` / `user-mongodb`)
- Mục **Execution Mandate** trong `lammuon-testing.mdc`.
- Mục **Quy tắc TỰ CHẠY TEST** trong `lammuon-tester.md`.
- Fallback khi thiếu tool: template `## Test Execution Limitation` (không khai pass nếu chưa chạy).

### Changed

- Chuẩn hóa output template Small/Medium (`lammuon-templates.mdc`).
- Làm rõ SpecKit chỉ cho Large Team (`lammuon-speckit.mdc`).
- Sửa format test case / markdown trong `lammuon-testing.mdc`.
- Chuẩn hoá browser MCP → `user-playwright` trong `lammuon-tooling.mdc`.
- Cập nhật agents: model, handoff, SpecKit reference, guardrails.
- `README.md`: cấu trúc repo, agent/rule map, ví dụ slash command.

### Fixed

- Formatting / nhất quán tài liệu giữa `lammuon-speckit`, `lammuon-testing`, `lammuon-tooling`.

---

## [2026-05-29] — Khởi tạo

### Added

- Cấu trúc project: `.cursor/agents`, `.cursor/rules`, `scripts/`, `codex/skills/`.
- Agents: `lammuon-pm`, `lammuon-ba`, `lammuon-tester`, `lammuon-senior-dev`, `test`.
- Rules: `lammuon-guardrails`, `lammuon-guardrails-detail`, `lammuon-router`, `lammuon-templates`, `lammuon-speckit`, `lammuon-testing`, `lammuon-tooling`.
- Script `scripts/install.sh`, `scripts/check-rules.py`.
- Codex skill `codex/skills/lammuon-team/SKILL.md`.
- `README.md`, `.gitattributes`.
