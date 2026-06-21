# Mô hình Dữ liệu: Bố cục Sprout Lands

## 1. DisplayFrame

**Mục đích**: Đại diện cho toàn bộ khung hiển thị của màn chơi mà `Water` luôn phủ lên.

**Thuộc tính chính**:
- `width`: số cột của khung game
- `height`: số hàng của khung game
- `water_cells`: tập ô nền `Water` phủ kín khung

**Ràng buộc**:
- `water_cells` phải bao phủ toàn bộ khung hiển thị.
- Mọi ô render và mọi actor đều phải nằm trong `DisplayFrame`.

## 2. PlayableGrassArea

**Mục đích**: Mô tả vùng chơi 14x12 dùng lớp `Grass` làm nền trực quan chính.

**Thuộc tính chính**:
- `size`: kỳ vọng 14x12
- `grass_cells`: tập ô thuộc vùng chơi
- `grass_variant_map`: metadata biến thể tile hoặc pattern ngẫu nhiên cho từng ô/cụm ô

**Ràng buộc**:
- `grass_cells` phải tạo thành vùng chơi 14x12 theo spec.
- `grass_variant_map` chỉ thay đổi thị giác, không thay đổi collision hay semantics gameplay.

## 3. PathBoundary

**Mục đích**: Đại diện cho ranh giới `Path` ngăn block đi qua và định hình bố cục puzzle.

**Thuộc tính chính**:
- `cells`: tập ô path
- `segments`: danh sách đoạn trực giao nối nhau
- `is_orthogonal_only`: luôn đúng

**Ràng buộc**:
- Mọi segment chỉ được đi ngang hoặc dọc.
- Không có cạnh chéo, góc xiên, hoặc cách sắp ô tạo cảm giác boundary chéo.
- `PathBoundary` phải dễ phân biệt với `CropsObstacle`.

## 4. CropsObstacle

**Mục đích**: Đại diện cho các chướng ngại vật tĩnh hiển thị bằng `Crops`.

**Thuộc tính chính**:
- `cells`: tập ô vật cản
- `cluster_id`: định danh cụm liền nhau nếu cần render liền mạch
- `blocks_player`: luôn đúng
- `blocks_blocks`: luôn đúng

**Ràng buộc**:
- Không được trùng với ô target, block hoặc player spawn.
- Phải được phân biệt thị giác rõ với `PathBoundary`.

## 5. TargetMarker

**Mục đích**: Đại diện cho ô đích mà block cần phủ lên để thắng.

**Thuộc tính chính**:
- `cell`: vị trí ô mục tiêu
- `inside_playable_area`: luôn đúng

**Ràng buộc**:
- Không được nằm trên `PathBoundary` hoặc `CropsObstacle`.
- Phải nằm trong vùng chơi hợp lệ.

## 6. BlockInstance

**Mục đích**: Đại diện cho mỗi khối đá trong màn chơi.

**Thuộc tính chính**:
- `cell`: vị trí hiện tại
- `type_id`: loại block, hiện tại gồm `gray-block` và `ice-block`
- `movement_mode`: bước đơn hoặc trượt
- `blocked_by_path_boundary`: luôn đúng
- `blocked_by_crops`: luôn đúng

**Ràng buộc**:
- Không block nào được spawn ngoài vùng chơi hợp lệ.
- Mọi block đều bị chặn bởi `PathBoundary` và `CropsObstacle`.

## 7. PlayerSpawn

**Mục đích**: Đại diện cho vị trí bắt đầu của người chơi.

**Thuộc tính chính**:
- `cell`: vị trí bắt đầu
- `inside_playable_area`: đúng

**Ràng buộc**:
- Player spawn phải nằm trong vùng chơi hợp lệ.
- Player không được đi ra ngoài khung game.
- Semantics cụ thể với `PathBoundary` phải khớp luật hiện hành của feature trước và được kiểm chứng lại trong implement/test.

## 8. LayoutVisualState

**Mục đích**: Gom toàn bộ dữ liệu nền và geometry tĩnh phục vụ render TileMapLayer.

**Thuộc tính chính**:
- `water_cells`
- `grass_cells`
- `grass_variant_map`
- `path_boundary_cells`
- `crops_cells`

**Ràng buộc**:
- Dữ liệu trong `LayoutVisualState` phải đủ để `Main.gd` render xong geometry tĩnh trước khi spawn actor.
- Thay đổi visual variant không được làm thay đổi luật collision.

## 9. GeneratedLevelState

**Mục đích**: Payload hoàn chỉnh mà `LevelGenerator` bàn giao cho `Main.gd` để dựng màn.

**Thuộc tính chính**:
- `grid_size`
- `layout_visual_state` hoặc các trường tương đương cho water/grass/path/crops
- `targets`
- `blocks`
- `player_pos`
- `target_moves` hoặc metadata độ khó tương đương

**Ràng buộc**:
- Payload phải chứa đủ dữ liệu để render và spawn mà không cần suy luận ngầm thêm trong `Main.gd`.
- Không actor hoặc target nào được nằm ngoài vùng hợp lệ của layout.

## 10. ValidationRuleSet

**Mục đích**: Nhóm các điều kiện mà layout/generator phải vượt qua trước khi level được chấp nhận.

**Quy tắc chính**:
- `Water` phủ kín khung game
- `Grass` phủ đúng vùng chơi 14x12
- `PathBoundary` chỉ gồm đoạn ngang/dọc
- `CropsObstacle` không trùng actor/target spawn
- Vùng chơi luôn đọc được rõ ràng giữa Water, Grass, Path và Crops

**Trạng thái**:
1. `layout_built`
2. `geometry_validated`
3. `targets_and_blocks_placed`
4. `spawn_validated`
5. `accepted` hoặc `rejected`
