# Mô hình Dữ liệu: Hệ thống lưới & Khối

## 1. Thực thể Logic

### Grid (Lưới)
- **Kiểu**: Mảng 2 chiều (10x10) hoặc Mảng phẳng (100 phần tử).
- **Trạng thái mỗi ô**:
    - `EMPTY`: Ô trống.
    - `WALL`: Tường/Vật cản cố định.
    - `TARGET`: Điểm mục tiêu 'X'.
    - `BLOCK`: Có khối đang đứng.
    - `PLAYER`: Vị trí nhân vật.

### Block (Khối - Base Class)
- **Tài nguyên (Resource)**: `BlockData`
    - `id`: String (e.g., "gray-block")
    - `color`: Color
    - `is_sliding`: bool (True cho khối băng, False cho khối xám)
- **Trạng thái**:
    - `grid_position`: Vector2i (Vị trí trên lưới)
    - `is_on_target`: bool (Đang nằm trên ô 'X')

## 2. Quy tắc Di chuyển

### Nhân vật
- **Input**: Vector2i (Hướng di chuyển).
- **Logic**:
    - Nếu ô đích là `EMPTY` hoặc `TARGET`: Di chuyển.
    - Nếu ô đích có `BLOCK`: Gọi hàm `push()` của khối đó.

### Khối Xám (GrayBlock)
- **Logic `push()`**:
    - Nếu ô tiếp theo là `EMPTY` hoặc `TARGET`: Di chuyển 1 ô.
    - Nếu là `WALL` hoặc `BLOCK`: Không di chuyển.

### Khối Băng (IceBlock)
- **Logic `push()`**:
    - Trượt theo hướng đẩy cho đến khi ô tiếp theo là `WALL` hoặc `BLOCK`.
    - Dừng lại ở ô trống cuối cùng trước vật cản.

## 3. Thuật toán Sinh màn (LevelGen)

### Move (Bước đi ngược)
- `block_index`: ID của khối bị kéo.
- `from_pos`: Vector2i.
- `to_pos`: Vector2i.
- `direction`: Vector2i.

### LevelState (Dictionary trả về cho Main)
- `blocks`: Danh sách đối tượng `{ "pos": Vector2i, "type": String }`.
- `player_pos`: Vị trí Vector2i ban đầu của nhân vật.
- `targets`: Danh sách vị trí Vector2i các ô 'X'.

## 4. Quy trình Điều phối (Main Orchestration)

1. **Giai đoạn Khởi tạo**: `Main.gd` khởi tạo `GridLogic` mới.
2. **Giai đoạn Sinh màn**: Gọi `LevelGenerator.generate_level()`, nhận về `LevelState`.
3. **Giai đoạn Ánh xạ (Mapping)**:
   - Duyệt `LevelState.targets`: Gọi `GridLogic.set_cell(pos, TARGET)`.
   - Duyệt `LevelState.blocks`:
     - Instante `Block.tscn`.
     - Gán `Block.data` dựa trên loại khối (Gray/Ice).
     - Gán `Block.grid_logic`.
     - Đặt vị trí Node tương ứng với `pos`.
     - Thêm vào `GridLogic.blocks`.
   - Khởi tạo `Player.tscn`:
     - Gán `Player.grid_logic`.
     - Đặt vị trí Node tương ứng với `player_pos`.
4. **Giai đoạn Kết nối**: Lắng nghe tín hiệu từ `GameEvents` để cập nhật HUD.
