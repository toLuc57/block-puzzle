# Hợp đồng Nội bộ: Layout Sprout Lands

## 1. Hợp đồng payload `GeneratedLevelState`

`LevelGenerator` phải trả về một `Dictionary` đủ để `Main.gd` dựng lại toàn bộ màn chơi mà không cần suy luận thêm từ scene tham chiếu.

| Trường | Kiểu dữ liệu | Bắt buộc | Ý nghĩa |
|--------|--------------|----------|--------|
| `grid_size` | `Vector2i` hoặc cặp số | Có | Kích thước khung hiển thị của màn |
| `water_cells` | `Array[Vector2i]` | Có | Tập ô `Water` phủ toàn khung game |
| `grass_cells` | `Array[Vector2i]` | Có | Tập ô `Grass` đại diện vùng chơi 14x12 |
| `grass_variant_map` | `Dictionary` | Không bắt buộc nhưng nên có | Metadata biến thể tile/pattern để giảm đơn điệu |
| `path_boundary_cells` | `Array[Vector2i]` | Có | Tập ô `Path` tạo ranh giới bố cục |
| `crops_cells` | `Array[Vector2i]` | Có | Tập ô `Crops` là chướng ngại vật tĩnh |
| `targets` | `Array[Vector2i]` | Có | Tập ô mục tiêu |
| `blocks` | `Array[Dictionary]` | Có | Mỗi phần tử tối thiểu có `pos` và `type` |
| `player_pos` | `Vector2i` | Có | Vị trí bắt đầu của player |
| `target_moves` | `int` | Không bắt buộc | Metadata độ khó hoặc số bước mục tiêu |

### Ràng buộc hợp lệ
- `water_cells` phải bao phủ toàn bộ khung game.
- `grass_cells` phải biểu diễn vùng chơi 14x12 theo spec.
- Không phần tử nào trong `path_boundary_cells` được tạo thành đoạn chéo.
- `crops_cells`, `targets`, `blocks`, `player_pos` không được chồng lên nhau theo cách vi phạm gameplay.

## 2. Hợp đồng semantics ô trong `GridLogic`

`GridLogic` là nguồn sự thật cho occupancy động và phân loại ô tĩnh mà gameplay quan tâm.

| Khái niệm ô | Player | Block | Ghi chú |
|-------------|--------|-------|--------|
| Ngoài khung game | Bị chặn | Bị chặn | Giới hạn cứng của màn |
| `Water` | Không tự mang gameplay | Không tự mang gameplay | Chỉ là lớp nền toàn khung |
| `Grass` | Ô nền hợp lệ | Ô nền hợp lệ | Vùng puzzle chính |
| `PathBoundary` | Theo luật hiện hành cần giữ nhất quán | Bị chặn | Cần khớp feature trước và test lại trong implement |
| `CropsObstacle` | Bị chặn | Bị chặn | Chướng ngại vật tĩnh |
| Ô đang có block khác | Không đi vào | Không đi vào | Occupancy động |

### Hàm kiểm tra mong đợi
- Một nhóm hàm cho actor kiểu Player
- Một nhóm hàm cho actor kiểu Block
- Một helper chung để kiểm tra ô thuộc khung game và phân loại geometry tĩnh

## 3. Hợp đồng `Main.gd` khi dựng màn

`Main.gd` phải khởi tạo màn theo thứ tự sau:
1. Xóa actor cũ và reset state cũ
2. Khởi tạo lại lưới theo `grid_size`
3. Render geometry tĩnh theo thứ tự `Water` → `Grass` → `Path` → `Crops` → `Target overlay`
4. Spawn block instances
5. Spawn player
6. Ghi checkpoint đầu tiên vào `GameState`

### Ràng buộc render
- Geometry tĩnh phải dựng xong trước khi spawn actor.
- Random hóa `Grass` chỉ được làm thay đổi tile/pattern hiển thị, không làm đổi semantics ô.
- Các layer phải giữ khả năng đọc thị giác rõ giữa Water, Grass, Path và Crops.

## 4. Hợp đồng `LevelGenerator.gd`

- `LevelGenerator` chịu trách nhiệm sinh payload layout đầy đủ cho mỗi màn.
- Không được đẩy suy luận hình nền hoặc boundary sang `Main.gd` nếu thông tin đó có thể xác định ngay trong generator.
- Generator phải có bước validation để loại layout vi phạm các điều kiện hình học của `PathBoundary` hoặc phân bố layer theo spec.

## 5. Hợp đồng kiểm thử tối thiểu

Các hành vi sau phải có coverage bằng unit test hoặc kịch bản xác thực rõ ràng:
- `Water` luôn phủ kín khung game
- `Grass` luôn hiện diện đúng vùng chơi 14x12
- `PathBoundary` không chứa đoạn chéo hoặc cách nối đọc ra đường chéo
- `CropsObstacle` luôn phân biệt rõ với `PathBoundary`
- Payload level sinh ra không đặt target/block/player ngoài vùng hợp lệ
