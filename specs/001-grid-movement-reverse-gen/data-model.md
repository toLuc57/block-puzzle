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

### LevelState
- `blocks`: Danh sách vị trí các khối.
- `player_pos`: Vị trí nhân vật.
- `targets`: Danh sách vị trí các ô 'X'.
