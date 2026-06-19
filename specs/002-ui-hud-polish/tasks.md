# Nhiệm vụ: Hệ thống UI và Đánh bóng giao diện (VBoxContainer Layout & Terrain)

**Đầu vào**: Các tài liệu thiết kế từ `/specs/002-ui-hud-polish/`

**Điều kiện tiên quyết**: plan.md, spec.md, research.md, data-model.md, contracts/interfaces.md

**Tổ chức**: Các nhiệm vụ được nhóm theo câu chuyện người dùng để cho phép triển khai và kiểm thử độc lập cho mỗi câu chuyện.

## Định dạng: `[ID] [P?] [Story] Mô tả`

- **[P]**: Có thể chạy song song (các tệp khác nhau, không có phụ thuộc)
- **[Story]**: Nhiệm vụ này thuộc về câu chuyện người dùng nào (ví dụ: US1, US2, US3)
- Bao gồm đường dẫn tệp chính xác trong mô tả

## Quy ước Đường dẫn

- **Cảnh (Scenes)**: `scenes/` (ví dụ: `scenes/ui/HUD.tscn`)
- **Kịch bản (Scripts)**: `scripts/` (ví dụ: `scripts/ui/GameUI.gd`)
- **Tài nguyên (Resources)**: `resources/` (ví dụ: `resources/themes/ui_theme.tres`)
- **Kiểm thử (Tests)**: `tests/` (ví dụ: `tests/unit/test_ui_updates.gd`)

## Giai đoạn 1: Thiết lập (Không cần thiết - Dự án đã tồn tại)

Dự án đã được khởi tạo ở Feature 001. Bỏ qua giai đoạn này.

---

## Giai đoạn 2: Nền tảng (Điều kiện tiên quyết ngăn chặn)

**Mục đích**: Cấu trúc lại Main.tscn với VBoxContainer layout 3 phần

**⚠️ QUAN TRỌNG**: Không có công việc câu chuyện người dùng nào có thể bắt đầu cho đến khi giai đoạn này hoàn thành

- [X] T001 Sao lưu Main.tscn hiện tại trước khi refactor scenes/main/Main.tscn
- [X] T002 Cấu trúc lại Main.tscn: Thay đổi root node thành VBoxContainer trong scenes/main/Main.tscn
- [X] T003 [P] Tạo TopPanel (PanelContainer) với chiều cao cố định 60px, size_flags_vertical=SIZE_SHRINK_BEGIN trong scenes/main/Main.tscn
- [X] T004 [P] Tạo CenterGameArea (Control) với size_flags_vertical=SIZE_EXPAND_FILL trong scenes/main/Main.tscn
- [X] T005 [P] Tạo BottomPanel (PanelContainer) với chiều cao cố định 50px, size_flags_vertical=SIZE_SHRINK_END trong scenes/main/Main.tscn
- [X] T006 Di chuyển GridContainer và TargetLayer vào bên trong CenterGameArea trong scenes/main/Main.tscn
- [X] T007 Cập nhật VictoryLayer: Đặt vào CanvasLayer riêng với layer=10 để luôn hiển thị trên cùng trong scenes/main/Main.tscn
- [X] T008 Xác minh cấu trúc Node Tree: VBoxContainer > TopPanel/CenterGameArea/BottomPanel bằng cách chạy game và kiểm tra Scene Tree

**Điểm kiểm tra**: Layout 3 phần đã sẵn sàng - việc triển khai câu chuyện người dùng hiện có thể bắt đầu song song

---

## Giai đoạn 3: Câu chuyện Người dùng 1 - Theo dõi tiến trình qua HUD (Ưu tiên: P1) 🎯 MVP

**Mục tiêu**: HUD hiển thị Move Count, Target Moves, Progress ở TopPanel, không bao giờ đè lên vùng chơi game

**Kiểm thử Độc lập**: Di chuyển Player và quan sát HUD cập nhật mà không có overlap với game objects

### Triển khai cho Câu chuyện Người dùng 1

- [X] T009 [P] [US1] Di chuyển HUD scene hiện tại vào bên trong TopPanel trong scenes/main/Main.tscn
- [X] T010 [P] [US1] Cập nhật HUD.gd: Đảm bảo labels (Moves, Target, Progress) được căn giữa ngang trong scripts/ui/HUD.gd
- [X] T011 [US1] Cập nhật HUD.gd: Kết nối với GameEvents signals (score_updated, progress_updated) trong scripts/ui/HUD.gd
- [ ] T012 [US1] Test thủ công: Chạy game, di chuyển Player lên sát mép trên, kiểm tra Player không bị che bởi TopPanel
- [ ] T013 [US1] Test thủ công: Resize cửa sổ game, kiểm tra TopPanel giữ chiều cao cố định, CenterGameArea co giãn

**Điểm kiểm tra**: HUD hoạt động đầy đủ trong TopPanel, không có UI overlap

---

## Giai đoạn 4: Câu chuyện Người dùng 2 - Trải nghiệm địa hình liền mạch (Ưu tiên: P1)

**Mục tiêu**: Terrain autotiling với set_cells_terrain_connect() để texture tự động nối khớp

**Kiểm thử Độc lập**: Sinh màn chơi mới và kiểm tra texture tường/nền nối liền mạch không có đường rời rạc

### Triển khai cho Câu chuyện Người dùng 2

- [X] T014 [P] [US2] Cập nhật _setup_level() trong Main.gd: Thay thế vòng lặp set_cell() cho background bằng set_cells_terrain_connect() trong scenes/main/Main.gd
- [X] T015 [P] [US2] Cập nhật _setup_level() trong Main.gd: Sử dụng set_cells_terrain_connect() cho targets layer (nếu targets cũng dùng terrain) trong scenes/main/Main.gd
- [X] T016 [US2] Xác minh TileSet configuration: Kiểm tra terrain_set và terrain đã được cấu hình đúng trong Editor
- [ ] T017 [US2] Test thủ công: Sinh màn chơi mới 3 lần, kiểm tra tất cả texture tường nối khớp (không có missing borders)
- [ ] T018 [US2] Debug nếu cần: Nếu terrain không nối đúng, kiểm tra terrain_peering_bits trong TileSet

**Điểm kiểm tra**: Terrain autotiling hoạt động, bản đồ có visual polish chuyên nghiệp

---

## Giai đoạn 5: Câu chuyện Người dùng 3 - Victory Screen bền vững (Ưu tiên: P1)

**Mục tiêu**: Victory Popup hiển thị ổn định ở TẤT CẢ các màn chơi, không chỉ màn đầu tiên

**Kiểm thử Độc lập**: Thắng màn 1 → Next Level → Thắng màn 2 → Victory Popup PHẢI hiện lần 2

### Triển khai cho Câu chuyện Người dùng 3

- [X] T019 [P] [US3] Audit Main.gd _ready(): Đảm bảo GameEvents.win_condition_met.connect(_on_win) chỉ gọi 1 lần trong scenes/main/Main.gd
- [X] T020 [P] [US3] Audit Main.gd: Tìm và XÓA bỏ tất cả disconnect() calls cho win_condition_met signal (nếu có) trong scenes/main/Main.gd
- [X] T021 [US3] Cập nhật _generate_and_setup(): Thêm victory_layer.hide() ở đầu hàm để reset UI state trong scenes/main/Main.gd
- [X] T022 [US3] Cập nhật _on_win(): Đảm bảo victory_layer.show() và %VictoryPopup.show() được gọi trong scenes/main/Main.gd
- [ ] T023 [US3] Test thủ công: Chơi và thắng 3 màn liên tiếp, đếm số lần Victory Popup hiện (phải là 3/3)
- [ ] T024 [US3] Debug với breakpoint: Nếu Victory không hiện, đặt breakpoint trong _on_win() và kiểm tra signal có được emit không

**Điểm kiểm tra**: Victory Screen hoạt động ổn định xuyên suốt game loop

---

## Giai đoạn 6: Trau chuốt & Block Legend

**Mục đích**: Hoàn thiện BlockLegend component ở BottomPanel

- [X] T025 [P] Di chuyển hoặc tạo BlockLegend scene vào bên trong BottomPanel trong scenes/main/Main.tscn
- [X] T026 [P] Cập nhật BlockLegend.gd: Duyệt qua BlockData resources và hiển thị icons + descriptions trong scripts/ui/BlockLegend.gd
- [X] T027 [P] Styling: Thêm padding/margin cho TopPanel và BottomPanel để UI không sát mép
- [ ] T028 Test toàn diện: Chạy quickstart.md validation scenarios (Layout, Terrain, Victory Loop)
- [X] T029 [P] Cập nhật documentation: Ghi lại cấu trúc VBoxContainer layout trong README.md hoặc CLAUDE.md nếu cần

---

## Phụ thuộc & Thứ tự Thực hiện

### Phụ thuộc Giai đoạn

- **Thiết lập (Giai đoạn 1)**: BỎ QUA - Dự án đã tồn tại
- **Nền tảng (Giai đoạn 2)**: Không có phụ thuộc - NGĂN CHẶN tất cả câu chuyện người dùng (T001-T008 PHẢI hoàn thành trước)
- **User Story 1 (Giai đoạn 3)**: Phụ thuộc vào T001-T008 (VBoxContainer layout)
- **User Story 2 (Giai đoạn 4)**: Phụ thuộc vào T001-T008, có thể song song với US1
- **User Story 3 (Giai đoạn 5)**: Phụ thuộc vào T001-T008, có thể song song với US1 và US2
- **Trau chuốt (Giai đoạn 6)**: Phụ thuộc vào T001-T024 (tất cả User Stories)

### Biểu đồ Phụ thuộc

```
T001-T008 (Nền tảng - VBoxContainer)
    ├─→ T009-T013 (US1: HUD)
    ├─→ T014-T018 (US2: Terrain) [có thể song song với US1]
    └─→ T019-T024 (US3: Victory) [có thể song song với US1, US2]
         └─→ T025-T029 (Polish)
```

### Cơ hội Song song

- **Sau T008**: T009-T013 (US1), T014-T018 (US2), T019-T024 (US3) có thể chạy song song nếu có đủ nhân lực
- **Trong mỗi Story**: Các tasks có đánh dấu [P] có thể chạy song song với nhau

---

## Chiến lược Triển khai

### MVP Trước (3 User Stories đều P1)

Vì cả 3 user stories đều có ưu tiên P1 và đều quan trọng như nhau, MVP nên bao gồm:

1. **Hoàn thành Giai đoạn 2: Nền tảng** (T001-T008) - BLOCKING
2. **Hoàn thành US1: HUD Layout** (T009-T013) - Đảm bảo UI không overlap
3. **Hoàn thành US2: Terrain** (T014-T018) - Visual polish
4. **Hoàn thành US3: Victory Loop** (T019-T024) - Game loop integrity
5. **DỪNG và XÁC THỰC**: Chạy toàn bộ quickstart.md scenarios
6. **Giai đoạn 6: BlockLegend Polish** (T025-T029) - Nice-to-have

### Bàn giao Tăng dần

1. **Checkpoint 1**: Hoàn thành T001-T008 → VBoxContainer layout đã sẵn sàng
2. **Checkpoint 2**: Hoàn thành T009-T013 → HUD không overlap, test riêng US1
3. **Checkpoint 3**: Hoàn thành T014-T018 → Terrain autotiling, test riêng US2
4. **Checkpoint 4**: Hoàn thành T019-T024 → Victory loop stable, test riêng US3
5. **Final**: Hoàn thành T025-T029 → BlockLegend + polish

---

## Tổng kết

- **Tổng số tasks**: 29 tasks
- **Tasks per story**:
  - Nền tảng (Giai đoạn 2): 8 tasks (T001-T008) - BLOCKING
  - US1 (HUD): 5 tasks (T009-T013)
  - US2 (Terrain): 5 tasks (T014-T018)
  - US3 (Victory): 6 tasks (T019-T024)
  - Polish: 5 tasks (T025-T029)
- **Parallel opportunities**: 
  - 12 tasks có đánh dấu [P] có thể song song
  - 3 User Stories (US1, US2, US3) có thể triển khai song song sau khi Nền tảng hoàn thành
- **MVP scope**: Giai đoạn 2 + US1 + US2 + US3 (T001-T024) = 24 tasks
- **Format validation**: ✅ Tất cả tasks tuân theo format `- [ ] [TID] [P?] [Story?] Description with file path`
