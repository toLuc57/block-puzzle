# Hướng dẫn Xác thực Nhanh: Bố cục Sprout Lands

Tài liệu này mô tả các bước kiểm tra nhanh để xác minh feature đã hoạt động đúng ở mức end-to-end sau khi triển khai.

## Điều kiện tiên quyết
- Dự án mở được bằng Godot 4.6.
- Scene chạy mặc định của dự án vẫn là `res://scenes/main/Main.tscn`.
- Scene tham chiếu `res://scenes/tile_maps/sprout_lands_tile_map.tscn` còn khả dụng để đối chiếu layer và tile source.
- Bộ unit test hiện có của dự án khả dụng.

## Cách chạy dự án

### Chạy bằng Godot Editor
1. Mở project `block-puzzle` trong Godot 4.6.
2. Run project với scene mặc định `Main.tscn`.

### Chạy bằng CLI (nếu môi trường đã cấu hình lệnh `godot`)
```sh
godot --path .
```

## Chạy bộ kiểm thử tự động

```sh
godot --headless -s addons/gut/gut_cmdln.gd -gdir=res://tests/unit/
```

## Kịch bản 1: Kiểm tra nền tổng thể và vùng chơi
1. **Hành động**: Chạy game và quan sát màn vừa sinh khi chưa di chuyển.
2. **Mong đợi**:
   - `Water` phủ toàn khung game.
   - `Grass` tạo thành vùng chơi 14x12.
   - Ô Water nằm trong vùng 14x12 vẫn là chướng ngại vật đối với player và block.
   - Người chơi nhìn vào có thể phân biệt ngay khung tổng thể và vùng chơi chính.

## Kịch bản 2: Kiểm tra ranh giới `Path`
1. **Hành động**: Quan sát các cạnh của ranh giới trong vài màn sinh liên tiếp.
2. **Mong đợi**:
   - Ranh giới chỉ gồm các đoạn ngang/dọc.
   - Không có đoạn chéo hoặc cách đặt tile tạo cảm giác đường chéo.
   - Ranh giới đọc rõ là lớp khác với `Crops`.

## Kịch bản 3: Kiểm tra chướng ngại vật `Crops`
1. **Hành động**: Tìm các màn có `Crops` nằm gần hoặc trong khu vực puzzle.
2. **Mong đợi**:
   - `Crops` thể hiện rõ là obstacle tĩnh.
   - `Crops` không bị nhầm với `Path` hoặc với block di động.
   - Bố cục vẫn dễ đọc ngay từ lần nhìn đầu tiên.

## Kịch bản 4: Kiểm tra độ đa dạng thị giác của `Grass`
1. **Hành động**: Sinh liên tiếp ít nhất 5 màn mới.
2. **Mong đợi**:
   - Pattern hoặc biến thể `Grass` có thay đổi giữa các màn hoặc giữa các vùng đủ để giảm cảm giác đơn điệu.
   - Sự thay đổi chỉ là trực quan; không làm thay đổi vùng gameplay hợp lệ.

## Kịch bản 5: Kiểm tra payload và spawn hợp lệ
1. **Hành động**: Chạy bộ test hoặc thêm log/debug tạm trong lúc implement để quan sát payload level.
2. **Mong đợi**:
   - `player_pos`, `targets`, `blocks` không nằm ngoài vùng hợp lệ của layout.
   - Geometry tĩnh được dựng xong trước khi actor xuất hiện.
   - Các trường dữ liệu khớp với hợp đồng ghi trong `contracts/interfaces.md`.

## Kịch bản 6: Kiểm tra hồi quy gameplay cốt lõi
1. **Hành động**: Chơi thử vài màn sau khi áp bố cục mới.
2. **Mong đợi**:
   - Layout mới không làm hỏng luồng reset/sinh màn.
   - Tương tác player/block vẫn nhất quán với semantics gameplay hiện hành.
   - Các thay đổi trực quan không làm mơ hồ vùng chặn, vùng chơi và mục tiêu.
