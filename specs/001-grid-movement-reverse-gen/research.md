# Nghiên cứu Kỹ thuật: Hệ thống lưới & Sinh màn ngược

## Thuật toán Sinh màn chơi ngược (Reverse Generation / Pull Moves)

### Quyết định: 
Sử dụng thuật toán "Kéo ngược" (Pull Moves) bắt đầu từ trạng thái thắng.

### Lý do:
Đảm bảo 100% màn chơi sinh ra có thể giải được. Bằng cách thực hiện các bước đi hợp lệ theo chiều ngược lại (kéo thay vì đẩy), chúng ta tạo ra một mê cung mà lối thoát chính là trạng thái xuất phát.

### Chi tiết triển khai:
1. **Trạng thái Thắng**: Đặt ngẫu nhiên các khối vào các vị trí mục tiêu 'X'.
2. **Các bước đi ngược (Pull Moves)**:
   - Một khối chỉ có thể được "kéo" nếu có không gian trống phía trước nó (vị trí mà nhân vật sẽ đứng để kéo) và không gian trống phía sau nó (vị trí mà khối sẽ di chuyển tới).
   - Đối với **Khối Băng**: Kéo lùi lại nhiều ô cho đến khi gặp vật cản hoặc biên giới.
   - Đối với **Khối Xám**: Kéo lùi lại đúng 1 ô.
3. **Xáo trộn**: Thực hiện N bước kéo ngẫu nhiên để tạo độ khó.
4. **Trạng thái Khởi đầu**: Vị trí cuối cùng của nhân vật và các khối sau N bước kéo chính là màn chơi bắt đầu.

### Các lựa chọn thay thế đã xem xét:
- **Sinh ngẫu nhiên và kiểm tra đường đi (BFS/DFS)**: Quá tốn kém hiệu suất cho lưới 10x10 và có thể thất bại nhiều lần trước khi tìm được map hợp lệ.

---

## Hệ thống di chuyển bằng Tween trong Godot 4.6

### Quyết định:
Sử dụng `create_tween()` trực tiếp trong script điều khiển nhân vật/khối.

### Lý do:
Tween trong Godot 4 linh hoạt và nhẹ nhàng hơn hệ thống AnimationPlayer cho các chuyển động tịnh tiến đơn giản.

### Chi tiết triển khai:
- Sử dụng `TRANS_SINE` hoặc `TRANS_QUAD` với `EASE_OUT` để tạo cảm giác mượt mà nhưng vẫn dứt khoát.
- Khóa (lock) đầu vào của người chơi trong khi Tween đang chạy để tránh xung đột di chuyển.

---

## Kiểm thử với GUT

### Quyết định:
Tách biệt logic Grid (Model) khỏi Node (View) để kiểm thử unit test dễ dàng.

### Lý do:
Việc kiểm thử trên logic mảng (Array) nhanh hơn và đáng tin cậy hơn so với việc kiểm tra vị trí Node trong không gian 2D.

### Chi tiết triển khai:
- Tạo một lớp `GridLogic` thuần túy xử lý mảng 2 chiều.
- Viết test case cho: `push_block()`, `is_win_condition()`, `generate_level()`.
