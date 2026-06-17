# Bản Đặc tả Tính năng: Hệ thống UI và Đánh bóng giao diện (Polish UI/HUD)

**Nhánh Tính năng**: `002-ui-hud-polish`

**Ngày tạo**: 2026-06-16

**Trạng thái**: Nháp

**Đầu vào**: Mô tả của người dùng: "Thiết kế và lập trình giao diện người dùng (User Interface) trực quan, hiện đại, hỗ trợ tốt cho trải nghiệm giải đố bằng Godot Engine 4.x. Yêu cầu chi tiết cho UI bao gồm: 1. Giao diện HUD trong màn chơi (In-game HUD): Thay thế Text thuần của ScoreLabel bằng một UI Panel nằm ở góc trên màn hình, hiển thị: Số bước đi hiện tại (Move Count), Số bước tối ưu (Target Moves - lấy từ thuật toán A* nếu có), và Số khối đá đã vào vị trí / Tổng số khối (vị dụ: "Blocks: 2/3"). Thêm nút "Reset (Phím R)" và nút "Undo (Ctrl+Z)" trực quan trên màn hình để người chơi click bằng chuột nếu bị kẹt khối. 2. Màn hình thông báo Chiến thắng (Victory Pop-up Scene): Tạo một UI Pop-up ẩn, chỉ hiển thị khi toàn bộ khối đá đã nằm trên ô "X". Hiển thị thông báo chúc mừng, tổng kết số bước đi của người chơi. Thêm 2 nút chức năng: "Màn tiếp theo (Next Level)" để kích hoạt lại bộ Generator sinh map mới, và "Chơi lại (Replay)". 3. Hiệu ứng đồ họa (Visual Polish): Tận dụng hệ thống Control Nodes của Godot (CanvasLayer, MarginContainer, VBoxContainer, HBoxContainer) để UI tự động co giãn theo độ phân giải màn hình (Responsive). Thêm hiệu ứng Tween nhỏ (ví dụ: Panel hơi nảy lên hoặc đổi màu xanh) mỗi khi có một khối đá được đẩy thành công vào ô "X". Kiến trúc: Tách biệt logic UI sang một script riêng (ví dụ: GameUI.gd) và kết nối với Main.gd thông qua hệ thống Signals của Godot để đảm bảo kiến trúc gọn gàng (Decoupled Architecture). Kết quả: Khi bắt đầu vào game, màn hình chơi phải hiển thị rõ ô nào là tường (WALL), đá xám và đá băng (BLOCK), player, và ô đích (TARGET - được đánh dấu "X")"

## Clarifications

### Session 2026-06-17
- Q: Bố cục UI và căn chỉnh? → A: HUD và Legend căn giữa ngang, neo ở đỉnh (Top) và đáy (Bottom) màn hình. Tránh middle align để không che khu vực chơi.
- Q: Định dạng chú giải khối (Block Concepts)? → A: Hiển thị icon khối kèm văn bản mô tả ngắn gọn về đặc tính/cách dùng ngay dưới màn chơi.
- Q: Phong cách đường viền (Border) của HUD? → A: Sử dụng StyleBoxFlat với đường viền đơn sắc rõ nét và bo góc nhẹ.

## Kịch bản Người dùng & Kiểm thử *(bắt buộc)*

### Câu chuyện Người dùng 1 - Theo dõi tiến trình màn chơi qua HUD (Ưu tiên: P1)

Người chơi cần biết họ đã đi bao nhiêu bước, còn bao xa để đạt mức tối ưu và bao nhiêu khối đã vào vị trí để điều chỉnh chiến thuật. HUD được hiển thị ở vị trí căn giữa ngang phía trên màn chơi với đường viền rõ nét để dễ quan sát.

**Lý do ưu tiên**: Đây là thông tin cốt lõi để người chơi tham gia vào gameplay giải đố một cách có ý thức về hiệu quả.

**Kiểm thử Độc lập**: Có thể kiểm thử bằng cách thực hiện các bước di chuyển và đẩy khối vào đích, sau đó quan sát các con số trên HUD cập nhật theo thời gian thực.

**Kịch bản Chấp nhận**:

1. **Cho** người chơi đang ở trong màn chơi, **Khi** người chơi thực hiện 1 bước di chuyển hợp lệ, **Thì** "Move Count" trên HUD tăng thêm 1.
2. **Cho** một khối đá đang ở ngoài ô đích, **Khi** người chơi đẩy khối đá đó vào ô "X", **Thì** số lượng "Blocks" trên HUD cập nhật (ví dụ từ 1/3 lên 2/3) và Panel HUD có hiệu ứng Tween phản hồi thị giác.

---

### Câu chuyện Người dùng 2 - Xử lý khi bị kẹt khối (Ưu tiên: P1)

Người chơi vô tình đẩy khối vào góc chết và cần quay lại bước trước hoặc chơi lại từ đầu mà không cần khởi động lại toàn bộ game.

**Lý do ưu tiên**: Trò chơi giải đố Sokoban/Block Puzzle rất dễ bị kẹt, việc thiếu chức năng Reset/Undo sẽ gây ức chế cực lớn cho người dùng.

**Kiểm thử Độc lập**: Click vào nút Reset trên màn hình hoặc nhấn phím 'R' để xem màn chơi có quay về trạng thái ban đầu không. Tương tự với Undo.

**Kịch bản Chấp nhận**:

1. **Cho** màn chơi đang diễn ra với một số bước đã đi, **Khi** người chơi nhấn nút "Reset" hoặc phím "R", **Thì** vị trí các khối và người chơi quay về ban đầu, "Move Count" về 0.
2. **Cho** người chơi vừa thực hiện một bước đẩy khối sai, **Khi** người chơi nhấn nút "Undo" hoặc tổ hợp "Ctrl+Z", **Thì** khối đá và người chơi quay về vị trí ngay trước đó, "Move Count" giảm đi 1.

---

### Câu chuyện Người dùng 3 - Hoàn thành màn chơi và tiếp tục (Ưu tiên: P1)

Người chơi muốn được ghi nhận thành tích khi giải xong đố và có lựa chọn chuyển sang thử thách mới.

**Lý do ưu tiên**: Đây là vòng lặp phản hồi tích cực (positive feedback loop) giúp người chơi cảm thấy thỏa mãn và tiếp tục gắn bó với game.

**Kiểm thử Độc lập**: Đẩy tất cả các khối vào ô đích và kiểm tra xem màn hình Victory có xuất hiện with đầy đủ thông tin và nút bấm không.

**Kịch bản Chấp nhận**:

1. **Cho** khối cuối cùng vừa được đẩy vào ô đích, **Khi** hệ thống phát hiện tất cả khối đã ở đúng vị trí, **Thì** một màn hình Pop-up hiện lên hiển thị "Victory!", tổng số bước đã đi.
2. **Cho** màn hình Victory đang hiển thị, **Khi** người chơi nhấn "Next Level", **Thì** màn chơi hiện tại biến mất và một màn chơi mới được sinh ra ngẫu nhiên.

---

### Câu chuyện Người dùng 4 - Tìm hiểu luật chơi qua Chú giải Khối (Ưu tiên: P2)

Người chơi mới cần hiểu ý nghĩa và cách hoạt động của từng loại khối để có thể giải đố.

**Lý do ưu tiên**: Giảm rào cản gia nhập cho người chơi mới và làm rõ các cơ chế đặc biệt (như khối băng).

**Kịch bản Chấp nhận**:

1. **Cho** người chơi đang ở màn chơi, **Khi** nhìn xuống phía dưới khu vực chơi, **Thì** thấy một bảng chú giải (Legend) hiển thị icon từng loại khối kèm mô tả ngắn về đặc tính của chúng.

---

### Các Trường hợp Biên (Edge Cases)

- Điều gì xảy ra khi người chơi nhấn Undo liên tục về tận bước đầu tiên? (Hệ thống nên vô hiệu hóa nút Undo khi không còn dữ liệu lịch sử).
- Hệ thống xử lý thế nào khi thuật toán A* không tìm thấy lời giải tối ưu? (HUD nên hiển thị "Target: N/A" hoặc một giá trị mặc định thay vì gây lỗi crash).
- UI hiển thị như thế nào trên các màn hình có tỉ lệ cực dị (như 21:9 hoặc màn hình dọc)? (Control Nodes phải được neo - anchor - chính xác để không bị tràn lề).

## Yêu cầu *(bắt buộc)*

### Yêu cầu Chức năng

- **FR-001**: Hệ thống PHẢI có một `GameUI` (CanvasLayer) chứa HUD hiển thị: Move Count, Target Moves, và Progress (Blocks: current/total). HUD PHẢI được căn giữa ngang ở phía trên màn hình.
- **FR-002**: Hệ thống PHẢI cung cấp nút Reset và Undo trên UI, đồng thời hỗ trợ phím tắt tương ứng (R và Ctrl+Z).
- **FR-003**: Hệ thống PHẢI có màn hình Victory Pop-up ẩn, tự động hiển thị khi điều kiện thắng được thỏa mãn.
- **FR-004**: `GameUI` PHẢI được tách biệt logic với `Main.gd`, giao tiếp qua các tín hiệu như `update_score(moves)`, `block_placed()`, `level_completed()`.
- **FR-005**: Hệ thống PHẢI sử dụng Tween để tạo hiệu ứng nảy/đổi màu Panel HUD khi có khối vào đích.
- **FR-006**: Tất cả các ô trên lưới (WALL, BLOCK, PLAYER, TARGET) PHẢI có hình ảnh phân biệt rõ ràng (ví dụ: Tường là gạch, Đích là chữ X đỏ, Khối là đá).
- **FR-007**: Hệ thống PHẢI hiển thị bảng Chú giải Khối (Block Legend) ở phía dưới màn chơi, căn giữa ngang, bao gồm icon và mô tả ngắn gọn cho từng loại khối.
- **FR-008**: HUD PHẢI có đường viền (border) xác định rõ ràng, sử dụng StyleBoxFlat với góc bo tròn nhẹ.

### Các Thực thể Chính

- **GameUI**: Thực thể quản lý toàn bộ giao diện, chịu trách nhiệm cập nhật thông tin hiển thị và bắt sự kiện từ người dùng trên UI.
- **GameState**: (Ngầm định) Lưu trữ trạng thái lịch sử cho Undo và đếm số bước, cung cấp dữ liệu cho GameUI.
- **VictoryPopup**: Thành phần con của GameUI, chuyên trách hiển thị kết quả cuối màn.

## Tiêu chí Thành công *(bắt buộc)*

### Kết quả Có thể Đo lường

- **SC-001**: UI tự động co giãn và giữ đúng vị trí trên các độ phân giải từ 800x600 đến 1920x1080.
- **SC-002**: Hiệu ứng Tween phản hồi khi đẩy khối vào đích diễn ra trong thời gian dưới 0.3s để đảm bảo cảm giác mượt mà.
- **SC-003**: Người chơi có thể thực hiện thao tác Reset hoặc Undo và thấy kết quả phản hồi trên màn hình trong dưới 100ms.
- **SC-004**: 100% các phần tử trong game (Tường, Khối, Người chơi, Đích) có thể phân biệt được ngay lập tức bởi người chơi mới mà không cần hướng dẫn bằng văn bản.

## Các Giả định

- Hệ thống hiện tại đã có logic di chuyển lưới cơ bản để kết nối tín hiệu.
- Thuật toán A* hoặc bộ sinh màn chơi có khả năng cung cấp số bước tối ưu (Target Moves).
- Tài nguyên hình ảnh (Sprites) cơ bản cho WALL, BLOCK, PLAYER đã có sẵn hoặc có thể tạo nhanh bằng Placeholder.
- Game được chơi trên Godot 4.x với hỗ trợ đầy đủ cho hệ thống Control và Tween mới.
