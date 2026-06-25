# Nhiệm vụ: Bố cục Sprout Lands

**Đầu vào**: Các tài liệu thiết kế từ `/specs/004-sprout-lands-layout/`

**Điều kiện tiên quyết**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, `contracts/interfaces.md`, `quickstart.md`

**Kiểm thử**: Kiểm thử là bắt buộc cho thay đổi cốt lõi liên quan đến luật chơi, dữ liệu layout, và luồng render/spawn của màn chơi.

**Tổ chức**: Các nhiệm vụ được nhóm theo câu chuyện người dùng để cho phép triển khai và kiểm thử độc lập cho mỗi câu chuyện.

## Định dạng: `[ID] [P?] [Story] Mô tả`

- **[P]**: Có thể chạy song song (các tệp khác nhau, không có phụ thuộc trực tiếp đang chờ hoàn tất)
- **[Story]**: Nhiệm vụ này thuộc về câu chuyện người dùng nào (`[US1]`, `[US2]`, `[US3]`)
- Mỗi nhiệm vụ đều nêu đường dẫn tệp chính xác trong mô tả

## Giai đoạn 1: Thiết lập

**Mục đích**: Xác nhận các điểm nối triển khai và phạm vi test cho feature 004 trước khi sửa code.

- [X] T001 Rà soát và cập nhật điểm neo feature 004 trong `specs/004-sprout-lands-layout/plan.md`
- [X] T002 Rà soát baseline render/spawn hiện tại trong `scenes/main/Main.gd`
- [X] T003 Rà soát baseline sinh màn và semantics lưới trong `scripts/logic/LevelGenerator.gd` và `scripts/logic/GridLogic.gd`

---

## Giai đoạn 2: Nền tảng

**Mục đích**: Thiết lập payload layout mới và semantics chung mà mọi user story đều dùng.

**⚠️ QUAN TRỌNG**: Không bắt đầu user story nào trước khi hoàn thành giai đoạn này.

- [X] T004 Cập nhật cấu trúc `GeneratedLevelState` trong `scripts/logic/LevelGenerator.gd` để trả về `grid_size`, `water_cells`, `grass_cells`, `grass_variant_map`, `path_boundary_cells`, `crops_cells`, `targets`, `blocks`, `player_pos`, và `target_moves`
- [X] T005 Cập nhật semantics geometry tĩnh trong `scripts/logic/GridLogic.gd` để phân biệt `PathBoundary` và `CropsObstacle`
- [X] T006 [P] Mở rộng fixture/assertion payload trong `tests/unit/test_level_gen.gd` cho contract layout mới
- [X] T007 [P] Cập nhật tài liệu xác thực triển khai trong `specs/004-sprout-lands-layout/quickstart.md` nếu hành vi lúc implement buộc phải tinh chỉnh bước kiểm tra

**Điểm kiểm tra**: Generator và grid semantics đã có contract đủ để render geometry tĩnh và spawn actor theo layout mới.

---

## Giai đoạn 3: Câu chuyện Người dùng 1 - Xem giao diện Sprout Lands (Ưu tiên: P1) 🎯 MVP

**Mục tiêu**: Người chơi mở màn và thấy khung `Water`, vùng `Grass` 14x12, cùng bố cục trực quan Sprout Lands rõ ràng ngay khi tải scene.

**Kiểm thử Độc lập**: Chạy `Main.tscn`, quan sát màn mới sinh, và xác nhận `Water` phủ toàn khung còn `Grass` tạo thành vùng chơi 14x12 với biến thể trực quan nhưng không đổi semantics gameplay.

### Kiểm thử cho Câu chuyện Người dùng 1

- [X] T008 [P] [US1] Cập nhật kiểm thử payload nền và kích thước vùng chơi trong `tests/unit/test_level_gen.gd`
- [X] T009 [P] [US1] Cập nhật kiểm thử reset/spawn theo `grid_size` mới trong `tests/unit/test_player_movement.gd`

### Triển khai cho Câu chuyện Người dùng 1

- [X] T010 [US1] Cập nhật khởi tạo lưới và pipeline dựng màn trong `scenes/main/Main.gd` để dùng `grid_size` 14x12 từ payload và bốn layer cố định `Water` → `Grass` → `Path` → `Crops` trong `scenes/main/Main.tscn`
- [X] T011 [US1] Triển khai render `Water` và `Grass` theo payload trong `scenes/main/Main.gd`, đảm bảo Water trong vùng 14x12 vẫn được gán là ô chặn trong logic lưới
- [X] T012 [US1] Thêm chọn biến thể trực quan cho `Grass` mà không đổi collision trong `scripts/logic/LevelGenerator.gd`
- [X] T013 [US1] Đồng bộ TileMapLayer và scene tham chiếu trong `scenes/main/Main.tscn` và `scenes/tile_maps/sprout_lands_tile_map.tscn` để giữ đúng thứ tự 4 layer `Water` → `Grass` → `Path` → `Crops` và tile source phục vụ `Water`/`Grass`

**Điểm kiểm tra**: Người chơi có thể mở game và thấy bố cục Sprout Lands nền mới đúng khung tổng thể và vùng chơi 14x12.

---

## Giai đoạn 4: Câu chuyện Người dùng 2 - Nhận biết ranh giới hợp lệ (Ưu tiên: P1)

**Mục tiêu**: Người chơi phân biệt rõ `Path` là ranh giới chặn đá theo đoạn ngang/dọc và `Crops` là obstacle tĩnh riêng biệt.

**Kiểm thử Độc lập**: Sinh nhiều màn và xác nhận không có boundary chéo, `Path` đọc được là ranh giới, `Crops` đọc được là obstacle tĩnh khác với boundary.

### Kiểm thử cho Câu chuyện Người dùng 2

- [X] T014 [P] [US2] Cập nhật kiểm thử boundary trực giao trong `tests/unit/test_level_gen.gd`
- [X] T015 [P] [US2] Cập nhật kiểm thử va chạm player với `PathBoundary` và `CropsObstacle` trong `tests/unit/test_player_movement.gd`
- [X] T016 [P] [US2] Cập nhật kiểm thử block bị chặn bởi `PathBoundary` và `CropsObstacle` trong `tests/unit/test_block_physics.gd`

### Triển khai cho Câu chuyện Người dùng 2

- [X] T017 [US2] Cập nhật generator boundary trực giao và placement của `Crops` trong `scripts/logic/LevelGenerator.gd`
- [X] T018 [US2] Cập nhật dựng `Path` và `Crops` theo layer riêng trong `scenes/main/Main.gd` và `scenes/main/Main.tscn`
- [X] T019 [US2] Hoàn thiện semantics ô chặn cho player và block trong `scripts/logic/GridLogic.gd`, bao gồm Water nằm trong vùng 14x12
- [X] T020 [US2] Điều chỉnh logic di chuyển người chơi theo semantics geometry mới trong `scenes/game_objects/Player.gd`
- [X] T021 [US2] Điều chỉnh logic tương tác/di chuyển block theo semantics geometry mới trong `scenes/game_objects/Block.gd`

**Điểm kiểm tra**: Màn chơi hiển thị và vận hành với boundary chỉ theo ngang/dọc, không gây nhầm lẫn với crops.

---

## Giai đoạn 5: Câu chuyện Người dùng 3 - Kiểm tra layout 14x12 và checkpoint/reset (Ưu tiên: P2)

**Mục tiêu**: Layout cố định 14x12 phải sinh hợp lệ, spawn không chồng lấn, và reset/checkpoint phải quay về trạng thái đầu chính xác.

**Kiểm thử Độc lập**: Sinh nhiều màn ở layout 14x12, xác nhận actor/target luôn nằm trong vùng hợp lệ, và reset đưa game về checkpoint ban đầu.

### Kiểm thử cho Câu chuyện Người dùng 3

- [X] T022 [P] [US3] Cập nhật kiểm thử layout hợp lệ trong giới hạn 14x12 trong `tests/unit/test_level_gen.gd`
- [X] T023 [P] [US3] Cập nhật kiểm thử spawn hợp lệ cho player, block, và target trong `tests/unit/test_level_gen.gd`

### Triển khai cho Câu chuyện Người dùng 3

- [X] T026 [US3] Cập nhật checkpoint/reset state cho payload layout mới trong `scripts/logic/GameState.gd` và `scenes/main/Main.gd`

**Điểm kiểm tra**: Layout 14x12 sinh ra hợp lệ, spawn không chồng lấn, và reset/checkpoint hoạt động nhất quán.

---

## Giai đoạn 6: Trau chuốt & Các vấn đề xuyên suốt

**Mục đích**: Hoàn tất các kiểm tra cuối, đảm bảo tính đúng, dễ đọc, và không hồi quy.

- [ ] T027 [P] Đối chiếu lại contract triển khai với `specs/004-sprout-lands-layout/contracts/interfaces.md`
- [X] T028 Chạy bộ kiểm thử logic trong `tests/unit/test_level_gen.gd`, `tests/unit/test_player_movement.gd`, và `tests/unit/test_block_physics.gd`
- [ ] T029 Chạy xác thực thủ công theo `specs/004-sprout-lands-layout/quickstart.md`

---

## Phụ thuộc & Thứ tự Thực hiện

### Phụ thuộc Giai đoạn

- **Giai đoạn 1: Thiết lập**: Không có phụ thuộc, bắt đầu ngay.
- **Giai đoạn 2: Nền tảng**: Phụ thuộc Giai đoạn 1; chặn tất cả user story.
- **US1 (Giai đoạn 3)**: Phụ thuộc Giai đoạn 2; là MVP.
- **US2 (Giai đoạn 4)**: Phụ thuộc Giai đoạn 2; nên thực hiện sau hoặc song song cuối US1 khi phần render nền đã ổn định.
- **US3 (Giai đoạn 5)**: Phụ thuộc Giai đoạn 2 và hưởng lợi từ việc US1/US2 đã chốt payload + semantics.
- **Giai đoạn 6: Trau chuốt**: Phụ thuộc các story được chọn cho phạm vi bàn giao.

### Phụ thuộc giữa các Câu chuyện Người dùng

- **US1**: Độc lập về giá trị hiển thị và là phạm vi MVP khuyến nghị.
- **US2**: Phụ thuộc contract layout nền tảng, nhưng có thể kiểm thử độc lập sau khi semantics geometry hoàn tất.
- **US3**: Phụ thuộc generator/payload đã mở rộng; không cần chờ polish của US1/US2.

---

## Cơ hội Chạy Song song

- `T006` và `T007` có thể làm song song sau `T004`-`T005`.
- `T008` và `T009` có thể làm song song trong US1.
- `T014`, `T015`, và `T016` có thể làm song song trong US2.
- `T020` và `T021` có thể tách người phụ trách khác nhau sau khi `T019` đã chốt semantics.
- `T022` và `T023` có thể làm song song trong US3.
- `T027` có thể thực hiện song song với chuẩn bị chạy test cuối nếu implementation đã ổn định.

---

## Chiến lược Triển khai

### MVP Trước

1. Hoàn thành Giai đoạn 1 và Giai đoạn 2.
2. Hoàn thành toàn bộ US1.
3. Chạy kiểm thử và xác thực độc lập cho US1.
4. Dừng tại đây nếu chỉ cần bàn giao MVP về giao diện Sprout Lands.

### Bàn giao Tăng dần

1. Nền tảng payload/layout hoàn tất.
2. Bàn giao US1 để chốt nền tổng thể và vùng chơi 14x12.
3. Bàn giao US2 để chốt ranh giới path và crops obstacle.
4. Bàn giao US3 để mở rộng shape linh hoạt mà không phá flow reset/spawn.
5. Hoàn tất polish bằng test tự động và quickstart thủ công.
