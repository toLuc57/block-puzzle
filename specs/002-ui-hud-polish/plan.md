# Kế hoạch Triển khai: Hệ thống UI và Đánh bóng giao diện (Cập nhật Phân vùng & Địa hình)

**Nhánh**: `system-UI-and-UI-polish` | **Ngày**: 2026-06-18 | **Đặc tả**: [specs/002-ui-hud-polish/spec.md](spec.md)

## Tóm tắt
Kế hoạch này tập trung vào việc triển khai hệ thống UI, không bị chồng lấn layout (Overlay) bằng cách sử dụng `SubViewport`, tích hợp hệ thống `Terrain` của Godot 4.x để tự động hóa texture bản đồ, và đảm bảo màn hình chiến thắng (Victory) hoạt động ổn định xuyên suốt các màn chơi. Cách tiếp cận kỹ thuật dựa trên việc sử dụng các Container mạnh mẽ của Godot và API TileMap mới.

## Ngữ cảnh Kỹ thuật

**Ngôn ngữ/Phiên bản**: Godot 4.6 (GDScript)
**Các Phụ thuộc Chính**: Godot Engine, GUT (Kiểm thử)
**Lưu trữ**: Resources (.tres) cho dữ liệu khối, GameState cho lịch sử Undo.
**Kiểm thử**: GUT cho logic Grid/Undo, Xác thực thủ công cho UI Responsive và Victory Loop.
**Nền tảng Mục tiêu**: Desktop (Windows)
**Mục tiêu Hiệu suất**: 60 FPS ổn định, UI phản hồi nhanh (<100ms).
**Ràng buộc**: Lưới cố định 10x10, không được phép UI che khuất game area.

## Kiểm tra Hiến chương

*CỔNG: Phải vượt qua trước nghiên cứu Giai đoạn 0. Kiểm tra lại sau thiết kế Giai đoạn 1.*

- **I. Hình ảnh Hiện đại & Phản hồi Nhanh**: ✅ Đạt. Sử dụng Tween và SubViewport để bảo vệ không gian hiển thị.
- **II. Kiến trúc Dựa trên Tín hiệu**: ✅ Đạt. Sử dụng `GameEvents` làm trung tâm giao tiếp.
- **III. Quản lý Dữ liệu Dựa trên Tài nguyên**: ✅ Đạt. Chú giải khối lấy dữ liệu trực tiếp từ tài nguyên.
- **VI. Ngôn ngữ Tài liệu**: ✅ Đạt. Tài liệu được viết bằng tiếng Việt.

## Cấu trúc Dự án

### Tài liệu (tính năng này)
```text
specs/002-ui-hud-polish/
├── spec.md              # Đặc tả cập nhật
├── plan.md              # Tệp này
├── research.md          # Nghiên cứu về SubViewport và Terrain
├── data-model.md        # Mô hình dữ liệu HUD/Legend
├── quickstart.md        # Hướng dẫn xác thực Victory Loop
├── contracts/           # Định nghĩa tín hiệu UI
│   └── interfaces.md
└── checklists/          # Danh sách kiểm tra chất lượng
```

### Mã nguồn (gốc kho lưu trữ)
```text
scenes/ui/
├── HUD.tscn
├── VictoryPopup.tscn
└── BlockLegend.tscn

scripts/ui/
├── HUD.gd
├── VictoryPopup.gd
└── BlockLegend.gd

scenes/main/
└── Main.tscn (Cập nhật cấu trúc VBoxContainer/SubViewport)
```

## Theo dõi Độ phức tạp

| Vi phạm | Tại sao cần thiết | Giải pháp thay thế đơn giản hơn bị từ chối vì |
|-----------|------------|-------------------------------------|
| Sử dụng SubViewport | Để cách ly hoàn toàn khu vực chơi 10x10 khỏi UI Overlay. | Sử dụng Z-index hoặc Margin đơn thuần không đảm bảo ngăn chặn được vật thể game lấn chiếm không gian UI khi camera di chuyển hoặc zoom. |
