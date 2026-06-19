# Nhiệm vụ: Ranh giới Hữu cơ và Rào cản Có chọn lọc

**Đầu vào**: Các tài liệu thiết kế từ `/specs/003-organic-boundaries-selective-barriers/`

**Điều kiện tiên quyết**: plan.md (bắt buộc), spec.md (bắt buộc cho các câu chuyện người dùng), research.md, data-model.md, contracts/

**Kiểm thử**: Bao gồm nhiệm vụ kiểm thử vì kế hoạch và hiến chương của dự án yêu cầu xác thực logic lưới, sinh màn và hành vi gameplay bằng unit test và kiểm thử thủ công.

**Tổ chức**: Các nhiệm vụ được nhóm theo câu chuyện người dùng để cho phép triển khai và kiểm thử độc lập cho mỗi câu chuyện.

## Định dạng: `[ID] [P?] [Story] Mô tả`

- **[P]**: Có thể chạy song song (các tệp khác nhau, không có phụ thuộc)
- **[Story]**: Nhiệm vụ này thuộc về câu chuyện người dùng nào (ví dụ: US1, US2, US3)
- Bao gồm đường dẫn tệp chính xác trong mô tả

## Quy ước Đường dẫn

- **Cảnh (Scenes)**: `scenes/`
- **Kịch bản (Scripts)**: `scripts/`
- **Tài nguyên (Resources)**: `resources/`
- **Kiểm thử (Tests)**: `tests/`

## Giai đoạn 1: Thiết lập (Cơ sở xác thực chung)

**Mục đích**: Đồng bộ bộ kiểm thử và điểm xác thực thủ công với khung 12x10 và feature mới trước khi thay logic cốt lõi.

- [ ] T001 Cập nhật fixture `before_each` và giả định kích thước lưới trong tests/unit/test_player_movement.gd cho khung hiển thị 12x10 và vùng chơi tối đa 10x8
- [ ] T002 [P] Cập nhật fixture `before_each` và giả định kích thước lưới trong tests/unit/test_block_physics.gd và tests/unit/test_level_gen.gd cho khung hiển thị 12x10 và pipeline generator mới

---

## Giai đoạn 2: Nền tảng (Điều kiện tiên quyết ngăn chặn)

**Mục đích**: Xây dựng mô hình ô, payload level và API kiểm tra va chạm dùng chung cho toàn bộ feature.

**⚠️ QUAN TRỌNG**: Không có công việc câu chuyện người dùng nào có thể bắt đầu cho đến khi giai đoạn này hoàn thành

- [ ] T003 Mở rộng mô hình ô và metadata lưới trong scripts/logic/GridLogic.gd để phân biệt outer wall, floor, boundary và static obstacle
- [ ] T004 Tạo các hàm kiểm tra ô dành riêng cho Player và Block trong scripts/logic/GridLogic.gd theo hợp đồng tại specs/003-organic-boundaries-selective-barriers/contracts/interfaces.md
- [ ] T005 Cập nhật scripts/logic/LevelGenerator.gd để trả về payload `GeneratedLevelState` có `grid_size`, `playable_mask`, `obstacles`, `targets`, `blocks` và `player_pos`
- [ ] T006 Điều chỉnh scenes/main/Main.gd để reset `GridLogic` theo kích thước động từ payload level thay vì hard-code 10x10

**Điểm kiểm tra**: Nền tảng đã sẵn sàng - các story hiện có thể được triển khai theo thứ tự ưu tiên mà không phải viết lại semantics ô

---

## Giai đoạn 3: Câu chuyện Người dùng 1 - Màn chơi có ranh giới hữu cơ đa dạng (Ưu tiên: P1) 🎯 MVP

**Mục tiêu**: Sinh được các màn mới trong khung 12x10 với vùng giải đố hữu cơ nằm giữa, không còn mặc định là hình chữ nhật đầy đủ 10x8.

**Kiểm thử Độc lập**: Sinh liên tiếp nhiều màn mới và xác nhận vùng giải đố luôn nằm trong khung 12x10, được bao quanh bởi boundary và có bố cục khác nhau giữa các lần sinh.

### Kiểm thử cho Câu chuyện Người dùng 1 ⚠️

- [ ] T007 [P] [US1] Thêm kiểm thử cho mask liên thông, giới hạn 10x8 và payload không đặt actor ngoài vùng giải đố trong tests/unit/test_level_gen.gd

### Triển khai cho Câu chuyện Người dùng 1

- [ ] T008 [US1] Triển khai bước sinh `PlayableMask` hữu cơ liên thông bên trong scripts/logic/LevelGenerator.gd
- [ ] T009 [US1] Thêm bước rải `StaticObstacle` và validate-and-retry cho bố cục không hợp lệ trong scripts/logic/LevelGenerator.gd
- [ ] T010 [US1] Cập nhật logic chọn vị trí `targets`, `blocks` và `player_pos` để chỉ dùng ô hợp lệ trong scripts/logic/LevelGenerator.gd
- [ ] T011 [US1] Dựng nền chơi, boundary và obstacle từ payload generator trong scenes/main/Main.gd

**Điểm kiểm tra**: Tại thời điểm này, màn chơi có thể sinh với hình dạng hữu cơ hợp lệ và có thể kiểm thử độc lập bằng luồng reset/next level

---

## Giai đoạn 4: Câu chuyện Người dùng 2 - Nhân vật đi xuyên qua đường viền giải đố (Ưu tiên: P1)

**Mục tiêu**: Nhân vật dùng luật va chạm riêng, có thể băng qua boundary nhưng vẫn bị chặn bởi outer wall và static obstacle.

**Kiểm thử Độc lập**: Đặt Player ở hai phía của boundary, xác nhận Player băng qua được boundary nhưng không thể đi vào obstacle hoặc ra ngoài outer wall.

### Kiểm thử cho Câu chuyện Người dùng 2 ⚠️

- [ ] T012 [P] [US2] Thêm kiểm thử Player đi xuyên boundary nhưng bị chặn bởi obstacle và outer wall trong tests/unit/test_player_movement.gd

### Triển khai cho Câu chuyện Người dùng 2

- [ ] T013 [US2] Refactor scenes/game_objects/Player.gd để mọi bước di chuyển đều gọi API kiểm tra ô dành cho Player từ scripts/logic/GridLogic.gd
- [ ] T014 [US2] Đồng bộ trạng thái người chơi và checkpoint sau luật di chuyển mới trong scripts/logic/GameState.gd
- [ ] T015 [US2] Xác nhận luồng spawn Player và vị trí bắt đầu hợp lệ theo policy mới trong scenes/main/Main.gd

**Điểm kiểm tra**: Tại thời điểm này, Player có thể vượt boundary đúng như đặc tả mà không làm hỏng undo hoặc luồng bắt đầu màn

---

## Giai đoạn 5: Câu chuyện Người dùng 3 - Khối đá bị chặn bởi đường viền có chọn lọc (Ưu tiên: P1)

**Mục tiêu**: Tất cả khối đá, bao gồm khối thường và khối băng, đều coi boundary là vật cản nhưng vẫn giữ hành vi đẩy/trượt đúng với obstacle và khối khác.

**Kiểm thử Độc lập**: Đẩy block thường và block băng về phía boundary và obstacle; xác nhận cả hai bị chặn đúng chỗ, và block băng dừng đúng khi gặp obstacle hoặc boundary.

### Kiểm thử cho Câu chuyện Người dùng 3 ⚠️

- [ ] T016 [P] [US3] Thêm kiểm thử block thường bị chặn bởi boundary và block băng dừng tại boundary hoặc obstacle trong tests/unit/test_block_physics.gd

### Triển khai cho Câu chuyện Người dùng 3

- [ ] T017 [US3] Refactor scenes/game_objects/Block.gd để push và slide dùng API kiểm tra ô dành cho Block từ scripts/logic/GridLogic.gd
- [ ] T018 [US3] Cập nhật scripts/logic/LevelGenerator.gd để reverse generation coi static obstacle và boundary là vật cản bất động khi pull moves
- [ ] T019 [US3] Đồng bộ logic cập nhật thắng/thua và occupancy sau chuyển động block mới trong scenes/game_objects/Block.gd và scripts/logic/GridLogic.gd

**Điểm kiểm tra**: Tại thời điểm này, selective barrier đã hoạt động đầy đủ cho cả Player và mọi loại Block

---

## Giai đoạn 6: Câu chuyện Người dùng 4 - Màn sinh tự động vẫn tạo được câu đố hợp lệ (Ưu tiên: P2)

**Mục tiêu**: Generator chỉ chấp nhận các màn còn giải được, có đủ không gian thao tác và không bị chia cắt bởi mask hoặc obstacle.

**Kiểm thử Độc lập**: Sinh liên tiếp nhiều màn và xác nhận generator loại bỏ các layout bị chia vùng, thiếu ô thao tác hoặc đặt actor ra ngoài vùng hợp lệ.

### Kiểm thử cho Câu chuyện Người dùng 4 ⚠️

- [ ] T020 [P] [US4] Thêm kiểm thử reject layout bị tách vùng, thiếu ô thao tác hoặc payload sai phạm trong tests/unit/test_level_gen.gd

### Triển khai cho Câu chuyện Người dùng 4

- [ ] T021 [US4] Bổ sung bước validate-and-retry với ngân sách số lần thử hữu hạn trong scripts/logic/LevelGenerator.gd
- [ ] T022 [US4] Cập nhật scenes/main/Main.gd để chỉ dựng màn từ payload đã qua validate và phát hiện payload thiếu trường bắt buộc

**Điểm kiểm tra**: Tại thời điểm này, luồng sinh màn tự động ưu tiên các bố cục hợp lệ thay vì trả về màn bị kẹt hoặc sai topology

---

## Giai đoạn 7: Câu chuyện Người dùng 5 - Ranh giới và vật cản hiển thị rõ ràng (Ưu tiên: P2)

**Mục tiêu**: Boundary, vùng ngoài và obstacle cố định được phân biệt rõ bằng TileMap/terrain, đọc tốt bằng mắt thường và liền mạch về mặt hình ảnh.

**Kiểm thử Độc lập**: Quan sát 3–5 màn mới, xác nhận boundary bao quanh không gian câu đố, obstacle hiển thị thành cụm rõ ràng, và các lớp không gian không bị nhầm với block di động.

### Kiểm thử cho Câu chuyện Người dùng 5 ⚠️

- [ ] T023 [P] [US5] Thêm tiêu chí xác thực thủ công cho boundary, obstacle cluster và khả năng đọc màn trong specs/003-organic-boundaries-selective-barriers/quickstart.md

### Triển khai cho Câu chuyện Người dùng 5

- [ ] T024 [US5] Cập nhật scenes/main/Main.tscn và scenes/main/Main.gd để vẽ boundary/obstacle bằng TileMap terrain, dùng art/Basic Grass Biom things 1.png nếu cần để làm rõ lớp địa hình tĩnh

**Điểm kiểm tra**: Tại thời điểm này, người chơi có thể phân biệt nhanh vùng ngoài, boundary và obstacle chỉ bằng quan sát màn hình

---

## Giai đoạn 8: Trau chuốt & Các vấn đề xuyên suốt

**Mục đích**: Hoàn thiện tài liệu, kiểm thử tổng thể và các điều chỉnh ảnh hưởng nhiều story.

- [ ] T025 [P] Chạy rà soát và cập nhật mô tả contract cuối cùng trong specs/003-organic-boundaries-selective-barriers/contracts/interfaces.md để khớp implementation đã hoàn tất
- [ ] T026 Chạy kiểm thử hồi quy cho tests/unit/test_player_movement.gd, tests/unit/test_block_physics.gd và tests/unit/test_level_gen.gd rồi cập nhật lưu ý xác thực trong specs/003-organic-boundaries-selective-barriers/quickstart.md

---

## Phụ thuộc & Thứ tự Thực hiện

### Phụ thuộc Giai đoạn

- **Thiết lập (Giai đoạn 1)**: Không có phụ thuộc - có thể bắt đầu ngay lập tức
- **Nền tảng (Giai đoạn 2)**: Phụ thuộc vào việc hoàn thành Thiết lập - NGĂN CHẶN tất cả các câu chuyện người dùng
- **US1 (Giai đoạn 3)**: Phụ thuộc vào Giai đoạn 2
- **US2 (Giai đoạn 4)**: Phụ thuộc vào Giai đoạn 2 và nên triển khai sau US1 vì Player spawn/mask hợp lệ đến từ generator mới
- **US3 (Giai đoạn 5)**: Phụ thuộc vào Giai đoạn 2 và nên triển khai sau US2 để dùng chung policy kiểm tra ô đã ổn định
- **US4 (Giai đoạn 6)**: Phụ thuộc vào US1 và US3 vì validate tính giải được cần mask, obstacle và reverse generation mới
- **US5 (Giai đoạn 7)**: Phụ thuộc vào US1 vì render boundary/obstacle cần payload hình học đã ổn định
- **Trau chuốt (Giai đoạn 8)**: Phụ thuộc vào các story mong muốn đã hoàn tất

### Thứ tự hoàn thành câu chuyện người dùng

1. **US1** → có generator và topology hữu cơ cơ bản
2. **US2** → Player dùng selective barrier đúng
3. **US3** → Block thường và block băng dùng selective barrier đúng
4. **US4** → Generator chỉ nhận layout hợp lệ và còn giải được
5. **US5** → Hoàn thiện khả năng đọc màn và polish hình ảnh

---

## Cơ hội Thực hiện Song song

### US1
- Sau khi T008 hoàn tất, T009 và phần chuẩn bị render của T011 có thể tiến hành song song nếu giữ đúng hợp đồng payload

### US2
- T012 có thể được viết song song với T013 vì test chỉ mô tả policy, chưa phụ thuộc implementation cụ thể

### US3
- T016 có thể được viết song song với T017; sau khi API Block policy trong `GridLogic.gd` đã ổn định, T018 và T019 có thể chia người làm theo generator và movement runtime

### US4
- T020 có thể được chuẩn bị song song với T021 bằng cách mã hóa trước các case reject mong muốn

### US5
- T023 và phần asset/layout của T024 có thể tiến hành song song vì một bên là tài liệu xác thực, một bên là render scene

---

## Chiến lược Triển khai

### MVP Trước (Chỉ Câu chuyện Người dùng 1)

1. Hoàn thành Giai đoạn 1: Thiết lập
2. Hoàn thành Giai đoạn 2: Nền tảng
3. Hoàn thành Giai đoạn 3: Câu chuyện Người dùng 1
4. **DỪNG và XÁC THỰC**: Sinh nhiều màn mới và xác nhận khung 12x10 + vùng giải đố hữu cơ hoạt động độc lập

### Bàn giao Tăng dần

1. Thêm **US2** để Player đi xuyên boundary đúng luật
2. Thêm **US3** để mọi Block bị chặn bởi boundary và obstacle đúng luật
3. Thêm **US4** để generator chỉ giữ lại các màn hợp lệ, còn giải được
4. Thêm **US5** để hoàn thiện khả năng đọc màn và polish hình ảnh
5. Kết thúc bằng Giai đoạn 8 để rà soát contract và regression
