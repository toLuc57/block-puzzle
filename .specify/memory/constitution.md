<!--
  Sync Impact Report:
  - Version change: 1.1.0 → 1.2.0
  - Modified principles:
    - I. Hình ảnh Hiện đại & Phản hồi Nhanh → I. Tài liệu & Thuật ngữ bằng tiếng Việt
    - II. Kiến trúc Dựa trên Tín hiệu (Signal-Driven) → II. Godot 4.6, GDScript, Desktop-First
    - III. Quản lý Dữ liệu Dựa trên Tài nguyên (Resource-Based) → III. Mã nguồn Tối giản, Rõ ràng, Có Mục đích
    - IV. Xác thực Thực nghiệm & Kiểm thử → IV. Đặt tên & Chú thích Không Gây Hiểu Nhầm
    - V. Logic Lưới Ưu tiên Hiệu suất → V. Kiến trúc Godot Rõ Ràng và Hiệu năng Ổn định
    - VI. Ngôn ngữ Tài liệu → VI. Kiểm thử & Xác thực Hành vi
  - Added sections: Quy trình Phát triển & Xác thực
  - Removed sections: None
  - Templates requiring updates:
    - ✅ .specify/templates/plan-template.md
    - ✅ .specify/templates/spec-template.md
    - ✅ .specify/templates/tasks-template.md
    - ✅ .specify/templates/checklist-template.md
    - ⚠ .specify/templates/commands/ (thư mục không tồn tại trong repo hiện tại)
  - Follow-up TODOs: None
-->

# Hiến chương dự án block-puzzle

## Các Nguyên tắc Cốt lõi

### I. Tài liệu & Thuật ngữ bằng tiếng Việt
Tất cả tài liệu hướng tới lập trình viên phải viết bằng tiếng Việt. Thuật ngữ chuyên môn, tên API, tên lớp, tên hàm, tên file, và các khái niệm chuẩn của Godot hoặc GDScript được giữ nguyên khi việc dịch dễ gây hiểu nhầm. Mục tiêu là làm rõ ý định cho người đọc kỹ thuật, không làm mờ nghĩa bằng bản dịch gượng ép.

### II. Godot 4.6, GDScript, Desktop-First
Dự án PHẢI dùng Godot Engine 4.6 và GDScript. Desktop là nền tảng ưu tiên; mọi thiết kế tương tác, bố cục UI, và luồng nhập liệu phải tối ưu cho bàn phím, chuột, và cửa sổ desktop trước khi xét đến di động. Bất kỳ lựa chọn nào lệch khỏi tiêu chuẩn này phải được nêu rõ trong đặc tả hoặc kế hoạch.

### III. Mã nguồn Tối giản, Rõ ràng, Có Mục đích
Chỉ viết phần mã thực sự cần thiết cho yêu cầu hiện tại. Mỗi đoạn mã phải phục vụ một chức năng rõ ràng và có đầu vào/đầu ra xác định. Khi thực hiện thay đổi, phải biết rõ từng dòng hoặc khối được thêm, sửa, hay xoá để giải quyết vấn đề nào. Không thêm lớp trừu tượng, fallback, hay mở rộng giả định nếu chưa có yêu cầu.

### IV. Đặt tên & Chú thích Không Gây Hiểu Nhầm
Tên file, biến, hằng số, hàm, scene, và resource phải phản ánh đúng vai trò của chúng. Khi một đoạn mã có thể bị hiểu sai nếu không có ngữ cảnh, phải viết comment ngắn gọn để giải thích lý do hoặc ràng buộc không hiển nhiên. Nếu bỏ comment mà người đọc vẫn hiểu đúng, thì không cần comment.

### V. Kiến trúc Godot Rõ ràng và Hiệu năng Ổn định
Phần tĩnh của thế giới trò chơi phải đi qua TileMap hoặc TileMapLayer; các actor di chuyển phải là node riêng do `Main.gd` hoặc lớp điều phối tương đương khởi tạo. Hệ thống phải ưu tiên Signal, Resource, và cấu trúc dữ liệu phù hợp với Godot thay vì ghép logic vào một script lớn. Mọi thay đổi về lưới phải giữ hiệu năng ổn định và chỉ xử lý phần bị ảnh hưởng.

### VI. Kiểm thử & Xác thực Hành vi
Mọi thay đổi liên quan đến luật chơi, dữ liệu, hoặc luồng tương tác cốt lõi PHẢI có cách xác thực rõ ràng: kiểm thử tự động, kiểm thử tích hợp, hoặc kịch bản thủ công ghi lại được. Bản sửa lỗi PHẢI có bước tái hiện lỗi trước khi sửa và bước xác nhận sau khi sửa. Nếu không thể xác thực, thay đổi chưa được coi là hoàn tất.

## Các Ràng buộc Kỹ thuật
- **Engine:** Godot Engine 4.6.
- **Ngôn ngữ:** GDScript.
- **Nền tảng:** Ưu tiên desktop; mobile chỉ là mục tiêu phụ khi đặc tả yêu cầu.
- **Cấu trúc scene:** Static geometry dùng TileMap/TileMapLayer; moving actors là node riêng do lớp điều phối khởi tạo.
- **Kích thước lưới:** Không hard-code kích thước nếu đặc tả tính năng quy định khác; mọi kích thước phải xuất phát từ spec/plan.
- **Tài liệu dev-facing:** Viết bằng tiếng Việt, ngoại lệ cho thuật ngữ chuyên môn hoặc tên API chuẩn.

## Quy trình Phát triển & Xác thực
1. Trước khi viết mã, xác định rõ file nào sẽ thêm, sửa, hay xoá và vì sao.
2. Mỗi tính năng phải đi theo chuỗi Spec → Plan → Tasks → Implement, trừ khi là sửa lỗi đã có mô tả tái hiện.
3. Mỗi thay đổi cốt lõi phải đi kèm xác thực tương ứng: test, script gỡ lỗi, hoặc kịch bản thủ công.
4. Khi đánh giá chất lượng, ưu tiên tính đúng, dễ đọc, và khả năng kiểm chứng hơn là mở rộng phạm vi.
5. Nếu thay đổi đòi hỏi ngoại lệ với các nguyên tắc trên, ngoại lệ đó phải được nêu rõ trong plan và được giải thích trong review.

## Quản trị
- Hiến chương này cao hơn mọi hướng dẫn phát triển khác trong kho lưu trữ này.
- Mọi thay đổi về tính năng, kiến trúc, hoặc quy trình phải phù hợp với các nguyên tắc ở trên.
- Sửa đổi hiến chương PHẢI ghi rõ lý do, tăng phiên bản theo quy tắc bên dưới, và cập nhật ngày sửa đổi cuối.
- **MAJOR**: thay đổi hoặc loại bỏ nguyên tắc theo cách không tương thích ngược.
- **MINOR**: thêm nguyên tắc mới hoặc mở rộng đáng kể phạm vi hướng dẫn.
- **PATCH**: chỉnh câu chữ, làm rõ nghĩa, hoặc sửa lỗi diễn đạt không đổi hành vi.
- Mọi kế hoạch, đặc tả, và tác vụ quan trọng PHẢI có bước kiểm tra hiến chương trước khi thực thi.

**Version**: 1.2.0 | **Ratified**: 2026-06-16 | **Last Amended**: 2026-06-21
