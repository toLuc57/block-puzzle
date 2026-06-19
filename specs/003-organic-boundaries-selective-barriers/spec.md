# Bản Đặc tả Tính năng: Ranh giới Hữu cơ và Rào cản Có chọn lọc

**Nhánh Tính năng**: `003-organic-boundaries-selective-barriers`

**Ngày tạo**: 2026-06-19

**Trạng thái**: Nháp

**Đầu vào**: Mô tả của người dùng: "Hãy cập nhật tài liệu Đặc tả (Spec) cho hệ thống Level Generator với các yêu cầu mới về kích thước, thuật toán sinh bản đồ không chữ nhật (Organic boundaries), Logic di chuyển (GridLogic) và Level Generator để triển khai cơ chế 'Rào cản có chọn lọc' (Selective Barrier) dựa trên hình ảnh `examples\puzzle1.png`"

## Kịch bản Người dùng & Kiểm thử *(bắt buộc)*

### Câu chuyện Người dùng 1 - Màn chơi có ranh giới hữu cơ đa dạng (Ưu tiên: P1)

Người chơi bắt đầu nhiều màn mới liên tiếp và thấy mỗi màn có hình dáng vùng giải đố khác nhau trong cùng một khung hiển thị thống nhất, thay vì luôn là một hình chữ nhật giống nhau.

**Lý do ưu tiên**: Đây là giá trị cốt lõi của tính năng. Nếu hình dạng vùng giải đố không thay đổi, cơ chế mới không tạo ra khác biệt đáng kể về trải nghiệm chơi.

**Kiểm thử Độc lập**: Có thể kiểm thử bằng cách tạo liên tiếp nhiều màn mới và xác nhận vùng giải đố luôn nằm trong khung 12x10, được đặt giữa màn, nhưng hình dạng biên và chướng ngại vật bên trong thay đổi giữa các màn.

**Kịch bản Chấp nhận**:

1. **Cho** một màn mới được tạo, **Khi** hệ thống hoàn tất sinh bố cục, **Thì** toàn bộ màn phải được hiển thị trong lưới 12x10 ô với vùng giải đố nằm giữa và không vượt quá 10x8 ô.
2. **Cho** nhiều màn mới được tạo liên tiếp, **Khi** người chơi quan sát vùng giải đố, **Thì** hình dạng ranh giới và vị trí chướng ngại vật bên trong phải tạo ra các bố cục khác nhau thay vì lặp lại một hình chữ nhật cố định.
3. **Cho** một màn đã được sinh xong, **Khi** người chơi quan sát khu vực chơi, **Thì** phải thấy rõ đường viền ngoằn ngoèo bao quanh phần không gian dùng cho câu đố.

---

### Câu chuyện Người dùng 2 - Nhân vật đi xuyên qua đường viền giải đố (Ưu tiên: P1)

Người chơi điều khiển nhân vật quanh khu vực giải đố và có thể băng qua đường viền ngoằn ngoèo để tiếp cận các vị trí cần thiết, trong khi vẫn bị chặn bởi tường ngoài cùng và các chướng ngại vật cố định.

**Lý do ưu tiên**: Cơ chế này tạo ra lớp điều hướng riêng cho nhân vật. Nếu nhân vật cũng bị chặn bởi đường viền, cơ chế rào cản có chọn lọc không tồn tại.

**Kiểm thử Độc lập**: Có thể kiểm thử bằng cách đặt nhân vật ở hai phía của đường viền và xác nhận nhân vật có thể đi qua đường viền nhưng không thể đi xuyên qua tường ngoài hoặc chướng ngại vật cố định.

**Kịch bản Chấp nhận**:

1. **Cho** nhân vật đứng cạnh đường viền giải đố, **Khi** người chơi ra lệnh di chuyển qua đường viền, **Thì** nhân vật phải sang được ô hợp lệ ở phía bên kia.
2. **Cho** nhân vật đứng cạnh tường ngoài cùng, **Khi** người chơi ra lệnh di chuyển vào tường, **Thì** nhân vật không được di chuyển.
3. **Cho** nhân vật đứng cạnh chướng ngại vật cố định, **Khi** người chơi ra lệnh di chuyển vào chướng ngại vật, **Thì** nhân vật không được di chuyển.

---

### Câu chuyện Người dùng 3 - Khối đá bị chặn bởi đường viền có chọn lọc (Ưu tiên: P1)

Người chơi đẩy hoặc kéo các khối đá và thấy rằng các khối coi đường viền ngoằn ngoèo như một bức tường thật, từ đó tạo ra các giới hạn giải đố khác với giới hạn di chuyển của nhân vật.

**Lý do ưu tiên**: Đây là phần quyết định độ sâu của cơ chế mới. Nếu khối đá không bị chặn bởi đường viền, sự khác biệt hành vi giữa nhân vật và khối sẽ biến mất.

**Kiểm thử Độc lập**: Có thể kiểm thử bằng cách thử đưa từng loại khối qua đường viền, qua chướng ngại vật và qua tường ngoài, đồng thời xác nhận các khối sử dụng chướng ngại vật làm điểm tựa hợp lệ trong các tình huống cần neo.

**Kịch bản Chấp nhận**:

1. **Cho** một khối đá đứng cạnh đường viền giải đố, **Khi** người chơi cố đẩy hoặc kéo khối vượt qua đường viền, **Thì** khối phải bị chặn lại tại mép ranh giới.
2. **Cho** một khối đá đứng cạnh tường ngoài hoặc chướng ngại vật cố định, **Khi** người chơi cố di chuyển khối xuyên qua vật cản đó, **Thì** khối không được đi qua.
3. **Cho** một khối trượt cần một điểm dừng để hoàn thành lời giải, **Khi** chướng ngại vật nằm trên hướng di chuyển của khối, **Thì** chướng ngại vật phải hoạt động như điểm neo hợp lệ để chặn hoặc dừng khối.

---

### Câu chuyện Người dùng 4 - Màn sinh tự động vẫn tạo được câu đố hợp lệ (Ưu tiên: P2)

Người chơi bắt đầu màn mới và luôn nhận được một câu đố còn giải được, dù vùng giải đố có hình dáng hữu cơ và có chướng ngại vật ngẫu nhiên.

**Lý do ưu tiên**: Sự đa dạng chỉ có giá trị khi vẫn giữ được khả năng giải và tính công bằng của câu đố.

**Kiểm thử Độc lập**: Có thể kiểm thử bằng cách sinh nhiều màn liên tiếp và xác nhận các vật cản cố định không bị coi là khối có thể di chuyển, đồng thời mục tiêu và khối luôn nằm trong vùng giải đố hợp lệ.

**Kịch bản Chấp nhận**:

1. **Cho** một màn mới đang được tạo, **Khi** hệ thống đặt mục tiêu và các khối, **Thì** chúng chỉ được đặt trong phần vùng giải đố được đường viền bao quanh.
2. **Cho** hệ thống đang xây dựng một câu đố mới, **Khi** có chướng ngại vật cố định trong vùng giải đố, **Thì** các vật cản đó phải luôn được coi là vật cản bất động chứ không bao giờ bị kéo như một khối di chuyển.
3. **Cho** một màn đã được tạo xong, **Khi** người chơi bắt đầu giải, **Thì** bố cục phải duy trì một đường đi hợp lệ để tiếp cận và thao tác các thành phần chính của câu đố.

---

### Câu chuyện Người dùng 5 - Ranh giới và vật cản hiển thị rõ ràng (Ưu tiên: P2)

Người chơi có thể nhìn lướt qua màn hình và ngay lập tức hiểu đâu là không gian giải đố, đâu là vùng ngoài, và đâu là các vật cản cố định bên trong.

**Lý do ưu tiên**: Tính dễ đọc của màn chơi quyết định việc cơ chế mới có dễ học và dễ giải hay không.

**Kiểm thử Độc lập**: Có thể kiểm thử bằng cách đối chiếu nhiều màn mới với hình tham chiếu `examples\puzzle1.png` và xác nhận đường viền bao quanh được đọc rõ bằng mắt thường, trong khi các vật cản cố định hiển thị thành các cụm liền mạch.

**Kịch bản Chấp nhận**:

1. **Cho** một màn được tạo ngẫu nhiên, **Khi** người chơi quan sát bố cục tổng thể, **Thì** có thể phân biệt ngay đường viền giải đố với vật cản cố định và vùng ngoài màn.
2. **Cho** nhiều vật cản cố định nằm kề nhau, **Khi** chúng xuất hiện trong cùng một màn, **Thì** chúng phải hiển thị như một cụm thống nhất thay vì các ô rời rạc gây khó đọc.
3. **Cho** các mục tiêu và khối đá đã được đặt xong, **Khi** người chơi nhìn vào vùng giải đố, **Thì** đường viền phải tiếp tục bao quanh toàn bộ không gian câu đố liên quan đến các thành phần đó.

---

### Các Trường hợp Biên (Edge Cases)

- Điều gì xảy ra khi bố cục ngẫu nhiên tạo ra vùng giải đố quá nhỏ để chứa đầy đủ mục tiêu, khối và lối tiếp cận của nhân vật?
- Điều gì xảy ra khi chướng ngại vật cố định vô tình chia vùng giải đố thành hai phần tách rời nhau?
- Điều gì xảy ra khi đường viền ngoằn ngoèo chèn sát mục tiêu hoặc sát khối, khiến khối không còn khoảng trống hợp lệ để thao tác?
- Điều gì xảy ra khi nhân vật có thể đi xuyên đường viền nhưng khối ở cùng hướng di chuyển thì không thể, gây ra tình huống nhân vật mắc kẹt ở phía ngoài vùng giải đố?
- Điều gì xảy ra khi số lượng hoặc vị trí chướng ngại vật khiến hệ thống không thể tạo được một màn còn giải được?

## Yêu cầu *(bắt buộc)*

### Yêu cầu Chức năng

- **FR-001**: Hệ thống PHẢI hiển thị toàn bộ màn chơi trong không gian 12x10 ô.
- **FR-002**: Hệ thống PHẢI giới hạn vùng giải đố hoạt động trong một khu vực tối đa 10x8 ô được đặt ở giữa khung hiển thị.
- **FR-003**: Hệ thống PHẢI tạo một đường viền ngoằn ngoèo bao quanh vùng giải đố để biểu thị ranh giới của không gian câu đố.
- **FR-004**: Hệ thống PHẢI sinh hình dạng vùng giải đố đa dạng giữa các màn, thay vì mặc định luôn là một hình chữ nhật đầy đủ 10x8 ô.
- **FR-005**: Hệ thống PHẢI đưa các chướng ngại vật cố định vào bên trong vùng giải đố trước khi hoàn tất bố cục mục tiêu và khối.
- **FR-006**: Hệ thống PHẢI đảm bảo mọi mục tiêu, khối đá và vị trí thao tác cốt lõi của câu đố đều nằm bên trong phần không gian được đường viền bao quanh.
- **FR-007**: Hệ thống PHẢI áp dụng một luật kiểm tra di chuyển dành cho nhân vật, trong đó nhân vật bị chặn bởi tường ngoài cùng và chướng ngại vật cố định nhưng không bị chặn bởi đường viền giải đố.
- **FR-008**: Hệ thống PHẢI áp dụng một luật kiểm tra di chuyển riêng cho các khối đá, trong đó khối bị chặn bởi tường ngoài cùng, chướng ngại vật cố định và cả đường viền giải đố.
- **FR-009**: Hệ thống PHẢI áp dụng cùng luật rào cản cho tất cả các loại khối đá dùng trong câu đố, bao gồm cả khối thường và khối trượt.
- **FR-010**: Hệ thống PHẢI coi chướng ngại vật cố định là vật cản bất động trong suốt quá trình tạo câu đố và không bao giờ đối xử chúng như khối có thể kéo hoặc di chuyển.
- **FR-011**: Hệ thống PHẢI cho phép chướng ngại vật cố định được dùng như điểm neo hợp lệ khi cần tạo hoặc giải các tình huống liên quan đến khối trượt.
- **FR-012**: Hệ thống PHẢI từ chối hoặc tạo lại các bố cục ngẫu nhiên làm vùng giải đố bị chia cắt, thiếu lối tiếp cận thiết yếu hoặc không còn đủ không gian hợp lệ cho câu đố.
- **FR-013**: Hệ thống PHẢI đảm bảo đường viền giải đố tiếp tục bao quanh toàn bộ không gian thực sự liên quan đến mục tiêu và khối sau khi màn được sinh xong.
- **FR-014**: Hệ thống PHẢI tạo ra cách hiển thị để người chơi phân biệt rõ ba lớp không gian: vùng ngoài màn, đường viền giải đố và chướng ngại vật cố định bên trong.

### Các Thực thể Chính

- **Khung hiển thị màn chơi**: Toàn bộ không gian 12x10 ô mà người chơi nhìn thấy khi màn được tải.
- **Vùng giải đố**: Phần không gian hoạt động nằm giữa khung hiển thị, tối đa 10x8 ô, chứa mục tiêu, khối đá và đường di chuyển cần thiết để giải màn.
- **Đường viền giải đố**: Ranh giới ngoằn ngoèo bao quanh vùng giải đố. Nhân vật có thể đi qua, nhưng khối đá bị coi là va chạm với ranh giới này.
- **Chướng ngại vật cố định**: Các ô cản trở được đặt ngẫu nhiên bên trong vùng giải đố. Chúng chặn cả nhân vật lẫn khối đá và có thể đóng vai trò điểm neo cho khối trượt.
- **Khối đá**: Các đối tượng cần được đẩy, kéo hoặc căn chỉnh để giải câu đố. Mọi loại khối đều tuân theo luật va chạm của khối đối với đường viền giải đố.
- **Bố cục câu đố hợp lệ**: Một màn chơi được sinh ra với vùng giải đố liên thông, có đủ không gian thao tác và vẫn còn lời giải hợp lệ cho người chơi.

## Tiêu chí Thành công *(bắt buộc)*

### Kết quả Có thể Đo lường

- **SC-001**: Khi tạo 10 màn mới liên tiếp, ít nhất 8 màn phải khác nhau về hình dạng ranh giới hoặc vị trí chướng ngại vật cố định.
- **SC-002**: Trong kiểm thử thao tác cơ bản, người chơi có thể xác nhận trong 100% trường hợp rằng nhân vật đi xuyên được đường viền giải đố nhưng khối đá thì không.
- **SC-003**: Trong 20 lần sinh màn liên tiếp, ít nhất 19 màn phải được chấp nhận là còn giải được và có đủ không gian thao tác hợp lệ.
- **SC-004**: Người chơi có thể phân biệt vùng ngoài, đường viền giải đố và chướng ngại vật cố định trong vòng 2 giây quan sát đầu tiên trên ít nhất 90% màn thử nghiệm.
- **SC-005**: Việc bắt đầu một màn mới phải hoàn tất nhanh đến mức người chơi không nhận thấy chờ đợi đáng kể trong luồng chơi thông thường.
- **SC-006**: Trong toàn bộ bộ kiểm thử chấp nhận của tính năng, không có trường hợp nào mục tiêu hoặc khối đá xuất hiện bên ngoài phần vùng giải đố được đường viền bao quanh.

## Các Giả định

- Tính năng này áp dụng cho chế độ chơi đố khối hiện tại, không mở rộng phạm vi sang các chế độ chơi khác.
- Tường ngoài cùng của màn vẫn tiếp tục là giới hạn cứng cho cả nhân vật và khối đá.
- Các loại khối đá hiện có tiếp tục tồn tại, và tất cả đều phải tuân theo cùng một nguyên tắc rào cản có chọn lọc đối với đường viền giải đố.
- Hệ thống sinh màn hiện tại đã có khả năng từ chối và tạo lại một bố cục không hợp lệ nếu bố cục đó không đạt tiêu chí của câu đố.
- Hình tham chiếu `examples\puzzle1.png` được dùng để định hướng cách đọc thị giác của ranh giới và vật cản, không dùng để khóa cứng đúng một bố cục duy nhất.
