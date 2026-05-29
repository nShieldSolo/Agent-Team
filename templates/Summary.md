# Summary Template

Nguồn template: sheet `Summary` trong `OneShop_WEB.xlsx`.

File này là dashboard cấp màn hình/chức năng. Nó gom các category UI/Function từ từng detail để nhìn nhanh tình trạng test theo screen.

## Test Report

| Metric | Giá trị | Cách tính |
|---|---:|---|
| Executed | `<number>` | `Passed + Failed + Blocked + N/A` |
| Passed | `<number>` | Tổng `Passed` từ tất cả detail |
| Failed | `<number>` | Tổng `Failed` từ tất cả detail |
| Blocked | `<number>` | Tổng `Blocked` từ tất cả detail |
| Not Run | `<number>` | Tổng case chưa run |
| Total TCs | `<number>` | Tổng test case trong tất cả detail |

## Screen Summary

| Screen | Function | Action | UI Testing (Giao diện) | Functional Testing (Chức năng) | Status | % TCs Executed | % TCs Passed | % TCs Failed | % TCs Blocked | % N/A | Notes |
|---|---|---|---|---|---|---:|---:|---:|---:|---:|---|
| `<tên screen>` | `<tên module/chức năng>` | `<action nếu có>` | `<UI category/detail link>` | `<Function category/detail link>` | `<Passed/Failed/Blocked/Not Run/Mixed>` | `<%>` | `<%>` | `<%>` | `<%>` | `<%>` | `<ghi chú>` |

## Source Details

| Detail | Feature | Owner | Categories | Total | Passed | Failed | Blocked | N/A | Not Run |
|---|---|---|---|---:|---:|---:|---:|---:|---:|
| `<detail file>` | `<tên tính năng>` | `<tester>` | `<UI_..., Function_...>` | `<n>` | `<n>` | `<n>` | `<n>` | `<n>` | `<n>` |

## Merge Rules

- Mỗi file detail đại diện cho một tính năng. Summary chỉ lấy số liệu từ các block `## Roll-up Categories` và `## Test Cases` của detail.
- `Screen`: lấy từ cột `Summary Screen` trong `## Roll-up Categories`; nếu trong detail không điền thì lấy `Area (Screen/Page)` của case.
- `Function`: lấy từ `Feature Name` hoặc `Summary Function` trong detail.
- `UI Testing (Giao diện)`: gom các category bắt đầu bằng `UI_`, `UI-`, hoặc có `Type = UI`.
- `Functional Testing (Chức năng)`: gom các category bắt đầu bằng `Function_`, `Function-`, `Data Flow`, `API`, `Permission`, hoặc có `Type = Function`.
- `Status` theo thứ tự ưu tiên: có `Failed` -> `Failed`; không failed nhưng có `Blocked` -> `Blocked`; tất cả chưa run -> `Not Run`; tất cả pass/NA và progress 100% -> `Passed`; còn lại -> `Mixed`.
- Các phần trăm tính trên `Total TCs` của screen/function, không tính trên số case đã executed.
