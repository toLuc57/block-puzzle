---

description: "Bản mẫu danh sách nhiệm vụ để triển khai tính năng"
---

# Nhiệm vụ: [TÊN TÍNH NĂNG]

**Đầu vào**: Các tài liệu thiết kế từ `/specs/[###-feature-name]/`

**Điều kiện tiên quyết**: plan.md (bắt buộc), spec.md (bắt buộc cho các câu chuyện người dùng), research.md, data-model.md, contracts/

**Kiểm thử**: Các ví dụ bên dưới bao gồm các nhiệm vụ kiểm thử. Kiểm thử là bắt buộc cho thay đổi cốt lõi, đặc biệt là luật chơi, dữ liệu, và luồng tương tác.

**Tổ chức**: Các nhiệm vụ được nhóm theo câu chuyện người dùng để cho phép triển khai và kiểm thử độc lập cho mỗi câu chuyện.

## Định dạng: `[ID] [P?] [Story] Mô tả`

- **[P]**: Có thể chạy song song (các tệp khác nhau, không có phụ thuộc)
- **[Story]**: Nhiệm vụ này thuộc về câu chuyện người dùng nào (ví dụ: US1, US2, US3)
- Bao gồm đường dẫn tệp chính xác trong mô tả

## Quy ước Đường dẫn

- **Cảnh (Scenes)**: `scenes/` (ví dụ: `scenes/main/Game.tscn`)
- **Kịch bản (Scripts)**: `scripts/` (ví dụ: `scripts/logic/Grid.gd`)
- **Tài nguyên (Resources)**: `resources/` (ví dụ: `resources/blocks/I_Block.tres`)
- **Kiểm thử (Tests)**: `tests/` (ví dụ: `tests/unit/test_grid.gd`)

<!--
  ============================================================================
  QUAN TRỌNG: Các nhiệm vụ bên dưới là CÁC NHIỆM VỤ VÍ DỤ chỉ nhằm mục đích minh họa.

  Lệnh /speckit.tasks PHẢI thay thế những nhiệm vụ này bằng các nhiệm vụ thực tế dựa trên:
  - Các câu chuyện người dùng từ spec.md (với các mức ưu tiên P1, P2, P3...)
  - Các yêu cầu tính năng từ plan.md
  - Các thực thể từ data-model.md
  - Các điểm cuối (endpoints) từ contracts/

  Các nhiệm vụ PHẢI được tổ chức theo câu chuyện người dùng để mỗi câu chuyện có thể:
  - Được triển khai độc lập
  - Được kiểm thử độc lập
  - Được bàn giao như một phần tăng trưởng MVP

  KHÔNG giữ các nhiệm vụ ví dụ này trong tệp tasks.md được tạo ra.
  ============================================================================
-->

## Giai đoạn 1: Thiết lập (Cơ sở hạ tầng dùng chung)

**Mục đích**: Khởi tạo dự án và cấu trúc cơ bản

- [ ] T001 Tạo cấu trúc thư mục (scenes, scripts, resources, tests)
- [ ] T002 Cấu hình các thiết lập dự án Godot
- [ ] T003 Thiết lập GUT (Godot Unit Testing) hoặc cơ chế kiểm thử phù hợp nếu được yêu cầu

---

## Giai đoạn 2: Nền tảng (Điều kiện tiên quyết ngăn chặn)

**Mục đích**: Cơ sở hạ tầng cốt lõi PHẢI hoàn thành trước khi BẤT KỲ câu chuyện người dùng nào có thể được triển khai

**⚠️ QUAN TRỌNG**: Không có công việc câu chuyện người dùng nào có thể bắt đầu cho đến khi giai đoạn này hoàn thành

Ví dụ về các nhiệm vụ nền tảng (điều chỉnh dựa trên dự án của bạn):

- [ ] T004 Định nghĩa các loại Resource cơ bản cho các khối
- [ ] T005 Thiết lập Bus Tín hiệu Toàn cầu (Autoload) nếu cần
- [ ] T006 Tạo cảnh Game chính và container Lưới (Grid)
- [ ] T007 Triển khai logic Lưới 10x10 cơ bản (Mảng 2 chiều)
- [ ] T008 Thiết lập cấu trúc giao diện người dùng UI (Điểm số, Kết thúc trò chơi)

**Điểm kiểm tra**: Nền tảng đã sẵn sàng - việc triển khai câu chuyện người dùng hiện có thể bắt đầu song song

---

## Giai đoạn 3: Câu chuyện Người dùng 1 - [Tiêu đề] (Ưu tiên: P1) 🎯 MVP

**Mục tiêu**: [Mô tả ngắn gọn về những gì câu chuyện này mang lại]

**Kiểm thử Độc lập**: [Cách xác minh câu chuyện này hoạt động độc lập]

### Kiểm thử cho Câu chuyện Người dùng 1 (TÙY CHỌN - chỉ khi có yêu cầu) ⚠️

> **LƯU Ý: Viết các kiểm thử này TRƯỚC, đảm bảo chúng THẤT BẠI trước khi triển khai**

- [ ] T010 [P] [US1] Kiểm thử đơn vị (Unit test) cho [logic] trong tests/unit/test_[name].gd
- [ ] T011 [P] [US1] Kiểm thử tích hợp (Integration test) cho [tương tác] trong tests/integration/test_[name].gd

### Triển khai cho Câu chuyện Người dùng 1

- [ ] T012 [P] [US1] Tạo [Resource] trong resources/[folder]/[name].tres
- [ ] T013 [P] [US1] Tạo [Script] trong scripts/[folder]/[name].gd
- [ ] T014 [US1] Tạo [Scene] in scenes/[folder]/[name].tscn
- [ ] T015 [US1] Kết nối các tín hiệu cho [sự kiện]
- [ ] T016 [US1] Triển khai [logic] trong [file].gd
- [ ] T017 [US1] Thêm phản hồi thị giác/hiệu ứng hoạt hình

**Điểm kiểm tra**: Tại thời điểm này, Câu chuyện Người dùng 1 sẽ hoạt động đầy đủ và có thể kiểm thử độc lập

---

## Giai đoạn 4: Câu chuyện Người dùng 2 - [Tiêu đề] (Ưu tiên: P2)

**Mục tiêu**: [Mô tả ngắn gọn về những gì câu chuyện này mang lại]

**Kiểm thử Độc lập**: [Cách xác minh câu chuyện này hoạt động độc lập]

### Kiểm thử cho Câu chuyện Người dùng 2 (TÙY CHỌN - chỉ khi có yêu cầu) ⚠️

- [ ] T018 [P] [US2] Kiểm thử đơn vị cho [logic] trong tests/unit/test_[name].gd
- [ ] T019 [P] [US2] Kiểm thử tích hợp cho [tương tác] trong tests/integration/test_[name].gd

### Triển khai cho Câu chuyện Người dùng 2

- [ ] T020 [P] [US2] Tạo [Script/Resource] trong [đường dẫn]
- [ ] T021 [US2] Triển khai logic cho [tính năng]
- [ ] T022 [US2] Tích hợp với các thành phần của Câu chuyện Người dùng 1 (nếu cần)

**Điểm kiểm tra**: Tại thời điểm này, các Câu chuyện Người dùng 1 VÀ 2 đều hoạt động độc lập

---

## Giai đoạn N: Trau chuốt & Các vấn đề xuyên suốt

**Mục đích**: Các cải tiến ảnh hưởng đến nhiều câu chuyện người dùng

- [ ] TXXX [P] Cập nhật tài liệu trong docs/
- [ ] TXXX Dọn dẹp mã và tái cấu trúc (refactoring)
- [ ] TXXX Tối ưu hóa hiệu suất cho tất cả các câu chuyện
- [ ] TXXX [P] Thêm các kiểm thử đơn vị bổ sung (nếu được yêu cầu) trong tests/unit/
- [ ] TXXX Tăng cường bảo mật

---

## Phụ thuộc & Thứ tự Thực hiện

### Phụ thuộc Giai đoạn

- **Thiết lập (Giai đoạn 1)**: Không có phụ thuộc - có thể bắt đầu ngay lập tức
- **Nền tảng (Giai đoạn 2)**: Phụ thuộc vào việc hoàn thành Thiết lập - NGĂN CHẶN tất cả các câu chuyện người dùng
- **Các Câu chuyện Người dùng (Giai đoạn 3+)**: Tất cả đều phụ thuộc vào việc hoàn thành giai đoạn Nền tảng
  - Các câu chuyện người dùng sau đó có thể tiến hành song song (nếu có nhân lực)
  - Hoặc tuần tự theo thứ tự ưu tiên (P1 → P2 → P3)
- **Trau chuốt (Giai đoạn cuối)**: Phụ thuộc vào việc hoàn thành tất cả các câu chuyện người dùng mong muốn

---

## Chiến lược Triển khai

### MVP Trước (Chỉ Câu chuyện Người dùng 1)

1. Hoàn thành Giai đoạn 1: Thiết lập
2. Hoàn thành Giai đoạn 2: Nền tảng (QUAN TRỌNG - ngăn chặn tất cả các câu chuyện)
3. Hoàn thành Giai đoạn 3: Câu chuyện Người dùng 1
4. **DỪNG và XÁC THỰC**: Kiểm thử Câu chuyện Người dùng 1 độc lập
5. Triển khai/trình diễn nếu đã sẵn sàng

### Bàn giao Tăng dần

1. Hoàn thành Thiết lập + Nền tảng → Nền tảng đã sẵn sàng
2. Thêm Câu chuyện Người dùng 1 → Kiểm thử độc lập → Triển khai/Trình diễn (MVP!)
3. Thêm Câu chuyện Người dùng 2 → Kiểm thử độc lập → Triển khai/Trình diễn
4. Mỗi câu chuyện thêm giá trị mà không phá vỡ các câu chuyện trước đó
