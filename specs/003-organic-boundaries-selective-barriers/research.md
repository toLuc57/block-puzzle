# Nghiên cứu kỹ thuật: Ranh giới Hữu cơ và Rào cản Có chọn lọc

## Quyết định 1: Tách nền ô tĩnh khỏi thông tin mục tiêu

**Decision**: Mô hình ô trong `GridLogic` nên tách phần địa hình tĩnh của màn chơi khỏi trạng thái mục tiêu, thay vì tiếp tục dùng một enum nhỏ trong đó `TARGET` vừa là trạng thái logic vừa là lớp hiển thị.

**Rationale**: Feature mới bổ sung ít nhất ba loại không gian tĩnh có ý nghĩa gameplay khác nhau: vùng chơi, đường viền giải đố và chướng ngại vật cố định. Nếu tiếp tục nhồi tất cả vào enum hiện tại `EMPTY/WALL/TARGET`, logic va chạm của Player, Block và reverse generation sẽ trở nên rối, đặc biệt khi một ô vừa là mục tiêu vừa nằm trong vùng chơi hợp lệ. Tách “ô nền” khỏi “danh sách target” cũng giữ được mô hình thắng hiện tại của `GridLogic.check_win()`.

**Alternatives considered**:
- Giữ enum hiện tại và thêm nhiều giá trị mới vào cùng một trục trạng thái → bị loại vì trộn lẫn semantics của địa hình và objective.
- Bỏ `targets` array, chỉ dùng cell type cho mọi thứ → bị loại vì làm hỏng logic thắng hiện có và khó render overlay.

## Quyết định 2: Đưa luật va chạm chọn lọc về `GridLogic`

**Decision**: `GridLogic` phải là nơi cung cấp hai họ hàm kiểm tra rõ ràng: một cho Nhân vật và một cho Khối đá, thay vì để `Player.gd` và `Block.gd` tự cài đặt điều kiện va chạm riêng lẻ.

**Rationale**: Hiện tại `Player.gd` và `Block.gd` cùng tự kiểm tra `is_within_bounds()`, `get_cell() != WALL`, và `is_occupied()`. Cơ chế selective barrier làm hai tác nhân có luật khác nhau trên cùng một ô, nên cách an toàn nhất là gom luật vào một nguồn sự thật duy nhất để tránh lệch nhau giữa push, slide, pull và kiểm thử.

**Alternatives considered**:
- Giữ logic va chạm tách trong `Player.gd` và `Block.gd` → bị loại vì dễ lệch quy tắc giữa nhân vật, block thường và block băng.
- Mã hóa quyền đi qua bằng cờ trong `BlockData` → bị loại vì đường viền là thuộc tính của ô, không phải của riêng block resource.

## Quyết định 3: Sinh mask vùng giải đố trước, rồi mới đặt target và chạy reverse generation

**Decision**: Pipeline sinh màn nên đổi thành: xác định khung hiển thị 12x10 → dựng vùng giải đố nằm giữa với trần 10x8 → sinh mask hữu cơ liên thông → thêm chướng ngại vật cố định → kiểm tra đủ không gian thao tác → đặt target/khối → chạy reverse generation bên trong mask hợp lệ.

**Rationale**: `LevelGenerator.gd` hiện đặt target trước rồi mới chạy pull moves trên toàn bộ lưới 10x10. Cách đó không còn phù hợp vì feature mới yêu cầu mọi target, block và thao tác kéo lùi đều phải nằm trong vùng được đường viền bao quanh. Việc chốt mask trước giúp tất cả bước sau cùng nói về một không gian hợp lệ duy nhất.

**Alternatives considered**:
- Tiếp tục đặt target trước rồi cố “cắt” biên quanh chúng sau → bị loại vì có thể sinh ra target nằm ngoài boundary hoặc không còn khoảng thao tác.
- Sinh trên toàn bộ 12x10 rồi lọc bỏ các ô ngoài cùng ở cuối pipeline → bị loại vì làm reverse generation dùng sai topology ngay từ đầu.

## Quyết định 4: Dùng TileMap để vẽ toàn bộ hình học tĩnh, không biến vật cản cố định thành node riêng

**Decision**: Nền chơi, đường viền giải đố và chướng ngại vật cố định nên đều được vẽ từ TileMap/terrain, trong khi Player và Block vẫn là node di động như hiện tại.

**Rationale**: `Main.gd` hiện đã dùng `target_layer.set_cells_terrain_connect()` để vẽ nền 10x10. Mở rộng theo cùng hướng này giúp giữ scene gọn, tận dụng auto-tiling cho các cụm chướng ngại vật, và đồng bộ tốt với yêu cầu polish. Hình `art\Basic Grass Biom things 1.png` có thể hỗ trợ việc chọn hoặc dựng thêm biến thể tile cho biên/vật cản nếu tileset hiện tại chưa đủ rõ ràng.

**Alternatives considered**:
- Spawn thêm node tường/chướng ngại vật cho từng ô → bị loại vì tăng quản lý scene tree mà không mang thêm giá trị gameplay.
- Vẽ sprite thủ công cho từng ô mà không dùng terrain connect → bị loại vì khó giữ tính liền mạch đồ họa giữa các cụm ô kề nhau.

## Quyết định 5: Dùng chiến lược validate-and-retry có chặn số lần thử

**Decision**: Level Generator nên chấp nhận việc một số layout ngẫu nhiên bị loại và sinh lại trong một ngân sách số lần thử hữu hạn, thay vì cố vá một layout xấu bằng nhiều luật đặc biệt.

**Rationale**: Lưới tuyệt đối rất nhỏ, nên retry rẻ hơn nhiều so với việc viết heuristic sửa layout tại chỗ. Điều kiện loại bỏ cần bao gồm: vùng giải đố không liên thông, không đủ ô trống cho player/blocks/targets, không có khoảng thao tác để pull moves, hoặc boundary không bao trọn không gian câu đố sau cùng.

**Alternatives considered**:
- Chỉ sinh một lần và chấp nhận mọi kết quả → bị loại vì sẽ cho ra màn không giải được hoặc khó đọc.
- Sinh một lần rồi vá từng lỗi riêng lẻ → bị loại vì dễ đẻ thêm edge case và khó test.

## Quyết định 6: Mở rộng test unit theo ma trận hành vi mới

**Decision**: Bộ test nên được mở rộng theo bốn nhóm: player-vs-boundary, block-vs-boundary, sliding block dùng obstacle làm anchor, và level generation từ chối layout không hợp lệ.

**Rationale**: Các test hiện có trong `test_player_movement.gd`, `test_block_physics.gd`, `test_level_gen.gd` đều đang giả định hình chữ nhật 10x10 và một loại cản duy nhất là `WALL`. Nếu không cập nhật test song song với thiết kế, việc đổi semantics ô sẽ rất dễ làm hỏng cả push, slide lẫn reverse generation.

**Alternatives considered**:
- Chỉ kiểm tra thủ công trong scene chính → bị loại vì không đủ để bắt hồi quy logic va chạm.
- Chỉ thêm test cho `LevelGenerator` → bị loại vì selective barrier tác động trực tiếp lên Player và Block, không chỉ generator.

## Tác động tới các file hiện có

- `scripts/logic/GridLogic.gd`: trở thành nơi giữ semantics ô và luật kiểm tra riêng cho player/block.
- `scripts/logic/LevelGenerator.gd`: thay đổi lớn nhất về pipeline sinh màn và dữ liệu trả về.
- `scenes/game_objects/Player.gd`: đổi sang gọi luật vào ô dành cho nhân vật.
- `scenes/game_objects/Block.gd`: đổi push/slide sang luật vào ô dành cho block.
- `scenes/main/Main.gd`: re-init lưới 12x10, vẽ boundary/obstacle/target, và spawn actor theo state mới.
- `tests/unit/test_player_movement.gd`, `tests/unit/test_block_physics.gd`, `tests/unit/test_level_gen.gd`: mở rộng theo semantics mới.
