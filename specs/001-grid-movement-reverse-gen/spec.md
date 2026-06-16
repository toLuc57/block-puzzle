# Bản Đặc tả Tính năng: Hệ thống lưới di chuyển & Sinh màn chơi ngược

**Nhánh Tính năng**: `001-grid-movement-reverse-gen`

**Ngày tạo**: 2026-06-16

**Trạng thái**: Nháp

**Đầu vào**: Mô tả của người dùng: "Hãy tạo file Spec cho tính năng Hệ thống lưới di chuyển (Grid-based movement) và Thuật toán sinh màn chơi ngược (Reverse Generation Level Generator). Yêu cầu: Nhân vật di chuyển 4 hướng theo ô lưới rời rạc, mượt mà bằng Tween. Map 10x10. Có 2 loại khối: Khối cơ bản (đẩy từng ô) và Khối băng (trượt liên tục đến khi gặp vật cản). Tạo lớp cơ bản, đặt tên cho 2 loại khối là khối xám (gray-block), khối băng (ice-block). Hệ thống tạo màn chơi tự động áp dụng thuật toán Duyệt ngược (Reverse Generation/Pull Moves) từ trạng thái thắng (mọi khối nằm trên ô X) đi lùi lại để xáo trộn map. Đảm bảo 100% map tạo ra giải được."

## Kịch bản Người dùng & Kiểm thử *(bắt buộc)*

### Câu chuyện Người dùng 1 - Di chuyển theo lưới (Ưu tiên: P1)

Là một người chơi, tôi muốn nhân vật di chuyển theo 4 hướng trong lưới 10x10 để có thể điều hướng màn chơi và tương tác với các khối.

**Lý do ưu tiên**: Điều hướng cốt lõi là nền tảng cho mọi tương tác giải đố.

**Kiểm thử Độc lập**: Nhân vật di chuyển chính xác một ô lưới khi nhấn phím điều hướng.

**Kịch bản Chấp nhận**:

1. **Cho** nhân vật đang ở vị trí (5, 5), **Khi** người chơi nhấn 'Phải', **Thì** nhân vật di chuyển mượt mà đến (6, 5).
2. **Cho** có một bức tường ở vị trí (6, 5), **Khi** người chơi nhấn 'Phải', **Thì** nhân vật vẫn ở nguyên vị trí (5, 5).

---

### Câu chuyện Người dùng 2 - Đẩy các khối (Ưu tiên: P1)

Là một người chơi, tôi muốn đẩy các khối xám và khối băng để có thể đặt chúng vào các điểm mục tiêu nhằm giải đố.

**Lý do ưu tiên**: Cơ chế giải đố chính cần thiết cho vòng lặp trò chơi.

**Kiểm thử Độc lập**: Các khối thay đổi vị trí dựa trên các đặc tính vật lý cụ thể của chúng khi bị nhân vật đẩy.

**Kịch bản Chấp nhận**:

1. **Cho** một Khối Xám ở vị trí (6, 5) và nhân vật ở (5, 5), **Khi** người chơi di chuyển 'Phải', **Thì** Khối Xám di chuyển đến (7, 5) và nhân vật di chuyển đến (6, 5).
2. **Cho** một Khối Băng ở vị trí (6, 5) và nhân vật ở (5, 5) với không gian trống đến tận (9, 5), **Khi** người chơi di chuyển 'Phải', **Thì** Khối Băng trượt đến (9, 5) và nhân vật di chuyển đến (6, 5).

---

### Câu chuyện Người dùng 3 - Sinh màn chơi (Ưu tiên: P2)

Là một hệ thống trò chơi, tôi muốn sinh các màn chơi bằng thuật toán "kéo ngược" (reverse-pull) để mọi bản đồ hiển thị cho người chơi đều được đảm bảo có thể giải được.

**Lý do ưu tiên**: Đảm bảo tính công bằng và đa dạng cho người chơi mà không cần thiết kế thủ công.

**Kiểm thử Độc lập**: Việc sinh màn chơi hoàn tất và trạng thái bản đồ kết quả có thể được giải bằng cách đảo ngược các bước sinh.

**Kịch bản Chấp nhận**:

1. **Cho** một tập hợp các điểm mục tiêu, **Khi** trình tạo màn chơi bắt đầu, **Thì** nó tạo ra một bố cục nơi các khối có thể tiếp cận và giải được.

## Yêu cầu *(bắt buộc)*

### Yêu cầu Chức năng

- **FR-001**: Hệ thống PHẢI hỗ trợ di chuyển rời rạc theo 4 hướng trên lưới 10x10.
- **FR-002**: Chuyển động của nhân vật và khối PHẢI sử dụng Tween để có các hiệu ứng chuyển cảnh mượt mà giữa các ô lưới.
- **FR-003**: Hệ thống PHẢI triển khai hành vi "Khối Xám" (gray-block): di chuyển chính xác 1 ô khi bị đẩy.
- **FR-004**: Hệ thống PHẢI triển khai hành vi "Khối Băng" (ice-block): trượt liên tục cho đến khi chạm tường, khối khác hoặc biên giới lưới.
- **FR-005**: Hệ thống PHẢI phát hiện điều kiện thắng khi tất cả các khối (Xám và Băng) nằm trên các điểm mục tiêu ('X').
- **FR-006**: Hệ thống PHẢI triển khai thuật toán Sinh màn chơi ngược (Pull Moves) bắt đầu từ trạng thái thắng để tạo bố cục câu đố.
- **FR-007**: Trình tạo màn chơi PHẢI đảm bảo 100% khả năng giải được cho mọi bản đồ được sinh ra.

### Các Thực thể Chính

- **Lưới (Grid)**: Một cấu trúc logic 10x10 đại diện cho việc chiếm hữu ô và vị trí tường.
- **Nhân vật (Character)**: Thực thể do người chơi điều khiển để thực hiện các cú đẩy.
- **Khối Xám (GrayBlock)**: Một khối được định nghĩa bằng Resource, di chuyển 1 ô cho mỗi lần đẩy.
- **Khối Băng (IceBlock)**: Một khối được định nghĩa bằng Resource, trượt cho đến khi va chạm.
- **Điểm Mục tiêu (TargetMark)**: Một vị trí lưới cố định ('X') nơi các khối phải được đặt để thắng.

## Tiêu chí Thành công *(bắt buộc)*

### Kết quả Có thể Đo lường

- **SC-001**: 100% màn chơi được sinh ra có ít nhất một đường đi hợp lệ dẫn đến trạng thái thắng.
- **SC-002**: Hoạt ảnh di chuyển trên lưới (Tween) hoàn tất trong dưới 300ms để đảm bảo phản hồi tốt.
- **SC-003**: Các khối không bao giờ chồng lấp hoặc rời khỏi biên giới lưới 10x10.
- **SC-004**: Việc sinh màn chơi (các bước đi ngược) hoàn tất trong dưới 500ms cho một bản đồ 10x10.

## Các Giả định

- Tween sẽ được xử lý bởi lớp Tween tích hợp sẵn của Godot.
- Lưới 10x10 là cố định và không thay đổi trong khi chơi.
- Đầu vào chủ yếu là bàn phím/D-pad (Lên, Xuống, Trái, Phải).
- Tất cả các khối trong danh sách sinh màn chơi đều là loại Xám hoặc Băng.
