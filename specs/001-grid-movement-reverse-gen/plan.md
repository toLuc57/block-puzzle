# Kế hoạch Triển khai: Hệ thống lưới di chuyển & Sinh màn chơi ngược

**Nhánh**: `001-grid-movement-reverse-gen` | **Ngày**: 2026-06-16 | **Đặc tả**: [spec.md](spec.md)

**Đầu vào**: Đặc tả tính năng từ `/specs/001-grid-movement-reverse-gen/spec.md`

## Tóm tắt

Tính năng này triển khai hệ thống di chuyển rời rạc trên lưới 10x10 cho nhân vật và hai loại khối (Xám và Băng). Điểm nhấn kỹ thuật là thuật toán Sinh màn chơi ngược (Reverse Generation) sử dụng các bước "kéo ngược" (pull moves) từ trạng thái thắng để đảm bảo mọi màn chơi đều có thể giải được. Việc triển khai sẽ sử dụng Godot 4.6 với GDScript, tận dụng Tween cho hoạt ảnh và Resource cho định nghĩa khối.

## Ngữ cảnh Kỹ thuật

**Ngôn ngữ/Phiên bản**: Godot 4.6 (GDScript)

**Các Phụ thuộc Chính**: Godot Engine

**Lưu trữ**: Resources (.tres) cho định nghĩa loại khối, Mảng logic cho lưới

**Kiểm thử**: GUT (Godot Unit Testing) cho logic lưới và thuật toán sinh màn

**Nền tảng Mục tiêu**: Máy tính để bàn (Windows/macOS/Linux)

**Loại Dự án**: Trò chơi giải đố Godot

**Mục tiêu Hiệu suất**: 60 FPS ổn định, Sinh màn chơi < 500ms

**Ràng buộc**: Lưới cố định 10x10, Hoạt ảnh Tween < 300ms

**Quy mô/Phạm vi**: Di chuyển lưới 4 hướng, 2 loại khối (đẩy/trượt), Sinh màn ngược tự động

## Kiểm tra Hiến chương

*CỔNG: Phải vượt qua trước nghiên cứu Giai đoạn 0. Kiểm tra lại sau thiết kế Giai đoạn 1.*

- [x] **Hình ảnh Hiện đại**: Đã quy định sử dụng Tween cho mọi chuyển động (FR-002).
- [x] **Kiến trúc Tín hiệu**: Sẽ sử dụng tín hiệu để thông báo sự kiện di chuyển và thắng cuộc (Nguyên tắc II).
- [x] **Dữ liệu Tài nguyên**: Các loại khối Gray và Ice sẽ được định nghĩa qua Resource (FR-003, FR-004).
- [x] **Xác thực Thực nghiệm**: Thuật toán sinh màn được yêu cầu đảm bảo 100% khả năng giải (FR-007).
- [x] **Ngôn ngữ**: Tài liệu kế hoạch và thiết kế sử dụng tiếng Việt (Nguyên tắc VI).

## Cấu trúc Dự án

### Tài liệu (tính năng này)

```text
specs/001-grid-movement-reverse-gen/
├── plan.md              # Tệp này
├── research.md          # Đầu ra Giai đoạn 0
├── data-model.md        # Đầu ra Giai đoạn 1
├── quickstart.md        # Đầu ra Giai đoạn 1
├── contracts/           # Đầu ra Giai đoạn 1
└── tasks.md             # Đầu ra Giai đoạn 2
```

### Mã nguồn (gốc kho lưu trữ)

```text
scenes/
├── main/
├── ui/
└── game_objects/

scripts/
├── autoload/
├── ui/
└── logic/

resources/
├── blocks/
├── themes/
└── data/

tests/
├── unit/
├── integration/
└── functional/
```

**Quyết định Cấu trúc**: Tuân theo cấu trúc Godot chuẩn đã thống nhất trong Hiến chương. Logic lưới sẽ nằm trong `scripts/logic/`, các thực thể khối trong `scenes/game_objects/`.

## Theo dõi Độ phức tạp

> **Chỉ điền nếu Kiểm tra Hiến chương có các vi phạm cần được giải thích**

| Vi phạm | Tại sao cần thiết | Giải pháp thay thế đơn giản hơn bị từ chối vì |
|-----------|------------|-------------------------------------|
| Không có | | |
