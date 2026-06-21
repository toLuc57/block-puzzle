# Kế hoạch Triển khai: Bố cục Sprout Lands

**Nhánh**: `004-sprout-lands-layout` | **Ngày**: 2026-06-21 | **Đặc tả**: [specs/004-sprout-lands-layout/spec.md](spec.md)

**Đầu vào**: Đặc tả tính năng từ `/specs/004-sprout-lands-layout/spec.md`

## Tóm tắt

Tính năng này cập nhật bố cục giao diện chơi sang phong cách Sprout Lands bằng cách dùng `sprout_lands_tile_map.tscn` làm nguồn tham chiếu trực quan, phủ `Water` trên toàn khung game, dựng `Grass` ngẫu nhiên trong lưới chơi 14x12, dùng `Path` làm ranh giới chặn đá theo các đoạn ngang/dọc, và dùng `Crops` làm chướng ngại vật. Cách tiếp cận kỹ thuật là giữ static geometry ở TileMapLayer, tiếp tục để actor di chuyển là node riêng do `Main.gd` spawn, và mở rộng pipeline sinh màn/lưới hiện có để trả về đầy đủ dữ liệu nền, ranh giới, vật cản và vị trí spawn phù hợp với bố cục mới.

## Ngữ cảnh Kỹ thuật

**Ngôn ngữ/Phiên bản**: Godot 4.6 (GDScript)

**Các Phụ thuộc Chính**: Godot Engine 4.6, TileMapLayer/TileSet terrain system, scene tham chiếu `scenes/tile_maps/sprout_lands_tile_map.tscn`

**Lưu trữ**: Scene state trong `Dictionary`, block definitions bằng `Resource (.tres)`, dữ liệu ô tĩnh và occupancy trong `GridLogic`, geometry hiển thị qua `TileMapLayer`

**Kiểm thử**: Kiểm thử thủ công scene chính `scenes/main/Main.tscn`; unit tests hiện có trong `tests/unit/test_level_gen.gd`, `tests/unit/test_player_movement.gd`, `tests/unit/test_block_physics.gd`

**Nền tảng Mục tiêu**: Desktop (Windows/macOS/Linux) là ưu tiên

**Loại Dự án**: Trò chơi giải đố Godot một màn hình

**Mục tiêu Hiệu suất**: Giữ 60 FPS ổn định khi render nền/ranh giới/vật cản trên lưới nhỏ và khi reset/sinh màn liên tiếp

**Ràng buộc**:
- Khu vực chơi của player dùng lưới 14x12 ô
- `Water` phủ toàn khung game
- `Grass` là lớp nền 14x12 với phân bố ô biến đổi để giảm đơn điệu
- Ranh giới `Path` chỉ được tạo bởi các đoạn ngang/dọc; không có đường chéo hoặc góc xiên
- `Crops` là chướng ngại vật dễ phân biệt với ranh giới
- Static geometry phải tiếp tục đi qua TileMapLayer; actor di chuyển vẫn là node riêng do `Main.gd` khởi tạo

**Quy mô/Phạm vi**: Một scene chơi chính, một scene tilemap tham chiếu, pipeline sinh màn/lưới hiện có, và bộ test logic hiện tại cần được cập nhật tương ứng

## Kiểm tra Hiến chương

*CỔNG: Phải vượt qua trước nghiên cứu Giai đoạn 0. Kiểm tra lại sau thiết kế Giai đoạn 1.*

- **I. Tài liệu & Thuật ngữ bằng tiếng Việt**: ✅ Đạt. Tài liệu planning viết bằng tiếng Việt và giữ nguyên các thuật ngữ trực quan/technical như Water, Grass, Path, Crops, TileMapLayer.
- **II. Godot 4.6, GDScript, Desktop-First**: ✅ Đạt. Kế hoạch bám đúng Godot 4.6, GDScript và ưu tiên desktop.
- **III. Mã nguồn Tối giản, Rõ ràng, Có Mục đích**: ✅ Đạt. Kế hoạch chỉ mở rộng các file đang chịu trách nhiệm về layout, generator, render và validation; không thêm abstraction mới ngoài nhu cầu feature.
- **IV. Đặt tên & Chú thích Không Gây Hiểu Nhầm**: ✅ Đạt. Các artifact giữ tên theo layer thực tế của tilemap tham chiếu và semantics gameplay tương ứng.
- **V. Kiến trúc Godot Rõ ràng và Hiệu năng Ổn định**: ✅ Đạt. Static geometry tiếp tục được dựng qua TileMapLayer; actor di chuyển vẫn tách node riêng do `Main.gd` spawn.
- **VI. Kiểm thử & Xác thực Hành vi**: ✅ Đạt. Kế hoạch yêu cầu kịch bản xác thực thủ công và mở rộng coverage cho generator/movement theo semantics mới.

## Cấu trúc Dự án

### Tài liệu (tính năng này)

```text
specs/004-sprout-lands-layout/
├── spec.md
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   └── interfaces.md
└── checklists/
    └── requirements.md
```

### Mã nguồn (gốc kho lưu trữ)

```text
scenes/
├── main/
│   ├── Main.tscn
│   └── Main.gd
├── game_objects/
│   ├── Player.tscn
│   ├── Player.gd
│   ├── Block.tscn
│   └── Block.gd
└── tile_maps/
    └── sprout_lands_tile_map.tscn

scripts/
└── logic/
    ├── GridLogic.gd
    ├── LevelGenerator.gd
    └── GameState.gd

resources/
└── blocks/
    ├── gray_block.tres
    └── ice_block.tres

tests/
└── unit/
    ├── test_level_gen.gd
    ├── test_player_movement.gd
    └── test_block_physics.gd
```

**Quyết định Cấu trúc**: Giữ `GridLogic` làm nguồn sự thật cho semantics ô và occupancy, để `LevelGenerator` sinh payload màn có đủ thông tin về Water/Grass/Path/Crops cùng spawn data, và để `Main.gd` chỉ dàn dựng reset lưới, render TileMapLayer, spawn actor và ghi state ban đầu.

## Kế hoạch Thực hiện Theo Giai đoạn

### Giai đoạn 0 — Chốt semantics layout và pipeline render/generator
- Chốt mapping từ các layer tham chiếu `Water`, `Grass`, `Path`, `Crops` sang semantics gameplay và render.
- Chốt cách Water phủ toàn khung, Grass phủ 14x12 với biến thể ngẫu nhiên, và Path chỉ đi theo cạnh ngang/dọc.
- Chốt phần nào nằm ở TileMapLayer và phần nào vẫn là node động.

**Kết quả**: `research.md`

### Giai đoạn 1 — Thiết kế dữ liệu và hợp đồng nội bộ
- Mô hình hóa payload layout/generator mới, gồm grid hiển thị, lớp nền, ranh giới, obstacle, target, block và player spawn.
- Ghi lại hợp đồng giữa `LevelGenerator`, `GridLogic`, `Main`, `Player`, `Block` cho các semantics mới.
- Tạo quickstart xác thực trực quan và hành vi.
- Cập nhật `CLAUDE.md` để trỏ sang plan của feature 004.

**Kết quả**: `data-model.md`, `contracts/interfaces.md`, `quickstart.md`, cập nhật `CLAUDE.md`

### Giai đoạn 2 — Chuẩn bị phân rã thành tasks
- Tách việc thực thi thành các cụm: mở rộng grid/layout state, cập nhật generator, cập nhật render TileMapLayer, cập nhật movement/collision semantics, và mở rộng test coverage.
- Đảm bảo mỗi cụm đều có tiêu chí xác minh cụ thể trước khi sang `/speckit-tasks`.

**Kết quả**: sẵn sàng cho `/speckit-tasks`
