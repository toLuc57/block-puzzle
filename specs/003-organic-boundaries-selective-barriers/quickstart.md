# Hướng dẫn Xác thực Nhanh: Ranh giới Hữu cơ và Rào cản Có chọn lọc

Tài liệu này mô tả các bước kiểm tra nhanh để xác minh feature đã hoạt động đúng ở mức end-to-end sau khi triển khai.

## Điều kiện tiên quyết
- Dự án mở được bằng Godot 4.6.
- Scene chạy mặc định của dự án vẫn là `res://scenes/main/Main.tscn`.
- Bộ unit test GUT của dự án khả dụng.
- Có thể dùng `examples\puzzle1.png` và `art\Basic Grass Biom things 1.png` làm tham chiếu thị giác khi đối chiếu boundary và vật cản.

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

## Kịch bản 1: Kiểm tra kích thước và bố cục màn
1. **Hành động**: Chạy game và sinh ít nhất 3 màn mới liên tiếp bằng luồng reset/next level.
2. **Mong đợi**:
   - Khung hiển thị cố định là 12x10 ô.
   - Vùng giải đố hữu cơ luôn nằm giữa và không vượt quá 10x8 ô.
   - Không có target, block hoặc player nào xuất hiện ngoài vùng giải đố.
3. **Đối chiếu**: So sánh nhanh cách đọc bố cục với `examples\puzzle1.png`.

## Kịch bản 2: Kiểm tra selective barrier cho Nhân vật và Khối đá
1. **Hành động**: Dẫn Player tiếp cận một ô boundary, sau đó đẩy một block theo cùng hướng về phía boundary đó.
2. **Mong đợi**:
   - Player đi xuyên boundary được.
   - Block bị chặn tại boundary.
   - Player vẫn bị chặn bởi chướng ngại vật cố định và tường ngoài.
3. **Xác thực**: Kết quả phải đúng cho cả block thường và block băng.

## Kịch bản 3: Kiểm tra chướng ngại vật cố định làm điểm neo
1. **Hành động**: Tìm hoặc sinh một màn có block băng và ít nhất một chướng ngại vật cố định nằm trên hướng trượt.
2. **Mong đợi**:
   - Block băng trượt cho tới khi gặp vật cản hợp lệ.
   - Chướng ngại vật cố định hoạt động như điểm dừng/điểm neo hợp lệ.
   - Block không trượt xuyên qua boundary hoặc obstacle.
3. **Xác thực**: Quan sát vị trí cuối cùng của block so với ô obstacle/boundary.

## Kịch bản 4: Kiểm tra độ đa dạng và tính hợp lệ của generator
1. **Hành động**: Sinh liên tiếp 10 màn mới.
2. **Mong đợi**:
   - Phần lớn màn có hình dạng boundary hoặc vị trí obstacle khác nhau.
   - Không có màn nào bị chia thành vùng rời rạc không thể thao tác.
   - Không có màn nào tạo cảm giác “kẹt cứng” ngay khi bắt đầu do thiếu lối tiếp cận.
3. **Xác thực**: Đối chiếu với các tiêu chí ở `spec.md` và contract payload trong `contracts/interfaces.md`.

## Kịch bản 5: Kiểm tra đọc thị giác và polish
1. **Hành động**: Quan sát 3–5 màn mới mà không di chuyển nhân vật trong 2 giây đầu.
2. **Mong đợi**:
   - Dễ phân biệt vùng ngoài, boundary giải đố và chướng ngại vật cố định.
   - Các cụm obstacle liền mạch, không có khe hở đồ họa khó chịu.
   - Nếu có dùng thêm asset từ `art\Basic Grass Biom things 1.png`, asset phải hỗ trợ rõ hơn cho việc đọc biên/vật cản chứ không gây nhầm lẫn với block di động.
3. **Xác thực**: So sánh nhanh khả năng đọc màn với ảnh tham chiếu và với các tiêu chí thành công trong `spec.md`.
