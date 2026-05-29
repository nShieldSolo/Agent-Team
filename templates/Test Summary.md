# Test Summary Template

Nguồn template: sheet `Test Summary` trong `OneShop_WEB.xlsx`.

File này là báo cáo tổng cuối cùng của một đợt test. Dữ liệu được tổng hợp từ tất cả file `Detail.md`; không nhập tay số liệu nếu có thể tính từ detail.

## Thông Tin Đợt Test

| Trường | Giá trị |
|---|---|
| Test Environment | `<WEB / Mobile / API / ...>` |
| Test Date | `<YYYY-MM-DD>` |
| Build Version | `<version/build>` |
| Device / Browser Info | `<OS, browser, device, resolution>` |
| Reporter | `<tên người báo cáo>` |

## Test Result

| Metric | Giá trị | Cách tính |
|---|---:|---|
| Executed TestCase | `<number>` | `Passed + Failed + Blocked + N/A` |
| Passed | `<number>` | Đếm case có `Result = Passed` |
| Failed | `<number>` | Đếm case có `Result = Failed` |
| Blocked | `<number>` | Đếm case có `Result = Blocked` |
| N/A | `<number>` | Đếm case có `Result = N/A` |
| TCs Not Run | `<number>` | `Total TCs - Executed TestCase` |
| Total TCs | `<number>` | Tổng tất cả test case trong các detail |

## Detailed Result

Mỗi dòng tương ứng với một `Category` trong file detail. Ví dụ: `UI_Danh sách Outlet`, `Function_Danh sách Outlet`, `Function_Chi tiết Outlet`.

| Category | TCs Sheet Name | Assign | Total | Passed | Failed | Blocked | N/A | TCs Not Run | Progress | % Passed | % Failed | % Blocked | % N/A | Bug ID | Remark |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---|---|
| `<UI/Function/DataFlow_...>` | `<tên file detail hoặc tên tính năng>` | `<tester>` | `<n>` | `<n>` | `<n>` | `<n>` | `<n>` | `<n>` | `<%>` | `<%>` | `<%>` | `<%>` | `<%>` | `<BUG-1, BUG-2>` | `<ghi chú>` |

## Bug / Blocked Summary

| Bug ID | Category | Detail | Số TC ảnh hưởng | Status | Remark |
|---|---|---|---:|---|---|
| `<bug id>` | `<category>` | `<detail file>` | `<n>` | `<Open/Fixed/Deferred/...>` | `<ghi chú ngắn>` |

## Roll-up Rules

- `Total`: đếm tất cả dòng trong `## Test Cases` của detail có `ID` không rỗng.
- `Passed / Failed / Blocked / N/A`: group theo cột `Result`.
- `Executed TestCase`: `Passed + Failed + Blocked + N/A`.
- `TCs Not Run`: case có `Result` rỗng hoặc `Not Run`.
- `Progress`: `Executed TestCase / Total`.
- `% Passed`: `Passed / Total`.
- `% Failed`: `Failed / Total`.
- `% Blocked`: `Blocked / Total`.
- `% N/A`: `N/A / Total`.
- `Bug ID`: lấy unique bug id của các case `Failed` hoặc `Blocked`; nếu bug id liên quan case pass thì chỉ đưa vào `Remark`.
- Không tính các dòng header/section. Mỗi case thật phải có `ID`.
