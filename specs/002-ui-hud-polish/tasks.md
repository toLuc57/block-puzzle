# Nhiệm vụ: Hệ thống UI và Đánh bóng giao diện (Polish UI/HUD)

**Đầu vào**: Các tài liệu thiết kế từ `/specs/002-ui-hud-polish/`

**Điều kiện tiên quyết**: plan.md (bắt buộc), spec.md (bắt buộc cho các câu chuyện người dùng), research.md, data-model.md, contracts/

**Kiểm thử**: Các nhiệm vụ kiểm thử được bao gồm để đảm bảo logic Undo và cập nhật UI hoạt động chính xác.

**Tổ chức**: Các nhiệm vụ được nhóm theo câu chuyện người dùng để cho phép triển khai và kiểm thử độc lập.

## Định dạng: `[ID] [P?] [Story] Mô tả`

- **[P]**: Có thể chạy song song (các tệp khác nhau, không có phụ thuộc)
- **[Story]**: Nhiệm vụ này thuộc về câu chuyện người dùng nào (ví dụ: US1, US2, US3)
- Bao gồm đường dẫn tệp chính xác trong mô tả

## Quy ước Đường dẫn

- **Cảnh (Scenes)**: `scenes/` (ví dụ: `scenes/ui/HUD.tscn`)
- **Kịch bản (Scripts)**: `scripts/` (ví dụ: `scripts/ui/GameUI.gd`)
- **Tài nguyên (Resources)**: `resources/` (ví dụ: `resources/themes/ui_theme.tres`)
- **Kiểm thử (Tests)**: `tests/` (ví dụ: `tests/unit/test_ui_updates.gd`)

## Giai đoạn 1: Thiết lập (Cơ sở hạ tầng dùng chung)

**Mục đích**: Cập nhật các Resource hiện có và tạo cấu trúc thư mục UI.

- [X] T001 [P] Thêm thuộc tính `description` vào `scripts/logic/BlockData.gd` để hỗ trợ hiển thị Chú giải
- [X] T002 [P] Cập nhật mô tả cho `resources/blocks/gray_block.tres` và `resources/blocks/ice_block.tres`
- [X] T003 Tạo thư mục `scenes/ui/` và `scripts/ui/` nếu chưa có

## Giai đoạn 2: Nền tảng (Điều kiện tiên quyết ngăn chặn)

**Mục đích**: Thiết lập hệ thống Tín hiệu (Signals) và Quản lý trạng thái (GameState) cần thiết cho tất cả các câu chuyện người dùng.

- [X] T004 [P] Định nghĩa các tín hiệu mới (`score_updated`, `progress_updated`, `victory_triggered`, `undo_requested`, `reset_requested`) trong `scripts/autoload/GameEvents.gd`
- [X] T005 Triển khai `scripts/logic/GameState.gd` (Autoload) để quản lý lịch sử Undo (Stack) và đếm bước
- [X] T006 [P] Tạo `StyleBoxFlat` với đường viền xác định và bo góc nhẹ trong `resources/themes/hud_border.tres`
- [X] T007 Tích hợp trực tiếp HUD, Legend và Victory vào `scenes/main/Main.tscn` sử dụng cấu trúc `VBoxContainer`

**Điểm kiểm tra**: Nền tảng Signal-driven và GameState đã sẵn sàng để tích hợp vào UI.

---

## Giai đoạn 3: Câu chuyện Người dùng 1 - Theo dõi tiến trình qua HUD (Ưu tiên: P1) 🎯 MVP

**Mục tiêu**: Hiển thị Move Count, Target Moves và Progress (Blocks current/total) ở phía trên màn hình, căn giữa ngang.

**Kiểm thử Độc lập**: Chạy game và thấy các con số cập nhật khi di chuyển hoặc đẩy khối vào đích.

### Kiểm thử cho Câu chuyện Người dùng 1
- [X] T008 [P] [US1] Viết kiểm thử đơn vị cho việc cập nhật số bước và số khối vào đích trong `tests/unit/test_ui_updates.gd`

### Triển khai cho Câu chuyện Người dùng 1
- [X] T009 [P] [US1] Tạo cảnh HUD `scenes/ui/HUD.tscn` sử dụng `MarginContainer` và `HBoxContainer` căn giữa ngang
- [X] T010 [US1] Áp dụng `resources/themes/hud_border.tres` cho Panel HUD để có đường viền xác định
- [X] T011 [US1] Triển khai logic cập nhật nhãn (Labels) trong `scripts/ui/HUD.gd` bằng cách lắng nghe signals từ `GameEvents.gd`
- [X] T012 [US1] Thêm hiệu ứng Tween nảy Panel trong `scripts/ui/HUD.gd` khi nhận tín hiệu `progress_updated`
- [X] T013 [US1] Kết nối `Main.gd` để phát tín hiệu `score_updated` và `progress_updated` và quản lý hiển thị HUD

**Điểm kiểm tra**: HUD hiển thị chính xác tiến trình màn chơi với hiệu ứng mượt mà.

---

## Giai đoạn 4: Câu chuyện Người dùng 2 - Xử lý khi bị kẹt khối (Ưu tiên: P1)

**Mục tiêu**: Cung cấp nút Reset/Undo trên màn hình và hỗ trợ phím tắt (R/Ctrl+Z).

**Kiểm thử Độc lập**: Nhấn nút hoặc phím tắt và thấy game quay lại trạng thái trước đó.

### Kiểm thử cho Câu chuyện Người dùng 2
- [X] T014 [P] [US2] Viết kiểm thử cho logic Undo (quay lại vị trí cũ, giảm move count) trong `tests/unit/test_undo_logic.gd`

### Triển khai cho Câu chuyện Người dùng 2
- [X] T015 [P] [US2] Thêm nút Undo và Reset vào `scenes/ui/HUD.tscn` với icon tương ứng
- [X] T016 [US2] Triển khai xử lý sự kiện nút bấm trong `scripts/ui/HUD.gd` để phát tín hiệu `undo_requested` và `reset_requested`
- [X] T017 [US2] Cập nhật `scripts/logic/Player.gd` và `scenes/game_objects/Block.gd` để hỗ trợ thiết lập lại vị trí từ trạng thái lịch sử
- [X] T018 [US2] Lắng nghe tín hiệu yêu cầu trong `scenes/main/Main.gd` và thực hiện logic Undo/Reset từ `GameState.gd`
- [X] T019 [US2] Bắt sự kiện phím tắt (Input Map: `ui_undo`, `ui_reset`) trong một script UI trung tâm hoặc `Main.gd`

**Điểm kiểm tra**: Người chơi có thể thoát khỏi tình trạng kẹt khối bằng Undo/Reset.

---

## Giai đoạn 5: Câu chuyện Người dùng 3 - Hoàn thành màn chơi (Ưu tiên: P1)

**Mục tiêu**: Hiển thị Victory Pop-up khi thắng, cho phép chơi lại hoặc sang màn tiếp theo.

**Kiểm thử Độc lập**: Đẩy khối cuối cùng vào đích và thấy Pop-up hiện ra.

### Triển khai cho Câu chuyện Người dùng 3
- [X] T020 [P] [US3] Thiết kế `scenes/ui/VictoryPopup.tscn` với thông báo chúc mừng và 2 nút "Next Level", "Replay"
- [X] T021 [US3] Triển khai logic hiển thị/ẩn và xử lý nút bấm trong `scripts/ui/VictoryPopup.gd`
- [X] T022 [US3] Kết nối tín hiệu `win_condition_met` từ `Main.gd` để kích hoạt `VictoryPopup`
- [X] T023 [US3] Liên kết nút "Next Level" để gọi hàm sinh màn mới trong `Main.gd` thông qua tín hiệu `next_level_requested`

**Điểm kiểm tra**: Vòng lặp game hoàn tất với màn hình thông báo chiến thắng.

---

## Giai đoạn 6: Câu chuyện Người dùng 4 - Chú giải Khối (Ưu tiên: P2)

**Mục tiêu**: Hiển thị bảng Chú giải (Legend) ở đáy màn hình, căn giữa ngang, mô tả các loại khối.

**Kiểm thử Độc lập**: Thấy bảng chú giải hiện ra ở dưới Grid với đầy đủ thông tin icon và text.

### Triển khai cho Câu chuyện Người dùng 4
- [X] T024 [P] [US4] Tạo cảnh `scenes/ui/BlockLegend.tscn` sử dụng `HBoxContainer` để chứa các mục chú giải
- [X] T025 [US4] Triển khai `scripts/ui/BlockLegend.gd` để sinh tự động các mục chú giải từ danh sách Resource khối có sẵn
- [X] T026 [US4] Tích hợp `BlockLegend.tscn` vào `VBoxContainer` ở đáy màn hình trong `Main.tscn`

---

## Giai đoạn 7: Trau chuốt & Các vấn đề xuyên suốt

**Mục đích**: Tối ưu hóa Responsive và làm sạch mã nguồn.

- [X] T027 [P] Kiểm tra tính Responsive của UI trên các độ phân giải khác nhau (800x600, 1920x1080)
- [ ] T028 [P] Thêm âm thanh hiệu ứng (SFX) nhẹ khi nhấn nút hoặc khi HUD "nảy" (nếu có tài nguyên)
- [X] T029 Dọn dẹp các đoạn mã `print()` debug và tối ưu hóa việc kết nối tín hiệu

---

## Phụ thuộc & Thứ tự Thực hiện

### Phụ thuộc Giai đoạn

- **Thiết lập (Giai đoạn 1)** & **Nền tảng (Giai đoạn 2)**: Cần hoàn thành trước để có hạ tầng Signal và GameState.
- **US1 (HUD)**: Là ưu tiên cao nhất (P1) vì nó cung cấp phản hồi cơ bản nhất.
- **US2, US3**: Có thể thực hiện song song sau khi có HUD cơ bản.
- **US4 (Legend)**: Ưu tiên thấp hơn (P2), thực hiện cuối cùng.

---

## Chiến lược Triển khai

### MVP Trước (Chỉ Câu chuyện Người dùng 1)

1. Hoàn thành Giai đoạn 1 & 2 (Cơ sở hạ tầng & Signals).
2. Triển khai HUD (US1) để người chơi thấy được số bước và tiến trình.
3. **Xác thực**: Kiểm tra số liệu hiển thị trên HUD có khớp với logic game không.

### Bàn giao Tăng dần

1. Thêm chức năng Undo/Reset (US2) để cải thiện trải nghiệm người dùng.
2. Thêm màn hình Victory (US3) để hoàn thiện vòng lặp chơi game.
3. Cuối cùng thêm Chú giải (US4) để hỗ trợ người chơi mới.
