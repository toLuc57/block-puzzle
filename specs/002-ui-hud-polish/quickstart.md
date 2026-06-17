# Hướng dẫn Xác thực Nhanh: Hệ thống UI

Tài liệu này hướng dẫn cách kiểm tra các thay đổi của UI sau khi triển khai.

## Điều kiện Tiên quyết
- Godot Engine 4.6 đã được cài đặt.
- Các resources khối (`.tres`) đã được cập nhật mô tả.

## Các Kịch bản Xác thực

### 1. Kiểm tra HUD và Tween
1. Chạy game (`F5`).
2. Quan sát HUD ở phía trên: Phải có đường viền rõ nét, căn giữa ngang.
3. Di chuyển người chơi: `Move Count` phải tăng.
4. Đẩy một khối vào ô "X":
   - `Blocks: current/total` phải cập nhật.
   - Panel HUD phải có hiệu ứng "nảy" nhẹ hoặc đổi màu (Tween).

### 2. Kiểm tra Undo/Reset
1. Di chuyển vài bước.
2. Nhấn nút `Undo` trên màn hình hoặc `Ctrl+Z`: Vị trí và số bước phải quay lại 1 nấc.
3. Nhấn nút `Reset` hoặc `R`: Màn chơi phải quay về trạng thái bắt đầu.

### 3. Kiểm tra Block Legend
1. Nhìn xuống dưới màn chơi: Phải thấy icon và mô tả của "Đá xám" và "Đá băng".
2. Đảm bảo Legend căn giữa ngang và không che lấp Grid.

### 4. Màn hình Chiến thắng
1. Giải đố hoàn toàn.
2. Pop-up Victory phải hiện ra.
3. Thử nhấn `Next Level` và `Replay` để đảm bảo vòng lặp game hoạt động.

## Kiểm thử Tự động
Chạy lệnh sau để kiểm thử logic Undo/Reset:
```bash
godot --headless --path . -s addons/gut/gut_cmdline.gd -gdir=res://tests/unit -ginclude=test_ui_updates.gd
```
