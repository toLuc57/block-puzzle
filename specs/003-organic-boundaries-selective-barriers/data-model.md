# Mô hình Dữ liệu: Ranh giới Hữu cơ và Rào cản Có chọn lọc

## 1. DisplayGrid

**Mục đích**: Đại diện cho toàn bộ khung hiển thị của màn chơi.

**Thuộc tính chính**:
- `width`: 12
- `height`: 10
- `playable_anchor`: gốc đặt vùng giải đố ở giữa khung hiển thị
- `playable_max_size`: giới hạn tối đa 10x8
- `padding_ring`: phần viền còn lại bao quanh vùng giải đố

**Ràng buộc**:
- Mọi ô logic và ô render đều phải nằm trong khung 12x10.
- Vùng giải đố thực tế không được tràn ra ngoài giới hạn 10x8 ở giữa.

## 2. PlayableMask

**Mục đích**: Mô tả tập các ô thuộc vùng giải đố hữu cơ mà generator cho phép dùng cho câu đố.

**Thuộc tính chính**:
- `floor_cells`: danh sách/tập ô được coi là nền chơi hợp lệ
- `boundary_cells`: các ô tạo thành đường viền giải đố bao quanh mask
- `outer_cells`: các ô còn lại ngoài vùng giải đố trong khung 12x10
- `is_connected`: cờ cho biết toàn bộ `floor_cells` có liên thông hay không

**Ràng buộc**:
- `floor_cells` phải liên thông.
- `boundary_cells` phải bao quanh phần không gian câu đố thay vì cắt ngang qua mục tiêu hoặc khối.
- `outer_cells` không được dùng để đặt player, target hoặc block.

## 3. StaticObstacle

**Mục đích**: Đại diện cho chướng ngại vật cố định sinh ngẫu nhiên bên trong vùng giải đố.

**Thuộc tính chính**:
- `cell`: vị trí ô
- `cluster_id`: định danh cụm để render liền mạch nếu nhiều ô kề nhau
- `blocks_player`: luôn đúng
- `blocks_blocks`: luôn đúng
- `acts_as_anchor`: luôn đúng cho các tình huống khối trượt cần điểm neo

**Ràng buộc**:
- Chỉ được nằm trong `floor_cells` hoặc không gian puzzle hợp lệ đã chọn cho vật cản tĩnh.
- Không được khiến vùng giải đố bị chia cắt hoặc mất lối thao tác thiết yếu.
- Không bao giờ bị xử lý như đối tượng di động trong reverse generation hoặc undo.

## 4. TargetMarker

**Mục đích**: Đại diện cho vị trí mục tiêu mà block phải phủ lên để thắng.

**Thuộc tính chính**:
- `cell`: vị trí ô mục tiêu
- `inside_playable_mask`: phải đúng
- `occupied_on_win`: điều kiện thắng của ô này

**Ràng buộc**:
- Chỉ được đặt trên ô hợp lệ bên trong vùng giải đố.
- Không được trùng với chướng ngại vật cố định hoặc ô boundary.

## 5. BlockInstance

**Mục đích**: Đại diện cho mỗi khối đá của câu đố.

**Thuộc tính chính**:
- `cell`: vị trí hiện tại
- `type_id`: định danh block, hiện tại gồm `gray-block` và `ice-block`
- `movement_mode`: bước đơn hoặc trượt liên tục
- `blocked_by_boundary`: luôn đúng
- `blocked_by_obstacle`: luôn đúng

**Ràng buộc**:
- Mọi block đều phải sinh trong vùng giải đố hợp lệ.
- Mọi block đều tuân theo cùng semantics va chạm đối với `boundary_cells`.
- Block trượt phải có cách dừng hợp lệ khi gặp wall, boundary, obstacle hoặc block khác.

## 6. PlayerSpawn

**Mục đích**: Đại diện cho vị trí bắt đầu của nhân vật và quy tắc di chuyển của nhân vật.

**Thuộc tính chính**:
- `cell`: vị trí bắt đầu
- `can_cross_boundary`: đúng
- `blocked_by_outer_wall`: đúng
- `blocked_by_static_obstacle`: đúng

**Ràng buộc**:
- Vị trí bắt đầu phải cho phép tiếp cận các thao tác đầu tiên của câu đố.
- Player có thể băng qua `boundary_cells`, nhưng không được đứng ngoài khung 12x10 hoặc đi xuyên vật cản cố định.

## 7. MovementPolicy

**Mục đích**: Chuẩn hóa luật vào ô theo loại tác nhân.

**Biến thể**:
- `player_policy`
  - chặn bởi: wall ngoài cùng, static obstacle, block đang chiếm ô
  - không chặn bởi: boundary
- `block_policy`
  - chặn bởi: wall ngoài cùng, static obstacle, boundary, block khác

**Ràng buộc**:
- Mọi kiểm tra push, slide, pull và di chuyển thường đều phải tham chiếu đúng policy thay vì tự viết luật ad-hoc.

## 8. GeneratedLevelState

**Mục đích**: Payload hoàn chỉnh mà `LevelGenerator` bàn giao cho `Main` để render và khởi tạo màn.

**Thuộc tính chính**:
- `grid_size`
- `playable_mask`
- `obstacles`
- `targets`
- `blocks`
- `player_pos`
- `target_moves` hoặc metadata độ khó tương đương

**Ràng buộc**:
- Payload phải đủ thông tin để `Main` vẽ toàn bộ geometry tĩnh trước khi spawn actor.
- Payload phải đi qua bước validation trước khi được emit như một level hợp lệ.

## 9. GenerationAttempt

**Mục đích**: Đại diện cho một lần thử sinh màn trước khi được chấp nhận hoặc bị loại.

**Trạng thái**:
1. `mask_built`
2. `obstacles_added`
3. `layout_validated`
4. `targets_and_blocks_placed`
5. `reverse_generated`
6. `accepted` hoặc `rejected`

**Điều kiện bị loại**:
- mask không liên thông
- không đủ ô trống cho player/targets/blocks
- boundary cắt vào không gian câu đố
- reverse generation không tạo được bố cục hợp lệ
- block hoặc target rơi ra ngoài vùng giải đố
