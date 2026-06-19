# Hướng dẫn Xác thực Nhanh: UI & Victory Loop

Tài liệu này hướng dẫn cách kiểm tra xem các tính năng UI và sửa lỗi đã hoạt động đúng như mong đợi hay chưa.

## Điều kiện tiên quyết
- Đã chạy game thành công trên Godot 4.6.
- Có sẵn ít nhất 2 loại khối (Xám và Băng).

## Kịch bản 1: Kiểm tra Layout 3 Phần (VBoxContainer)
1. **Hành động**: Chạy game, di chuyển Player lên sát mép trên cùng và mép dưới cùng của lưới 10x10.
2. **Mong đợi**: 
   - Player không bao giờ biến mất dưới TopPanel (HUD) hoặc BottomPanel (Legend).
   - Khu vực chơi 10x10 phải hiển thị trọn vẹn bên trong CenterGameArea.
   - Khi resize cửa sổ, chỉ CenterGameArea co giãn, TopPanel và BottomPanel giữ chiều cao cố định.
3. **Xác thực**: Kiểm tra Scene Tree có cấu trúc VBoxContainer > TopPanel/CenterGameArea/BottomPanel.

## Kịch bản 2: Kiểm tra Địa hình (Terrain)
1. **Hành động**: Nhấn "Reset" hoặc "Next Level" để sinh map mới.
2. **Mong đợi**: Các ô tường (Wall) phải có texture nối liền mạch với nhau. Không có các đường đứt gãy giữa các ô tường kề nhau.
3. **Xác thực**: Kiểm tra mã nguồn sử dụng `set_cells_terrain_connect`.

## Kịch bản 3: Kiểm tra Victory Loop (Persistence)
1. **Hành động**: 
    - Giải quyết màn chơi thứ nhất -> Màn hình Victory hiện lên.
    - Nhấn "Next Level" -> Màn mới được sinh ra.
    - Giải quyết màn chơi thứ hai.
2. **Mong đợi**: Màn hình Victory PHẢI hiện lên lần nữa ở màn thứ hai.
3. **Xác thực**: Tín hiệu `win_condition_met` phải luôn được kích hoạt và UI phải phản hồi đúng.

## Lệnh kiểm thử tự động
```sh
# Chạy unit tests cho logic Undo và Progress
godot --headless -s addons/gut/gut_cmdln.gd -gdir=res://tests/unit/ -ginclude=test_ui_updates.gd
```
