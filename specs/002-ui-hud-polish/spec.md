# Bản Đặc tả Tính năng: Hệ thống UI và Đánh bóng giao diện (Polish UI/HUD) - Cập nhật Phân vùng & Địa hình

**Nhánh Tính năng**: `002-ui-hud-polish`

**Ngày tạo**: 2026-06-16 (Cập nhật: 2026-06-18)

**Trạng thái**: Nháp (Đã cập nhật lỗi Layout & Terrain)

**Đầu vào**: Mô tả của người dùng: "Chia màn hình làm 3 phần tách biệt rõ ràng thông qua VBoxContainer:
   - Phần đầu (Top): Chứa HUD (Moves, Target, nút Undo, Reset) nằm gọn trong một Panel có chiều cao cố định, không đè lên vùng chơi.
   - Phần giữa (Center): Chứa vùng chơi game (GridContainer, TargetLayer, Player, Blocks). Thiết lập Size Flags dọc thành 'Expand' và 'Fill' để vùng chơi tự động co giãn chiếm trọn không gian ở giữa mà không bị lấn chiếm.
   - Phần cuối (Bottom): Chứa thanh chú thích thuộc tính các loại đá (Đá xám, Đá băng) nằm cố định ở đáy.

Các yêu cầu bổ sung:
1. Tích hợp Hệ thống Địa hình (TileMap Terrain): Trong TileMapLayer của 'scenes/main/Main.tscn', đã cấu hình sẵn 'terrain_set' và 'terrain'. Cập nhật mã nguồn thiết lập level để khi sinh map tự động, hệ thống phải áp dụng tính năng tự động nối tường/đường của Godot bằng cách sử dụng hàm `set_cells_terrain_connect()` của TileMapLayer thay vì vẽ từng ô riêng lẻ.
2. Sửa lỗi màn hình Chiến thắng (Victory Screen Loop Bug): Màn hình Victory chỉ xuất hiện ở màn chơi đầu tiên. Khi người chơi nhấn 'Next Level', thuật toán sinh map mới thành công nhưng khi thắng các ải về sau, màn hình Victory không hiển thị nữa. Kiểm tra lại việc ngắt/kết nối lại tín hiệu (Signals) giữa GameEvents và UI khi reset/đổi màn chơi. Đảm bảo hàm `_on_win` luôn được kích hoạt ở TẤT CẢ các ải."

## Clarifications

### Session 2026-06-18
- Q: Giải pháp cho Layout Overlay? -> A: Sử dụng SubViewportContainer hoặc PanelContainer với kích thước cố định để đảm bảo Grid 10x10 luôn nằm trong "vùng an toàn", không bị HUD/Legend che khuất.
- Q: Cách thức áp dụng Terrain? -> A: Sử dụng API `set_cells_terrain_connect` của Godot 4.x để vẽ toàn bộ nền và tường trong một lần gọi, giúp các texture tự động nối liền mạch.
- Q: Cơ chế hiển thị Victory ổn định? -> A: Đảm bảo Signal `win_condition_met` không bị ngắt kết nối khi chuyển màn và node VictoryPopup được reset trạng thái hiển thị đúng cách.

## Kịch bản Người dùng & Kiểm thử *(bắt buộc)*

### Câu chuyện Người dùng 1 - Theo dõi tiến trình màn chơi qua HUD (Ưu tiên: P1)

Người chơi cần biết họ đã đi bao nhiêu bước, còn bao xa để đạt mức tối ưu và bao nhiêu khối đã vào vị trí. HUD được hiển thị ở vị trí căn giữa ngang phía trên màn chơi, **tuyệt đối không che khuất khu vực chơi game**.

**Kiểm thử Độc lập**: Thực hiện di chuyển và quan sát HUD cập nhật mà không bị các vật thể game (Player/Block) lấn vào không gian của HUD.

---

### Câu chuyện Người dùng 2 - Trải nghiệm địa hình liền mạch (Ưu tiên: P1)

Người chơi nhìn thấy bản đồ có cỏ, tường và các đường nối tự nhiên, không bị rời rạc giữa các ô.

**Lý do ưu tiên**: Tăng tính thẩm mỹ và độ chuyên nghiệp cho sản phẩm.

**Kiểm thử Độc lập**: Sinh màn chơi mới và kiểm tra xem các texture tường và nền có tự động nối khớp (autotile) với nhau không.

---

### Câu chuyện Người dùng 3 - Hoàn thành màn chơi liên tục (Ưu tiên: P1)

Người chơi có thể vượt qua nhiều màn chơi liên tiếp và luôn nhận được thông báo chiến thắng mỗi khi hoàn thành.

**Lý do ưu tiên**: Đảm bảo vòng lặp game (Game Loop) không bị đứt quãng.

**Kiểm thử Độc lập**: Thắng màn 1, nhấn "Next Level", thắng màn 2 và kiểm tra xem màn hình Victory có hiện lên 100% số lần không.

---

### Các Trường hợp Biên (Edge Cases)

- Điều gì xảy ra khi lưới 10x10 lớn hơn diện tích SubViewport? (Hệ thống phải scale lưới hoặc container để vừa khít vùng an toàn).
- Hệ thống xử lý thế nào khi `set_cells_terrain_connect` nhận danh sách tọa độ không hợp lệ? (Cần kiểm tra bounds trước khi gọi hàm).

## Yêu cầu *(bắt buộc)*

### Yêu cầu Chức năng

- **FR-001**: HUD PHẢI hiển thị Move Count, Target Moves, và Progress. Căn giữa ngang ở Top.
- **FR-002**: Hệ thống PHẢI có nút Reset (R) và Undo (Ctrl+Z).
- **FR-003**: Hệ thống PHẢI có màn hình Victory Pop-up, hiển thị mỗi khi thắng ở BẤT KỲ màn nào.
- **FR-004**: `GameUI` PHẢI tách biệt logic qua Signals.
- **FR-007**: Hệ thống PHẢI hiển thị bảng Chú giải Khối (Block Legend) ở Bottom.
- **FR-009**: Hệ thống PHẢI đóng gói khu vực chơi (Grid 10x10) vào một container (ví dụ: `SubViewportContainer`) để đảm bảo **tuyệt đối không có UI overlay** che khuất các vật thể game.
- **FR-010**: Khi thiết lập level, hệ thống PHẢI sử dụng hàm `set_cells_terrain_connect()` để áp dụng Terrain cho TileMapLayer thay vì đặt từng tile đơn lẻ.
- **FR-011**: Hệ thống PHẢI đảm bảo tín hiệu `win_condition_met` được kết nối bền vững hoặc tái kết nối chính xác sau mỗi lần sinh màn chơi mới để Victory Screen luôn hiển thị.

### Các Thực thể Chính

- **GameAreaContainer**: Container chuyên dụng bảo vệ không gian hiển thị của lưới 10x10.
- **TerrainSystem**: Logic tích hợp với TileMapLayer để xử lý việc nối địa hình tự động.

## Tiêu chí Thành công *(bắt buộc)*

### Kết quả Có thể Đo lường

- **SC-001**: 100% không gian lưới 10x10 hiển thị đầy đủ, không bị HUD/Legend đè lên ở bất kỳ độ phân giải nào từ 800x600.
- **SC-002**: Texture địa hình tự động nối liền mạch 100% (không có lỗi 'missing border' giữa các ô cùng terrain).
- **SC-003**: Tỉ lệ xuất hiện màn hình Victory là 10/10 lần thử nghiệm thắng liên tục.

## Các Giả định

- TileSet đã được cấu hình đúng `terrain_set` và `terrain` index trong Editor.
- `GameEvents` là một Autoload bền vững xuyên suốt vòng đời ứng dụng.
- Kích thước ô (cell_size) là cố định (16px hoặc tùy chọn) và Grid luôn là 10x10.
