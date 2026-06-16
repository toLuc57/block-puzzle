---

description: "Danh sách nhiệm vụ triển khai Hệ thống lưới di chuyển & Sinh màn chơi ngược"
---

# Nhiệm vụ: Hệ thống lưới di chuyển & Sinh màn chơi ngược

**Đầu vào**: Các tài liệu thiết kế từ `specs/001-grid-movement-reverse-gen/`

**Điều kiện tiên quyết**: plan.md, spec.md, research.md, data-model.md, contracts/interfaces.md

**Kiểm thử**: TDD được khuyến nghị cho logic Grid và thuật toán Sinh màn (sử dụng GUT).

## Định dạng: `[ID] [P?] [Story] Mô tả`

## Quy ước Đường dẫn
- **Cảnh (Scenes)**: `scenes/`
- **Kịch bản (Scripts)**: `scripts/`
- **Tài nguyên (Resources)**: `resources/`
- **Kiểm thử (Tests)**: `tests/`

## Giai đoạn 1: Thiết lập (Cơ sở hạ tầng dùng chung)

**Mục đích**: Khởi tạo cấu trúc dự án và công cụ kiểm thử.

- [x] T001 Tạo cấu trúc thư mục dự án (scenes, scripts/logic, resources/blocks, tests/unit)
- [x] T002 Thiết lập Godot project settings (màn hình, input map: up, down, left, right)
- [x] T003 [P] Cấu hình GUT (Godot Unit Testing) và tạo file test mẫu trong tests/unit/test_smoke.gd

---

## Giai đoạn 2: Nền tảng (Điều kiện tiên quyết ngăn chặn)

**Mục đích**: Xây dựng các thành phần cốt lõi mà mọi câu chuyện người dùng đều phụ thuộc vào.

- [x] T004 [P] Định nghĩa Resource `BlockData.gd` trong `scripts/logic/BlockData.gd` (id, color, is_sliding)
- [x] T005 [P] Thiết lập Autoload `GameEvents.gd` trong `scripts/autoload/GameEvents.gd` cho các tín hiệu toàn cục
- [x] T006 Tạo lớp `GridLogic.gd` trong `scripts/logic/GridLogic.gd` quản lý mảng 2 chiều 10x10
- [x] T007 [P] Tạo cảnh `Main.tscn` và Node `GridContainer` để hiển thị bản đồ
- [x] T008 [P] Thiết lập UI cơ bản (ScoreLabel, WinLabel) trong `scenes/ui/HUD.tscn`

**Điểm kiểm tra**: Nền tảng sẵn sàng, logic mảng đã có thể bắt đầu kiểm thử.

---

## Giai đoạn 3: Câu chuyện Người dùng 1 - Di chuyển theo lưới (Ưu tiên: P1) 🎯 MVP

**Mục tiêu**: Cho phép nhân vật di chuyển rời rạc và mượt mà trên lưới.

**Kiểm thử Độc lập**: Chạy cảnh Main, nhân vật phải di chuyển đúng 1 ô khi nhấn phím và không xuyên tường.

### Kiểm thử cho Câu chuyện Người dùng 1
- [x] T009 [P] [US1] Viết unit test cho logic di chuyển nhân vật trong `tests/unit/test_player_movement.gd`
- [x] T010 [US1] Đảm bảo test thất bại (Red) trước khi triển khai logic

### Triển khai cho Câu chuyện Người dùng 1
- [x] T011 [P] [US1] Tạo cảnh `Player.tscn` và script `Player.gd` trong `scenes/game_objects/`
- [x] T012 [US1] Triển khai hàm `move()` sử dụng `create_tween()` để di chuyển mượt mà (<300ms)
- [x] T013 [US1] Tích hợp kiểm tra va chạm với `GridLogic.gd` trước khi bắt đầu Tween
- [x] T014 [US1] Khóa input khi nhân vật đang trong trạng thái di chuyển (Tween active)

**Điểm kiểm tra**: Nhân vật có thể di chuyển trên lưới 10x10.

---

## Giai đoạn 4: Câu chuyện Người dùng 2 - Đẩy các khối (Ưu tiên: P1)

**Mục tiêu**: Triển khai hành vi vật lý cho Khối Xám và Khối Băng.

**Kiểm thử Độc lập**: Đẩy Khối Xám di chuyển 1 ô; đẩy Khối Băng trượt đến khi va chạm.

### Kiểm thử cho Câu chuyện Người dùng 2
- [x] T015 [P] [US2] Viết unit test cho logic `push_block()` trong `tests/unit/test_block_physics.gd`
- [x] T016 [US2] Kiểm tra hành vi trượt của IceBlock qua unit test

### Triển khai cho Câu chuyện Người dùng 2
- [x] T017 [P] [US2] Tạo lớp cơ bản `Block.tscn` và `Block.gd` trong `scenes/game_objects/`
- [x] T018 [P] [US2] Tạo Resource cho Khối Xám (`gray_block.tres`) và Khối Băng (`ice_block.tres`)
- [x] T019 [US2] Triển khai logic `push()` cho Khối Xám (di chuyển 1 ô) trong `Block.gd`
- [x] T020 [US2] Triển khai logic `push()` cho Khối Băng (vòng lặp trượt đến vật cản)
- [x] T021 [US2] Cập nhật `GridLogic.gd` để quản lý vị trí các khối sau khi di chuyển

**Điểm kiểm tra**: Cả hai loại khối đều có thể bị đẩy và tuân thủ quy tắc vật lý.

---

## Giai đoạn 5: Câu chuyện Người dùng 3 - Sinh màn chơi ngược (Ưu tiên: P2)

**Mục tiêu**: Thuật toán sinh màn đảm bảo 100% khả năng giải được.

**Kiểm thử Độc lập**: Sinh màn chơi 100 lần, kiểm tra xem có lỗi logic nào không.

### Kiểm thử cho Câu chuyện Người dùng 3
- [x] T022 [P] [US3] Viết unit test cho thuật toán `Pull Moves` trong `tests/unit/test_level_gen.gd`
- [x] T023 [US3] Xác thực 100% màn hình sinh ra phải có lời giải từ trạng thái thắng

### Triển khai cho Câu chuyện Người dùng 3
- [x] T024 [P] [US3] Tạo script `LevelGenerator.gd` trong `scripts/logic/`
- [x] T025 [US3] Triển khai logic đặt Target ngẫu nhiên và thực hiện `N` bước kéo (pull) lùi lại
- [x] T026 [US3] Triển khai hàm khởi tạo map từ Dictionary trạng thái được sinh ra
- [x] T027 [US3] Kết nối tín hiệu `level_generated` để thông báo cho `Main.tscn`

**Điểm kiểm tra**: Hệ thống có thể tự động tạo màn chơi mới và bắt đầu trò chơi.

---

## Giai đoạn N: Trau chuốt & Các vấn đề xuyên suốt

**Mục đích**: Hoàn thiện win condition và giao diện.

- [x] T028 [US3] Triển khai logic phát hiện điều kiện thắng (tất cả target đều có block) trong `GridLogic.gd`
- [x] T029 Thêm hiệu ứng âm thanh/hình ảnh khi khối khớp vào ô 'X'
- [x] T030 Cập nhật tài liệu hướng dẫn vận hành trong `quickstart.md`
- [x] T031 Dọn dẹp mã nguồn và kiểm tra hiệu suất sinh màn (<500ms)

---

## Phụ thuộc & Thứ tự Thực hiện

### Phụ thuộc Giai đoạn
1. **Thiết lập (G1)** -> **Nền tảng (G2)**: Bắt buộc.
2. **Nền tảng (G2)** -> **Di chuyển Lưới (G3)**: Bắt buộc để có GridLogic.
3. **Di chuyển Lưới (G3)** -> **Đẩy khối (G4)**: Cần Player để đẩy.
4. **Đẩy khối (G4)** -> **Sinh màn (G5)**: Cần logic đẩy hoàn thiện để đảo ngược thành kéo.
5. **Sinh màn (G5)** -> **Trau chuốt (GN)**.

### Cơ hội chạy Song song
- Các nhiệm vụ đánh dấu **[P]** trong cùng một giai đoạn có thể làm cùng lúc.
- Thiết kế Resource (T004) và Tín hiệu (T005) có thể làm song song.
- UI (T008) có thể phát triển độc lập với logic di chuyển.

---

## Chiến lược Triển khai

### MVP Trước (Câu chuyện Người dùng 1 & 2)
1. Hoàn thành G1, G2, G3.
2. Hoàn thành G4 để có gameplay cơ bản với map tĩnh.
3. **Xác thực**: Kiểm tra cơ chế đẩy/trượt thủ công.

### Bàn giao Tăng dần
- Thêm G5 để có khả năng chơi vô tận.
- Hoàn thiện GN để có trải nghiệm người dùng tốt hơn.
