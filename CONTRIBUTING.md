# Quy trình làm việc nhóm

Tạo hoặc chọn Issue thật trước khi sửa. Dùng `feature/<tên>` từ develop, commit dạng `lab: ... (#14)`, `fix: ... (#16)` hoặc `docs: ... (#16)`. Không đổi lịch sử cũ để làm giả việc đã tuân quy trình.

Mở PR vào develop, mô tả vấn đề/hành vi sau sửa, cách kiểm tra, bằng chứng và giới hạn. Người khác trong nhóm đọc diff và bằng chứng, ghi review trên GitHub; cần tối thiểu một approval khác tác giả trên phiên bản cuối. Nhờ bằng miệng được, nhưng lời nhờ không thay thế review đã lưu. Không tự approve bằng tài khoản của người khác và không tự nhận là đã review.

Chỉ merge sau khi review và các check cần thiết đạt. Đưa develop sang main qua PR riêng, giữ main ổn định; không push trực tiếp main. Hiện repo chưa có branch protection nên đây vẫn là nghĩa vụ nhóm phải tuân thủ, chưa được nền tảng cưỡng chế.

Trước khi tạo lại container: xác định project/mounts, backup ngoài repo, kiểm hash và đường rollback. Không thử nghiệm ngoài lab. Không stage cả thư mục chứa secret/log/pcap. Xem `SECURITY.md` và `lab/README.md`.

Mỗi checkpoint gắn Issues với milestone thật và cập nhật Project board. Tag/Release do Long thao tác trên web sau khi xác nhận báo cáo/slide/video, review và kiểm thử; không tạo giả version chỉ để đủ checklist.
