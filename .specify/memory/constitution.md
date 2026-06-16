<!--
  Sync Impact Report:
  - Version change: block-puzzle Constitution v1.1.0
  - List of modified principles:
    - Added: VI. Ngôn ngữ Tài liệu (Vietnamese for Dev-facing docs)
  - Added sections: None
  - Removed sections: None
  - Templates requiring updates: 
    - ✅ .specify/templates/plan-template.md (dịch sang tiếng Việt)
    - ✅ .specify/templates/tasks-template.md (dịch sang tiếng Việt)
    - ✅ .specify/templates/spec-template.md (dịch sang tiếng Việt)
    - ✅ .specify/templates/checklist-template.md (dịch sang tiếng Việt)
  - Follow-up TODOs: Dịch các file spec hiện có.
-->

# Hiến chương dự án block-puzzle

## Các Nguyên tắc Cốt lõi

### I. Hình ảnh Hiện đại & Phản hồi Nhanh
Trò chơi phải mang lại cảm giác hiện đại, sạch sẽ và "sống động". Mọi cơ chế đều phải có phản hồi thị giác trau chuốt, bao gồm các khối "bóng" (ghost blocks) khi đặt và các hiệu ứng hoạt hình thỏa mãn khi xóa hàng. Các tương tác phải phản hồi nhanh, các khối co giãn khi được nắm và khớp chính xác vào lưới 10x10.

### II. Kiến trúc Dựa trên Tín hiệu (Signal-Driven)
Sử dụng hệ thống tín hiệu của Godot để tách biệt các thành phần trò chơi. Các hệ thống như `Grid`, `BlockSpawner`, và `UIManager` phải giao tiếp qua tín hiệu (ví dụ: `BlockPlaced`, `LineCleared`, `GameOver`) để đảm bảo tính module và dễ bảo trì.

### III. Quản lý Dữ liệu Dựa trên Tài nguyên (Resource-Based)
Hình dạng, màu sắc và thuộc tính của các khối phải được định nghĩa bằng các tệp `Resource` của Godot. Điều này cho phép dễ dàng mở rộng các loại khối (khối đa ô tiêu chuẩn hoặc các hình dạng bất thường lớn hơn) mà không cần sửa đổi logic sinh khối cốt lõi.

### IV. Xác thực Thực nghiệm & Kiểm thử
Mọi cơ chế cốt lõi (chiếm hữu lưới, xóa hàng, phát hiện kết thúc trò chơi) phải được xác thực thông qua các bài kiểm tra tự động hoặc các kịch bản gỡ lỗi thủ công chuyên biệt trước khi được coi là hoàn thành. Các bản sửa lỗi phải có trường hợp tái hiện lỗi đi kèm.

### V. Logic Lưới Ưu tiên Hiệu suất
Duy trì tốc độ 60 FPS ổn định bằng cách tối ưu hóa các thao tác trên lưới. Chỉ kiểm tra các hàng và cột bị ảnh hưởng sau khi đặt khối. Sử dụng các cấu trúc dữ liệu hiệu quả (mảng 2 chiều hoặc mảng phẳng với bản đồ ánh xạ) cho khu vực chơi 10x10.

### VI. Ngôn ngữ Tài liệu
Tất cả tài liệu hướng tới lập trình viên (tệp `.md`, kế hoạch, đặc tả, nhiệm vụ) phải được viết bằng tiếng Việt. Các tệp cấu hình hệ thống và mã nguồn vẫn tuân theo tiêu chuẩn tiếng Anh hoặc theo quy định của nền tảng.

## Các Ràng buộc Kỹ thuật
- **Engine:** Godot Engine 4.6.
- **Ngôn ngữ:** GDScript (tuân theo hướng dẫn phong cách chính thức).
- **Nền tảng:** Ưu tiên máy tính để bàn (desktop) trước, với đầu vào thân thiện với thiết bị di động (kéo và thả).
- **Lưới:** Khu vực chơi cố định 10x10.

## Quy trình Phát triển Cuốn chiếu (Iterative)
Việc triển khai phải tuân theo cách tiếp cận từng bước, chính xác:
1. Logic Lưới & Hình ảnh.
2. Hệ thống Sinh khối (bộ 3 khối).
3. Đầu vào Kéo & Thả.
4. Cơ chế Xóa hàng.
5. Điều kiện Tính điểm & Kết thúc trò chơi.

## Quản trị
- Hiến chương này thay thế tất cả các thực hành phát triển khác trong kho lưu trữ này.
- Tất cả các triển khai tính năng phải phù hợp với các nguyên tắc này.
- Các sửa đổi yêu cầu tăng phiên bản và cập nhật tài liệu.
- Sử dụng `GEMINI.md` để hướng dẫn kiến trúc và quy trình làm việc toàn dự án.

**Phiên bản**: 1.1.0 | **Phê chuẩn**: 2026-06-16 | **Cập nhật lần cuối**: 2026-06-16
