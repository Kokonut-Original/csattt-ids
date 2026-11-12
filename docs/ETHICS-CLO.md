# Phạm vi lab và ánh xạ CLO

Lab phục vụ BTL SEC1304, không thử nghiệm mục tiêu ngoài phạm vi. Người vận hành phải kiểm tra topology và đích trước chạy. Ba container: victim `.10`, Kali `.20`, server3 `.30` trong `172.28.0.0/24`. DNS giả chỉ dùng `exfil.lab`, không upstream. Lưu lượng mô phỏng, tài khoản và dữ liệu thử do nhóm chuẩn bị; không thu dữ liệu cá nhân thật.

| CLO | Nội dung cần chứng minh | Bằng chứng hiện có | Còn cần cho bộ nộp |
|---|---|---|---|
| CLO2 | Dựng và vận hành công cụ | `lab/`, `src/suricata/local.rules`, hướng dẫn và kết quả dựng lại 13/11 | Cấu hình host đã làm sạch, demo/tái lập độc lập |
| CLO2 | Phân tích phát hiện và giới hạn | Kết quả Duy và JSON EVE/Wazuh 13/11 | Mẫu số FP/FN, thêm benign/đối chiếu phiên bản, bằng chứng IPS/drop |
| CLO3 | Chỉ chạy trong phạm vi được phép | Script đích cố định, capture toàn bridge ở lượt tích hợp, `SECURITY.md` | Nhóm xác nhận cam kết trong báo cáo cuối |
| CLO3 | Bảo vệ dữ liệu và trách nhiệm | Bí mật ngoài repo, không upload raw bằng chứng mới, hướng dẫn disclosure | Rà dữ liệu cũ trên main/lịch sử và quyền truy cập giảng viên |

## Cam kết đạo đức và trách nhiệm nghề nghiệp

Phần dưới là nội dung chính sách cần được nhóm xác nhận và đưa vào báo cáo cuối, không phải chữ ký hoặc xác nhận thay cho các thành viên.

Chỉ sinh lưu lượng trong lab được ủy quyền, không dùng live target hoặc dữ liệu cá nhân thật. Không public payload hoặc capture. Khi phát hiện vấn đề thật, dừng khai thác, báo riêng giảng viên/chủ hệ thống và theo responsible disclosure. Lưu raw log/pcap ở nơi cục bộ có kiểm soát, chỉ chia sẻ phần đã rà. Giữ bằng chứng tới khi hoàn tất đánh giá, sau đó trưởng nhóm quyết định thời hạn lưu/xóa; chưa có ngày retention cụ thể được nhóm xác nhận.

Đề thầy yêu cầu tham chiếu Luật An ninh mạng 2018, Nghị định 147/2024, Nghị định 13/2023 về bảo vệ dữ liệu cá nhân và Điều 289–291 BLHS. Danh sách này được chép làm yêu cầu bộ nộp; không phải kết luận rằng mọi văn bản còn nguyên hiệu lực hoặc lab đã được thẩm định pháp lý. Trước nộp, đối chiếu văn bản áp dụng và cách trích dẫn với giảng viên.

## Quyền sử dụng

Repo chưa được cấp giấy phép nguồn mở. Quyền tác giả của từng đóng góp được bảo lưu; truy cập private không tự cấp quyền phân phối công khai. Thành phần bên thứ ba giữ giấy phép riêng. Nhóm cần chốt chính sách license và quyền sử dụng phục vụ chấm bài; không tự gán MIT hoặc giấy phép khác cho đóng góp của thành viên khi chưa thống nhất.
