# Detail Test Case Template

Nguồn template: các sheet detail trong `OneShop_WEB.xlsx` như `Quản lý Outlet`, `Cấu hình đơn hàng`, `Xác thực cửa hàng`, `Quản lý tin tức`, `Quản lý thông báo`, `Quản lý Account`.

Đây là template quan trọng nhất. Mỗi tính năng tạo một file detail riêng; các detail merge lại thành `Summary.md` và `Test Summary.md`.

## Feature Metadata

| Trường | Giá trị |
|---|---|
| Feature ID | `<FEATURE-ID>` |
| Feature Name | `<tên tính năng>` |
| Source Sheet Name | `<tên sheet nếu convert từ Excel>` |
| Owner / Assign | `<tester>` |
| Platform | `<WEB / Mobile / API / ...>` |
| Test Environment | `<env>` |
| Build Version | `<version/build>` |
| Test Date | `<YYYY-MM-DD>` |
| Requirement / SRS Ref | `<link hoặc mã tài liệu>` |

## Roll-up Categories

Bảng này là contract để merge lên `Summary.md` và `Test Summary.md`. Có thể tính từ `## Test Cases`, nhưng nên giữ bảng này để review nhanh trước khi merge.

| Category | Type | Summary Screen | Summary Function | Assign | Total | Passed | Failed | Blocked | N/A | Not Run | Progress | % Passed | % Failed | % Blocked | % N/A | Bug ID | Remark |
|---|---|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---|---|
| `<UI_Danh sách ...>` | `UI` | `<screen>` | `<function>` | `<tester>` | `<n>` | `<n>` | `<n>` | `<n>` | `<n>` | `<n>` | `<%>` | `<%>` | `<%>` | `<%>` | `<%>` | `<BUG-1, BUG-2>` | `<ghi chú>` |
| `<Function_Danh sách ...>` | `Function` | `<screen>` | `<function>` | `<tester>` | `<n>` | `<n>` | `<n>` | `<n>` | `<n>` | `<n>` | `<%>` | `<%>` | `<%>` | `<%>` | `<%>` | `<BUG-1, BUG-2>` | `<ghi chú>` |

## Test Cases

Cột trong bảng này chuẩn hóa các biến thể từ Excel:

- `Test Scenario` từ cột `Test scenarios`; nếu sheet cũ không có thì để trống.
- `Result` gom các cột Excel cũ như `Result 16/8`, `Results`, `Results (Edge)`.
- Giá trị hợp lệ của `Result`: `Passed`, `Failed`, `Blocked`, `N/A`, `Not Run`.

| ID | Category | Area (Screen/Page) | Priority | Pre-condition | Test Scenario | TC Name | Step | Expected | Result | Bug ID | Comment |
|---|---|---|---|---|---|---|---|---|---|---|---|
| `TC-001` | `<UI_.../Function_...>` | `<screen/page>` | `<Critical/Major/Minor>` | `<điều kiện tiên quyết>` | `<nhóm scenario>` | `<tên test case>` | `<bước test, có thể dùng numbered list trong cell>` | `<kết quả mong đợi>` | `<Passed/Failed/Blocked/N/A/Not Run>` | `<bug id nếu có>` | `<ghi chú>` |

## Failed / Blocked Details

Chỉ liệt kê case cần theo dõi để merge bug summary và review rủi ro.

| ID | Category | Result | Bug ID | Actual / Comment | Expected | Owner | Next Action |
|---|---|---|---|---|---|---|---|
| `<TC-ID>` | `<category>` | `<Failed/Blocked>` | `<bug id>` | `<actual/ghi chú>` | `<expected>` | `<owner>` | `<fix/retest/waiting/...>` |

## Evidence

| ID | Evidence Type | Link / Path | Note |
|---|---|---|---|
| `<TC-ID>` | `<screenshot/log/video/api response>` | `<link/path>` | `<ghi chú>` |

## Detail Merge Rules

- Mỗi file detail chỉ đại diện cho một tính năng.
- Mỗi test case thật phải có `ID`; không dùng dòng section rỗng như Excel. Dùng cột `Category` để nhóm case.
- `Category` nên theo format `UI_<tên nhóm>`, `Function_<tên nhóm>`, `DataFlow_<tên nhóm>`, `API_<tên nhóm>`, hoặc `Permission_<tên nhóm>`.
- `Roll-up Categories` group theo `Category` trong `Test Cases`.
- `Total`: đếm tất cả case có `ID`.
- `Passed / Failed / Blocked / N/A`: đếm theo `Result`.
- `Not Run`: case có `Result` rỗng hoặc `Result = Not Run`.
- `Progress`: `(Passed + Failed + Blocked + N/A) / Total`.
- Các phần trăm status dùng mẫu số `Total`.
- `Bug ID` trong roll-up là unique bug id của case `Failed`/`Blocked`.
- Nếu một test case cần data DB/API, ghi rõ trong `Pre-condition` và `Expected` để người merge không mất ngữ cảnh.
