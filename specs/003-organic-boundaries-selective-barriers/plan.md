# Kế hoạch Triển khai: Ranh giới Hữu cơ và Rào cản Có chọn lọc

**Nhánh**: `organic-boundaries-selective-barriers` | **Ngày**: 2026-06-19 | **Đặc tả**: [specs/003-organic-boundaries-selective-barriers/spec.md](spec.md)

**Đầu vào**: Đặc tả tính năng từ `/specs/003-organic-boundaries-selective-barriers/spec.md`

## Tóm tắt

Tính năng này mở rộng pipeline sinh màn hiện tại từ một lưới chữ nhật 10x10 cố định sang một khung hiển thị 12x10 với vùng giải đố nằm giữa, tối đa 10x8, có ranh giới hữu cơ và các chướng ngại vật cố định bên trong. Kế hoạch triển khai tập trung vào ba thay đổi cốt lõi: (1) mô hình hóa lại không gian tĩnh của màn chơi để phân biệt rõ nền chơi, đường viền và vật cản; (2) tách luật va chạm của Nhân vật và Khối đá để thực hiện cơ chế “rào cản có chọn lọc”; và (3) cập nhật Level Generator để sinh, kiểm tra và vẽ các bố cục hữu cơ nhưng vẫn còn giải được. Hình tham chiếu `art\Basic Grass Biom things 1.png` chỉ được dùng khi cần mở rộng tileset hoặc tinh chỉnh cách đọc thị giác của địa hình tĩnh.

## Ngữ cảnh Kỹ thuật

**Ngôn ngữ/Phiên bản**: Godot 4.6 (GDScript)

**Các Phụ thuộc Chính**: Godot Engine 4.6, TileMap/Terrain system, GUT cho unit tests

**Lưu trữ**: Scene state trong `Dictionary`, block definitions bằng `Resource (.tres)`, dữ liệu ô tĩnh trong `GridLogic`, hiển thị địa hình qua `TileMap`

**Kiểm thử**: GUT unit tests cho `GridLogic`, `LevelGenerator`, `Player`, `Block`; kiểm thử thủ công scene chính `scenes/main/Main.tscn`

**Nền tảng Mục tiêu**: Desktop (Windows) theo cấu hình dự án hiện tại

**Loại Dự án**: Trò chơi giải đố Godot một màn hình

**Mục tiêu Hiệu suất**: Giữ 60 FPS ổn định khi chơi; sinh màn mới đủ nhanh để người chơi không cảm nhận chờ đợi đáng kể

**Ràng buộc**:
- Khung hiển thị phải là 12x10 ô
- Vùng giải đố hoạt động phải được đặt giữa và không vượt quá 10x8 ô
- Nhân vật được đi xuyên đường viền giải đố; Khối đá thì không
- Chướng ngại vật cố định chặn cả Nhân vật và Khối đá
- Cần tái sử dụng pipeline hiện tại quanh `Main.gd`, `GridLogic.gd`, `LevelGenerator.gd` thay vì thay toàn bộ scene flow

**Quy mô/Phạm vi**: Một scene chơi chính, 2 loại khối hiện có (xám và băng), một pipeline sinh màn, và bộ unit test logic tương ứng

## Kiểm tra Hiến chương

*CỔNG: Phải vượt qua trước nghiên cứu Giai đoạn 0. Kiểm tra lại sau thiết kế Giai đoạn 1.*

- **I. Hình ảnh Hiện đại & Phản hồi Nhanh**: ✅ Đạt. Tính năng bổ sung ranh giới hữu cơ, vật cản liền mạch và yêu cầu đọc thị giác rõ hơn, phù hợp mục tiêu polish.
- **II. Kiến trúc Dựa trên Tín hiệu**: ✅ Đạt. Không thay đổi hướng giao tiếp tổng thể; các thay đổi tập trung trong `GridLogic`, `LevelGenerator`, `Main`, `Player`, `Block`, và vẫn dùng `GameEvents`.
- **III. Quản lý Dữ liệu Dựa trên Tài nguyên**: ✅ Đạt. Các loại khối tiếp tục lấy từ `BlockData`; chỉ bổ sung dữ liệu màn sinh động chứ không thay mô hình block resource.
- **IV. Xác thực Thực nghiệm & Kiểm thử**: ✅ Đạt. Kế hoạch yêu cầu mở rộng unit tests cho va chạm chọn lọc, sinh màn hợp lệ và tương tác khối băng với chướng ngại vật.
- **V. Logic Lưới Ưu tiên Hiệu suất**: ✅ Đạt. Lưới tuyệt đối vẫn rất nhỏ (12x10), nên việc thêm phân loại ô và vòng lặp validate có chi phí thấp và nằm trong giới hạn thời gian thực.
- **VI. Ngôn ngữ Tài liệu**: ✅ Đạt. Toàn bộ tài liệu kế hoạch được viết bằng tiếng Việt.

## Cấu trúc Dự án

### Tài liệu (tính năng này)

```text
specs/003-organic-boundaries-selective-barriers/
├── spec.md              # Đặc tả đã cập nhật
├── plan.md              # Tệp này
├── research.md          # Quyết định kỹ thuật và phương án bị loại
├── data-model.md        # Mô hình dữ liệu màn chơi và luật va chạm
├── quickstart.md        # Kịch bản xác thực nhanh
├── contracts/
│   └── interfaces.md    # Hợp đồng nội bộ cho state sinh màn và luật di chuyển
└── checklists/
    └── requirements.md  # Checklist chất lượng đặc tả
```

### Mã nguồn (gốc kho lưu trữ)

```text
scenes/
├── main/
│   ├── Main.tscn
│   └── Main.gd
└── game_objects/
    ├── Player.gd
    └── Block.gd

scripts/
├── autoload/
│   └── GameEvents.gd
└── logic/
    ├── GridLogic.gd
    ├── LevelGenerator.gd
    ├── GameState.gd
    └── BlockData.gd

resources/
└── blocks/
    ├── gray_block.tres
    └── ice_block.tres

tests/
└── unit/
    ├── test_player_movement.gd
    ├── test_block_physics.gd
    └── test_level_gen.gd
```

**Quyết định Cấu trúc**: Giữ `GridLogic` làm nguồn sự thật cho ô tĩnh và occupancy, giữ `LevelGenerator` chịu trách nhiệm sinh state màn, để `Main.gd` chỉ đóng vai trò dàn dựng render/spawn. `Player.gd` và `Block.gd` sẽ dùng cùng một nguồn quy tắc từ `GridLogic`, nhưng gọi các hàm kiểm tra khác nhau theo loại tác nhân để tránh nhân đôi logic va chạm.

## Kế hoạch Thực hiện Theo Giai đoạn

### Giai đoạn 0 — Chuẩn hóa mô hình ô và quyết định pipeline
- Xác định các loại ô tĩnh cần có để tách đường viền giải đố khỏi chướng ngại vật cố định.
- Chốt thứ tự pipeline sinh màn: tạo mask vùng giải đố → thêm vật cản cố định → kiểm tra hợp lệ → đặt target/khối → reverse generation → render.
- Chốt cách dùng TileMap/Terrain cho nền, biên và cụm chướng ngại vật.

**Kết quả**: `research.md`

### Giai đoạn 1 — Thiết kế dữ liệu và hợp đồng nội bộ
- Mô hình hóa state sinh màn, cell semantics, movement policy, điều kiện hợp lệ.
- Ghi lại hợp đồng dữ liệu giữa `LevelGenerator`, `GridLogic`, `Main`, `Player`, `Block`.
- Tạo quickstart xác thực cho các hành vi cốt lõi và các edge case quan trọng.
- Cập nhật `CLAUDE.md` để trỏ sang kế hoạch hiện tại.

**Kết quả**: `data-model.md`, `contracts/interfaces.md`, `quickstart.md`, cập nhật `CLAUDE.md`

### Giai đoạn 2 — Chuẩn bị cho phân rã thành tasks
- Chia công việc thành các cụm: mô hình lưới, sinh mask hữu cơ, render TileMap, luật di chuyển, reverse generation, và test coverage.
- Đảm bảo mọi cụm việc có tiêu chí xác minh cụ thể trước khi sang `/speckit-tasks`.

**Kết quả**: sẵn sàng cho `/speckit-tasks`
