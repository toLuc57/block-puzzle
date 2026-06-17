# Giao diện Tín hiệu (GameEvents Signals)

Tất cả các thành phần UI và Logic sẽ giao tiếp thông qua Singleton `GameEvents.gd`.

## Tín hiệu từ Logic đến UI

### `score_updated(current_moves: int, target_moves: int)`
- Phát ra khi số bước di chuyển thay đổi.
- **HUD** lắng nghe để cập nhật hiển thị.

### `progress_updated(placed: int, total: int)`
- Phát ra khi một khối được đẩy vào hoặc ra khỏi ô đích.
- **HUD** lắng nghe để cập nhật thanh tiến trình và thực hiện hiệu ứng Tween.

### `victory_triggered(stats: Dictionary)`
- Phát ra khi điều kiện thắng được thỏa mãn.
- **VictoryPopup** lắng nghe để hiển thị.

## Tín hiệu từ UI đến Logic

### `undo_requested()`
- Phát ra khi người chơi nhấn nút Undo hoặc phím `Ctrl+Z`.
- **Main/GameState** lắng nghe để quay lại trạng thái trước đó.

### `reset_requested()`
- Phát ra khi người chơi nhấn nút Reset hoặc phím `R`.
- **Main** lắng nghe để làm mới màn chơi hiện tại.

### `next_level_requested()`
- Phát ra khi người chơi nhấn "Next Level" trên màn hình chiến thắng.
- **Main** lắng nghe để sinh màn mới.
