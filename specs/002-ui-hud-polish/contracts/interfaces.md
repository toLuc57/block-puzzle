# Hợp đồng Giao diện: Tín hiệu UI & Game Loop

## Tín hiệu Autoload (GameEvents.gd)

Hợp đồng này quy định cách thức UI và Logic Game giao tiếp với nhau.

| Tín hiệu | Tham số | Mô tả |
|----------|---------|-------|
| `score_updated` | `current: int, target: int` | Phát ra khi số bước thay đổi. HUD cập nhật nhãn tương ứng. |
| `progress_updated` | `placed: int, total: int` | Phát ra khi một khối di chuyển vào/ra khỏi ô đích. HUD thực hiện hiệu ứng Tween. |
| `win_condition_met` | (không có) | Phát ra khi tất cả các khối ở đúng vị trí. VictoryPopup hiển thị. |
| `undo_requested` | (không có) | UI yêu cầu quay lại bước trước. |
| `reset_requested` | (không có) | UI yêu cầu chơi lại màn hiện tại. |
| `next_level_requested`| (không có) | UI yêu cầu sinh màn chơi mới sau khi thắng. |

## Ràng buộc Hiển thị (UI Contracts)

- **VBoxContainer Root**: Phải chứa 3 children theo thứ tự: TopPanel, CenterGameArea, BottomPanel.
- **TopPanel**: `size_flags_vertical = SIZE_SHRINK_BEGIN`, chiều cao cố định, chứa HUD.
- **CenterGameArea**: `size_flags_vertical = SIZE_EXPAND_FILL`, tự động chiếm không gian còn lại, chứa GridContainer và TargetLayer.
- **BottomPanel**: `size_flags_vertical = SIZE_SHRINK_END`, chiều cao cố định, chứa BlockLegend.
- **VictoryPopup**: Phải nằm trong một `CanvasLayer` riêng với `layer = 10` để hiển thị trên tất cả. Phải tự động `hide()` khi nhận tín hiệu `next_level_requested` hoặc `reset_requested`.
- **Signal Connection**: `GameEvents.win_condition_met.connect(_on_win)` chỉ được gọi 1 lần duy nhất tại `_ready()` của Main.gd, không bao giờ disconnect.
