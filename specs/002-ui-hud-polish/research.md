# Nghiên cứu Kỹ thuật: Hệ thống UI và Đánh bóng giao diện

## Các Quyết định Kỹ thuật

### 1. Hệ thống Hoàn tác (Undo) và Đặt lại (Reset)
- **Quyết định**: Sử dụng một Stack để lưu trữ lịch sử trạng thái trong một Singleton `GameState.gd` hoặc trong `Main.gd`.
- **Chi tiết**: Mỗi khi người chơi hoặc khối di chuyển, lưu trạng thái hiện tại (`player_pos`, `blocks_positions`).
- **Lý do**: Đơn giản, hiệu quả cho trò chơi dựa trên lưới quy mô nhỏ (10x10).
- **Giải pháp thay thế**: Mẫu lệnh (Command Pattern) - Phức tạp hơn mức cần thiết cho dự án này.

### 2. Kiến trúc UI và Phản hồi
- **Quyết định**: Sử dụng `CanvasLayer` cho `GameUI`. Các thành phần HUD và VictoryPopup sẽ là các `Control` nodes riêng biệt.
- **Chi tiết**: Sử dụng `StyleBoxFlat` để tạo đường viền và bo góc cho HUD. Sử dụng `create_tween()` của Godot 4.x để thực hiện các hiệu ứng nảy Panel.
- **Lý do**: Đảm bảo UI không bị ảnh hưởng bởi phép biến đổi của camera và dễ dàng thiết kế responsive.

### 3. Bảng Chú giải Khối (Block Legend)
- **Quyết định**: Tạo một `HBoxContainer` động, lấy dữ liệu từ `BlockData.gd` resources.
- **Chi tiết**: Hiển thị Sprite của khối kèm theo mô tả lấy từ một thuộc tính mới trong `BlockData.gd`.
- **Lý do**: Tuân thủ nguyên tắc III của Hiến chương (Quản lý dữ liệu dựa trên Tài nguyên).

### 4. Giao tiếp Signal (Decoupled Architecture)
- **Quyết định**: Mở rộng `GameEvents.gd` để bao gồm các tín hiệu UI như `undo_requested`, `reset_requested`, `next_level_requested`.
- **Chi tiết**: `Main.gd` sẽ lắng nghe các tín hiệu này để thay đổi trạng thái game, trong khi UI chỉ chịu trách nhiệm phát tín hiệu.
- **Lý do**: Đảm bảo logic game và logic UI không phụ thuộc cứng vào nhau.

## Các Phụ thuộc
- **Godot 4.6**: Tận dụng các tính năng Tween và Control nodes mới nhất.
- **GUT**: Dùng để kiểm thử logic Undo mà không cần chạy toàn bộ game.
