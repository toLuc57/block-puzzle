# Kế hoạch Triển khai: Hệ thống UI và Đánh bóng giao diện (Polish UI/HUD)

**Nhánh**: `system-UI-and-UI-polish` | **Ngày**: 2026-06-17 | **Đặc tả**: [spec.md](spec.md)

**Đầu vào**: Đặc tả tính năng từ `/specs/002-ui-hud-polish/spec.md`

**Lưu ý**: Bản mẫu này được điền bởi lệnh `/speckit.plan`. Xem `.specify/templates/plan-template.md` cho quy trình thực hiện.

## Tóm tắt

Tính năng này tập trung vào việc nâng cấp giao diện người dùng (UI) từ dạng văn bản thuần túy sang một HUD chuyên nghiệp, hiện đại. Các thành phần chính bao gồm HUD hiển thị tiến trình (bước đi, mục tiêu, số khối), bảng chú giải khối (Block Legend), hệ thống Undo/Reset, và màn hình Victory. Kiến trúc sẽ tuân thủ mô hình tách biệt (decoupled) sử dụng Signals để giao tiếp giữa Main logic và UI logic.

## Ngữ cảnh Kỹ thuật

**Ngôn ngữ/Phiên bản**: Godot Engine 4.6 (GDScript)

**Các Phụ thuộc Chính**: Godot Engine (Control Nodes, CanvasLayer, Tween)

**Lưu trữ**: Resources (.tres) cho dữ liệu khối (BlockData.gd)

**Kiểm thử**: GUT (Godot Unit Test)

**Nền tảng Mục tiêu**: Máy tính để bàn (Windows), Di động (Kéo và thả)

**Loại Dự án**: Trò chơi Godot

**Mục tiêu Hiệu suất**: 60 FPS ổn định, phản hồi UI < 100ms

**Ràng buộc**: Kiến trúc Signal-driven, tài liệu Tiếng Việt

**Quy mô/Phạm vi**: HUD, Victory Pop-up, Block Legend, Polish hiệu ứng

## Kiểm tra Hiến chương

*CỔNG: Phải vượt qua trước nghiên cứu Giai đoạn 0. Kiểm tra lại sau thiết kế Giai đoạn 1.*

- [x] **I. Hình ảnh Hiện đại & Phản hồi Nhanh**: HUD sẽ sử dụng StyleBoxFlat với đường viền rõ nét và Tween phản hồi.
- [x] **II. Kiến trúc Dựa trên Tín hiệu**: `GameUI.gd` tách biệt hoàn toàn, giao tiếp qua signals.
- [x] **III. Quản lý Dữ liệu Dựa trên Tài nguyên**: Block Legend sẽ lấy dữ liệu từ các tệp `.tres` hiện có.
- [x] **IV. Xác thực Thực nghiệm & Kiểm thử**: Sẽ viết thêm test cases cho UI updates và Undo/Reset logic.
- [x] **V. Logic Lưới Ưu tiên Hiệu suất**: UI cập nhật không gây giật lag (tối ưu hóa signal handling).
- [x] **VI. Ngôn ngữ Tài liệu**: Toàn bộ spec, plan, research, tasks đều sử dụng tiếng Việt.

## Cấu trúc Dự án

### Tài liệu (tính năng này)

```text
specs/002-ui-hud-polish/
├── spec.md              # Đặc tả tính năng
├── plan.md              # Tệp này
├── research.md          # Kết quả nghiên cứu (Giai đoạn 0)
├── data-model.md        # Mô hình dữ liệu (Giai đoạn 1)
├── quickstart.md        # Hướng dẫn xác thực (Giai đoạn 1)
├── contracts/           # Giao diện/Signals (Giai đoạn 1)
└── checklists/          # Danh sách kiểm tra chất lượng
```

### Mã nguồn (gốc kho lưu trữ)

```text
scenes/
├── main/                # Main.tscn
├── ui/                  # HUD.tscn, VictoryPopup.tscn, BlockLegend.tscn
└── game_objects/        # Player.tscn, Block.tscn

scripts/
├── autoload/            # GameEvents.gd (Global signals)
├── ui/                  # GameUI.gd, HUD.gd, VictoryPopup.gd
└── logic/               # GridLogic.gd, BlockData.gd

resources/
├── blocks/              # ice_block.tres, gray_block.tres
└── themes/              # UI Theme, StyleBoxFlats

tests/
├── unit/                # test_ui_updates.gd, test_undo_logic.gd
```

**Quyết định Cấu trúc**: Sử dụng `CanvasLayer` cho `GameUI` để đảm bảo UI luôn nằm trên cùng. Các thành phần HUD và Legend sẽ được tổ chức trong các `MarginContainer` để hỗ trợ responsive. Sử dụng `GameEvents.gd` làm Singleton để quản lý các tín hiệu toàn cục nếu cần thiết, hoặc kết nối trực tiếp từ Main.

## Theo dõi Độ phức tạp

> **Chỉ điền nếu Kiểm tra Hiến chương có các vi phạm cần được giải thích**

| Vi phạm | Tại sao cần thiết | Giải pháp thay thế đơn giản hơn bị từ chối vì |
|-----------|------------|-------------------------------------|
| Không có | N/A | N/A |
