# Giao diện Kết nối (Interfaces & Signals)

Tài liệu này định nghĩa cách các thành phần trong hệ thống lưới giao tiếp với nhau.

## 1. Tín hiệu (Signals)

### GridManager (Autoload hoặc Node chính)
- `player_moved(from: Vector2i, to: Vector2i)`: Phát ra khi nhân vật di chuyển thành công.
- `block_moved(block: Node2D, from: Vector2i, to: Vector2i)`: Phát ra khi một khối bị đẩy.
- `line_cleared()`: (Nếu có tính năng xóa hàng).
- `win_condition_met()`: Phát ra khi tất cả các khối nằm trên ô 'X'.
- `game_over()`: Phát ra khi không còn nước đi hợp lệ.

### LevelGenerator
- `level_generated(state: Dictionary)`: Phát ra khi màn chơi mới được tạo xong.

## 2. Các hàm chính (Public Methods)

### GridLogic
- `can_move(pos: Vector2i, dir: Vector2i) -> bool`: Kiểm tra xem một vị trí có thể di chuyển vào không.
- `get_cell_type(pos: Vector2i) -> int`: Trả về loại ô (WALL, EMPTY, TARGET, v.v.).
- `update_cell(pos: Vector2i, type: int)`: Cập nhật trạng thái logic của ô.

### Block (Base Class)
- `push(direction: Vector2i) -> bool`: Xử lý logic khi bị đẩy. Trả về `true` nếu di chuyển thành công.

### LevelGenerator
- `generate_reverse(target_count: int, moves: int) -> Dictionary`: Thực hiện thuật toán sinh màn ngược.
