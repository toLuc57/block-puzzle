# Nghiên cứu kỹ thuật: Bố cục Sprout Lands

## Quyết định 1: Dùng `sprout_lands_tile_map.tscn` như nguồn tham chiếu layer, không nhúng trực tiếp scene tham chiếu vào scene chơi

**Decision**: Dùng `scenes/tile_maps/sprout_lands_tile_map.tscn` làm chuẩn đặt tên layer, tile source và cách đọc thị giác, nhưng vẫn để `Main.gd` dựng layout gameplay động từ payload level thay vì instance nguyên scene tilemap tham chiếu.

**Rationale**: Scene tham chiếu đã cho sẵn các layer `Water`, `Grass`, `Path`, `Crops` và tile sources cần thiết, nhưng layout gameplay của game vẫn phải sinh động theo state từ `LevelGenerator`. Dựng layout từ payload giúp giữ generator, collision và render nằm trên cùng một nguồn dữ liệu, đồng thời tránh tách rời giữa hình và logic.

**Alternatives considered**:
- Instance nguyên `sprout_lands_tile_map.tscn` rồi sửa tile runtime → bị loại vì scene tham chiếu không tự mang gameplay state cần cho mỗi màn sinh ra.
- Bỏ scene tham chiếu, tự đặt lại toàn bộ tile source từ đầu → bị loại vì tăng rủi ro lệch visual vocabulary so với yêu cầu feature.

## Quyết định 2: `Water` phủ toàn khung game, còn `Grass` chỉ mô tả vùng chơi 14x12

**Decision**: `Water` phải được xem là lớp nền toàn khung hiển thị, còn `Grass` chỉ đánh dấu vùng chơi 14x12 và được biến đổi nhẹ theo pattern ngẫu nhiên để tránh đơn điệu.

**Rationale**: Spec yêu cầu người chơi nhìn vào là nhận ra ngay khung game tổng thể và khu vực chơi chính. Phủ `Water` toàn khung tạo nền thống nhất, còn giới hạn `Grass` vào 14x12 làm nổi bật vùng mà layout puzzle thực sự diễn ra.

**Alternatives considered**:
- Cho cả `Water` lẫn `Grass` cùng phủ 14x12 → bị loại vì mất phân tách rõ giữa khung tổng thể và vùng chơi.
- Dùng một loại nền duy nhất → bị loại vì không đáp ứng yêu cầu đa dạng thị giác đã nêu trong spec.

## Quyết định 3: Ranh giới `Path` phải được sinh theo polyline trực giao

**Decision**: Path boundary được mô hình hóa như chuỗi đoạn ngang/dọc nối nhau theo lưới, cho phép gãy khúc nhưng không cho phép bất kỳ đoạn chéo hoặc hình đọc ra như đường chéo.

**Rationale**: Yêu cầu đặc tả đã chốt rõ ví dụ hợp lệ và không hợp lệ. Cách an toàn nhất là định nghĩa boundary như tập ô trên lưới trực giao, chỉ cho mở rộng theo bốn hướng cơ bản. Điều này giúp generator, render và validation cùng nói về một quy tắc hình học đơn giản, dễ test.

**Alternatives considered**:
- Cho phép tile góc xiên nếu nhìn tổng thể vẫn ổn → bị loại vì mâu thuẫn trực tiếp với clarification của spec.
- Vẽ boundary bằng sprite tự do ngoài lưới → bị loại vì làm khó validation hình học và không hợp với TileMapLayer hiện có.

## Quyết định 4: `Crops` là chướng ngại vật tĩnh, tách biệt rõ với `Path`

**Decision**: `Crops` chỉ dùng cho obstacle nằm bên trong hoặc sát vùng chơi và luôn mang semantics chặn rõ ràng, khác với `Path` là ranh giới hình học của bố cục.

**Rationale**: Spec yêu cầu người chơi phân biệt nhanh giữa ranh giới chặn đá và vật cản. Nếu dùng cùng một lớp/thể hiện thị giác cho cả hai, người chơi khó đọc màn và logic collision cũng khó diễn đạt nhất quán.

**Alternatives considered**:
- Gộp `Path` và `Crops` thành cùng một loại ô cản → bị loại vì làm mất ý nghĩa trực quan riêng của từng lớp.
- Spawn `Crops` dưới dạng node object riêng → bị loại vì static geometry nên ở TileMapLayer theo hiến chương và cấu trúc hiện tại.

## Quyết định 5: Giữ actor di chuyển là node riêng do `Main.gd` spawn

**Decision**: Player và Block vẫn là scene/node riêng, còn mọi geometry tĩnh của bố cục Sprout Lands được vẽ trước qua TileMapLayer.

**Rationale**: Điều này khớp cả hiến chương lẫn cách `Main.gd` đang hoạt động. Render nền và vật cản bằng TileMapLayer giúp scene gọn, còn node riêng cho actor giữ nguyên animation, input và collision flow hiện tại.

**Alternatives considered**:
- Biến block/player thành tile động trong TileMap → bị loại vì làm phức tạp undo, animation và occupancy tracking.
- Spawn cả obstacle như node → bị loại vì tăng scene tree mà không thêm lợi ích gameplay.

## Quyết định 6: Mở rộng payload generator để mang đủ dữ liệu nền và layout

**Decision**: `LevelGenerator` cần trả về payload có đủ grid hiển thị, vùng grass, boundary path, obstacle crops, targets, blocks, player spawn và metadata biến thể nền nếu cần.

**Rationale**: `Main.gd` hiện đã dựng màn từ `Dictionary state`, nên mở rộng cùng cấu trúc là cách ít xâm lấn nhất. Nó cũng giúp `GridLogic`, render và test dùng chung một nguồn sự thật.

**Alternatives considered**:
- Để `Main.gd` tự suy luận layer nền từ targets/blocks → bị loại vì logic render sẽ trở nên ngầm định và khó test.
- Lưu layout nền ngoài payload rồi đọc từ file khác → bị loại vì thêm phụ thuộc không cần thiết cho feature này.

## Quyết định 7: `Water` trong vùng 14x12 phải chặn player và block

**Decision**: Dù `Water` phủ toàn khung game để tạo nền trực quan, mọi ô `Water` nằm bên trong vùng 14x12 vẫn được xem là ô chặn trong gameplay và phải đi qua semantics `GridLogic`.

**Rationale**: Clarification mới của spec yêu cầu player chỉ đi trên `Grass` và `Path`; vì vậy `Water` bên trong vùng chơi không thể chỉ là nền trang trí. Đưa semantics này vào research giúp generator, grid logic, test và quickstart nói cùng một ngôn ngữ.

**Alternatives considered**:
- Xem `Water` chỉ là nền không chặn → bị loại vì mâu thuẫn trực tiếp với clarification.
- Tạo layer/loại ô riêng cho water-chặn → bị loại vì tăng rườm rà mà không cần thiết; cùng một `Water` layer đã đủ để thể hiện nền và semantics chặn qua GridLogic.

## Tác động tới các file hiện có

- `scenes/main/Main.gd`: cập nhật reset grid, render Water/Grass/Path/Crops, và spawn actor theo payload mới.
- `scripts/logic/LevelGenerator.gd`: mở rộng payload sinh màn để mô tả layout 14x12 và semantics path/crops.
- `scripts/logic/GridLogic.gd`: đảm bảo semantics ô khớp với ranh giới/path và obstacle/crops.
- `scenes/game_objects/Player.gd`, `scenes/game_objects/Block.gd`: xác thực lại hành vi di chuyển theo semantics mới nếu grid meaning thay đổi.
- `tests/unit/test_level_gen.gd`, `tests/unit/test_player_movement.gd`, `tests/unit/test_block_physics.gd`: mở rộng coverage cho layout và luật chặn mới.
