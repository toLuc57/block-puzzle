# Mô hình Dữ liệu: Hệ thống UI và Đánh bóng giao diện

## Thực thể

### 1. HUDState
Đại diện cho trạng thái hiện tại hiển thị trên HUD.
- `current_moves`: int (Số bước người chơi đã thực hiện)
- `target_moves`: int (Số bước tối ưu để thắng)
- `placed_blocks`: int (Số khối đã nằm trên ô đích)
- `total_blocks`: int (Tổng số khối trong màn chơi)

### 2. BlockConcept
Đại diện cho một mục trong bảng Chú giải (Legend).
- `block_name`: String
- `icon_texture`: Texture2D
- `description`: String (Lấy từ `BlockData.tres`)

### 3. LayoutContainer
Định nghĩa cấu trúc layout 3 phần của màn hình.
- `top_panel_height`: int (Chiều cao cố định cho HUD, ví dụ: 60px)
- `bottom_panel_height`: int (Chiều cao cố định cho Legend, ví dụ: 40px)
- `center_area_flags`: int (SIZE_EXPAND_FILL để chiếm không gian còn lại)

## Mối quan hệ

- `Main.gd` quản lý `GameState`, phát tín hiệu cập nhật cho `HUDState`.
- `BlockLegend.gd` duyệt qua danh sách các `BlockData` để sinh ra các `BlockConcept` trên UI.
- `VBoxContainer` tổ chức TopPanel, CenterGameArea, BottomPanel theo chiều dọc để ngăn chặn overlay.
