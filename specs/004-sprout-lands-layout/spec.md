# Bản Đặc tả Tính năng: Bố cục Sprout Lands

**Nhánh Tính năng**: `004-sprout-lands-layout`

**Ngày tạo**: 2026-06-21

**Trạng thái**: Nháp

**Đầu vào**: Mô tả của người dùng: "Thiết kế giao diện mới, dựa theo [titlemap](scenes\tile_maps\sprout_lands_tile_map.tscn), sử dụng glass (nền), path(ranh giới chặn đá) và crops(chướng ngại vật), không quá 12x10 ô, không nhất thiết là hình chữ nhật, đường ranh giới không hiển thị đường chéo."

## Kịch bản Người dùng & Kiểm thử *(bắt buộc)*

### Câu chuyện Người dùng 1 - Xem giao diện Sprout Lands (Ưu tiên: P1)

Người chơi mở màn chơi và nhìn thấy một bố cục mới lấy cảm hứng từ Sprout Lands, với nền glass, ranh giới path và chướng ngại vật crops được sắp xếp rõ ràng.

**Lý do ưu tiên**: Đây là thay đổi nhìn thấy trực tiếp đầu tiên, quyết định ấn tượng và khả năng nhận biết khu vực chơi.

**Kiểm thử Độc lập**: Có thể kiểm tra bằng cách mở màn chơi và quan sát giao diện mới mà không cần thực hiện thêm hành động nào.

**Kịch bản Chấp nhận**:

1. **Cho** người chơi mở màn chơi, **Khi** giao diện được tải, **Thì** bố cục Sprout Lands hiển thị đúng nền glass, path và crops theo thiết kế mới.
2. **Cho** người chơi quan sát toàn bộ khu vực, **Khi** giao diện được hiển thị, **Thì** không có vùng nào vượt quá giới hạn bố cục đã quy định.

---

### Câu chuyện Người dùng 2 - Nhận biết ranh giới hợp lệ (Ưu tiên: P1)

Người chơi có thể phân biệt rõ khu vực hợp lệ để chơi với các vùng ranh giới và chướng ngại vật, kể cả khi bố cục không phải hình chữ nhật.

**Lý do ưu tiên**: Nếu ranh giới khó nhận biết, người chơi dễ hiểu sai vùng tương tác và trải nghiệm sẽ bị gián đoạn.

**Kiểm thử Độc lập**: Có thể kiểm tra bằng cách xác định các ô hợp lệ, các ô path và các ô crops trên bố cục mới.

**Kịch bản Chấp nhận**:

1. **Cho** người chơi nhìn vào bố cục, **Khi** ranh giới được hiển thị, **Thì** các cạnh chỉ gồm các đoạn ngang và dọc, không có đường chéo.
2. **Cho** người chơi nhìn vào các vùng chặn, **Khi** ranh giới và chướng ngại vật xuất hiện, **Thì** path thể hiện ranh giới chặn đá và crops thể hiện chướng ngại vật khác biệt rõ ràng.

---

### Câu chuyện Người dùng 3 - Tối ưu hình dạng khu vực chơi (Ưu tiên: P2)

Bố cục khu vực chơi có thể có hình dạng linh hoạt, miễn là vẫn nằm trong giới hạn tổng thể và không vượt quá 12x10 ô.

**Lý do ưu tiên**: Tính linh hoạt cho phép bố cục phù hợp hơn với giao diện mới mà vẫn giữ giới hạn rõ ràng.

**Kiểm thử Độc lập**: Có thể kiểm tra bằng cách đối chiếu kích thước vùng chơi và xác nhận hình dạng không bắt buộc là hình chữ nhật.

**Kịch bản Chấp nhận**:

1. **Cho** bố cục được thiết kế xong, **Khi** kiểm tra kích thước tổng thể, **Thì** bố cục không vượt quá 12 ô ngang và 10 ô dọc.
2. **Cho** bố cục có vùng khuyết hoặc cạnh bo theo thiết kế, **Khi** kiểm tra hình dạng, **Thì** khu vực chơi không bị ràng buộc phải là hình chữ nhật hoàn chỉnh.

---

### Các Trường hợp Biên (Edge Cases)

- Điều gì xảy ra khi bố cục có vùng khuyết làm cho khu vực chơi không còn hình chữ nhật hoàn chỉnh?
- Hệ thống xử lý thế nào khi người chơi nhìn thấy ranh giới mà không có đường chéo nhưng vẫn phải phân biệt rõ khu vực chặn đá?
- Điều gì xảy ra nếu một bố cục mới vô tình vượt quá giới hạn 12x10 ô?

## Yêu cầu *(bắt buộc)*

### Yêu cầu Chức năng

- **FR-001**: Giao diện phải hiển thị một bố cục mới dựa trên Sprout Lands.
- **FR-002**: Bố cục phải sử dụng glass làm nền chính của khu vực hiển thị.
- **FR-003**: Bố cục phải dùng path để thể hiện ranh giới chặn đá.
- **FR-004**: Bố cục phải dùng crops để thể hiện chướng ngại vật trong khu vực chơi.
- **FR-005**: Khu vực chơi không được vượt quá 12 ô ngang và 10 ô dọc.
- **FR-006**: Khu vực chơi được phép có hình dạng không phải hình chữ nhật, miễn là vẫn nằm trong giới hạn kích thước.
- **FR-007**: Đường ranh giới không được hiển thị theo đường chéo.
- **FR-008**: Bố cục phải giúp người chơi phân biệt được vùng hợp lệ, ranh giới chặn và chướng ngại vật một cách rõ ràng.

### Các Thực thể Chính *(bao gồm nếu tính năng liên quan đến dữ liệu)*

- **Bố cục giao diện**: Mô tả cách sắp xếp tổng thể của nền, ranh giới và chướng ngại vật trong màn chơi.
- **Vùng chơi**: Phần khu vực người chơi có thể tương tác, bị giới hạn bởi kích thước và hình dạng của bố cục.
- **Ranh giới**: Các ô hoặc cạnh path xác định vùng chặn đá và tách biệt vùng chơi.
- **Chướng ngại vật**: Các ô crops đặt trong bố cục để làm thay đổi cách tiếp cận không gian chơi.

## Tiêu chí Thành công *(bắt buộc)*

### Kết quả Có thể Đo lường

- **SC-001**: 100% lần mở màn chơi hiển thị một bố cục không vượt quá 12x10 ô.
- **SC-002**: 100% bản bố cục hợp lệ không chứa đường ranh giới chéo.
- **SC-003**: Ít nhất 90% người thử nghiệm xác định đúng được vùng chặn và chướng ngại vật trong vòng 30 giây quan sát.
- **SC-004**: Người chơi có thể nhận ra sự khác biệt giữa nền, ranh giới và chướng ngại vật trong lần xem đầu tiên ở đa số lần thử.

## Các Giả định

- Bố cục mới là một thay đổi hướng tới trải nghiệm nhìn và nhận biết không gian chơi rõ ràng hơn.
- Thuật ngữ glass, path, và crops được giữ nguyên vì đây là các khái niệm trực quan đã được xác định cho giao diện này.
- Giới hạn 12x10 ô là giới hạn tối đa cho khu vực chơi, không phải kích thước bắt buộc cố định.
- Hình dạng không chữ nhật là hợp lệ miễn là vẫn giữ được ranh giới rõ ràng và không làm mơ hồ vùng chơi.
