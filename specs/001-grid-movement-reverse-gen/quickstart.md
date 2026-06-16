# Hướng dẫn Xác thực Nhanh (Quickstart)

Tài liệu này hướng dẫn cách kiểm tra thủ công và tự động các tính năng cốt lõi của Hệ thống Lưới và Sinh màn.

## 1. Kiểm tra Di chuyển Lưới (Grid Movement)

### Kịch bản: Nhân vật di chuyển cơ bản
1. **Khởi chạy** cảnh `Main.tscn`.
2. **Nhấn** các phím mũi tên.
3. **Mong đợi**: Nhân vật di chuyển từng ô một mượt mà. Không thể đi xuyên tường.

### Kịch bản: Đẩy Khối Xám (Gray Block)
1. **Tiếp cận** một khối xám.
2. **Nhấn** phím mũi tên hướng về phía khối.
3. **Mong đợi**: Khối di chuyển 1 ô. Nếu phía sau khối là tường, cả nhân vật và khối đều không di chuyển.

### Kịch bản: Đẩy Khối Băng (Ice Block)
1. **Tiếp cận** một khối băng.
2. **Nhấn** phím mũi tên hướng về phía khối.
3. **Mong đợi**: Khối trượt liên tục cho đến khi chạm tường. Nhân vật chỉ di chuyển 1 ô vào vị trí cũ của khối.

## 2. Kiểm tra Sinh màn (Level Generation)

### Kịch bản: Đảm bảo khả năng giải (Solvability)
1. **Chạy** script `tests/unit/test_level_gen.gd` (sử dụng GUT).
2. **Kiểm tra**: Chạy 100 lần sinh màn ngẫu nhiên.
3. **Mong đợi**: 100% các màn chơi sinh ra phải có ít nhất một chuỗi lệnh đẩy (đảo ngược của chuỗi kéo) để đưa khối về đích.

## 3. Các lệnh hữu ích
- Chạy test toàn bộ: `godot --headless -s addons/gut/gut_cmdline.gd`
- Chạy riêng test logic lưới: `godot --headless -s addons/gut/gut_cmdline.gd -gdir=res://tests/unit/ -gtest=test_grid_logic.gd`
