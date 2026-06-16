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
- [x] **Điều phối Tích hợp**: Cảnh Main sẽ làm orchestrator chính để lắp ghép các thành phần (FR-008).

## Cấu trúc Dự án

### Tài liệu (tính năng này)

```text
specs/001-grid-movement-reverse-gen/
├── plan.md              # Tệp này
├── research.md          # Đầu ra Giai đoạn 0
├── data-model.md        # Đầu ra Giai đoạn 1 (Đã cập nhật logic Orchestration)
├── quickstart.md        # Đầu ra Giai đoạn 1
├── contracts/           # Đầu ra Giai đoạn 1 (Đã cập nhật Interface điều phối)
└── tasks.md             # Đầu ra Giai đoạn 2 (Cần cập nhật các nhiệm vụ tích hợp)
```

### Mã nguồn (gốc kho lưu trữ)

```text
scenes/
├── main/
│   ├── Main.tscn        # Cảnh điều phối chính
│   └── Main.gd          # Script quản lý vòng đời game
├── ui/
│   └── HUD.tscn         # Giao diện người dùng
└── game_objects/
    ├── Player.tscn
    └── Block.tscn

scripts/
├── autoload/
│   └── GameEvents.gd    # Tín hiệu toàn cục
└── logic/
    ├── GridLogic.gd     # Xử lý dữ liệu lưới
    ├── LevelGenerator.gd # Thuật toán sinh màn
    └── BlockData.gd     # Định nghĩa Resource
```

**Quyết định Cấu trúc**: Tuân theo cấu trúc Godot chuẩn đã thống nhất trong Hiến chương. `Main.gd` sẽ thực hiện quy trình:
1. `_ready()`: Gọi `LevelGenerator.generate_level()`.
2. Nhận dữ liệu trạng thái: Khởi tạo thực thể trực quan (`add_child`) tương ứng với vị trí logic.
3. Liên kết tham chiếu: Mọi thực thể nhận chung 1 instance của `GridLogic`.

## Theo dõi Độ phức tạp

> **Chỉ điền nếu Kiểm tra Hiến chương có các vi phạm cần được giải thích**

| Vi phạm | Tại sao cần thiết | Giải pháp thay thế đơn giản hơn bị từ chối vì |
|-----------|------------|-------------------------------------|
| Không có | | |
