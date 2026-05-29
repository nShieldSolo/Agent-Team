# Agent Team

Repo này chưa có code ứng dụng. Đây là bộ cấu hình Cursor cho **lammuon team**: một workflow dùng nhiều vai trò AI để phân tích, code và verify task một cách có kiểm soát.

## Mục tiêu

- Chọn team nhỏ nhất có thể hoàn thành task an toàn.
- Tách rõ vai trò: PM, BA, Tester, Senior Developer.
- Chuẩn hóa cách agent giao tiếp, bàn giao và báo cáo tiến độ.
- Bắt buộc test case tiếng Việt và không khai test pass nếu chưa chạy.
- Giữ guardrail an toàn cho git, file, package, DB, API và infra.

## Cấu trúc

```text
.cursor/
  agents/
    lammuon-pm.md
    lammuon-ba.md
    lammuon-tester.md
    lammuon-senior-dev.md
  rules/
    lammuon-guardrails.mdc
    lammuon-guardrails-detail.mdc
    lammuon-router.mdc
    lammuon-templates.mdc
    lammuon-speckit.mdc
    lammuon-testing.mdc
    lammuon-tooling.mdc
scripts/
  install.sh
  check-rules.py
codex/
  skills/
    lammuon-team/
      SKILL.md
.gitattributes
README.md
```

## Các agent

- **lammuon-pm**: chỉ dùng cho Large Team; lập plan, chia phase, quản trị scope/risk/rollback.
- **lammuon-ba**: dùng cho Medium/Large Team; làm rõ yêu cầu, mapping behavior, viết acceptance criteria.
- **lammuon-tester**: có ở mọi team; verify bug, viết test case, chạy test và regression.
- **lammuon-senior-dev**: có ở mọi task implement; đọc code, tìm root cause, sửa nhỏ nhất an toàn.

## Các rule chính

- **lammuon-guardrails.mdc**: rule an toàn core, always-on.
- **lammuon-router.mdc**: phân loại task thành Small/Medium/Large Team và chọn flow.
- **lammuon-templates.mdc**: template output bắt buộc cho Small/Medium Team.
- **lammuon-speckit.mdc**: template SpecKit đầy đủ cho Large Team.
- **lammuon-testing.mdc**: quy tắc test case, UI/API/DB/regression testing.
- **lammuon-tooling.mdc**: gợi ý skill/MCP theo role và loại task.
- **lammuon-guardrails-detail.mdc**: checklist và template xác nhận cho hành động nhạy cảm.

## Flow làm việc

### Small Team

Dùng cho bug nhỏ, typo, UI text, API/query issue gọn.

```text
Tester -> Senior Developer -> Tester
```

### Medium Team

Dùng cho feature mapping, business rule vừa phải, UI workflow/API behavior có ý nghĩa nghiệp vụ.

```text
BA -> Tester -> Senior Developer -> Tester
```

### Large Team

Dùng cho feature phức tạp, multi-module/service, architecture, migration, rollout nhiều phase.

```text
PM -> BA -> Tester -> Senior Developer -> Tester
```

## Cách dùng trong Cursor

### Cài tự động từ GitHub

Cài vào project hiện tại:

```bash
curl -fsSL https://raw.githubusercontent.com/nShieldSolo/Agent-Team/main/scripts/install.sh | bash
```

Cài vào project khác bằng path:

```bash
curl -fsSL https://raw.githubusercontent.com/nShieldSolo/Agent-Team/main/scripts/install.sh | bash -s -- /path/to/project
```

Script chỉ copy các file `lammuon-*` vào `.cursor/agents` và `.cursor/rules`. Nếu có file cũ trùng tên và khác nội dung, script sẽ backup file cũ thành `*.bak.<timestamp>` trước khi ghi đè.

### Cài global cho Cursor/Codex

Cài global Cursor subagents vào `~/.cursor/agents`:

```bash
curl -fsSL https://raw.githubusercontent.com/nShieldSolo/Agent-Team/main/scripts/install.sh | bash -s -- --global cursor
```

Cài global Codex skill vào `~/.codex/skills/lammuon-team`:

```bash
curl -fsSL https://raw.githubusercontent.com/nShieldSolo/Agent-Team/main/scripts/install.sh | bash -s -- --global codex
```

Cài cả hai:

```bash
curl -fsSL https://raw.githubusercontent.com/nShieldSolo/Agent-Team/main/scripts/install.sh | bash -s -- --global all
```

Lưu ý: Cursor Project Rules vẫn là project-scoped trong `.cursor/rules`. Cài global Cursor ở trên chỉ cài subagents; nếu muốn rule chạy chắc trong một repo cụ thể, vẫn nên chạy lệnh cài project trong repo đó.

### Gọi agent/rule

1. Mở project đã cài bằng Cursor.
2. Khi làm task dev/bug/feature/test, rule core sẽ yêu cầu nạp `lammuon-router`.
3. Nếu Cursor không tự kích hoạt đúng rule, gọi rõ bằng cách mention rule cần dùng, ví dụ:

```text
@lammuon-router xử lý bug này theo lammuon team
```

4. Với task nhỏ, ưu tiên Small Team. Chỉ lên Medium/Large khi task cần BA/PM thật sự.

## Nguyên tắc bảo trì

- Giữ `lammuon-guardrails.mdc` ngắn, chỉ để rule an toàn core.
- Template chỉ nên có một source of truth để tránh drift.
- Khi thêm rule mới, cập nhật README và rule map trong `lammuon-router.mdc`.
- Khi thêm hành động nhạy cảm mới, thêm checklist vào `lammuon-guardrails-detail.mdc`.
- Chạy kiểm tra markdown/frontmatter trước khi commit nếu có sửa nhiều rule.

## Kiểm tra (smoke test)

Script `scripts/check-rules.py` kiểm tra toàn bộ agent/rule:

- Frontmatter có block `---` mở/đóng.
- Code fence cân bằng (hỗ trợ fence 4 backtick bọc 3 backtick kiểu template).
- Mọi reference `lammuon-xxx` đều tồn tại file tương ứng.

Chạy trước khi commit nếu sửa nhiều rule:

```bash
python3 scripts/check-rules.py
```

Exit code 0 = pass, 1 = có lỗi.

## Tình trạng hiện tại

- Repo tập trung vào workflow và rule cho Cursor, chưa có code ứng dụng.
- Đã có smoke test (`scripts/check-rules.py`) cho frontmatter, markdown fence và reference giữa các rule.
