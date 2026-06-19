# Nghiên cứu Kỹ thuật: Hệ thống UI và Đánh bóng giao diện (Cập nhật Phân vùng & Địa hình)

## Các Quyết định Kỹ thuật

### 1. Hệ thống Hoàn tác (Undo) và Đặt lại (Reset)
- **Quyết định**: Sử dụng một Stack để lưu trữ lịch sử trạng thái trong một Singleton `GameState.gd`.
- **Chi tiết**: Mỗi khi người chơi hoặc khối di chuyển, lưu trạng thái hiện tại (`player_pos`, `blocks_positions`).
- **Lý do**: Đơn giản, hiệu quả cho trò chơi dựa trên lưới quy mô nhỏ (10x10).
- **Giải pháp thay thế**: Mẫu lệnh (Command Pattern) - Phức tạp hơn mức cần thiết cho dự án này.

### 2. Kiến trúc UI và Phân vùng Game Area - VBoxContainer 3 Phần
- **Quyết định**: Sử dụng `VBoxContainer` làm root container, chia màn hình thành 3 phần tách biệt.
- **Chi tiết**: 
  - **Top Panel**: HUD (Moves, Target, buttons) - chiều cao cố định, `size_flags_vertical = SIZE_SHRINK_BEGIN`
  - **Center Area**: Vùng chơi game (GridContainer, TargetLayer) - `size_flags_vertical = SIZE_EXPAND_FILL` để chiếm trọn không gian còn lại
  - **Bottom Panel**: Block Legend - chiều cao cố định, `size_flags_vertical = SIZE_SHRINK_END`
- **Lý do**: VBoxContainer tự động xếp children theo chiều dọc, đảm bảo không overlap. Đơn giản hơn SubViewport và không cần camera riêng.
- **Giải pháp thay thế đã loại bỏ**: SubViewportContainer (quá phức tạp, tốn performance khi không cần isolate rendering hoàn toàn)

### 3. Hệ thống Địa hình (TileMap Terrain)
- **Quyết định**: Sử dụng hàm `set_cells_terrain_connect()` của `TileMapLayer` (Godot 4.x).
- **Chi tiết**: Khi sinh màn chơi, thu thập danh sách tất cả các tọa độ ô nền và ô tường, sau đó gọi hàm này một lần duy nhất với terrain index tương ứng.
- **Lý do**: Tự động hóa việc chọn texture nối (autotiling), giúp bản đồ trông chuyên nghiệp và liền mạch mà không cần code logic phức tạp cho từng ô.

### 4. Giao tiếp Signal và Victory Screen Loop (Sửa lỗi Victory)
- **Quyết định**: Kết nối tín hiệu `win_condition_met` từ `GameEvents` (Autoload) trực tiếp vào `VictoryPopup`.
- **Chi tiết**: Vì `VictoryPopup` nằm trong một `CanvasLayer` cố định trong `Main.tscn`, việc kết nối signal một lần trong `_ready()` là đủ, miễn là `GameEvents` không bị giải phóng. Đảm bảo logic sinh màn mới (`_on_next_level_requested`) reset đúng trạng thái `visible` của Popup.
- **Lý do**: Tránh việc ngắt kết nối signal khi thay đổi dữ liệu màn chơi bên dưới.

### 5. Bảng Chú giải Khối (Block Legend)
- **Quyết định**: Tạo một `HBoxContainer` động trong `scripts/ui/BlockLegend.gd`.
- **Chi tiết**: Duyệt qua danh sách `BlockData` resources, instantiate một item template gồm Icon và Label.
- **Lý do**: Dễ bảo trì và mở rộng khi thêm loại khối mới.

## Các Phụ thuộc
- **Godot 4.6**: Tận dụng các tính năng `SubViewport` và `TileMapLayer` mới.
- **GUT**: Dùng để kiểm thử logic Undo và kiểm tra trạng thái chiến thắng.
