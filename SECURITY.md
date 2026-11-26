# Bảo mật và sử dụng có trách nhiệm

Repo private, chỉ dùng trong lab BTL `172.28.0.0/24`. Không đổi public để bật tính năng bảo mật. Không public payload, pcap/log hoặc bí mật. File credential nằm ngoài repo; không đặt giá trị thật vào example, commit, PR, Issue hoặc video.

Nếu lộ secret: dừng chia sẻ, đổi/thu hồi credential liên quan, thông báo riêng chủ repo và giảng viên; không dán secret vào Issue. Dọn file ở HEAD không xóa dữ liệu trong lịch sử Git. Raw log/pcap ở main và credential mẫu trong lịch sử cần rà riêng; không coi việc ignore file là đã xóa file tracked.

Nếu phát hiện lỗ hổng ngoài lab: không tiếp tục khai thác; lưu bằng chứng tối thiểu không nhạy cảm, báo riêng giảng viên/chủ hệ thống và chỉ xác minh thêm khi được ủy quyền. Không đăng Issue public chứa chi tiết khai thác hoặc dữ liệu thật. Chưa có phát hiện lỗ hổng thật được ghi nhận trong lượt kiểm tra này.

CI dùng Semgrep với policy local giới hạn và Gitleaks quét lịch sử có redact. Đây không thay thế GitHub Secret Protection, không chứng minh vắng mọi secret và không phải một cuộc đánh giá an toàn toàn diện. Dependabot config chỉ quản lý cập nhật Actions sau khi được GitHub tiếp nhận; trạng thái alerts trong Settings cần xác minh riêng.
