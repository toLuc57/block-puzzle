# Mô hình Dữ liệu: Hệ thống UI và Trạng thái Game

## Thực thể

### 1. GameHistoryState (Cấu trúc dữ liệu nội bộ)
Dùng để lưu trữ trạng thái tại một thời điểm để phục vụ tính năng Undo.

- `player_pos`: `Vector2i` - Vị trí hiện tại của người chơi.
- `block_positions`: `Dictionary[Block, Vector2i]` - Bản đồ vị trí của tất cả các khối.
- `move_count`: `int` - Số bước đã đi tại thời điểm đó.

### 2. BlockData (Resource mở rộng)
Cập nhật tệp `scripts/logic/BlockData.gd` để hỗ trợ hiển thị Chú giải.

- `id`: `String` - Định danh duy nhất.
- `color`: `Color` - Màu sắc hiển thị.
- `is_sliding`: `bool` - Khối có trượt hay không.
- `description`: `String` - **(MỚI)** Mô tả ngắn về cách khối hoạt động để hiển thị trong Legend.

## Trạng thái UI

### HUDState
- `current_moves`: `int`
- `target_moves`: `int`
- `blocks_placed`: `int`
- `total_blocks`: `int`

### VictoryState
- `is_visible`: `bool`
- `final_score`: `int`
