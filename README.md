
# Quy trình làm việc với Spec-Kit & Gemini CLI

Tài liệu này hướng dẫn chi tiết quy trình phát triển phần mềm theo phương pháp **SDD (Spec-Driven Development)** sử dụng công cụ `spec-kit` và AI Coding Agent (Gemini CLI).

---

## 1. Sơ đồ luồng công việc (Workflow Diagram)

Quy trình phát triển của `spec-kit` bắt buộc phải đi theo một chiều từ trên xuống dưới. Tuyệt đối không nhảy cóc qua các bước để đảm bảo AI không sinh mã nguồn sai lệch hoặc thiếu sót logic.

---

## 2. Chi tiết cú pháp, nội dung và Ví dụ thực tế

### Bước 0: Khởi tạo bộ nhớ dự án

* **Cú pháp:** `speckit-constitution` (hoặc `/speckit.constitution`)
* **Nội dung:** Lệnh này tạo ra file `constitution.md` trong thư mục `.specify/memory/`. Đây là "hiến pháp" quy định các quy tắc cốt lõi, công nghệ sử dụng (ví dụ: Godot 4.x, GDScript) mà AI bắt buộc phải tuân theo trong suốt dự án.

---

### Bước 1: Tạo đặc tả tính năng (`Specify`)

* **Cú pháp:** `speckit-specify`
* **Nội dung:** Khởi tạo một thư mục tính năng mới và file `spec.md`. Tại đây, bạn cung cấp ý tưởng thô, AI sẽ chuẩn hóa nó thành tài liệu kỹ thuật.

#### Mẫu Prompt ví dụ từ dự án:

**Ví dụ cho Tính năng 1 (Hệ thống lưới & Sinh map ngược):**

> "Hãy tạo file Spec cho tính năng Hệ thống lưới di chuyển (Grid-based movement) và Thuật toán sinh màn chơi ngược (Reverse Generation Level Generator) bằng Godot Engine.
> Yêu cầu cốt lõi:
> 1. Nhân vật di chuyển 4 hướng theo ô lưới rời rạc, mượt mài bằng Tween.
> 2. Có 2 loại khối: Khối cơ bản (đẩy từng ô) và Khối băng (trượt liên tục đến khi gặp vật cản).
> 3. Hệ thống tạo màn chơi tự động áp dụng thuật toán Duyệt ngược (Reverse Generation/Pull Moves) từ trạng thái thắng đi lùi lại để xáo trộn map.

---

### Bước 2: Làm rõ điểm mù (`Clarify`)

* **Cú pháp:** `speckit-clarify`
* **Nội dung:** AI quét file `spec.md`, tìm các điểm mơ hồ hoặc thiếu thông tin kỹ thuật để đặt câu hỏi cho bạn. Sau khi bạn trả lời, AI tự cập nhật câu trả lời vào Spec.
* **Ví dụ thực tế:** AI hỏi: *"Kích thước bản đồ mặc định là bao nhiêu và xử lý thế nào khi người chơi bị kẹt khối?"* $\rightarrow$ Bạn phản hồi: *"Kích thước 10x10. Nếu kẹt thì bấm phím R để reset lại màn chơi hiện tại"*.

---

### Bước 3: Lập kế hoạch kiến trúc (`Plan`)

* **Cú pháp:** `speckit-plan`
* **Nội dung:** AI phân tích `spec.md` đã hoàn thiện để lập ra cấu trúc file, cấu trúc các Node trong Godot và giải thuật cụ thể (ví dụ: Thuật toán $A^*$, khoảng cách Manhattan), lưu vào file `plan.md`.
* **Ví dụ thực tế:** Trong file `plan.md`, AI xác định sẽ tạo các file: `Main.tscn`, `Main.gd`, `Player.tscn`, `Block.tscn`, và class logic độc lập `GridLogic.gd`.

---

### Bước 4: Tạo danh sách tác vụ (`Tasks`)

* **Cú pháp:** `speckit-tasks`
* **Nội dung:** Băm nhỏ kế hoạch trong `plan.md` thành một danh sách các đầu việc (Checklist) có thứ tự ưu tiên và sự phụ thuộc lẫn nhau, lưu vào file `tasks.md`.
* **Ví dụ thực tế:** * `[ ] Task 1: Khởi tạo các Node TileMapLayer và cấu hình TileSet cho Target.`
* `[ ] Task 2: Lập trình logic di chuyển trượt cho Khối Băng khi có lực đẩy.`



---

### Bước 5: Thực thi lập trình (`Implement`)

* **Cú pháp:** `speckit-implement`
* **Nội dung:** AI Coding Agent đọc toàn bộ Spec, Plan, Tasks và tiến hành viết mã nguồn thực tế (GDScript) hoặc tạo cấu trúc Scene (`.tscn`) đổ vào thư mục dự án của bạn.

---

## 3. Quy trình xử lý lỗi (Bug Fixing Workflow)

Khi chạy game gặp lỗi (ví dụ: *Map không hiển thị các ô Target, chỉ hiển thị Score: 0*), **tuyệt đối không tạo Spec mới**. Quy trình xử lý như sau:

1. **Không chạy** `speckit-specify`.
2. Chạy trực tiếp lệnh **`speckit-implement`** kèm prompt mô tả lỗi chi tiết dựa trên mã nguồn hiện tại.

#### Mẫu Prompt sửa lỗi ví dụ từ dự án:

> "Hiện tại khi chạy scene chính `res://scenes/Main.tscn`, game chỉ hiển thị `ScoreLabel: 0` mà không hiển thị hệ thống lưới, người chơi hay các khối đá như đặc tả.
> Hãy kiểm tra lại các file script đã tạo (đặc biệt là `Main.gd`, `LevelGenerator.gd` và cách cấu hình `TileMapLayer`). Sửa lại code để đảm bảo khi game khởi chạy (`_ready()`), thuật toán sinh màn chơi được kích hoạt, vẽ các ô lên TileMap và instance Player cùng các Khối đá vào đúng vị trí."

---

*Tài liệu này được lưu trữ tại thư mục gốc của dự án để định hình phong cách làm việc nhất quán cho lập trình viên và AI.*