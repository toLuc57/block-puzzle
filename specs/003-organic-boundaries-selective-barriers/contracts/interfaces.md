# Hợp đồng Nội bộ: Sinh màn và Va chạm Có chọn lọc

## 1. Hợp đồng payload `GeneratedLevelState`

`LevelGenerator` phải trả về một `Dictionary` đủ để `Main.gd` dựng lại màn mà không cần suy luận thêm.

| Trường | Kiểu dữ liệu | Bắt buộc | Ý nghĩa |
|--------|--------------|----------|--------|
| `grid_size` | `Vector2i` hoặc cặp số | Có | Kích thước khung hiển thị, kỳ vọng là 12x10 |
| `playable_mask` | `Dictionary` | Có | Chứa danh sách ô nền chơi, ô boundary và metadata liên thông |
| `obstacles` | `Array[Vector2i]` | Có | Tập ô chướng ngại vật cố định |
| `targets` | `Array[Vector2i]` | Có | Tập ô mục tiêu |
| `blocks` | `Array[Dictionary]` | Có | Mỗi phần tử tối thiểu có `pos` và `type` |
| `player_pos` | `Vector2i` | Có | Vị trí khởi đầu của nhân vật |
| `target_moves` | `int` | Không bắt buộc nhưng nên có | Số bước mục tiêu hoặc metadata độ khó hiện tại |

### Ràng buộc hợp lệ
- Không có `target`, `block`, `player_pos` nào được nằm ngoài `playable_mask.floor_cells`.
- Không có `obstacle` nào trùng với `target`, `block` hoặc `player_pos`.
- `playable_mask` phải mô tả được `boundary_cells` để render và validate va chạm.

## 2. Hợp đồng semantics ô trong `GridLogic`

`GridLogic` là nguồn sự thật cho không gian tĩnh và occupancy động.

| Khái niệm ô | Nhân vật | Khối đá | Ghi chú |
|-------------|----------|---------|--------|
| Vùng ngoài / tường ngoài | Bị chặn | Bị chặn | Giới hạn cứng của khung 12x10 |
| Nền chơi hợp lệ | Đi qua được | Đi qua được | Có thể chứa player/block/target |
| Boundary giải đố | Đi qua được | Bị chặn | Cốt lõi của selective barrier |
| Chướng ngại vật cố định | Bị chặn | Bị chặn | Đồng thời là anchor cho khối trượt |
| Ô đang có block khác | Không đi vào | Không đi vào | Occupancy động |

### Hàm kiểm tra mong đợi
- Một nhóm hàm cho tác nhân kiểu Player
- Một nhóm hàm cho tác nhân kiểu Block
- Một lớp helper chung để kiểm tra ô có thuộc khung hiển thị hay không

## 3. Hợp đồng `Player.gd`

- `Player.gd` không tự định nghĩa luật va chạm riêng ngoài `GridLogic`.
- Khi nhận input di chuyển, Player phải hỏi `GridLogic` xem ô đích có hợp lệ cho Player không.
- Nếu ô đích có block, Player chỉ được di chuyển sau khi block đó thực hiện thành công chuyển động hợp lệ theo luật dành cho block.

## 4. Hợp đồng `Block.gd`

- Block thường chỉ tiến một ô nếu ô kế hợp lệ cho block.
- Block băng lặp kiểm tra ô kế tiếp cho tới khi gặp vật cản hợp lệ để dừng.
- Boundary giải đố và chướng ngại vật cố định đều phải được coi là điểm dừng hợp lệ cho block băng.
- Không có block nào được đi xuyên boundary, kể cả khi player đứng ở phía bên kia boundary.

## 5. Hợp đồng `Main.gd` khi dựng màn

`Main.gd` phải khởi tạo màn theo thứ tự sau:
1. Xóa actor cũ và reset `GridLogic`
2. Khởi tạo lại khung lưới theo kích thước từ `GeneratedLevelState`
3. Vẽ geometry tĩnh: nền chơi, boundary, obstacle, target overlay
4. Spawn block instances
5. Spawn player
6. Ghi checkpoint đầu tiên vào `GameState`

### Ràng buộc render
- Geometry tĩnh phải được dựng xong trước khi spawn actor để tránh block/player xuất hiện trên ô chưa được phân loại.
- Nếu dùng tiles từ `art\Basic Grass Biom things 1.png`, việc dùng chúng không được làm thay đổi semantics logic của ô.

## 6. Hợp đồng kiểm thử tối thiểu

Các hành vi sau phải có coverage bằng unit test hoặc kịch bản xác thực rõ ràng:
- Player đi xuyên boundary nhưng bị chặn bởi obstacle
- Block thường bị chặn bởi boundary
- Block băng trượt tới obstacle hoặc boundary và dừng đúng chỗ
- Generator loại bỏ mask bị tách vùng hoặc thiếu ô thao tác
- Payload level sinh ra không đặt target/block/player ngoài vùng giải đố
