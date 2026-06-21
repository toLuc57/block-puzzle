# Bản Đặc tả Tính năng: [TÊN TÍNH NĂNG]

**Nhánh Tính năng**: `[###-feature-name]`

**Ngày tạo**: [DATE]

**Trạng thái**: Nháp

**Đầu vào**: Mô tả của người dùng: "$ARGUMENTS"

## Kịch bản Người dùng & Kiểm thử *(bắt buộc)*

<!--
  QUAN TRỌNG: Các câu chuyện người dùng nên được ƯU TIÊN như các hành trình người dùng được sắp xếp theo tầm quan trọng.
  Mỗi câu chuyện/hành trình người dùng phải có thể KIỂM THỬ ĐỘC LẬP - nghĩa là nếu bạn chỉ triển khai MỘT trong số chúng,
  bạn vẫn nên có một MVP (Sản phẩm Khả thi Tối thiểu) có giá trị.

  Gán mức độ ưu tiên (P1, P2, P3, v.v.) cho mỗi câu chuyện, trong đó P1 là quan trọng nhất.
  Hãy coi mỗi câu chuyện là một lát cắt chức năng độc lập có thể:
  - Phát triển độc lập
  - Kiểm thử độc lập
  - Triển khai độc lập
  - Trình diễn cho người dùng độc lập
-->

### Câu chuyện Người dùng 1 - [Tiêu đề ngắn] (Ưu tiên: P1)

[Mô tả hành trình người dùng này bằng tiếng Việt, dùng thuật ngữ chuyên môn giữ nguyên khi cần]

**Lý do ưu tiên**: [Giải thích giá trị và tại sao nó có mức độ ưu tiên này]

**Kiểm thử Độc lập**: [Mô tả cách kiểm thử độc lập - ví dụ: "Có thể kiểm thử đầy đủ bằng [hành động cụ thể] và mang lại [giá trị cụ thể]"]

**Kịch bản Chấp nhận**:

1. **Cho** [trạng thái ban đầu], **Khi** [hành động], **Thì** [kết quả mong đợi]
2. **Cho** [trạng thái ban đầu], **Khi** [hành động], **Thì** [kết quả mong đợi]

---

### Câu chuyện Người dùng 2 - [Tiêu đề ngắn] (Ưu tiên: P2)

[Mô tả hành trình người dùng này bằng tiếng Việt, dùng thuật ngữ chuyên môn giữ nguyên khi cần]

**Lý do ưu tiên**: [Giải thích giá trị và tại sao nó có mức độ ưu tiên này]

**Kiểm thử Độc lập**: [Mô tả cách kiểm thử độc lập]

**Kịch bản Chấp nhận**:

1. **Cho** [trạng thái ban đầu], **Khi** [hành động], **Thì** [kết quả mong đợi]

---

### Câu chuyện Người dùng 3 - [Tiêu đề ngắn] (Ưu tiên: P3)

[Mô tả hành trình người dùng này bằng tiếng Việt, dùng thuật ngữ chuyên môn giữ nguyên khi cần]

**Lý do ưu tiên**: [Giải thích giá trị và tại sao nó có mức độ ưu tiên này]

**Kiểm thử Độc lập**: [Mô tả cách kiểm thử độc lập]

**Kịch bản Chấp nhận**:

1. **Cho** [trạng thái ban đầu], **Khi** [hành động], **Thì** [kết quả mong đợi]

---

[Thêm câu chuyện người dùng nếu cần, mỗi câu chuyện gán một mức ưu tiên]

### Các Trường hợp Biên (Edge Cases)

<!--
  YÊU CẦU HÀNH ĐỘNG: Nội dung trong phần này là các ví dụ giữ chỗ.
  Hãy điền các trường hợp biên phù hợp.
-->

- Điều gì xảy ra khi [điều kiện biên]?
- Hệ thống xử lý thế nào khi [kịch bản lỗi]?

## Yêu cầu *(bắt buộc)*

<!--
  YÊU CẦU HÀNH ĐỘNG: Nội dung trong phần này là các ví dụ giữ chỗ.
  Hãy điền các yêu cầu chức năng phù hợp.
-->

### Yêu cầu Chức năng

- **FR-001**: Hệ thống PHẢI [khả năng cụ thể, ví dụ: "cho phép người dùng tạo tài khoản"]
- **FR-002**: Hệ thống PHẢI [khả năng cụ thể, ví dụ: "xác thực địa chỉ email"]
- **FR-003**: Người dùng PHẢI có thể [tương tác chính, ví dụ: "đặt lại mật khẩu"]
- **FR-004**: Hệ thống PHẢI [yêu cầu dữ liệu, ví dụ: "lưu trữ tùy chọn người dùng"]
- **FR-005**: Hệ thống PHẢI [hành vi, ví dụ: "ghi nhật ký tất cả các sự kiện bảo mật"]

*Ví dụ về đánh dấu yêu cầu chưa rõ ràng:*

- **FR-006**: Hệ thống PHẢI xác thực người dùng qua [CẦN LÀM RÕ: phương thức xác thực chưa được chỉ định - email/mật khẩu, SSO, OAuth?]
- **FR-007**: Hệ thống PHẢI giữ lại dữ liệu người dùng trong [CẦN LÀM RÕ: thời gian lưu trữ chưa được chỉ định]

### Các Thực thể Chính *(bao gồm nếu tính năng liên quan đến dữ liệu)*

- **[Thực thể 1]**: [Nó đại diện cho cái gì, các thuộc tính chính mà không cần triển khai]
- **[Thực thể 2]**: [Nó đại diện cho cái gì, mối quan hệ với các thực thể khác]

## Tiêu chí Thành công *(bắt buộc)*

<!--
  YÊU CẦU HÀNH ĐỘNG: Định nghĩa các tiêu chí thành công có thể đo lường được.
  Những tiêu chí này phải không phụ thuộc vào công nghệ và có thể đo lường được.
-->

### Kết quả Có thể Đo lường

- **SC-001**: [Số liệu đo lường, ví dụ: "Người dùng có thể hoàn thành việc tạo tài khoản trong dưới 2 phút"]
- **SC-002**: [Số liệu đo lường, ví dụ: "Hệ thống xử lý 1000 người dùng đồng thời mà không giảm hiệu suất"]
- **SC-003**: [Chỉ số hài lòng của người dùng, ví dụ: "90% người dùng hoàn thành thành công nhiệm vụ chính trong lần thử đầu tiên"]
- **SC-004**: [Chỉ số kinh doanh, ví dụ: "Giảm 50% số phiếu hỗ trợ liên quan đến [X]"]

## Các Giả định

<!--
  YÊU CẦU HÀNH ĐỘNG: Nội dung trong phần này là các ví dụ giữ chỗ.
  Hãy điền các giả định phù hợp dựa trên các mặc định hợp lý được chọn
  khi mô tả tính năng không chỉ rõ một số chi tiết nhất định.
-->

- [Giả định về người dùng mục tiêu, ví dụ: "Người dùng làm việc trên desktop"]
- [Giả định về ranh giới phạm vi, ví dụ: "Desktop là nền tảng ưu tiên; di động chỉ khi đặc tả yêu cầu"]
- [Giả định về dữ liệu/môi trường, ví dụ: "Hệ thống xác thực hiện tại sẽ được tái sử dụng"]
- [Phụ thuộc vào hệ thống/dịch vụ hiện có, ví dụ: "Yêu cầu quyền truy cập vào API hồ sơ người dùng hiện tại"]
